import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/routes.dart';
import '../../../core/services/offers_service.dart';
import '../../../core/services/purchases_service.dart';
import '../../../core/state/app_state.dart';
import '../../../core/widgets/gradient_header.dart';
import '../../../core/widgets/placeholder_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final pro = await ref.read(purchasesServiceProvider).restore();
      ref.read(isProProvider.notifier).state = pro;
      messenger.showSnackBar(SnackBar(content: Text(pro ? 'Pro restored 🎉' : 'No active Pro subscription found.')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Could not restore: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(isProProvider);
    final service = ref.watch(purchasesServiceProvider);
    final disclosure = ref.watch(offersProvider).valueOrNull?.disclosure ?? kDefaultDisclosure;
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              GradientHeader(
                title: isPro ? 'Pro member' : 'Free plan',
                subtitle: isPro
                    ? 'Every feature unlocked. Thank you!'
                    : 'Upgrade for debt plans and unlimited pinned results.',
                icon: isPro ? Icons.workspace_premium : Icons.person_outline,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionTitle('Membership'),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.workspace_premium_outlined),
                            title: Text(isPro ? 'Your Pro membership' : 'Upgrade to Pro'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push(Routes.paywall),
                          ),
                          ListTile(
                            leading: const Icon(Icons.restore),
                            title: const Text('Restore purchases'),
                            subtitle: const Text('Already paid on another device? Restore it here.'),
                            onTap: () => _restore(context, ref),
                          ),
                          if (isPro && !service.isDemo)
                            ListTile(
                              leading: const Icon(Icons.manage_accounts_outlined),
                              title: const Text('Manage or cancel subscription'),
                              trailing: const Icon(Icons.open_in_new, size: 18),
                              onTap: () async {
                                final url = await service.manageUrl();
                                if (url != null) await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              },
                            ),
                          if (kDebugMode && service is DemoPurchasesService && isPro)
                            ListTile(
                              leading: const Icon(Icons.science_outlined),
                              title: const Text('Reset demo Pro (debug only)'),
                              onTap: () async {
                                await service.resetDemo();
                                ref.read(isProProvider.notifier).state = false;
                              },
                            ),
                        ],
                      ),
                    ),
                    const SectionTitle('Your data'),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.cloud_download_outlined),
                            title: const Text('Backup & export'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push(Routes.settingsBackup),
                          ),
                          ListTile(
                            leading: const Icon(Icons.fingerprint),
                            title: const Text('App lock'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push(Routes.settingsSecurity),
                          ),
                        ],
                      ),
                    ),
                    const SectionTitle('About'),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.privacy_tip_outlined),
                            title: const Text('Privacy policy'),
                            trailing: const Icon(Icons.open_in_new, size: 18),
                            onTap: () => launchUrl(Uri.parse(AppConfig.privacyPolicyUrl)),
                          ),
                          ListTile(
                            leading: const Icon(Icons.description_outlined),
                            title: const Text('Terms of use'),
                            trailing: const Icon(Icons.open_in_new, size: 18),
                            onTap: () => launchUrl(Uri.parse(AppConfig.termsUrl)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Money Hub is for education only and is not financial, tax or legal advice. '
                      'Your budget and debt data stays on this device.\n\n$disclosure',
                      style: t.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Backup & export', details: 'CSV export and backup file. Coming soon.');
}

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'App lock', details: 'Face ID / fingerprint when the app opens. Coming soon.');
}
