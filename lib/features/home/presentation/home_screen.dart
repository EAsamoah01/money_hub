import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';

/// Dashboard: one card per module. Each card deep-links into its tab.
/// Replace with real widgets reading from AppDatabase
/// (currentNetWorth, watchUpcomingBills, watchTotalDebt, lesson streak).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Hub'),
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => context.push(Routes.settings)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DashCard(icon: Icons.account_balance_wallet, title: 'Left to spend this month', go: Routes.budget),
          _DashCard(icon: Icons.receipt_long, title: 'Bills due this week', go: Routes.bills),
          _DashCard(icon: Icons.trending_down, title: 'Debt-free date', go: Routes.debts),
          _DashCard(icon: Icons.show_chart, title: 'Net worth', go: Routes.netWorth),
          _DashCard(icon: Icons.local_fire_department, title: 'Learning streak', go: Routes.learn),
          _DashCard(
            icon: Icons.calculate,
            title: 'Try: what is your FIRE number?',
            go: Loc.calculator(CalculatorId.fire),
          ),
        ],
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  const _DashCard({required this.icon, required this.title, required this.go});
  final IconData icon;
  final String title;
  final String go;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(go),
          trailing: const Icon(Icons.chevron_right),
          // `go` switches to the right tab and opens the screen.
          onTap: () => context.go(go),
        ),
      );
}
