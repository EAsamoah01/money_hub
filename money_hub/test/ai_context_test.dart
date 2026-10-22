// Run with:  flutter test

import 'package:flutter_test/flutter_test.dart';
import 'package:money_hub/core/database/tables.dart';
import 'package:money_hub/features/ai/domain/money_context.dart';
import 'package:money_hub/features/budget/domain/budget_math.dart';
import 'package:money_hub/features/learn/domain/lesson.dart';

void main() {
  final now = DateTime(2026, 10, 21, 15);

  final summary = BudgetMonthSummary.compute(
    categories: [
      (id: 1, groupId: 1, name: 'Rent / Mortgage'),
      (id: 2, groupId: 2, name: 'Groceries'),
      (id: 3, groupId: 2, name: 'Fun money'),
    ],
    assignedByCategory: {1: 160000, 2: 40000},
    transactions: [
      (categoryId: null, type: TransactionType.income, amountCents: 300000),
      (categoryId: 2, type: TransactionType.expense, amountCents: -45000),
    ],
  );

  test('money context lists totals, used envelopes, bills and debts', () {
    final c = buildMoneyContext(
      now: now,
      summary: summary,
      recentSpending: [(date: DateTime(2026, 10, 20), payee: 'Walmart', category: 'Groceries', amountCents: 45000)],
      bills: [
        (
          name: 'Telnet',
          subscription: false,
          amountCents: 2000000,
          frequency: Frequency.monthly,
          nextDue: DateTime(2026, 10, 21),
          autoPay: false,
        ),
      ],
      debts: [(name: 'Visa', balanceCents: 300000, aprBasisPoints: 1999, minimumCents: 9000)],
      debtPlan: (strategy: DebtStrategy.avalanche, extraMonthlyCents: 10000),
    );
    expect(c, contains(r'Income received this month: $3,000.00'));
    expect(c, contains(r'Income not yet assigned: $1,000.00'));
    expect(c, contains(r'- Groceries: $400.00 / $450.00 / -$50.00 OVERSPENT'));
    expect(c, isNot(contains('Fun money'))); // empty envelopes are left out
    expect(c, contains(r'Walmart [Groceries]'));
    expect(c, contains(r'- Telnet (bill, monthly): $20,000.00, due today'));
    expect(c, contains('APR 19.99%'));
    expect(c, contains('Payoff plan: avalanche'));
  });

  test('money context copes with an empty app', () {
    final c = buildMoneyContext(now: now, summary: null);
    expect(c, contains('(not loaded)'));
    expect(c, contains('None tracked.'));
  });

  test('matchCategory maps the AI answer to a real category', () {
    const names = ['Groceries', 'Dining out', 'Phone & Internet'];
    expect(matchCategory('Groceries', names), 'Groceries');
    expect(matchCategory(' "dining out". ', names), 'Dining out');
    expect(matchCategory('Category: Phone & Internet', names), 'Phone & Internet');
    expect(matchCategory('NONE', names), isNull);
    expect(matchCategory('Travel', names), isNull);
  });

  test('lessonContext flattens sections', () {
    const lesson = Lesson(
      id: 'x',
      title: 'Emergency funds',
      track: 'basics',
      trackTitle: 'Money basics',
      trackOrder: 1,
      order: 1,
      minutes: 3,
      sections: [
        TextSection('Save 3 months of costs.'),
        CalloutSection('Start with \$500.'),
        BulletsSection(['High-yield savings', 'Separate account']),
        CalculatorLinkSection(label: 'Try it', calculator: 'fire', prefill: {}),
      ],
      quiz: [],
    );
    final c = lessonContext(lesson);
    expect(c, startsWith('LESSON: Emergency funds (Money basics)'));
    expect(c, contains('Tip: Start with \$500.'));
    expect(c, contains('- Separate account'));
    expect(c, isNot(contains('Try it')));
  });
}
