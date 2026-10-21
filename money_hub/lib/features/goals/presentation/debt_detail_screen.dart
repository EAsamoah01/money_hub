import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/router/routes.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/gradient_header.dart';
import '../data/debts_repository.dart';
import '../domain/debt_payoff.dart';

class DebtDetailScreen extends ConsumerWidget {
  const DebtDetailScreen({super.key, required this.debtId});
  final int debtId;

  Future<void> _recordPayment(BuildContext context, WidgetRef ref, Debt debt) async {
    final cents = await showDialog<int>(
      context: context,
      builder: (_) => _PaymentDialog(suggestedCents: debt.minimumPaymentCents, maxCents: debt.currentBalanceCents),
    );
    if (cents == null || cents <= 0) return;
    await ref.read(debtsRepositoryProvider).recordPayment(debtId: debt.id, amountCents: cents);
    if (context.mounted) {
      final done = cents >= debt.currentBalanceCents;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(done ? '🎉 ${debt.name} is paid off!' : 'Payment of ${fmtMoney(cents / 100, cents: true)} recorded'),
      ));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Debt debt) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${debt.name}?'),
        content: const Text('This removes the debt from your plan. Past payments stay in your history.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(debtsRepositoryProvider).remove(debt.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtAsync = ref.watch(debtProvider(debtId));
    final payments = ref.watch(debtPaymentsProvider(debtId)).valueOrNull ?? const <MoneyTransaction>[];
    final summary = ref.watch(debtSummaryProvider);

    return debtAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('$e'))),
      data: (debt) {
        if (debt == null) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('This debt was deleted.')));
        }
        final t = Theme.of(context);
        final fg = t.colorScheme.onPrimary;
        final start = debt.startingBalanceCents;
        final progress = start == 0 ? 1.0 : ((start - debt.currentBalanceCents) / start).clamp(0.0, 1.0).toDouble();
        final monthlyInterest = debt.currentBalanceCents / 100 * (debt.aprBasisPoints / 10000) / 12;

        int? goneInMonths;
        for (final p in summary?.payoff?.payoffOrder ?? const <PaidOffDebt>[]) {
          if (p.name == debt.name) goneInMonths = p.month;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(debt.name),
            actions: [
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push(Loc.debtEdit(debt.id)),
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _delete(context, ref, debt),
              ),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.only(bottom: 32),
                children: [
                  GradientHeader(
                    title: fmtMoney(debt.currentBalanceCents / 100, cents: true),
                    subtitle: debt.isPaidOff
                        ? 'Paid off. One less bill to worry about!'
                        : 'left of ${fmtMoney(start / 100)} · ${(progress * 100).round()}% paid',
                    icon: debt.isPaidOff ? Icons.celebration : Icons.credit_card,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
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
                            HeaderStat(label: 'APR', value: fmtPct(debt.aprBasisPoints / 100), icon: Icons.percent),
                            HeaderStat(
                              label: 'minimum',
                              value: fmtMoney(debt.minimumPaymentCents / 100),
                              icon: Icons.calendar_month_outlined,
                            ),
                            if (debt.dueDayOfMonth != null)
                              HeaderStat(label: 'due day', value: '${debt.dueDayOfMonth}', icon: Icons.event_outlined),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!debt.isPaidOff) ...[
                          FilledButton.icon(
                            onPressed: () => _recordPayment(context, ref, debt),
                            icon: const Icon(Icons.payments_outlined),
                            label: const Text('Record a payment'),
                            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                          ),
                          const SizedBox(height: 12),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _InfoRow(
                                    icon: Icons.local_fire_department_outlined,
                                    label: 'Interest this month (approx.)',
                                    value: fmtMoney(monthlyInterest, cents: true),
                                  ),
                                  if (goneInMonths != null)
                                    _InfoRow(
                                      icon: Icons.flag_outlined,
                                      label: 'Paid off with your plan in',
                                      value: fmtDuration(goneInMonths),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SectionTitle('Payments (${payments.length})'),
                        if (payments.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            child: Text(
                              'No payments recorded yet. Each payment you log moves your progress bar.',
                              style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
                            ),
                          ),
                        for (final p in payments)
                          Card(
                            child: ListTile(
                              leading: IconBubble(Icons.south_east, color: Colors.green.shade600),
                              title: Text(fmtMoney(-p.amountCents / 100, cents: true)),
                              subtitle: Text(DateFormat.yMMMd().format(p.date)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: t.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: t.textTheme.bodyMedium)),
          Text(value, style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/// Returns the payment amount in cents, or null if cancelled.
class _PaymentDialog extends StatefulWidget {
  const _PaymentDialog({required this.suggestedCents, required this.maxCents});
  final int suggestedCents;
  final int maxCents;

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  late final _amount = TextEditingController(
    text: (widget.suggestedCents.clamp(0, widget.maxCents) / 100).toStringAsFixed(2),
  );

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(context, (parseNum(_amount.text) * 100).round());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record a payment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _amount,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Amount paid', prefixText: r'$ '),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _amount.text = (widget.maxCents / 100).toStringAsFixed(2),
              child: Text('Pay it all off (${fmtMoney(widget.maxCents / 100, cents: true)})'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
