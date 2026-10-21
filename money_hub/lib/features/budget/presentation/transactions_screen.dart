import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/router/routes.dart';
import '../../../core/utils/money_format.dart';
import '../data/budget_repository.dart';
import '../domain/budget_math.dart';
import 'widgets/budget_widgets.dart';

enum _Filter { all, spending, income }

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _month = monthKey(DateTime.now());
  _Filter _filter = _Filter.all;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(monthTransactionsProvider(_month));
    final names = ref.watch(categoryNamesProvider);
    final accounts = ref.watch(accountNamesProvider);
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add transaction',
        onPressed: () => context.push(Loc.transactionNew()),
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: all.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (txs) {
              final q = _query.toLowerCase();
              final shown = txs.where((x) {
                if (_filter == _Filter.spending && x.type != TransactionType.expense) return false;
                if (_filter == _Filter.income && x.type != TransactionType.income) return false;
                if (q.isEmpty) return true;
                final cat = x.categoryId == null ? '' : (names[x.categoryId] ?? '');
                return (x.payee ?? '').toLowerCase().contains(q) ||
                    (x.note ?? '').toLowerCase().contains(q) ||
                    cat.toLowerCase().contains(q);
              }).toList();

              final spent = txs
                  .where((x) => x.type == TransactionType.expense)
                  .fold<int>(0, (s, x) => s - x.amountCents);
              final earned = txs
                  .where((x) => x.type == TransactionType.income)
                  .fold<int>(0, (s, x) => s + x.amountCents);

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                children: [
                  MonthSwitcher(month: _month, onChanged: (m) => setState(() => _month = m)),
                  Row(
                    children: [
                      Expanded(
                        child: _Total(label: 'Spent', cents: spent, color: t.colorScheme.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Total(label: 'Income', cents: earned, color: Colors.green.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search payee, note or category',
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<_Filter>(
                    segments: const [
                      ButtonSegment(value: _Filter.all, label: Text('All')),
                      ButtonSegment(value: _Filter.spending, label: Text('Spending')),
                      ButtonSegment(value: _Filter.income, label: Text('Income')),
                    ],
                    selected: {_filter},
                    onSelectionChanged: (s) => setState(() => _filter = s.first),
                  ),
                  if (shown.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: Text('No transactions here yet.')),
                    ),
                  ...transactionsByDay(
                    shown,
                    categoryNames: names,
                    accountNames: accounts,
                    context: context,
                    onTap: (x) => context.push(Loc.transactionEdit(x.id)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({required this.label, required this.cents, required this.color});
  final String label;
  final int cents;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: t.textTheme.labelLarge?.copyWith(color: color)),
          Text(fmtMoney(cents / 100),
              style: t.textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
