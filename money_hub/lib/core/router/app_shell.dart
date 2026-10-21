import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

/// Bottom navigation shell. Each tab keeps its own navigation stack, and
/// the selected tab's pill takes that tab's color.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell, required this.children});

  final StatefulNavigationShell navigationShell;

  /// One navigator per tab (from StatefulShellRoute.navigatorContainerBuilder).
  final List<Widget> children;

  static const tabs = AppModule.values; // order matches the router branches

  void _onTap(int index) => navigationShell.goBranch(
        index,
        // Tapping the active tab again pops it back to its root screen.
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final current = tabs[navigationShell.currentIndex];
    final cs = current.scheme(b);

    return Scaffold(
      body: IndexedStack(
        index: navigationShell.currentIndex,
        children: [
          for (var i = 0; i < children.length; i++) ModuleTheme(module: tabs[i], child: children[i]),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        indicatorColor: cs.primaryContainer,
        destinations: [
          for (final t in tabs)
            NavigationDestination(
              icon: Icon(t.icon),
              selectedIcon: Icon(t.selectedIcon, color: t.scheme(b).onPrimaryContainer),
              label: t.label,
            ),
        ],
      ),
    );
  }
}
