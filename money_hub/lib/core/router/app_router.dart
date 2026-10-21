import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/budget/presentation/budget_screens.dart';
import '../../features/goals/presentation/goals_screens.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/learn/presentation/learn_screens.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/paywall/presentation/paywall_screen.dart';
import '../../features/settings/presentation/settings_screens.dart';
import '../../features/tools/presentation/tools_screens.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/placeholder_screen.dart';
import 'app_shell.dart';
import 'routes.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

int? _intParam(GoRouterState s, String name) => int.tryParse(s.pathParameters[name] ?? '');
int? _intQuery(GoRouterState s, String name) => int.tryParse(s.uri.queryParameters[name] ?? '');

/// Screens pushed above the tab bar sit outside the tab's theme, so they
/// get their module color here.
Widget _themed(AppModule module, Widget child) => ModuleTheme(module: module, child: child);

final routerProvider = Provider<GoRouter>((ref) {
  // Re-run redirects when onboarding / Pro status changes.
  final refresh = ValueNotifier<int>(0);
  ref
    ..listen(onboardingCompleteProvider, (_, __) => refresh.value++)
    ..listen(isProProvider, (_, __) => refresh.value++)
    ..onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.home,
    refreshListenable: refresh,
    debugLogDiagnostics: true,

    // ── Global guards ──
    redirect: (context, state) {
      final path = state.uri.path;
      final onboarded = ref.read(onboardingCompleteProvider);
      final isPro = ref.read(isProProvider);

      if (path == '/' || path.isEmpty) return Routes.home;

      if (!onboarded && path != Routes.onboarding) return Routes.onboarding;
      if (onboarded && path == Routes.onboarding) return Routes.home;

      // Pro gate: match the route *pattern* (e.g. /goals/net-worth/holdings/:accountId).
      final pattern = state.fullPath ?? path;
      if (!isPro && Routes.proOnly.contains(pattern)) {
        return Loc.paywall(from: state.uri.toString());
      }
      // Pro-only calculators.
      if (!isPro && pattern == Routes.calculator) {
        final calc = CalculatorId.fromSlug(state.pathParameters['calculatorId'] ?? '');
        if (calc != null && calc.isPro) return Loc.paywall(from: state.uri.toString());
      }
      return null;
    },

    errorBuilder: (context, state) => NotFoundScreen(location: state.uri.toString()),

    routes: [
      // ───────────── Full-screen routes (no bottom bar) ─────────────
      GoRoute(
        path: Routes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.paywall,
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => MaterialPage(
          fullscreenDialog: true,
          child: PaywallScreen(returnTo: s.uri.queryParameters['from']),
        ),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (_, __) => const SettingsScreen(),
        routes: [
          GoRoute(path: 'backup', builder: (_, __) => const BackupScreen()),
          GoRoute(path: 'security', builder: (_, __) => const SecurityScreen()),
        ],
      ),

      // ───────────── Bottom-tab shell: each tab keeps its own stack ─────────────
      // navigatorContainerBuilder lets AppShell give each tab its own color theme.
      StatefulShellRoute(
        builder: (context, state, navigationShell) => navigationShell,
        navigatorContainerBuilder: (context, navigationShell, children) =>
            AppShell(navigationShell: navigationShell, children: children),
        branches: [
          // ── Tab 0: Home ──
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
          ]),

          // ── Tab 1: Budget ──
          // NOTE: static segments ('new') must come BEFORE ':id' segments.
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.budget,
              builder: (_, s) => BudgetScreen(month: s.uri.queryParameters['month']),
              routes: [
                GoRoute(
                  path: 'category/:categoryId',
                  builder: (_, s) => CategoryScreen(
                    categoryId: _intParam(s, 'categoryId')!,
                    month: s.uri.queryParameters['month'],
                  ),
                ),
                GoRoute(
                  path: 'transactions',
                  builder: (_, __) => const TransactionsScreen(),
                  routes: [
                    GoRoute(
                      path: 'new',
                      parentNavigatorKey: _rootKey, // opens above the tab bar
                      builder: (_, s) => _themed(
                        AppModule.budget,
                        TransactionFormScreen(
                          categoryId: _intQuery(s, 'categoryId'),
                          accountId: _intQuery(s, 'accountId'),
                          income: s.uri.queryParameters['type'] == 'income',
                        ),
                      ),
                    ),
                    GoRoute(
                      path: ':txId',
                      parentNavigatorKey: _rootKey,
                      builder: (_, s) => _themed(AppModule.budget, TransactionFormScreen(txId: _intParam(s, 'txId'))),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'bills',
                  builder: (_, __) => const BillsScreen(),
                  routes: [
                    GoRoute(
                      path: 'new',
                      parentNavigatorKey: _rootKey,
                      builder: (_, __) => _themed(AppModule.budget, const BillFormScreen()),
                    ),
                    GoRoute(
                      path: ':billId',
                      builder: (_, s) => BillDetailScreen(billId: _intParam(s, 'billId')!),
                      routes: [
                        GoRoute(
                          path: 'edit',
                          parentNavigatorKey: _rootKey,
                          builder: (_, s) => _themed(AppModule.budget, BillFormScreen(billId: _intParam(s, 'billId'))),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: 'accounts',
                  builder: (_, __) => const AccountsScreen(),
                  routes: [
                    GoRoute(
                      path: ':accountId',
                      builder: (_, s) => AccountDetailScreen(accountId: _intParam(s, 'accountId')!),
                    ),
                  ],
                ),
              ],
            ),
          ]),

          // ── Tab 2: Goals ──
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.goals,
              builder: (_, __) => const GoalsScreen(),
              routes: [
                GoRoute(
                  path: 'debts',
                  builder: (_, __) => const DebtsScreen(),
                  routes: [
                    GoRoute(
                      path: 'new',
                      parentNavigatorKey: _rootKey,
                      builder: (_, __) => _themed(AppModule.goals, const DebtFormScreen()),
                    ),
                    GoRoute(path: 'plan', builder: (_, __) => const DebtPlanScreen()),
                    GoRoute(
                      path: ':debtId',
                      builder: (_, s) => DebtDetailScreen(debtId: _intParam(s, 'debtId')!),
                      routes: [
                        GoRoute(
                          path: 'edit',
                          parentNavigatorKey: _rootKey,
                          builder: (_, s) => _themed(AppModule.goals, DebtFormScreen(debtId: _intParam(s, 'debtId'))),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: 'net-worth',
                  builder: (_, __) => const NetWorthScreen(),
                  routes: [
                    GoRoute(
                      path: 'holdings/:accountId',
                      builder: (_, s) => HoldingsScreen(accountId: _intParam(s, 'accountId')!),
                    ),
                  ],
                ),
              ],
            ),
          ]),

          // ── Tab 3: Tools (calculators) ──
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.tools,
              builder: (_, __) => const ToolsScreen(),
              routes: [
                GoRoute(path: 'saved', builder: (_, __) => const SavedCalculationsScreen()),
                GoRoute(
                  path: ':calculatorId',
                  redirect: (_, s) =>
                      CalculatorId.fromSlug(s.pathParameters['calculatorId']!) == null
                          ? Routes.tools
                          : null,
                  builder: (_, s) => CalculatorScreen(
                    calculator: CalculatorId.fromSlug(s.pathParameters['calculatorId']!)!,
                    prefill: s.uri.queryParameters,
                  ),
                ),
              ],
            ),
          ]),

          // ── Tab 4: Learn ──
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.learn,
              builder: (_, __) => const LearnScreen(),
              routes: [
                GoRoute(
                  path: ':lessonId',
                  builder: (_, s) => LessonScreen(lessonId: s.pathParameters['lessonId']!),
                  routes: [
                    GoRoute(
                      path: 'quiz',
                      parentNavigatorKey: _rootKey,
                      builder: (_, s) => _themed(AppModule.learn, LessonQuizScreen(lessonId: s.pathParameters['lessonId']!)),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
});
