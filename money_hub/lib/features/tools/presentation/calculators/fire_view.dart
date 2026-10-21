import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/utils/money_format.dart';
import '../../domain/calculators.dart';
import '../widgets/calc_widgets.dart';

/// Prefill keys: spend, wr, savings, monthly, rate, age
class FireView extends StatefulWidget {
  const FireView({super.key, this.prefill = const {}});
  final Map<String, String> prefill;

  @override
  State<FireView> createState() => _FireViewState();
}

class _FireViewState extends State<FireView> {
  late final f = CalcFields(
    widget.prefill,
    const {
      'spend': '40000',
      'wr': '4',
      'savings': '25000',
      'monthly': '1000',
      'rate': '7',
      'age': '30',
    },
    () => setState(() {}),
  );

  @override
  void dispose() {
    f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const calc = CalculatorId.fire;
    final age = f.whole('age');
    final r = fireCalc(
      annualSpending: f.number('spend'),
      withdrawalRatePct: f.number('wr'),
      currentSavings: f.number('savings'),
      monthlyContribution: f.number('monthly'),
      annualReturnPct: f.number('rate'),
      currentAge: age > 0 ? age : null,
    );

    final reached = r.monthsToFire != null;
    final lastYear = r.series.isEmpty ? 0.0 : r.series.last.year.toDouble();

    return CalcScaffold(
      title: calc.title,
      children: [
        FieldGrid(children: [
          NumberField(controller: f['spend'], label: 'Yearly spending in retirement', prefix: r'$ '),
          NumberField(
            controller: f['wr'],
            label: 'Safe withdrawal rate',
            suffix: '%',
            helper: '4% is the common rule of thumb',
          ),
          NumberField(controller: f['savings'], label: 'Invested today', prefix: r'$ '),
          NumberField(controller: f['monthly'], label: 'Monthly investing', prefix: r'$ '),
          NumberField(controller: f['rate'], label: 'Annual return', suffix: '%'),
          NumberField(controller: f['age'], label: 'Your age', allowDecimal: false),
        ]),
        ResultCard(
          caption: 'Your FIRE number',
          headline: fmtMoney(r.fireNumber),
          warning: reached ? null : 'Not reached within 70 years at these numbers. Try investing more each month.',
          rows: [
            if (reached) ResultRow('Time to get there', fmtDuration(r.monthsToFire!)),
            if (r.fireAge != null) ResultRow('Age you could retire', '${r.fireAge}'),
            ResultRow('Supports spending of', '${fmtMoney(f.number('spend') / 12)}/month'),
          ],
        ),
        MoneyLineChart(lines: [
          ChartLine(
            label: 'Portfolio',
            spots: [for (final p in r.series) FlSpot(p.year.toDouble(), p.balance)],
          ),
          ChartLine(
            label: 'FIRE number',
            dashed: true,
            spots: [FlSpot(0, r.fireNumber), FlSpot(lastYear <= 0 ? 1.0 : lastYear, r.fireNumber)],
          ),
        ]),
        CalcFooter(
          calculator: calc,
          inputs: f.values,
          pinSummary: 'FIRE number ${fmtMoney(r.fireNumber)}${reached ? ' · in ${fmtDuration(r.monthsToFire!)}' : ''}',
          shareText: 'My FIRE number is ${fmtMoney(r.fireNumber)}'
              '${reached ? ' and I could get there in ${fmtDuration(r.monthsToFire!)}' : ''}. '
              "What's yours? $kWebBaseUrl${Loc.calculator(calc, f.values)}",
          affiliatePlacement: 'tools.fire.result',
        ),
      ],
    );
  }
}
