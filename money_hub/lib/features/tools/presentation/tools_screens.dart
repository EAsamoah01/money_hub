import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/gradient_header.dart';
import '../../../core/widgets/placeholder_screen.dart';
import 'calculators/compound_interest_view.dart';
import 'calculators/dca_view.dart';
import 'calculators/debt_payoff_view.dart';
import 'calculators/fire_view.dart';
import 'calculators/inflation_view.dart';
import 'calculators/what_if_view.dart';

const _icons = <CalculatorId, IconData>{
  CalculatorId.compoundInterest: Icons.trending_up,
  CalculatorId.fire: Icons.local_fire_department_outlined,
  CalculatorId.debtPayoff: Icons.trending_down,
  CalculatorId.whatIf: Icons.history,
  CalculatorId.dcaVsLumpSum: Icons.stacked_line_chart,
  CalculatorId.inflation: Icons.shopping_cart_outlined,
  CalculatorId.retirementScenarios: Icons.beach_access_outlined,
};

const _blurbs = <CalculatorId, String>{
  CalculatorId.compoundInterest: 'See how regular investing grows over time',
  CalculatorId.fire: 'How much you need to retire early, and when',
  CalculatorId.debtPayoff: 'Your debt-free date and the cheapest payoff order',
  CalculatorId.whatIf: 'What a past investment could be worth today',
  CalculatorId.dcaVsLumpSum: 'Invest all at once or spread it out?',
  CalculatorId.inflation: 'How inflation shrinks cash over time',
  CalculatorId.retirementScenarios: 'Compare retirement plans side by side',
};

/// Accent per calculator so the list is easy to scan.
const calculatorColors = <CalculatorId, Color>{
  CalculatorId.compoundInterest: Color(0xFF4338CA),
  CalculatorId.fire: Color(0xFFEA580C),
  CalculatorId.debtPayoff: Color(0xFFDC2626),
  CalculatorId.whatIf: Color(0xFF0891B2),
  CalculatorId.dcaVsLumpSum: Color(0xFF2563EB),
  CalculatorId.inflation: Color(0xFFCA8A04),
  CalculatorId.retirementScenarios: Color(0xFF9333EA),
};

IconData calculatorIcon(CalculatorId c) => _icons[c] ?? Icons.calculate_outlined;

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'Saved scenarios (Pro)',
            onPressed: () => context.push(Routes.savedCalculations),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const GradientHeader(
                title: 'Money calculators',
                subtitle: 'Run the numbers on investing, retirement and debt. Pin any result to Home.',
                icon: Icons.calculate,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (final c in CalculatorId.values)
                      Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          leading: IconBubble(calculatorIcon(c), color: calculatorColors[c], size: 44),
                          title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(_blurbs[c] ?? ''),
                          trailing: c.isPro
                              ? Chip(
                                  label: const Text('Pro'),
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                )
                              : const Icon(Icons.chevron_right),
                          onTap: () => context.push(Loc.calculator(c)),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One route hosts every calculator. [prefill] comes from the URL query, so
/// links from lessons, YouTube descriptions or the website open pre-filled,
/// e.g. /tools/fire?spend=50000&age=28
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key, required this.calculator, this.prefill = const {}});
  final CalculatorId calculator;
  final Map<String, String> prefill;

  @override
  Widget build(BuildContext context) {
    return switch (calculator) {
      CalculatorId.compoundInterest => CompoundInterestView(prefill: prefill),
      CalculatorId.fire => FireView(prefill: prefill),
      CalculatorId.debtPayoff => DebtPayoffView(prefill: prefill),
      CalculatorId.whatIf => WhatIfView(prefill: prefill),
      CalculatorId.dcaVsLumpSum => DcaView(prefill: prefill),
      CalculatorId.inflation => InflationView(prefill: prefill),
      CalculatorId.retirementScenarios => const PlaceholderScreen(
          title: 'Retirement Scenarios',
          details: 'Pro calculator, coming soon: compare retirement ages, savings rates and '
              'returns side by side.',
        ),
    };
  }
}

class SavedCalculationsScreen extends StatelessWidget {
  const SavedCalculationsScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Saved scenarios');
}
