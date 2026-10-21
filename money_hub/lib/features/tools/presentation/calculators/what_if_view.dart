import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/utils/money_format.dart';
import '../../domain/calculators.dart';
import '../widgets/calc_widgets.dart';

/// Prefill keys: amount, from, rate, monthly
class WhatIfView extends StatefulWidget {
  const WhatIfView({super.key, this.prefill = const {}});
  final Map<String, String> prefill;

  @override
  State<WhatIfView> createState() => _WhatIfViewState();
}

class _WhatIfViewState extends State<WhatIfView> {
  final _thisYear = DateTime.now().year;

  late final f = CalcFields(
    widget.prefill,
    {'amount': '1000', 'from': '${_thisYear - 10}', 'rate': '10', 'monthly': '0'},
    () => setState(() {}),
  );

  @override
  void dispose() {
    f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const calc = CalculatorId.whatIf;
    final from = f.whole('from');
    final r = whatIfInvested(
      amount: f.number('amount'),
      fromYear: from,
      toYear: _thisYear,
      annualReturnPct: f.number('rate'),
      monthly: f.number('monthly'),
    );
    final multiple = r.totalContributed > 0 ? r.finalBalance / r.totalContributed : 0.0;

    return CalcScaffold(
      title: calc.title,
      children: [
        FieldGrid(children: [
          NumberField(controller: f['amount'], label: 'Amount invested', prefix: r'$ '),
          NumberField(controller: f['from'], label: 'In the year', allowDecimal: false),
          NumberField(
            controller: f['rate'],
            label: 'Average annual return',
            suffix: '%',
            helper: 'An assumption, not actual market history',
          ),
          NumberField(controller: f['monthly'], label: 'Plus monthly (optional)', prefix: r'$ '),
        ]),
        ResultCard(
          caption: 'It could be worth this today',
          headline: fmtMoney(r.finalBalance),
          warning: from >= _thisYear ? 'Pick a year before $_thisYear.' : null,
          rows: [
            ResultRow('You put in', fmtMoney(r.totalContributed)),
            ResultRow('Growth', fmtMoney(r.totalGrowth)),
            ResultRow('Multiple', '${multiple.toStringAsFixed(1)}×'),
          ],
        ),
        MoneyLineChart(lines: [
          ChartLine(
            label: 'Value',
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
          pinSummary: '${fmtMoney(f.number('amount'))} in $from could be ${fmtMoney(r.finalBalance)} today',
          shareText: '${fmtMoney(f.number('amount'))} invested in $from at an average '
              '${fmtPct(f.number('rate'))} a year would be about ${fmtMoney(r.finalBalance)} now. '
              '$kWebBaseUrl${Loc.calculator(calc, f.values)}',
          affiliatePlacement: 'tools.what-if.result',
        ),
      ],
    );
  }
}
