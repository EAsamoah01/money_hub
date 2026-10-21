// Run with:  flutter test
// Expected values were cross-checked against standard formulas
// (e.g. future value of an annuity) and an independent implementation.

import 'package:flutter_test/flutter_test.dart';
import 'package:money_hub/features/goals/domain/debt_payoff.dart';
import 'package:money_hub/features/tools/domain/calculators.dart';

void main() {
  group('compoundInterest', () {
    test('\$200/mo for 30 years at 7%', () {
      final r = compoundInterest(principal: 0, monthly: 200, annualRatePct: 7, years: 30);
      expect(r.finalBalance, closeTo(243994.20, 0.01));
      expect(r.totalContributed, 72000);
      expect(r.series.length, 31); // year 0..30
    });

    test('lump sum only: \$10k for 10 years at 7%', () {
      final r = compoundInterest(principal: 10000, monthly: 0, annualRatePct: 7, years: 10);
      expect(r.finalBalance, closeTo(20096.61, 0.01));
    });

    test('0% return just adds contributions', () {
      final r = compoundInterest(principal: 1000, monthly: 100, annualRatePct: 0, years: 10);
      expect(r.finalBalance, closeTo(13000, 1e-9));
      expect(r.totalGrowth, closeTo(0, 1e-9));
    });
  });

  group('fireCalc', () {
    test('4% rule: \$40k spending → \$1M, reached in 235 months', () {
      final r = fireCalc(
        annualSpending: 40000,
        currentSavings: 0,
        monthlyContribution: 2000,
        annualReturnPct: 7,
        currentAge: 30,
      );
      expect(r.fireNumber, 1000000);
      expect(r.monthsToFire, 235);
      expect(r.fireAge, 50);
    });

    test('already at FIRE', () {
      final r = fireCalc(
        annualSpending: 40000,
        currentSavings: 2000000,
        monthlyContribution: 0,
        annualReturnPct: 7,
      );
      expect(r.monthsToFire, 0);
    });
  });

  group('dcaVsLumpSum', () {
    test('equal at 0% return', () {
      final r = dcaVsLumpSum(amount: 12000, dcaMonths: 12, annualReturnPct: 0, years: 5);
      expect(r.lumpSumFinal, closeTo(12000, 1e-6));
      expect(r.dcaFinal, closeTo(12000, 1e-6));
    });

    test('lump sum wins with a constant positive return', () {
      final r = dcaVsLumpSum(amount: 12000, dcaMonths: 12, annualReturnPct: 7, years: 5);
      expect(r.lumpSumFinal, closeTo(17011.50, 0.01));
      expect(r.dcaFinal, closeTo(16479.24, 0.01));
      expect(r.lumpByMonth.length, 61);
    });
  });

  test('inflationCalc: \$100 at 3% for 10 years', () {
    final r = inflationCalc(amount: 100, inflationPct: 3, years: 10);
    expect(r.futureCost, closeTo(134.39, 0.01));
    expect(r.purchasingPower, closeTo(74.41, 0.01));
  });

  group('simulatePayoff', () {
    const debts = [
      DebtInput(name: 'Card A', balance: 5000, aprPct: 22.99, minPayment: 150),
      DebtInput(name: 'Car loan', balance: 12000, aprPct: 6.5, minPayment: 300),
      DebtInput(name: 'Card B', balance: 1200, aprPct: 18, minPayment: 40),
    ];

    test('snowball pays smallest balance first', () {
      final r = simulatePayoff(debts, strategy: PayoffStrategy.snowball, extraMonthly: 200);
      expect(r.paysOff, isTrue);
      expect(r.months, 30);
      expect(r.totalInterest, closeTo(2493.95, 0.01));
      expect(r.payoffOrder.map((d) => d.name), ['Card B', 'Card A', 'Car loan']);
      expect(r.payoffOrder.map((d) => d.month), [6, 20, 30]);
    });

    test('avalanche pays highest APR first and costs less interest', () {
      final r = simulatePayoff(debts, strategy: PayoffStrategy.avalanche, extraMonthly: 200);
      expect(r.months, 30);
      expect(r.totalInterest, closeTo(2418.65, 0.01));
      expect(r.payoffOrder.first.name, 'Card A');
    });

    test('total paid = balances + interest', () {
      final r = simulatePayoff(debts, strategy: PayoffStrategy.snowball, extraMonthly: 200);
      expect(r.totalPaid, closeTo(18200 + r.totalInterest, 0.01));
    });

    test('flags payments that never cover interest', () {
      final r = simulatePayoff(
        const [DebtInput(name: 'Card', balance: 10000, aprPct: 24, minPayment: 100)],
        strategy: PayoffStrategy.snowball,
      );
      expect(r.paysOff, isFalse);
    });
  });
}
