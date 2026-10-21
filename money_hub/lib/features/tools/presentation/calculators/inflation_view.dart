import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/utils/money_format.dart';
import '../../domain/calculators.dart';
import '../widgets/calc_widgets.dart';

/// Prefill keys: amount, rate, years
class InflationView extends StatefulWidget {
  const InflationView({super.key, this.prefill = const {}});
  final Map<String, String> prefill;

  @override
  State<InflationView> createState() => _InflationViewState();
}

class _InflationViewState extends State<InflationView> {
  late final f = CalcFields(
    widget.prefill,
    const {'amount': '10000', 'rate': '3', 'years': '20'},
    () => setState(() {}),
  );

  @override
  void dispose() {
    f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const calc = CalculatorId.inflation;
    final amount = f.number('amount');
    final years = f.whole('years');
    final r = inflationCalc(amount: amount, inflationPct: f.number('rate'), years: years);
    final lost = amount - r.purchasingPower;

    return CalcScaffold(
      title: calc.title,
      children: [
        FieldGrid(children: [
          NumberField(controller: f['amount'], label: 'Cash today', prefix: r'$ '),
          NumberField(controller: f['rate'], label: 'Yearly inflation', suffix: '%'),
          NumberField(controller: f['years'], label: 'Years', allowDecimal: false),
        ]),
        ResultCard(
          caption: 'In $years years, ${fmtMoney(amount)} in cash will buy what this buys today',
          headline: fmtMoney(r.purchasingPower),
          rows: [
            ResultRow('Buying power lost', fmtMoney(lost)),
            ResultRow("Today's ${fmtMoney(amount)} of stuff will cost", fmtMoney(r.futureCost)),
          ],
        ),
        MoneyLineChart(lines: [
          ChartLine(
            label: 'What your cash buys (today\'s dollars)',
            spots: [for (final p in r.series) FlSpot(p.year.toDouble(), p.purchasingPower)],
          ),
          ChartLine(
            label: 'Cost of the same things',
            dashed: true,
            spots: [for (final p in r.series) FlSpot(p.year.toDouble(), p.futureCost)],
          ),
        ]),
        CalcFooter(
          calculator: calc,
          inputs: f.values,
          pinSummary: '${fmtMoney(amount)} will buy ${fmtMoney(r.purchasingPower)} in $years yrs',
          shareText: 'At ${fmtPct(f.number('rate'))} inflation, ${fmtMoney(amount)} sitting in cash '
              'loses ${fmtMoney(lost)} of buying power in $years years. '
              '$kWebBaseUrl${Loc.calculator(calc, f.values)}',
          affiliatePlacement: 'tools.inflation.result',
        ),
      ],
    );
  }
}
