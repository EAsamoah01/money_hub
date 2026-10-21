import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/utils/money_format.dart';
import '../../domain/calculators.dart';
import '../widgets/calc_widgets.dart';

/// Prefill keys: amount, months, rate, years
class DcaView extends StatefulWidget {
  const DcaView({super.key, this.prefill = const {}});
  final Map<String, String> prefill;

  @override
  State<DcaView> createState() => _DcaViewState();
}

class _DcaViewState extends State<DcaView> {
  late final f = CalcFields(
    widget.prefill,
    const {'amount': '12000', 'months': '12', 'rate': '7', 'years': '5'},
    () => setState(() {}),
  );

  @override
  void dispose() {
    f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const calc = CalculatorId.dcaVsLumpSum;
    final years = f.whole('years');
    final months = f.whole('months');
    final r = dcaVsLumpSum(
      amount: f.number('amount'),
      dcaMonths: months,
      annualReturnPct: f.number('rate'),
      years: years,
    );
    final lumpAhead = r.difference >= 0;

    List<FlSpot> spots(List<double> values) =>
        [for (var m = 0; m < values.length; m++) FlSpot(m / 12, values[m])];

    return CalcScaffold(
      title: calc.title,
      children: [
        FieldGrid(children: [
          NumberField(controller: f['amount'], label: 'Amount to invest', prefix: r'$ '),
          NumberField(
            controller: f['months'],
            label: 'Spread over (months)',
            allowDecimal: false,
            helper: 'For dollar-cost averaging',
          ),
          NumberField(controller: f['rate'], label: 'Annual return', suffix: '%'),
          NumberField(controller: f['years'], label: 'Years', allowDecimal: false),
        ]),
        ResultCard(
          caption: lumpAhead ? 'Lump sum comes out ahead by' : 'Dollar-cost averaging comes out ahead by',
          headline: fmtMoney(r.difference.abs()),
          rows: [
            ResultRow('Lump sum after $years years', fmtMoney(r.lumpSumFinal)),
            ResultRow('DCA over $months months', fmtMoney(r.dcaFinal)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            'With a steady positive return, investing all at once always wins on paper because '
            'your money is in the market longer. DCA trades a bit of expected return for less '
            'regret if prices drop right after you invest.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        MoneyLineChart(lines: [
          ChartLine(label: 'Lump sum', spots: spots(r.lumpByMonth)),
          ChartLine(label: 'Dollar-cost averaging', spots: spots(r.dcaByMonth)),
        ]),
        CalcFooter(
          calculator: calc,
          inputs: f.values,
          pinSummary: 'Lump sum ${fmtMoney(r.lumpSumFinal)} vs DCA ${fmtMoney(r.dcaFinal)} after $years yrs',
          shareText: 'Lump sum vs DCA for ${fmtMoney(f.number('amount'))}: '
              '${fmtMoney(r.lumpSumFinal)} vs ${fmtMoney(r.dcaFinal)} after $years years. '
              '$kWebBaseUrl${Loc.calculator(calc, f.values)}',
          affiliatePlacement: 'tools.dca.result',
        ),
      ],
    );
  }
}
