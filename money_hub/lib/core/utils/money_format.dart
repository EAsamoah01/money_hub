import 'package:intl/intl.dart';

final _whole = NumberFormat.simpleCurrency(decimalDigits: 0);
final _cents = NumberFormat.simpleCurrency(decimalDigits: 2);
final _compact = NumberFormat.compactSimpleCurrency();

/// $12,345  (or $12,345.67 with [cents]).
String fmtMoney(double value, {bool cents = false}) => (cents ? _cents : _whole).format(value);

/// $12K, $1.2M — for chart axes.
String fmtMoneyCompact(double value) => _compact.format(value);

/// 7 → "7%", 6.5 → "6.5%".
String fmtPct(double value) =>
    '${value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toStringAsFixed(1)}%';

/// 40 → "3 yrs 4 mos".
String fmtDuration(int months) {
  if (months <= 0) return 'now';
  final y = months ~/ 12;
  final m = months % 12;
  return [
    if (y > 0) '$y yr${y == 1 ? '' : 's'}',
    if (m > 0) '$m mo${m == 1 ? '' : 's'}',
  ].join(' ');
}

/// Parses user input like "10,000" or "7.5"; returns [fallback] if empty/invalid.
double parseNum(String text, [double fallback = 0]) =>
    double.tryParse(text.replaceAll(',', '').replaceAll(r'$', '').trim()) ?? fallback;
