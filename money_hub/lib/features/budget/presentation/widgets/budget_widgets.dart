import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../domain/budget_math.dart';

/// "‹  October 2026  ›"
class MonthSwitcher extends StatelessWidget {
  const MonthSwitcher({super.key, required this.month, required this.onChanged});
  final String month;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isCurrent = month == monthKey(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Previous month',
            onPressed: () => onChanged(shiftMonth(month, -1)),
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Column(
              children: [
                Text(DateFormat.yMMMM().format(monthStart(month)),
                    style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                if (!isCurrent)
                  TextButton(
                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                    onPressed: () => onChanged(monthKey(DateTime.now())),
                    child: const Text('Back to this month'),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Next month',
            onPressed: () => onChanged(shiftMonth(month, 1)),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

/// One row in any transaction list.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.tx,
    this.categoryName,
    this.accountName,
    this.onTap,
  });

  final MoneyTransaction tx;
  final String? categoryName;
  final String? accountName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final income = tx.type == TransactionType.income;
    final color = income ? Colors.green.shade700 : cs.onSurface;

    final IconData icon;
    if (income) {
      icon = Icons.south_west;
    } else if (tx.debtId != null) {
      icon = Icons.credit_card;
    } else if (tx.recurringItemId != null) {
      icon = Icons.receipt_long;
    } else {
      icon = Icons.shopping_bag_outlined;
    }

    final details = [
      if (income) 'Income' else categoryName ?? (tx.debtId != null ? 'Debt payment' : 'Uncategorized'),
      if (accountName != null) accountName!,
      DateFormat.MMMd().format(tx.date),
    ].join(' · ');

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: IconBubble(icon, color: income ? Colors.green.shade700 : cs.primary),
        title: Text(
          (tx.payee?.trim().isNotEmpty ?? false) ? tx.payee! : (income ? 'Income' : 'Spending'),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(details, style: TextStyle(color: cs.onSurfaceVariant)),
        trailing: Text(
          '${income ? '+' : '−'}${fmtMoney(tx.amountCents.abs() / 100, cents: true)}',
          style: t.textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// Envelope row: name, spent-of-assigned bar, and what's available.
class EnvelopeTile extends StatelessWidget {
  const EnvelopeTile({super.key, required this.line, this.onTap});
  final EnvelopeLine line;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final over = line.overspent;
    final empty = line.assignedCents == 0 && line.spentCents == 0;
    final availColor = over ? cs.error : (empty ? cs.onSurfaceVariant : Colors.green.shade700);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(line.name, style: t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: availColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      fmtMoney(line.availableCents / 100),
                      style: t.textTheme.labelLarge?.copyWith(color: availColor, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: line.usedFraction,
                  minHeight: 6,
                  color: over ? cs.error : cs.primary,
                  backgroundColor: cs.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                empty
                    ? 'Nothing assigned yet'
                    : 'Spent ${fmtMoney(line.spentCents / 100)} of ${fmtMoney(line.assignedCents / 100)}'
                        '${over ? ' · overspent' : ''}',
                style: t.textTheme.bodySmall?.copyWith(color: over ? cs.error : cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Groups transactions under day headings with a daily total.
List<Widget> transactionsByDay(
  List<MoneyTransaction> txs, {
  required Map<int, String> categoryNames,
  Map<int, String> accountNames = const {},
  required void Function(MoneyTransaction) onTap,
  required BuildContext context,
}) {
  final t = Theme.of(context);
  final out = <Widget>[];
  String? currentDay;
  for (final tx in txs) {
    final day = DateFormat.yMMMEd().format(tx.date);
    if (day != currentDay) {
      currentDay = day;
      final dayTotal = txs
          .where((x) => DateFormat.yMMMEd().format(x.date) == day && x.type == TransactionType.expense)
          .fold<int>(0, (s, x) => s - x.amountCents);
      out.add(Padding(
        padding: const EdgeInsets.fromLTRB(4, 14, 4, 6),
        child: Row(
          children: [
            Expanded(child: Text(day, style: t.textTheme.labelLarge)),
            if (dayTotal > 0)
              Text('spent ${fmtMoney(dayTotal / 100)}',
                  style: t.textTheme.labelMedium?.copyWith(color: t.colorScheme.onSurfaceVariant)),
          ],
        ),
      ));
    }
    out.add(TransactionTile(
      tx: tx,
      categoryName: tx.categoryId == null ? null : categoryNames[tx.categoryId],
      accountName: accountNames[tx.accountId],
      onTap: () => onTap(tx),
    ));
  }
  return out;
}
