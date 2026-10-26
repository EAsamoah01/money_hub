import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/database/app_database.dart';
import '../../../core/state/app_state.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  Future<void> _getStarted(WidgetRef ref) async {
    try {
      await ref.read(databaseProvider).setSetting(kOnboardingDoneKey, 'true');
    } catch (e) {
      debugPrint('Could not save onboarding: $e'); // still let the user in
    }
    // The router listens to this flag and redirects to /home.
    ref.read(onboardingCompleteProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(AppConfig.appName, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              const Text('Budget, crush debt, track net worth and learn, all in one place. '
                  'Your data stays on your device.'),
              const SizedBox(height: 8),
              Text(
                'Educational tools only, not financial advice.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => _getStarted(ref),
                child: const Text('Get started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
