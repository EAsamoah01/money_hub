import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/affiliate_slot.dart';
import '../../../core/widgets/gradient_header.dart';
import '../data/bills_repository.dart';
import '../data/budget_repository.dart';
import '../domain/budget_math.dart';
import 'widgets/budget_widgets.dart';

/// Zero-based budget for one month: give every dollar of income a job.
class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key, this.month});
  final String? month; // "2026-10"; null = this month

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  late String _month = isValidMonthKey(widget.month) ? widget.month! : monthKey(DateTime.now());

  Future<void> _copyLastMonth() async {
    final n = await ref.read(budgetRepositoryProvider).copyAssignmentsFromPreviousMonth(_month);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(n == 0 ? 'Nothing to copy from last month' : 'Copied $n amounts from last month'),
    ));
  }

  Future<void> _addCategory(int groupId, String groupName) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _NameDialog(
        title: 'New category in $groupName',
        label: 'Category name',
        helper: 'A budget envelope for setting money aside. To track due dates and get '
            'reminders, add the bill in Bills & Alerts instead.',
        onOpenBills: () => context.push(Routes.bills),
      ),
    );
    if (name == null || name.trim().isEmpty) return;
    await ref.read(budgetRepositoryProvider).addCategory(groupId: groupId, name: name.trim());
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(budgetSummaryProvider(_month));
    final groups = ref.watch(categoryGroupsProvider).valueOrNull;
    final totals = ref.watch(recurringTotalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'copy') _copyLastMonth();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'copy', child: Text("Copy last month's amounts")),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Loc.transactionNew()),
        icon: const Icon(Icons.add),
        label: const Text('Add spending'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: summary == null || groups == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.only(bottom: 96),
                  children: [
                    MonthSwitcher(month: _month, onChanged: (m) => setState(() => _month = m)),
                    _Header(summary: summary),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ActionChip(
                                avatar: const Icon(Icons.south_west, size: 18),
                                label: const Text('Add income'),
                                onPressed: () => context.push(Loc.transactionNew(income: true)),
                              ),
                              ActionChip(
                                avatar: const Icon(Icons.receipt_long_outlined, size: 18),
                                label: Text(totals == null || totals.billCount + totals.subscriptionCount == 0
                                    ? 'Bills & Alerts'
                                    : 'Bills & Alerts · ${fmtMoney(totals.monthlyCents / 100)}/mo'),
                                onPressed: () => context.push(Routes.bills),
                              ),
                              ActionChip(
                                avatar: const Icon(Icons.list_alt, size: 18),
                                label: const Text('Transactions'),
                                onPressed: () => context.push(Routes.transactions),
                              ),
                              ActionChip(
                                avatar: const Icon(Icons.account_balance_outlined, size: 18),
                                label: const Text('Accounts'),
                                onPressed: () => context.push(Routes.accounts),
                              ),
                            ],
                          ),
                          if (summary.incomeCents == 0) const _IncomeHint(),
                          for (final g in groups) ...[
                            SectionTitle(
                              g.name,
                              action: IconButton(
                                tooltip: 'Add a budget category to ${g.name}',
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => _addCategory(g.id, g.name),
                              ),
                            ),
                            for (final line in summary.lines.where((l) => l.groupId == g.id))
                              EnvelopeTile(
                                line: line,
                                onTap: () => context.push(Loc.budgetCategory(line.categoryId, month: _month)),
                              ),
                          ],
                          const AffiliateSlot(placement: 'budget.overview', margin: EdgeInsets.only(top: 18)),
                          if (summary.uncategorizedSpentCents > 0) ...[
                            const SectionTitle('Other spending'),
                            Card(
                              child: ListTile(
                                leading: const IconBubble(Icons.help_outline),
                                title: const Text('Uncategorized'),
                                subtitle: const Text('Includes debt payments logged from Goals'),
                                trailing: Text(fmtMoney(summary.uncategorizedSpentCents / 100),
                                    style: const TextStyle(fontWeight: FontWeight.w700)),
                                onTap: () => context.push(Routes.transactions),
                              ),
                            ),
                          ],
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

class _Header extends StatelessWidget {
  const _Header({required this.summary});
  final BudgetMonthSummary summary;

  @override
  Widget build(BuildContext context) {
    final toBudget = summary.toBudgetCents;
    final String subtitle;
    if (summary.incomeCents == 0) {
      subtitle = 'Add your income to start budgeting';
    } else if (toBudget > 0) {
      subtitle = 'ready to assign. Give every dollar a job!';
    } else if (toBudget == 0) {
      subtitle = 'Every dollar has a job 🎯';
    } else {
      subtitle = 'assigned more than you earned. Lower an envelope.';
    }

    return GradientHeader(
      title: fmtMoney(toBudget / 100),
      subtitle: subtitle,
      icon: toBudget < 0 ? Icons.warning_amber_rounded : Icons.account_balance_wallet,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          HeaderStat(label: 'income', value: fmtMoney(summary.incomeCents / 100), icon: Icons.south_west),
          HeaderStat(label: 'assigned', value: fmtMoney(summary.assignedCents / 100), icon: Icons.inbox_outlined),
          HeaderStat(label: 'spent', value: fmtMoney(summary.spentCents / 100), icon: Icons.shopping_bag_outlined),
          HeaderStat(
            label: summary.overspentCount > 0 ? '${summary.overspentCount} overspent' : 'left to spend',
            value: fmtMoney(summary.leftToSpendCents / 100),
            icon: Icons.savings_outlined,
          ),
        ],
      ),
    );
  }
}

class _IncomeHint extends StatelessWidget {
  const _IncomeHint();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(top: 14),
      color: cs.secondaryContainer,
      child: ListTile(
        leading: Icon(Icons.lightbulb_outline, color: cs.onSecondaryContainer),
        title: Text('How this works', style: TextStyle(color: cs.onSecondaryContainer, fontWeight: FontWeight.w700)),
        subtitle: Text(
          '1. Add the income you get this month.\n'
          '2. Tap each envelope and assign part of it.\n'
          '3. Log spending. Each envelope shows what\'s left.',
          style: TextStyle(color: cs.onSecondaryContainer),
        ),
      ),
    );
  }
}

/// Simple text prompt that returns the entered text.
class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.title, required this.label, this.helper, this.onOpenBills});
  final String title;
  final String label;
  final String? helper;

  /// When set, shows a link that closes the dialog and opens the bill tracker.
  final VoidCallback? onOpenBills;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _c,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: widget.label),
              onSubmitted: (v) => Navigator.pop(context, v),
            ),
            if (widget.helper != null) ...[
              const SizedBox(height: 12),
              Text(widget.helper!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
        actions: [
          if (widget.onOpenBills != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onOpenBills!();
              },
              child: const Text('Bills & Alerts'),
            ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, _c.text), child: const Text('Add')),
        ],
      );
}
