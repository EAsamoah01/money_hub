import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Later: await Firebase.initializeApp(); await Purchases.configure(...);

  // Open the database once and read the settings the router needs at startup.
  final db = AppDatabase();
  var onboarded = false;
  try {
    onboarded = await db.getSetting(kOnboardingDoneKey) == 'true';
  } catch (e) {
    // On web this usually means web/sqlite3.wasm or web/drift_worker.js is
    // missing or doesn't match the package versions. Run tool/setup_web_db.ps1.
    debugPrint('Could not open the database: $e');
  }

  runApp(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      onboardingCompleteProvider.overrideWith((ref) => onboarded),
    ],
    child: const MoneyHubApp(),
  ));
}
