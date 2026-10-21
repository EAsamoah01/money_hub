import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/state/app_state.dart';

/// One paywall for every Pro feature. [returnTo] is the screen the user was
/// trying to open; after purchase we send them straight there.
class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key, this.returnTo});
  final String? returnTo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Money Hub Pro')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('• Net worth & holdings tracker\n'
              '• Debt payoff plans & extra-payment scenarios\n'
              '• Saved calculator scenarios\n'
              '• Encrypted cloud backup'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              // TODO: replace with RevenueCat purchase; set isPro from CustomerInfo.
              ref.read(isProProvider.notifier).state = true;
              context.go(returnTo ?? Routes.home);
            },
            child: const Text('Start free trial (demo)'),
          ),
          TextButton(onPressed: () => context.pop(), child: const Text('Not now')),
        ],
      ),
    );
  }
}
