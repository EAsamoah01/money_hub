import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/utils/money_format.dart';
import '../../domain/calculators.dart';
import '../widgets/calc_widgets.dart';

/// Prefill keys: principal, monthly, rate, years
class CompoundInterestView extends StatefulWidget {
  const CompoundInterestView({super.key, this.prefill = const {}});
  final Map<String, String> prefill;

  @override
  State<CompoundInterestView> createState() => _CompoundInterestViewState();
}

class _CompoundInterestViewState extends State<CompoundInterestView> {
  late final f = CalcFields(
    widget.prefill,
    const {'principal': '10000', 'monthly': '500', 'rate': '7', 'years': '30'},
    () => setState(() {}),
  );

  @override
  void dispose() {
    f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const calc = CalculatorId.compoundInterest;
    final years = f.whole('years');
    final r = compoundInterest(
      principal: f.number('principal'),
      monthly: f.number('monthly'),
      annualRatePct: f.number('rate'),
      years: years,
    );

    return CalcScaffold(
      title: calc.title,
      children: [
        FieldGrid(children: [
          NumberField(controller: f['principal'], label: 'Starting amount', prefix: r'$ '),
          NumberField(controller: f['monthly'], label: 'Monthly contribution', prefix: r'$ '),
          NumberField(controller: f['rate'], label: 'Annual return', suffix: '%'),
          NumberField(controller: f['years'], label: 'Years', allowDecimal: false),
        ]),
        ResultCard(
          caption: 'Balance after $years years',
          headline: fmtMoney(r.finalBalance),
          rows: [
            ResultRow('You put in', fmtMoney(r.totalContributed)),
            ResultRow('Growth from returns', fmtMoney(r.totalGrowth)),
          ],
        ),
        MoneyLineChart(lines: [
          ChartLine(
            label: 'Balance',
            spots: [for (final p in r.series) FlSpot(p.year.toDouble(), p.balance)],
          ),
          ChartLine(
            label: 'Money you put in',
            dashed: true,
            spots: [for (final p in r.series) FlSpot(p.year.toDouble(), p.contributed)],
          ),
        ]),
        CalcFooter(
          calculator: calc,
          inputs: f.values,
          pinSummary: '${fmtMoney(r.finalBalance)} after $years yrs · ${fmtMoney(f.number('monthly'))}/mo at ${fmtPct(f.number('rate'))}',
          shareText: 'Investing ${fmtMoney(f.number('monthly'))}/month for $years years at '
              '${fmtPct(f.number('rate'))} could grow to ${fmtMoney(r.finalBalance)}. '
              'Try your numbers: $kWebBaseUrl${Loc.calculator(calc, f.values)}',
          lessonLabel: 'Lesson: compound interest',
          lessonLocation: Loc.lesson('compound-interest-basics'),
          affiliatePlacement: 'tools.compound-interest.result',
        ),
      ],
    );
  }
}
