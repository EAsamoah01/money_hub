import 'package:flutter_riverpod/flutter_riverpod.dart';

// App-wide flags the router listens to.

/// app_settings key that remembers the user tapped "Get started".
const kOnboardingDoneKey = 'onboarding_done';

/// Real value is loaded from the database in main() and injected with an
/// override, so the router knows it before the first frame.
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

/// TODO: drive from RevenueCat's CustomerInfo listener.
final isProProvider = StateProvider<bool>((ref) => false);
