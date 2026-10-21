import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/router/routes.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/gradient_header.dart';
import '../data/bills_repository.dart';
import '../domain/budget_math.dart';

const subscriptionColor = Color(0xFF7C3AED);
const billColor = Color(0xFF0E7490);

class BillsScreen extends ConsumerWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billsProvider);
    final totals = ref.watch(recurringTotalsProvider);
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Bills & subscriptions')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.billNew),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: billsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (bills) {
          if (bills.isEmpty) return const _Empty();
          final active = bills.where((b) => b.isActive).toList();
          final soon = active.where((b) => daysUntil(b.nextDueDate, today) <= 7).toList();
          final later = active.where((b) => daysUntil(b.nextDueDate, today) > 7).toList();
          final paused = bills.where((b) => !b.isActive).toList();
          final overdue = active.where((b) => daysUntil(b.nextDueDate, today) < 0).length;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.only(bottom: 96),
                children: [
                  if (totals != null)
                    GradientHeader(
                      title: '${fmtMoney(totals.monthlyCents / 100)}/mo',
                      subtitle: '${fmtMoney(totals.yearlyCents / 100)} a year on recurring costs',
                      icon: Icons.receipt_long,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          HeaderStat(label: 'bills', value: '${totals.billCount}', icon: Icons.receipt_outlined),
                          HeaderStat(
                            label: 'subscriptions · ${fmtMoney(totals.subscriptionsYearlyCents / 100)}/yr',
                            value: '${totals.subscriptionCount}',
                            icon: Icons.autorenew,
                          ),
                          HeaderStat(
                            label: overdue > 0 ? '$overdue overdue' : 'due this week',
                            value: '${soon.length}',
                            icon: overdue > 0 ? Icons.error_outline : Icons.event_outlined,
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (soon.isNotEmpty) const SectionTitle('Due in the next 7 days'),
                        for (final b in soon) BillTile(bill: b),
                        if (later.isNotEmpty) const SectionTitle('Later'),
                        for (final b in later) BillTile(bill: b),
                        if (paused.isNotEmpty) const SectionTitle('Paused or cancelled'),
                        for (final b in paused) BillTile(bill: b),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BillTile extends StatelessWidget {
  const BillTile({super.key, required this.bill});
  final RecurringItem bill;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final today = DateTime.now();
    final sub = bill.kind == RecurringKind.subscription;
    final days = daysUntil(bill.nextDueDate, today);
    final trial = bill.trialEndsAt;
    final trialSoon = trial != null && daysUntil(trial, today) >= 0;

    final String status;
    final Color statusColor;
    if (!bill.isActive) {
      status = 'Paused';
      statusColor = cs.onSurfaceVariant;
    } else if (trialSoon) {
      status = 'Free trial ends ${DateFormat.MMMd().format(trial!)}';
      statusColor = Colors.orange.shade800;
    } else {
      status = dueLabel(bill.nextDueDate, today);
      statusColor = days < 0 ? cs.error : (days <= 3 ? Colors.orange.shade800 : cs.onSurfaceVariant);
    }

    return Opacity(
      opacity: bill.isActive ? 1 : 0.6,
      child: Card(
        child: ListTile(
          onTap: () => context.push(Loc.billDetail(bill.id)),
          leading: IconBubble(sub ? Icons.autorenew : Icons.receipt_outlined, color: sub ? subscriptionColor : billColor),
          title: Text(bill.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text.rich(TextSpan(children: [
            TextSpan(text: status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600)),
            TextSpan(
              text: ' · ${frequencyLabel(bill.frequency)}${bill.autoPay ? ' · autopay' : ''}',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ])),
          trailing: Text(
            fmtMoney(bill.amountCents / 100, cents: true),
            style: t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconBubble(Icons.receipt_long_outlined, size: 88),
            const SizedBox(height: 20),
            Text('Never miss a bill', style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Add rent, phone, streaming and other recurring costs. See what\'s due and what '
              'your subscriptions really cost each year.',
              textAlign: TextAlign.center,
              style: t.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.push(Routes.billNew),
              icon: const Icon(Icons.add),
              label: const Text('Add your first bill'),
            ),
          ],
        ),
      ),
    );
  }
}
