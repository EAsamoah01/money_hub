// Pure calculator math — no Flutter imports, so it's fast to unit-test.
//
// Model used everywhere: monthly compounding at (annual rate / 12),
// contributions added at the END of each month.
// These are educational projections with a constant assumed return,
// not predictions.

import 'dart:math' as math;

const maxYears = 100;

int _clampYears(int years) => math.min(math.max(years, 0), maxYears);

/// One point per year for charts and tables.
class YearPoint {
  const YearPoint(this.year, this.contributed, this.balance);
  final int year;
  final double contributed;
  final double balance;
  double get growth => balance - contributed;
}

// ───────────────────────── Compound interest ─────────────────────────

class CompoundResult {
  const CompoundResult({
    required this.finalBalance,
    required this.totalContributed,
    required this.series,
  });
  final double finalBalance;
  final double totalContributed;
  final List<YearPoint> series;
  double get totalGrowth => finalBalance - totalContributed;
}

CompoundResult compoundInterest({
  required double principal,
  required double monthly,
  required double annualRatePct,
  required int years,
}) {
  final y = _clampYears(years);
  final r = annualRatePct / 100 / 12;
  var balance = principal;
  var contributed = principal;
  final series = <YearPoint>[YearPoint(0, contributed, balance)];
  for (var m = 1; m <= y * 12; m++) {
    balance = balance * (1 + r) + monthly;
    contributed += monthly;
    if (m % 12 == 0) series.add(YearPoint(m ~/ 12, contributed, balance));
  }
  return CompoundResult(finalBalance: balance, totalContributed: contributed, series: series);
}

// ───────────────────────── "What if I had invested…" ─────────────────────────
// Uses an assumed average annual return. Swap in real historical prices
// (Alpha Vantage / FMP) later for ticker-specific results.

CompoundResult whatIfInvested({
  required double amount,
  required int fromYear,
  required int toYear,
  required double annualReturnPct,
  double monthly = 0,
}) =>
    compoundInterest(
      principal: amount,
      monthly: monthly,
      annualRatePct: annualReturnPct,
      years: math.max(0, toYear - fromYear),
    );

// ───────────────────────── FIRE number ─────────────────────────

class FireResult {
  const FireResult({
    required this.fireNumber,
    required this.monthsToFire,
    required this.series,
    this.fireAge,
  });

  /// Portfolio needed: annual spending ÷ withdrawal rate (4% rule → ×25).
  final double fireNumber;

  /// null = not reached within the horizon.
  final int? monthsToFire;
  final int? fireAge;
  final List<YearPoint> series;
}

FireResult fireCalc({
  required double annualSpending,
  double withdrawalRatePct = 4,
  required double currentSavings,
  required double monthlyContribution,
  required double annualReturnPct,
  int? currentAge,
  int horizonYears = 70,
}) {
  final wr = withdrawalRatePct > 0 ? withdrawalRatePct : 4.0;
  final target = annualSpending / (wr / 100);
  final r = annualReturnPct / 100 / 12;

  var balance = currentSavings;
  var contributed = currentSavings;
  final series = <YearPoint>[YearPoint(0, contributed, balance)];
  int? months = balance >= target ? 0 : null;

  for (var m = 1; months == null && m <= horizonYears * 12; m++) {
    balance = balance * (1 + r) + monthlyContribution;
    contributed += monthlyContribution;
    if (balance >= target) months = m;
    if (m % 12 == 0 || months != null) {
      series.add(YearPoint((m / 12).ceil(), contributed, balance));
    }
  }

  return FireResult(
    fireNumber: target,
    monthsToFire: months,
    series: series,
    fireAge: (currentAge != null && months != null) ? currentAge + (months / 12).ceil() : null,
  );
}

// ───────────────────────── DCA vs lump sum ─────────────────────────

class DcaResult {
  const DcaResult({
    required this.lumpSumFinal,
    required this.dcaFinal,
    required this.lumpByMonth,
    required this.dcaByMonth,
  });
  final double lumpSumFinal;
  final double dcaFinal;

  /// Index 0 = start, index n = value after month n.
  final List<double> lumpByMonth;
  final List<double> dcaByMonth;
  double get difference => lumpSumFinal - dcaFinal;
}

/// Lump sum: invest everything on day one.
/// DCA: invest amount / [dcaMonths] at the start of each of the first
/// [dcaMonths] months; uninvested cash earns [cashRatePct].
DcaResult dcaVsLumpSum({
  required double amount,
  required int dcaMonths,
  required double annualReturnPct,
  required int years,
  double cashRatePct = 0,
}) {
  final totalMonths = math.max(_clampYears(years) * 12, 1);
  final n = math.max(1, math.min(dcaMonths, totalMonths));
  final r = annualReturnPct / 100 / 12;
  final cr = cashRatePct / 100 / 12;
  final slice = amount / n;

  var lump = amount;
  var invested = 0.0;
  var cash = amount;
  final lumpS = <double>[amount];
  final dcaS = <double>[amount];

  for (var m = 0; m < totalMonths; m++) {
    if (m < n) {
      invested += slice;
      cash -= slice;
    }
    lump *= 1 + r;
    invested *= 1 + r;
    cash *= 1 + cr;
    lumpS.add(lump);
    dcaS.add(invested + cash);
  }

  return DcaResult(lumpSumFinal: lump, dcaFinal: invested + cash, lumpByMonth: lumpS, dcaByMonth: dcaS);
}

// ───────────────────────── Inflation erosion ─────────────────────────

class InflationPoint {
  const InflationPoint(this.year, this.futureCost, this.purchasingPower);
  final int year;

  /// What today's basket of goods will cost in [year] years.
  final double futureCost;

  /// What today's cash will buy then, in today's dollars.
  final double purchasingPower;
}

class InflationResult {
  const InflationResult(this.series);
  final List<InflationPoint> series;
  double get futureCost => series.last.futureCost;
  double get purchasingPower => series.last.purchasingPower;
}

InflationResult inflationCalc({
  required double amount,
  required double inflationPct,
  required int years,
}) {
  final y = _clampYears(years);
  final g = 1 + inflationPct / 100;
  return InflationResult([
    for (var i = 0; i <= y; i++)
      InflationPoint(i, amount * math.pow(g, i).toDouble(), amount / math.pow(g, i).toDouble()),
  ]);
}
