import 'package:flutter_riverpod/flutter_riverpod.dart';

// App-wide flags the router listens to.
//
// Starter versions keep these in memory. Next steps:
// - onboardingCompleteProvider → load/save via AppDatabase.getSetting('onboarding_done')
// - isProProvider → drive from RevenueCat's CustomerInfo listener

final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

final isProProvider = StateProvider<bool>((ref) => false);
