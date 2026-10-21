import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/utils/money_format.dart';
import '../../../goals/domain/debt_payoff.dart';
import '../widgets/calc_widgets.dart';

/// Prefill keys: extra
class DebtPayoffView extends StatefulWidget {
  const DebtPayoffView({super.key, this.prefill = const {}});
  final Map<String, String> prefill;

  @override
  State<DebtPayoffView> createState() => _DebtPayoffViewState();
}

class _DebtRow {
  _DebtRow(String name, String balance, String apr, String min, VoidCallback onChanged)
      : name = TextEditingController(text: name),
        balance = TextEditingController(text: balance),
        apr = TextEditingController(text: apr),
        min = TextEditingController(text: min) {
    for (final c in all) {
      c.addListener(onChanged);
    }
  }

  final TextEditingController name;
  final TextEditingController balance;
  final TextEditingController apr;
  final TextEditingController min;
  List<TextEditingController> get all => [name, balance, apr, min];

  DebtInput toInput(int index) => DebtInput(
        name: name.text.trim().isEmpty ? 'Debt ${index + 1}' : name.text.trim(),
        balance: parseNum(balance.text),
        aprPct: parseNum(apr.text),
        minPayment: parseNum(min.text),
      );

  void dispose() {
    for (final c in all) {
      c.dispose();
    }
  }
}

class _DebtPayoffViewState extends State<DebtPayoffView> {
  void _changed() => setState(() {});

  late final f = CalcFields(widget.prefill, const {'extra': '200'}, _changed);

  late final List<_DebtRow> _rows = [
    _DebtRow('Credit card', '5000', '22.99', '150', _changed),
    _DebtRow('Car loan', '12000', '6.5', '300', _changed),
    _DebtRow('Store card', '1200', '18', '40', _changed),
  ];

  PayoffStrategy _selected = PayoffStrategy.avalanche;

  @override
  void dispose() {
    f.dispose();
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  void _addRow() => setState(() => _rows.add(_DebtRow('', '', '', '', _changed)));

  void _removeRow(int i) {
    final row = _rows[i];
    setState(() => _rows.removeAt(i));
    // Dispose after the frame, once its TextFields are gone.
    WidgetsBinding.instance.addPostFrameCallback((_) => row.dispose());
  }

  @override
  Widget build(BuildContext context) {
    const calc = CalculatorId.debtPayoff;
    final debts = [for (var i = 0; i < _rows.length; i++) _rows[i].toInput(i)];
    final extra = f.number('extra');
    final snow = simulatePayoff(debts, strategy: PayoffStrategy.snowball, extraMonthly: extra);
    final aval = simulatePayoff(debts, strategy: PayoffStrategy.avalanche, extraMonthly: extra);
    final shown = _selected == PayoffStrategy.snowball ? snow : aval;
    final saved = snow.totalInterest - aval.totalInterest;
    final paysOff = shown.paysOff;

    List<FlSpot> spots(DebtPayoffResult r) =>
        [for (var m = 0; m < r.balanceByMonth.length; m++) FlSpot(m / 12, r.balanceByMonth[m])];

    final t = Theme.of(context);

    return CalcScaffold(
      title: calc.title,
      children: [
        const SectionLabel('Your debts'),
        for (var i = 0; i < _rows.length; i++)
          Card(
            key: ObjectKey(_rows[i]),
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FieldGrid(children: [
                      TextField(
                        controller: _rows[i].name,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      NumberField(controller: _rows[i].balance, label: 'Balance', prefix: r'$ '),
                      NumberField(controller: _rows[i].apr, label: 'Interest rate (APR)', suffix: '%'),
                      NumberField(controller: _rows[i].min, label: 'Minimum payment', prefix: r'$ '),
                    ]),
                  ),
                  IconButton(
                    tooltip: 'Remove',
                    onPressed: _rows.length > 1 ? () => _removeRow(i) : null,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addRow,
            icon: const Icon(Icons.add),
            label: const Text('Add a debt'),
          ),
        ),
        const SizedBox(height: 8),
        NumberField(
          controller: f['extra'],
          label: 'Extra you can pay each month',
          prefix: r'$ ',
          helper: 'On top of all minimum payments',
        ),
        const SizedBox(height: 16),
        SegmentedButton<PayoffStrategy>(
          segments: const [
            ButtonSegment(value: PayoffStrategy.avalanche, label: Text('Avalanche'), icon: Icon(Icons.percent)),
            ButtonSegment(value: PayoffStrategy.snowball, label: Text('Snowball'), icon: Icon(Icons.ac_unit)),
          ],
          selected: {_selected},
          onSelectionChanged: (s) => setState(() => _selected = s.first),
        ),
        const SizedBox(height: 6),
        Text(
          _selected == PayoffStrategy.avalanche
              ? 'Avalanche: extra money goes to the highest interest rate first. Costs the least.'
              : 'Snowball: extra money goes to the smallest balance first. Quicker early wins.',
          style: t.textTheme.bodySmall,
        ),
        ResultCard(
          caption: 'Debt-free in',
          headline: paysOff ? fmtDuration(shown.months) : 'Never at this rate',
          warning: paysOff
              ? null
              : "Your payments don't cover the interest. Raise the minimums or the extra payment.",
          rows: paysOff
              ? [
                  ResultRow('Total interest (this plan)', fmtMoney(shown.totalInterest)),
                  ResultRow('Avalanche interest', fmtMoney(aval.totalInterest)),
                  ResultRow('Snowball interest', fmtMoney(snow.totalInterest)),
                  if (saved.abs() >= 1) ResultRow('Avalanche saves you', fmtMoney(saved)),
                ]
              : const [],
        ),
        if (paysOff) ...[
          const SectionLabel('Payoff order'),
          for (var i = 0; i < shown.payoffOrder.length; i++)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(radius: 14, child: Text('${i + 1}')),
              title: Text(shown.payoffOrder[i].name),
              trailing: Text('paid off in ${fmtDuration(shown.payoffOrder[i].month)}'),
            ),
          MoneyLineChart(lines: [
            ChartLine(label: 'Avalanche: total owed', spots: spots(aval)),
            ChartLine(label: 'Snowball: total owed', spots: spots(snow), dashed: true),
          ]),
        ],
        CalcFooter(
          shareText: paysOff
              ? 'I can be debt-free in ${fmtDuration(shown.months)} with the '
                  '${_selected.name} method. $kWebBaseUrl${Loc.calculator(calc, f.values)}'
              : 'Plan your debt payoff: $kWebBaseUrl${Loc.calculator(calc)}',
          lessonLabel: 'Lesson: snowball vs avalanche',
          lessonLocation: Loc.lesson('debt-snowball-vs-avalanche'),
          affiliatePlacement: 'tools.debt-payoff.result',
        ),
      ],
    );
  }
}
