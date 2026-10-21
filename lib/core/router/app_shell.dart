import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom navigation shell. Each tab keeps its own navigation stack,
/// so switching tabs doesn't lose where the user was.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = <({IconData icon, IconData selected, String label})>[
    (icon: Icons.home_outlined, selected: Icons.home, label: 'Home'),
    (icon: Icons.account_balance_wallet_outlined, selected: Icons.account_balance_wallet, label: 'Budget'),
    (icon: Icons.flag_outlined, selected: Icons.flag, label: 'Goals'),
    (icon: Icons.calculate_outlined, selected: Icons.calculate, label: 'Tools'),
    (icon: Icons.school_outlined, selected: Icons.school, label: 'Learn'),
  ];

  void _onTap(int index) => navigationShell.goBranch(
        index,
        // Tapping the active tab again pops it back to its root screen.
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          for (final t in _tabs)
            NavigationDestination(icon: Icon(t.icon), selectedIcon: Icon(t.selected), label: t.label),
        ],
      ),
    );
  }
}
