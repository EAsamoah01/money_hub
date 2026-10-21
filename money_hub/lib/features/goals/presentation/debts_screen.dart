import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/router/routes.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/gradient_header.dart';
import '../data/debts_repository.dart';
import '../domain/debt_payoff.dart';

class DebtsScreen extends ConsumerWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtsAsync = ref.watch(allDebtsProvider);
    final summary = ref.watch(debtSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(Routes.debtPlan),
            icon: const Icon(Icons.tune),
            label: const Text('Plan'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.debtNew),
        icon: const Icon(Icons.add),
        label: const Text('Add debt'),
      ),
      body: debtsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load debts.\n$e', textAlign: TextAlign.center)),
        data: (debts) {
          if (debts.isEmpty) return const _EmptyState();
          final open = debts.where((d) => !d.isPaidOff).toList();
          final paid = debts.where((d) => d.isPaidOff).toList();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.only(bottom: 96),
                children: [
                  if (summary != null) _SummaryHeader(summary: summary),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (summary != null) _PlanBanner(summary: summary),
                        if (open.isNotEmpty) SectionTitle('Still to pay (${open.length})'),
                        for (final d in open) _DebtTile(debt: d, summary: summary),
                        if (paid.isNotEmpty) SectionTitle('Paid off (${paid.length}) 🎉'),
                        for (final d in paid) _DebtTile(debt: d, summary: summary),
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

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.summary});
  final DebtSummary summary;

  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).colorScheme.onPrimary;
    final free = summary.debtFreeDate;
    final payoff = summary.payoff;
    return GradientHeader(
      title: fmtMoney(summary.totalOwedCents / 100),
      subtitle: summary.openCount == 0
          ? 'All debts paid off. Amazing work!'
          : 'left to pay across ${summary.openCount} debt${summary.openCount == 1 ? '' : 's'}',
      icon: Icons.trending_down,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: summary.progress,
              minHeight: 8,
              color: fg,
              backgroundColor: fg.withValues(alpha: 0.25),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              HeaderStat(
                label: 'paid off (${(summary.progress * 100).round()}%)',
                value: fmtMoney(summary.paidCents / 100),
                icon: Icons.check_circle_outline,
              ),
              if (free != null)
                HeaderStat(label: 'debt-free', value: DateFormat.yMMM().format(free), icon: Icons.celebration_outlined),
              if (payoff != null && payoff.paysOff)
                HeaderStat(
                  label: 'interest to go',
                  value: fmtMoney(payoff.totalInterest),
                  icon: Icons.percent,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanBanner extends StatelessWidget {
  const _PlanBanner({required this.summary});
  final DebtSummary summary;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final payoff = summary.payoff;
    final method = summary.strategy == PayoffStrategy.snowball ? 'Snowball' : 'Avalanche';
    final extra = summary.extraMonthlyCents > 0 ? ' + ${fmtMoney(summary.extraMonthlyCents / 100)}/mo extra' : '';
    final warning = payoff != null && !payoff.paysOff;

    return Card(
      color: warning ? t.colorScheme.errorContainer : t.colorScheme.secondaryContainer,
      child: ListTile(
        leading: Icon(warning ? Icons.warning_amber : Icons.route_outlined),
        title: Text(warning ? "Payments don't cover the interest" : 'Plan: $method$extra'),
        subtitle: Text(warning
            ? 'Raise a minimum payment or add extra each month.'
            : 'Tap to change your strategy or add an extra payment'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(Routes.debtPlan),
      ),
    );
  }
}

class _DebtTile extends StatelessWidget {
  const _DebtTile({required this.debt, required this.summary});
  final Debt debt;
  final DebtSummary? summary;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final start = debt.startingBalanceCents;
    final progress = start == 0 ? 1.0 : (start - debt.currentBalanceCents) / start;

    int? paidOffMonth;
    for (final p in summary?.payoff?.payoffOrder ?? const <PaidOffDebt>[]) {
      if (p.name == debt.name) paidOffMonth = p.month;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(Loc.debtDetail(debt.id)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  IconBubble(
                    debt.isPaidOff ? Icons.check : Icons.credit_card,
                    color: debt.isPaidOff ? Colors.green.shade600 : cs.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(debt.name, style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        Text(
                          debt.isPaidOff
                              ? 'Paid off${debt.paidOffAt != null ? ' ${DateFormat.yMMMd().format(debt.paidOffAt!)}' : ''}'
                              : '${fmtPct(debt.aprBasisPoints / 100)} APR · min ${fmtMoney(debt.minimumPaymentCents / 100)}'
                                  '${paidOffMonth != null ? ' · gone in ${fmtDuration(paidOffMonth)}' : ''}',
                          style: t.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    fmtMoney(debt.currentBalanceCents / 100),
                    style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0).toDouble(),
                  minHeight: 6,
                  color: debt.isPaidOff ? Colors.green.shade600 : cs.primary,
                  backgroundColor: cs.surfaceContainerHighest,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconBubble(Icons.credit_card_off_outlined, size: 88),
            const SizedBox(height: 20),
            Text('Track your debts', style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Add each credit card or loan to see your debt-free date and the fastest way to get there.',
              textAlign: TextAlign.center,
              style: t.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.push(Routes.debtNew),
              icon: const Icon(Icons.add),
              label: const Text('Add your first debt'),
            ),
          ],
        ),
      ),
    );
  }
}
