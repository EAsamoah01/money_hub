import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Later: await Firebase.initializeApp(); await Purchases.configure(...);
  runApp(const ProviderScope(child: MoneyHubApp()));
}
