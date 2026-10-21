import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_screen.dart';

// The router imports this file; each screen lives in its own file.
export 'debt_detail_screen.dart';
export 'debt_form_screen.dart';
export 'debt_plan_screen.dart';
export 'debts_screen.dart';
export 'goals_screen.dart';

class NetWorthScreen extends StatelessWidget {
  const NetWorthScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
        title: 'Net worth',
        icon: Icons.show_chart,
        details: 'Track everything you own and owe in one chart. Coming in v2.',
      );
}

class HoldingsScreen extends StatelessWidget {
  const HoldingsScreen({super.key, required this.accountId});
  final int accountId;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(title: 'Holdings, account #$accountId');
}
