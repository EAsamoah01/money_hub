// Turns the user's budget into a short plain-text summary the AI can read.
// Pure Dart (no Flutter, no database) so it's easy to test.

import 'package:intl/intl.dart';

import '../../../core/database/tables.dart' show DebtStrategy, Frequency;
import '../../budget/domain/budget_math.dart';
import '../../learn/domain/lesson.dart';

typedef CtxSpend = ({DateTime date, String? payee, String? category, int amountCents});
typedef CtxBill = ({
  String name,
  bool subscription,
  int amountCents,
  Frequency frequency,
  DateTime nextDue,
  bool autoPay,
});
typedef CtxDebt = ({String name, int balanceCents, int aprBasisPoints, int minimumCents});

String _money(int cents) {
  final f = NumberFormat.simpleCurrency(decimalDigits: 2);
  return f.format(cents / 100);
}

final _day = DateFormat('MMM d');

/// Keeps the summary small: the AI only needs the main facts.
String buildMoneyContext({
  required DateTime now,
  required BudgetMonthSummary? summary,
  List<CtxSpend> recentSpending = const [],
  List<CtxBill> bills = const [],
  List<CtxDebt> debts = const [],
  ({DebtStrategy strategy, int extraMonthlyCents})? debtPlan,
}) {
  final b = StringBuffer()
    ..writeln('Today: ${DateFormat('EEEE, MMMM d, y').format(now)}');

  b.writeln();
  b.writeln('BUDGET FOR ${DateFormat('MMMM y').format(now).toUpperCase()}');
  if (summary == null) {
    b.writeln('(not loaded)');
  } else {
    b
      ..writeln('Income received this month: ${_money(summary.incomeCents)}')
      ..writeln('Assigned to envelopes: ${_money(summary.assignedCents)}')
      ..writeln('Spent: ${_money(summary.spentCents)}'
          '${summary.uncategorizedSpentCents > 0 ? ' (incl. ${_money(summary.uncategorizedSpentCents)} uncategorized)' : ''}')
      ..writeln('Left in envelopes: ${_money(summary.leftToSpendCents)}')
      ..writeln(summary.toBudgetCents >= 0
          ? 'Income not yet assigned: ${_money(summary.toBudgetCents)}'
          : 'Over-assigned by ${_money(-summary.toBudgetCents)} (assigned more than income)');
    final used = summary.lines.where((l) => l.assignedCents != 0 || l.spentCents != 0).toList();
    if (used.isEmpty) {
      b.writeln('No envelopes have money assigned or spending yet.');
    } else {
      b.writeln('Envelopes (assigned / spent / available):');
      for (final l in used) {
        b.writeln('- ${l.name}: ${_money(l.assignedCents)} / ${_money(l.spentCents)} / '
            '${_money(l.availableCents)}${l.overspent ? ' OVERSPENT' : ''}');
      }
    }
  }

  if (recentSpending.isNotEmpty) {
    b
      ..writeln()
      ..writeln('RECENT SPENDING THIS MONTH');
    for (final s in recentSpending.take(15)) {
      b.writeln('- ${_day.format(s.date)}: ${_money(s.amountCents)}'
          '${s.payee != null ? ' at ${s.payee}' : ''} [${s.category ?? 'uncategorized'}]');
    }
  }

  b
    ..writeln()
    ..writeln('BILLS AND SUBSCRIPTIONS (active)');
  if (bills.isEmpty) {
    b.writeln('None tracked.');
  } else {
    var monthly = 0;
    for (final x in bills) {
      monthly += monthlyCents(x.amountCents, x.frequency);
      b.writeln('- ${x.name} (${x.subscription ? 'subscription' : 'bill'}, ${frequencyLabel(x.frequency).toLowerCase()}): '
          '${_money(x.amountCents)}, ${dueLabel(x.nextDue, now).toLowerCase()} (${_day.format(x.nextDue)})'
          '${x.autoPay ? ', autopay' : ''}');
    }
    b.writeln('Total about ${_money(monthly)} a month.');
  }

  b
    ..writeln()
    ..writeln('DEBTS');
  if (debts.isEmpty) {
    b.writeln('None tracked.');
  } else {
    for (final d in debts) {
      b.writeln('- ${d.name}: balance ${_money(d.balanceCents)}, '
          'APR ${(d.aprBasisPoints / 100).toStringAsFixed(2)}%, minimum ${_money(d.minimumCents)}/month');
    }
    if (debtPlan != null) {
      b.writeln('Payoff plan: ${debtPlan.strategy.name}, extra ${_money(debtPlan.extraMonthlyCents)}/month');
    }
  }
  return b.toString().trim();
}

/// The lesson as plain text, for "explain this lesson".
String lessonContext(Lesson lesson) {
  final b = StringBuffer()..writeln('LESSON: ${lesson.title} (${lesson.trackTitle})');
  for (final s in lesson.sections) {
    switch (s) {
      case TextSection(:final body):
        b.writeln(body);
      case CalloutSection(:final body):
        b.writeln('Tip: $body');
      case BulletsSection(:final items):
        for (final i in items) {
          b.writeln('- $i');
        }
      case CalculatorLinkSection():
        break;
    }
  }
  return b.toString().trim();
}

/// Category list for auto-categorize: one allowed name per line.
String categoriesContext(Iterable<String> names) =>
    'Allowed categories:\n${[for (final n in names) n].join('\n')}';

/// Maps the AI's answer back to a category name (case-insensitive), or null.
String? matchCategory(String aiAnswer, Iterable<String> names) {
  final a = aiAnswer.trim().replaceAll(RegExp(r'^["“\x27-]+|["”\x27.]+$'), '').trim().toLowerCase();
  if (a.isEmpty || a == 'none') return null;
  for (final n in names) {
    if (n.toLowerCase() == a) return n;
  }
  for (final n in names) {
    if (a.contains(n.toLowerCase())) return n;
  }
  return null;
}
