import 'package:flutter/material.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/placeholder_screen.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
        title: 'Goals',
        links: {
          'Debt payoff': Routes.debts,
          'Net worth (Pro)': Routes.netWorth,
        },
      );
}

class DebtsScreen extends StatelessWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Debts',
        details: 'List of debts, total remaining, debt-free date.',
        links: {
          'Add debt': Routes.debtNew,
          'Snowball vs Avalanche plan (Pro)': Routes.debtPlan,
          'Debt #1': Loc.debtDetail(1),
        },
      );
}

class DebtFormScreen extends StatelessWidget {
  const DebtFormScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Add debt');
}

class DebtPlanScreen extends StatelessWidget {
  const DebtPlanScreen({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Payoff plan',
        details: 'Month-by-month timeline. Compare strategies, add extra payments.',
        links: {
          'Learn: snowball vs avalanche': Loc.lesson('debt-snowball-vs-avalanche'),
        },
      );
}

class DebtDetailScreen extends StatelessWidget {
  const DebtDetailScreen({super.key, required this.debtId});
  final int debtId;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Debt #$debtId',
        details: 'Balance, APR, payments, progress bar. Affiliate slot: balance-transfer offer.',
      );
}

class NetWorthScreen extends StatelessWidget {
  const NetWorthScreen({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Net worth',
        details: 'Chart from NetWorthSnapshots; assets vs liabilities from Accounts.',
        links: {'Brokerage holdings': Loc.holdings(1)},
      );
}

class HoldingsScreen extends StatelessWidget {
  const HoldingsScreen({super.key, required this.accountId});
  final int accountId;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(title: 'Holdings — account #$accountId');
}
