// Run with:  flutter test

import 'package:flutter_test/flutter_test.dart';
import 'package:money_hub/core/database/tables.dart';
import 'package:money_hub/features/budget/domain/budget_math.dart';

void main() {
  group('months', () {
    test('key, start, end, shift', () {
      expect(monthKey(DateTime(2026, 3, 15)), '2026-03');
      expect(monthStart('2026-12'), DateTime(2026, 12));
      expect(monthEnd('2026-12'), DateTime(2027, 1));
      expect(shiftMonth('2026-01', -1), '2025-12');
      expect(shiftMonth('2026-11', 2), '2027-01');
    });

    test('validates keys', () {
      expect(isValidMonthKey('2026-10'), isTrue);
      expect(isValidMonthKey('2026-13'), isFalse);
      expect(isValidMonthKey(null), isFalse);
    });
  });

  group('due dates', () {
    test('monthly clamps to the end of short months', () {
      expect(nextDueDate(DateTime(2026, 1, 31), Frequency.monthly), DateTime(2026, 2, 28));
      expect(nextDueDate(DateTime(2028, 1, 31), Frequency.monthly), DateTime(2028, 2, 29)); // leap year
    });

    test('weekly, quarterly and yearly', () {
      expect(nextDueDate(DateTime(2026, 12, 29), Frequency.weekly), DateTime(2027, 1, 5));
      expect(nextDueDate(DateTime(2026, 11, 30), Frequency.quarterly), DateTime(2027, 2, 28));
      expect(nextDueDate(DateTime(2028, 2, 29), Frequency.yearly), DateTime(2029, 2, 28));
    });

    test('days until and labels', () {
      final today = DateTime(2026, 10, 18, 21, 30);
      expect(daysUntil(DateTime(2026, 10, 18), today), 0);
      expect(dueLabel(DateTime(2026, 10, 19), today), 'Due tomorrow');
      expect(dueLabel(DateTime(2026, 10, 23), today), 'Due in 5 days');
      expect(dueLabel(DateTime(2026, 10, 16), today), '2 days overdue');
    });

    test('yearly and monthly equivalents', () {
      expect(yearlyCents(1599, Frequency.monthly), 19188);
      expect(monthlyCents(12000, Frequency.yearly), 1000);
      expect(yearlyCents(1000, Frequency.weekly), 52000);
    });
  });

  test('recurringTotals counts active items only', () {
    final t = recurringTotals([
      (amountCents: 1599, frequency: Frequency.monthly, kind: RecurringKind.subscription, active: true),
      (amountCents: 120000, frequency: Frequency.yearly, kind: RecurringKind.bill, active: true),
      (amountCents: 999, frequency: Frequency.monthly, kind: RecurringKind.subscription, active: false),
    ]);
    expect(t.yearlyCents, 19188 + 120000);
    expect(t.monthlyCents, ((19188 + 120000) / 12).round());
    expect(t.subscriptionCount, 1);
    expect(t.billCount, 1);
    expect(t.subscriptionsYearlyCents, 19188);
  });

  group('BudgetMonthSummary', () {
    final s = BudgetMonthSummary.compute(
      categories: const [
        (id: 1, groupId: 1, name: 'Rent'),
        (id: 2, groupId: 2, name: 'Groceries'),
      ],
      assignedByCategory: const {1: 150000, 2: 40000},
      transactions: const [
        (categoryId: null, type: TransactionType.income, amountCents: 300000),
        (categoryId: 1, type: TransactionType.expense, amountCents: -150000),
        (categoryId: 2, type: TransactionType.expense, amountCents: -45000), // overspent
        (categoryId: null, type: TransactionType.expense, amountCents: -20000), // debt payment
        (categoryId: 2, type: TransactionType.transfer, amountCents: -99999), // ignored
      ],
    );

    test('totals', () {
      expect(s.incomeCents, 300000);
      expect(s.assignedCents, 190000);
      expect(s.toBudgetCents, 110000);
      expect(s.spentCents, 215000);
      expect(s.uncategorizedSpentCents, 20000);
    });

    test('envelopes', () {
      final groceries = s.lines.firstWhere((l) => l.name == 'Groceries');
      expect(groceries.availableCents, -5000);
      expect(groceries.overspent, isTrue);
      expect(groceries.usedFraction, 1.0);
      expect(s.overspentCount, 1);
      expect(s.leftToSpendCents, 0 + -5000);
    });
  });
}
