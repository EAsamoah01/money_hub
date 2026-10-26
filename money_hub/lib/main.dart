import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/services/app_lock.dart';
import 'core/services/notification_service.dart';
import 'core/services/purchases_service.dart';
import 'core/state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database once and read the settings the router needs at startup.
  final db = AppDatabase();
  var onboarded = false;
  var remindersOn = false;
  var lockOn = false;
  try {
    onboarded = await db.getSetting(kOnboardingDoneKey) == 'true';
    remindersOn = await db.getSetting(kRemindersEnabledKey) == 'true';
    lockOn = await db.getSetting(kAppLockKey) == 'true';
  } catch (e) {
    // On web this usually means web/sqlite3.wasm or web/drift_worker.js is
    // missing or doesn't match the package versions. Run tool/setup_web_db.ps1.
    debugPrint('Could not open the database: $e');
  }

  // Subscriptions: RevenueCat if a key is configured, otherwise the demo store.
  final purchases = await createPurchasesService(db);
  var isPro = false;
  try {
    isPro = await purchases.isPro();
  } catch (e) {
    debugPrint('Could not read Pro status: $e');
  }

  final container = ProviderContainer(overrides: [
    databaseProvider.overrideWithValue(db),
    purchasesServiceProvider.overrideWithValue(purchases),
    onboardingCompleteProvider.overrideWith((ref) => onboarded),
    isProProvider.overrideWith((ref) => isPro),
    remindersEnabledProvider.overrideWith((ref) => remindersOn),
    appLockEnabledProvider.overrideWith((ref) => lockOn),
  ]);

  // Keep the app's Pro flag in sync with the store (purchase, restore, expiry).
  purchases.proChanges.listen((pro) => container.read(isProProvider.notifier).state = pro);

  runApp(UncontrolledProviderScope(container: container, child: const MoneyHubApp()));
}
