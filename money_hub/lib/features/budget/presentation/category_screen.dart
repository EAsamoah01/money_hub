import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/routes.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/gradient_header.dart';
import '../data/budget_repository.dart';
import '../domain/budget_math.dart';
import 'widgets/budget_widgets.dart';

/// One envelope for one month: assign money, see what's been spent.
class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key, required this.categoryId, this.month});
  final int categoryId;
  final String? month;

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  late final String _month = isValidMonthKey(widget.month) ? widget.month! : monthKey(DateTime.now());
  final _assign = TextEditingController();
  bool _filled = false;

  @override
  void dispose() {
    _assign.dispose();
    super.dispose();
  }

  Future<void> _saveAssigned() async {
    FocusScope.of(context).unfocus();
    await ref.read(budgetRepositoryProvider).setAssigned(
          categoryId: widget.categoryId,
          month: _month,
          cents: (parseNum(_assign.text) * 100).round(),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Envelope updated')));
    }
  }

  Future<void> _rename(String current) async {
    final c = TextEditingController(text: current);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename category'),
        content: TextField(controller: c, autofocus: true, decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, c.text), child: const Text('Save')),
        ],
      ),
    );
    c.dispose();
    if (name != null && name.trim().isNotEmpty) {
      await ref.read(budgetRepositoryProvider).renameCategory(widget.categoryId, name.trim());
    }
  }

  Future<void> _delete(String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete $name?'),
        content: const Text('Its spending stays in your history but becomes uncategorized.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(budgetRepositoryProvider).deleteCategory(widget.categoryId);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(budgetSummaryProvider(_month));
    final txs = ref.watch(monthTransactionsProvider(_month)).valueOrNull ?? const [];
    final names = ref.watch(categoryNamesProvider);
    final accounts = ref.watch(accountNamesProvider);

    if (summary == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    EnvelopeLine? line;
    for (final l in summary.lines) {
      if (l.categoryId == widget.categoryId) line = l;
    }
    if (line == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('This category was deleted.')));
    }
    final env = line;

    // Pre-fill the assign box once with the current amount.
    if (!_filled) {
      _filled = true;
      final v = env.assignedCents / 100;
      _assign.text = env.assignedCents == 0 ? '' : (v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2));
    }

    final mine = txs.where((t) => t.categoryId == widget.categoryId).toList();
    final fg = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(env.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => v == 'rename' ? _rename(env.name) : _delete(env.name),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'rename', child: Text('Rename')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Loc.transactionNew(categoryId: widget.categoryId)),
        icon: const Icon(Icons.add),
        label: const Text('Add spending'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              GradientHeader(
                title: fmtMoney(env.availableCents / 100, cents: true),
                subtitle: env.overspent
                    ? 'overspent in ${DateFormat.MMMM().format(monthStart(_month))}. Move money from another envelope.'
                    : 'available in ${DateFormat.MMMM().format(monthStart(_month))}',
                icon: env.overspent ? Icons.warning_amber_rounded : Icons.inbox_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: env.usedFraction,
                        minHeight: 8,
                        color: fg,
                        backgroundColor: fg.withValues(alpha: 0.25),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(spacing: 10, runSpacing: 10, children: [
                      HeaderStat(label: 'assigned', value: fmtMoney(env.assignedCents / 100), icon: Icons.inbox_outlined),
                      HeaderStat(label: 'spent', value: fmtMoney(env.spentCents / 100), icon: Icons.shopping_bag_outlined),
                    ]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Assign money', style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: 4),
                            Text(
                              '${fmtMoney(summary.toBudgetCents / 100)} still ready to assign this month',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _assign,
                                    decoration: const InputDecoration(labelText: 'Amount for this month', prefixText: r'$ '),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                                    onSubmitted: (_) => _saveAssigned(),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                FilledButton(onPressed: _saveAssigned, child: const Text('Save')),
                              ],
                            ),
                            if (summary.toBudgetCents > 0) ...[
                              const SizedBox(height: 6),
                              TextButton.icon(
                                onPressed: () {
                                  final v = (env.assignedCents + summary.toBudgetCents) / 100;
                                  _assign.text = v.toStringAsFixed(2);
                                  _saveAssigned();
                                },
                                icon: const Icon(Icons.add, size: 18),
                                label: Text('Add the remaining ${fmtMoney(summary.toBudgetCents / 100)}'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SectionTitle('Spending this month (${mine.length})'),
                    if (mine.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Nothing spent from this envelope yet.'),
                      ),
                    ...transactionsByDay(
                      mine,
                      categoryNames: names,
                      accountNames: accounts,
                      context: context,
                      onTap: (t) => context.push(Loc.transactionEdit(t.id)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
