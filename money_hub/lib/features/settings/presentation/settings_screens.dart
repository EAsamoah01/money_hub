import 'package:flutter/material.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/placeholder_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
        title: 'Settings',
        details: 'Currency, theme, notifications, disclosures, privacy policy.',
        links: {
          'Backup & export': Routes.settingsBackup,
          'App lock (biometrics)': Routes.settingsSecurity,
          'Upgrade to Pro': Routes.paywall,
        },
      );
}

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Backup & export', details: 'CSV export, encrypted backup file.');
}

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'App lock', details: 'local_auth: Face ID / fingerprint on open.');
}
