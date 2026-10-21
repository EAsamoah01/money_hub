import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/tables.dart' show DebtStrategy;
import '../../../core/utils/money_format.dart';
import '../../tools/presentation/widgets/calc_widgets.dart';
import '../data/debts_repository.dart';
import '../domain/debt_payoff.dart';

/// Pro: choose snowball/avalanche and an extra monthly payment for YOUR
/// saved debts, compare both, and save the plan (used by Home and Debts).
class DebtPlanScreen extends ConsumerStatefulWidget {
  const DebtPlanScreen({super.key});

  @override
  ConsumerState<DebtPlanScreen> createState() => _DebtPlanScreenState();
}

class _DebtPlanScreenState extends ConsumerState<DebtPlanScreen> {
  final _extra = TextEditingController();
  PayoffStrategy _strategy = PayoffStrategy.avalanche;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Fill the form from the saved plan once it loads.
    ref.read(debtPlanProvider.future).then((p) {
      if (!mounted) return;
      final extra = (p?.extraMonthlyCents ?? 0) / 100;
      setState(() {
        _strategy = DebtSummary.strategyOf(p);
        _extra.text = extra == extra.roundToDouble() ? extra.toStringAsFixed(0) : extra.toStringAsFixed(2);
      });
    });
    _extra.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _extra.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(debtsRepositoryProvider).savePlan(
          strategy: _strategy == PayoffStrategy.snowball ? DebtStrategy.snowball : DebtStrategy.avalanche,
          extraMonthlyCents: (parseNum(_extra.text) * 100).round(),
        );
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan saved')));
  }

  @override
  Widget build(BuildContext context) {
    final debts = ref.watch(allDebtsProvider).valueOrNull;

    if (debts == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final inputs = [
      for (final d in debts)
        if (!d.isPaidOff && d.currentBalanceCents > 0) toDebtInput(d),
    ];
    if (inputs.isEmpty) {
      return const CalcScaffold(title: 'Payoff plan', children: [
        SizedBox(height: 40),
        Center(child: Text('Add a debt first, then build your plan here.')),
      ]);
    }

    final extra = parseNum(_extra.text);
    final snow = simulatePayoff(inputs, strategy: PayoffStrategy.snowball, extraMonthly: extra);
    final aval = simulatePayoff(inputs, strategy: PayoffStrategy.avalanche, extraMonthly: extra);
    final shown = _strategy == PayoffStrategy.snowball ? snow : aval;
    final now = DateTime.now();
    final freeDate = DateTime(now.year, now.month + shown.months);
    final noExtra = simulatePayoff(inputs, strategy: _strategy);
    final monthsSaved = noExtra.months - shown.months;
    final interestSaved = noExtra.totalInterest - shown.totalInterest;

    List<FlSpot> spots(DebtPayoffResult r) =>
        [for (var m = 0; m < r.balanceByMonth.length; m++) FlSpot(m / 12, r.balanceByMonth[m])];

    return CalcScaffold(
      title: 'Payoff plan',
      children: [
        SegmentedButton<PayoffStrategy>(
          segments: const [
            ButtonSegment(value: PayoffStrategy.avalanche, label: Text('Avalanche'), icon: Icon(Icons.percent)),
            ButtonSegment(value: PayoffStrategy.snowball, label: Text('Snowball'), icon: Icon(Icons.ac_unit)),
          ],
          selected: {_strategy},
          onSelectionChanged: (s) => setState(() => _strategy = s.first),
        ),
        const SizedBox(height: 6),
        Text(
          _strategy == PayoffStrategy.avalanche
              ? 'Highest interest rate first. Costs the least.'
              : 'Smallest balance first. Quicker early wins.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        NumberField(
          controller: _extra,
          label: 'Extra you can pay each month',
          prefix: r'$ ',
          helper: 'On top of all your minimum payments',
        ),
        ResultCard(
          caption: 'Debt-free by',
          headline: shown.paysOff ? DateFormat.yMMMM().format(freeDate) : 'Never at this rate',
          warning: shown.paysOff ? null : "Payments don't cover the interest. Add an extra payment.",
          rows: shown.paysOff
              ? [
                  ResultRow('Time to go', fmtDuration(shown.months)),
                  ResultRow('Total interest', fmtMoney(shown.totalInterest)),
                  if (extra > 0 && noExtra.paysOff && monthsSaved > 0)
                    ResultRow('The extra saves you', '${fmtDuration(monthsSaved)} · ${fmtMoney(interestSaved)}'),
                  if ((snow.totalInterest - aval.totalInterest).abs() >= 1)
                    ResultRow('Avalanche vs snowball', 'saves ${fmtMoney(snow.totalInterest - aval.totalInterest)}'),
                ]
              : const [],
        ),
        if (shown.paysOff) ...[
          const SectionLabel('Payoff order'),
          for (var i = 0; i < shown.payoffOrder.length; i++)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(radius: 14, child: Text('${i + 1}')),
              title: Text(shown.payoffOrder[i].name),
              trailing: Text(DateFormat.yMMM().format(DateTime(now.year, now.month + shown.payoffOrder[i].month))),
            ),
          MoneyLineChart(lines: [
            ChartLine(label: 'Avalanche: total owed', spots: spots(aval)),
            ChartLine(label: 'Snowball: total owed', spots: spots(snow), dashed: true),
          ]),
        ],
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save this plan'),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        ),
        const SizedBox(height: 12),
        Text(
          'Estimates assume rates and minimums stay the same and no new charges. Not financial advice.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
