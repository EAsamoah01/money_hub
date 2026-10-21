import 'package:flutter_riverpod/flutter_riverpod.dart';

// App-wide flags the router listens to. Real values are loaded in main()
// and injected with overrides, so the router knows them before the first frame.

/// app_settings key that remembers the user tapped "Get started".
const kOnboardingDoneKey = 'onboarding_done';

final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

/// Kept in sync with the store by main() (see PurchasesService.proChanges).
final isProProvider = StateProvider<bool>((ref) => false);
