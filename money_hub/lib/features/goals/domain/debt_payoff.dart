// Debt payoff simulator — shared by the free Tools calculator and the
// Pro Goals → Payoff plan screen.
//
// Each month:
//   1. interest is added to every open debt (APR / 12),
//   2. every open debt gets its minimum payment,
//   3. whatever is left of the monthly budget goes to the priority debt.
// The monthly budget stays fixed at (sum of all minimums + extra), so when a
// debt is paid off its minimum "rolls over" to the next one — the classic
// snowball/avalanche effect.

import 'dart:math' as math;

enum PayoffStrategy {
  /// Smallest balance first — quick wins, more motivation.
  snowball,

  /// Highest interest rate first — least total interest.
  avalanche,
}

class DebtInput {
  const DebtInput({
    required this.name,
    required this.balance,
    required this.aprPct,
    required this.minPayment,
  });
  final String name;
  final double balance;
  final double aprPct;
  final double minPayment;
}

class PaidOffDebt {
  const PaidOffDebt(this.name, this.month);
  final String name;
  final int month;
}

class DebtPayoffResult {
  const DebtPayoffResult({
    required this.strategy,
    required this.months,
    required this.totalInterest,
    required this.totalPaid,
    required this.payoffOrder,
    required this.balanceByMonth,
    required this.paysOff,
  });
  final PayoffStrategy strategy;
  final int months;
  final double totalInterest;
  final double totalPaid;
  final List<PaidOffDebt> payoffOrder;

  /// Total remaining balance; index 0 = today.
  final List<double> balanceByMonth;

  /// false when payments never cover the interest within the time limit.
  final bool paysOff;
}

const _eps = 0.005; // half a cent

DebtPayoffResult simulatePayoff(
  List<DebtInput> debts, {
  required PayoffStrategy strategy,
  double extraMonthly = 0,
  int maxMonths = 600,
}) {
  final bal = [for (final d in debts) math.max(0.0, d.balance)];
  final rate = [for (final d in debts) d.aprPct / 100 / 12];
  final mins = [for (final d in debts) math.max(0.0, d.minPayment)];
  final budget = mins.fold<double>(0, (a, b) => a + b) + math.max(0.0, extraMonthly);
  final done = [for (final b in bal) b <= _eps];

  double total() => bal.fold<double>(0, (a, b) => a + b);

  final order = <PaidOffDebt>[];
  final series = <double>[total()];
  var interestSum = 0.0;
  var paidSum = 0.0;
  var month = 0;

  while (total() > _eps && month < maxMonths) {
    month++;

    // 1. Interest.
    for (var i = 0; i < bal.length; i++) {
      if (bal[i] > _eps) {
        final interest = bal[i] * rate[i];
        bal[i] += interest;
        interestSum += interest;
      }
    }

    // 2. Minimum payments.
    var left = budget;
    for (var i = 0; i < bal.length; i++) {
      if (bal[i] > _eps && left > 0) {
        final p = math.min(math.min(mins[i], bal[i]), left);
        bal[i] -= p;
        left -= p;
        paidSum += p;
      }
    }

    // 3. Everything left goes to the priority debt(s).
    final open = [for (var i = 0; i < bal.length; i++) if (bal[i] > _eps) i];
    open.sort((a, b) {
      if (strategy == PayoffStrategy.snowball) return bal[a].compareTo(bal[b]);
      final byRate = rate[b].compareTo(rate[a]);
      return byRate != 0 ? byRate : bal[a].compareTo(bal[b]);
    });
    for (final i in open) {
      if (left <= 0) break;
      final p = math.min(left, bal[i]);
      bal[i] -= p;
      left -= p;
      paidSum += p;
    }

    // Record payoffs.
    for (var i = 0; i < bal.length; i++) {
      if (!done[i] && bal[i] <= _eps) {
        bal[i] = 0;
        done[i] = true;
        order.add(PaidOffDebt(debts[i].name, month));
      }
    }
    series.add(total());
  }

  return DebtPayoffResult(
    strategy: strategy,
    months: month,
    totalInterest: interestSum,
    totalPaid: paidSum,
    payoffOrder: order,
    balanceByMonth: series,
    paysOff: total() <= _eps,
  );
}
