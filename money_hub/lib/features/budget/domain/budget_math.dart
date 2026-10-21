// Pure budgeting logic (no Flutter, no database) so it's easy to unit-test.

import 'dart:math' as math;

import '../../../core/database/tables.dart' show Frequency, RecurringKind, TransactionType;

// ───────────────────────── Months ─────────────────────────

/// "2026-10"
String monthKey(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}';

bool isValidMonthKey(String? k) => k != null && RegExp(r'^\d{4}-(0[1-9]|1[0-2])$').hasMatch(k);

DateTime monthStart(String key) {
  final p = key.split('-');
  return DateTime(int.parse(p[0]), int.parse(p[1]));
}

/// First moment of the NEXT month (exclusive end).
DateTime monthEnd(String key) {
  final s = monthStart(key);
  return DateTime(s.year, s.month + 1);
}

String shiftMonth(String key, int delta) {
  final s = monthStart(key);
  return monthKey(DateTime(s.year, s.month + delta));
}

// ───────────────────────── Bills ─────────────────────────

/// Adds months without spilling over: Jan 31 + 1 month → Feb 28/29.
DateTime addMonthsClamped(DateTime d, int months) {
  final first = DateTime(d.year, d.month + months);
  final lastDay = DateTime(first.year, first.month + 1, 0).day;
  return DateTime(first.year, first.month, math.min(d.day, lastDay));
}

/// The due date after [from] for a bill on [frequency].
DateTime nextDueDate(DateTime from, Frequency frequency) => switch (frequency) {
      Frequency.weekly => DateTime(from.year, from.month, from.day + 7),
      Frequency.biweekly => DateTime(from.year, from.month, from.day + 14),
      Frequency.monthly => addMonthsClamped(from, 1),
      Frequency.quarterly => addMonthsClamped(from, 3),
      Frequency.yearly => addMonthsClamped(from, 12),
    };

double timesPerYear(Frequency f) => switch (f) {
      Frequency.weekly => 52,
      Frequency.biweekly => 26,
      Frequency.monthly => 12,
      Frequency.quarterly => 4,
      Frequency.yearly => 1,
    };

int yearlyCents(int amountCents, Frequency f) => (amountCents * timesPerYear(f)).round();
int monthlyCents(int amountCents, Frequency f) => (amountCents * timesPerYear(f) / 12).round();

String frequencyLabel(Frequency f) => switch (f) {
      Frequency.weekly => 'Weekly',
      Frequency.biweekly => 'Every 2 weeks',
      Frequency.monthly => 'Monthly',
      Frequency.quarterly => 'Every 3 months',
      Frequency.yearly => 'Yearly',
    };

/// Whole calendar days from [today] to [due]; negative = overdue.
int daysUntil(DateTime due, DateTime today) =>
    DateTime.utc(due.year, due.month, due.day).difference(DateTime.utc(today.year, today.month, today.day)).inDays;

/// "Due today", "Due tomorrow", "Due in 5 days", "3 days overdue".
String dueLabel(DateTime due, DateTime today) {
  final d = daysUntil(due, today);
  if (d < 0) return '${-d} day${d == -1 ? '' : 's'} overdue';
  if (d == 0) return 'Due today';
  if (d == 1) return 'Due tomorrow';
  return 'Due in $d days';
}

class RecurringTotals {
  const RecurringTotals({
    required this.monthlyCents,
    required this.yearlyCents,
    required this.billCount,
    required this.subscriptionCount,
    required this.subscriptionsYearlyCents,
  });
  final int monthlyCents;
  final int yearlyCents;
  final int billCount;
  final int subscriptionCount;
  final int subscriptionsYearlyCents;
}

/// Totals for ACTIVE items only.
RecurringTotals recurringTotals(Iterable<({int amountCents, Frequency frequency, RecurringKind kind, bool active})> items) {
  var yearly = 0, subsYearly = 0, bills = 0, subs = 0;
  for (final i in items) {
    if (!i.active) continue;
    final y = yearlyCents(i.amountCents, i.frequency);
    yearly += y;
    if (i.kind == RecurringKind.subscription) {
      subs++;
      subsYearly += y;
    } else {
      bills++;
    }
  }
  return RecurringTotals(
    monthlyCents: (yearly / 12).round(),
    yearlyCents: yearly,
    billCount: bills,
    subscriptionCount: subs,
    subscriptionsYearlyCents: subsYearly,
  );
}

// ───────────────────────── Monthly envelope summary ─────────────────────────

class EnvelopeLine {
  const EnvelopeLine({
    required this.categoryId,
    required this.groupId,
    required this.name,
    required this.assignedCents,
    required this.spentCents,
  });
  final int categoryId;
  final int groupId;
  final String name;
  final int assignedCents;

  /// Positive number = money spent this month.
  final int spentCents;

  int get availableCents => assignedCents - spentCents;
  bool get overspent => availableCents < 0;
  double get usedFraction =>
      assignedCents <= 0 ? (spentCents > 0 ? 1.0 : 0.0) : math.min(1.0, spentCents / assignedCents);
}

class BudgetMonthSummary {
  const BudgetMonthSummary({
    required this.incomeCents,
    required this.lines,
    required this.uncategorizedSpentCents,
  });

  final int incomeCents;
  final List<EnvelopeLine> lines;

  /// Spending with no category (e.g. debt payments logged from Goals).
  final int uncategorizedSpentCents;

  int get assignedCents => lines.fold(0, (s, l) => s + l.assignedCents);
  int get categorizedSpentCents => lines.fold(0, (s, l) => s + l.spentCents);
  int get spentCents => categorizedSpentCents + uncategorizedSpentCents;

  /// Zero-based budgeting: income not yet given a job. Negative = over-assigned.
  int get toBudgetCents => incomeCents - assignedCents;

  /// What's still left inside the envelopes.
  int get leftToSpendCents => lines.fold(0, (s, l) => s + l.availableCents);

  int get overspentCount => lines.where((l) => l.overspent).length;

  /// Build from plain values so it can be tested without a database.
  factory BudgetMonthSummary.compute({
    required List<({int id, int groupId, String name})> categories,
    required Map<int, int> assignedByCategory,
    required Iterable<({int? categoryId, TransactionType type, int amountCents})> transactions,
  }) {
    final spent = <int, int>{};
    var income = 0;
    var uncategorized = 0;
    final known = {for (final c in categories) c.id};

    for (final t in transactions) {
      switch (t.type) {
        case TransactionType.income:
          income += t.amountCents;
        case TransactionType.expense:
          final cents = -t.amountCents; // expenses are stored negative
          final id = t.categoryId;
          if (id != null && known.contains(id)) {
            spent[id] = (spent[id] ?? 0) + cents;
          } else {
            uncategorized += cents;
          }
        case TransactionType.transfer:
          break; // moving money between accounts isn't spending
      }
    }

    return BudgetMonthSummary(
      incomeCents: income,
      uncategorizedSpentCents: uncategorized,
      lines: [
        for (final c in categories)
          EnvelopeLine(
            categoryId: c.id,
            groupId: c.groupId,
            name: c.name,
            assignedCents: assignedByCategory[c.id] ?? 0,
            spentCents: spent[c.id] ?? 0,
          ),
      ],
    );
  }
}
