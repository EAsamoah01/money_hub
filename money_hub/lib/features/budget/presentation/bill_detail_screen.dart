import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/database/app_database.dart';
import '../../../core/router/routes.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/gradient_header.dart';
import '../data/bills_repository.dart';
import '../data/budget_repository.dart';
import '../domain/budget_math.dart';
import 'widgets/budget_widgets.dart';

class BillDetailScreen extends ConsumerWidget {
  const BillDetailScreen({super.key, required this.billId});
  final int billId;

  Future<void> _markPaid(BuildContext context, WidgetRef ref, RecurringItem bill) async {
    final cents = await showDialog<int>(
      context: context,
      builder: (_) => _PaidDialog(bill: bill),
    );
    if (cents == null || cents <= 0) return;
    await ref.read(billsRepositoryProvider).markPaid(bill, amountCents: cents);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Paid. Next due ${DateFormat.MMMd().format(nextDueDate(bill.nextDueDate, bill.frequency))}'),
      ));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, RecurringItem bill) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${bill.name}?'),
        content: const Text('Past payments stay in your transactions.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(billsRepositoryProvider).remove(bill.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billAsync = ref.watch(billProvider(billId));
    final payments = ref.watch(billPaymentsProvider(billId)).valueOrNull ?? const [];
    final names = ref.watch(categoryNamesProvider);
    final accounts = ref.watch(accountNamesProvider);

    return billAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('$e'))),
      data: (bill) {
        if (bill == null) return Scaffold(appBar: AppBar(), body: const Center(child: Text('This bill was deleted.')));
        final t = Theme.of(context);
        final today = DateTime.now();
        final sub = bill.kind == RecurringKind.subscription;
        final trial = bill.trialEndsAt;
        final cancelUrl = bill.cancelUrl;
        final paidTotal = payments.fold<int>(0, (s, p) => s - p.amountCents);

        return Scaffold(
          appBar: AppBar(
            title: Text(bill.name),
            actions: [
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push(Loc.billEdit(bill.id)),
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _delete(context, ref, bill),
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
                    title: fmtMoney(bill.amountCents / 100, cents: true),
                    subtitle: '${frequencyLabel(bill.frequency)} ${sub ? 'subscription' : 'bill'}'
                        '${bill.autoPay ? ' · autopay' : ''}',
                    icon: sub ? Icons.autorenew : Icons.receipt_long,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        HeaderStat(
                          label: bill.isActive ? dueLabel(bill.nextDueDate, today) : 'paused',
                          value: DateFormat.MMMd().format(bill.nextDueDate),
                          icon: Icons.event_outlined,
                        ),
                        HeaderStat(
                          label: 'per year',
                          value: fmtMoney(yearlyCents(bill.amountCents, bill.frequency) / 100),
                          icon: Icons.calendar_today_outlined,
                        ),
                        if (bill.categoryId != null && names[bill.categoryId] != null)
                          HeaderStat(label: 'category', value: names[bill.categoryId]!, icon: Icons.inbox_outlined),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (trial != null && daysUntil(trial, today) >= 0)
                          Card(
                            color: Colors.orange.shade50,
                            child: ListTile(
                              leading: Icon(Icons.hourglass_bottom, color: Colors.orange.shade800),
                              title: Text(
                                'Free trial ends ${DateFormat.yMMMd().format(trial)}',
                                style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                'Cancel before then if you don\'t want to pay ${fmtMoney(bill.amountCents / 100, cents: true)}.',
                                style: TextStyle(color: Colors.orange.shade900),
                              ),
                            ),
                          ),
                        if (bill.isActive)
                          FilledButton.icon(
                            onPressed: () => _markPaid(context, ref, bill),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Mark as paid'),
                            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                          ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => ref.read(billsRepositoryProvider).setActive(bill.id, !bill.isActive),
                                icon: Icon(bill.isActive ? Icons.pause : Icons.play_arrow),
                                label: Text(bill.isActive ? 'Pause' : 'Resume'),
                              ),
                            ),
                            if (cancelUrl != null) ...[
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      launchUrl(Uri.parse(cancelUrl), mode: LaunchMode.externalApplication),
                                  icon: const Icon(Icons.open_in_new),
                                  label: const Text('How to cancel'),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SectionTitle(
                          'Payments (${payments.length})',
                          action: paidTotal > 0
                              ? Text('${fmtMoney(paidTotal / 100)} total', style: t.textTheme.labelLarge)
                              : null,
                        ),
                        if (payments.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('No payments logged yet. Tap "Mark as paid" when you pay it.'),
                          ),
                        ...transactionsByDay(
                          payments,
                          categoryNames: names,
                          accountNames: accounts,
                          context: context,
                          onTap: (p) => context.push(Loc.transactionEdit(p.id)),
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

class _PaidDialog extends StatefulWidget {
  const _PaidDialog({required this.bill});
  final RecurringItem bill;

  @override
  State<_PaidDialog> createState() => _PaidDialogState();
}

class _PaidDialogState extends State<_PaidDialog> {
  late final _amount = TextEditingController(text: (widget.bill.amountCents / 100).toStringAsFixed(2));

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(context, (parseNum(_amount.text) * 100).round());

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('Paid ${widget.bill.name}'),
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
            Text(
              'Logged as spending today and the next due date moves to '
              '${DateFormat.yMMMd().format(nextDueDate(widget.bill.nextDueDate, widget.bill.frequency))}.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: _submit, child: const Text('Save')),
        ],
      );
}
