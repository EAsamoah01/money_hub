import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/database/app_database.dart';
import '../../../core/router/routes.dart';
import '../../../core/services/app_lock.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/offers_service.dart';
import '../../../core/services/purchases_service.dart';
import '../../../core/state/app_state.dart';
import '../../../core/widgets/gradient_header.dart';
import '../../../core/widgets/placeholder_screen.dart';
import '../../ai/presentation/ai_gate.dart';

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
                    const SectionTitle('Reminders & security'),
                    Card(
                      child: Column(
                        children: [
                          SwitchListTile(
                            secondary: const Icon(Icons.notifications_active_outlined),
                            title: const Text('Bill reminders'),
                            subtitle: Text(NotificationService.supported
                                ? 'A notification before each bill is due and before free trials end'
                                : 'Available in the Android and iPhone app'),
                            value: ref.watch(remindersEnabledProvider),
                            onChanged: NotificationService.supported ? (v) => setReminders(context, ref, v) : null,
                          ),
                          ListTile(
                            leading: const Icon(Icons.fingerprint),
                            title: const Text('App lock'),
                            subtitle: Text(ref.watch(appLockEnabledProvider) ? 'On' : 'Off'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push(Routes.settingsSecurity),
                          ),
                        ],
                      ),
                    ),
                    const SectionTitle('AI money coach'),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.auto_awesome),
                            title: const Text('Open the money coach'),
                            subtitle: Text(isPro ? 'Ask anything about your budget' : 'Pro feature'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push(Loc.coach()),
                          ),
                          SwitchListTile(
                            secondary: const Icon(Icons.share_outlined),
                            title: const Text('Share budget summary with AI'),
                            subtitle: const Text('Needed for AI answers. Turn off to stop sending any data.'),
                            value: ref.watch(aiConsentProvider).valueOrNull ?? false,
                            onChanged: (v) async {
                              if (v) {
                                await ensureAiAllowed(context, ref);
                              } else {
                                await setAiConsent(ref, false);
                              }
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
                      '${AppConfig.appName} is for education only and is not financial, tax or legal advice. '
                      'Your budget and debt data stays on this device. If you use the AI coach, a summary is sent '
                      'to answer your question and is not stored by us.\n\n$disclosure',
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

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  late final Future<bool> _available = ref.read(appLockServiceProvider).isAvailable();

  Future<void> _toggle(bool on) async {
    final messenger = ScaffoldMessenger.of(context);
    // Confirm the user can actually unlock before turning the lock on.
    if (on && !await ref.read(appLockServiceProvider).authenticate()) {
      messenger.showSnackBar(const SnackBar(content: Text('App lock not turned on.')));
      return;
    }
    await ref.read(databaseProvider).setSetting(kAppLockKey, '$on');
    ref.read(appLockEnabledProvider.notifier).state = on;
    messenger.showSnackBar(SnackBar(content: Text(on ? 'App lock is on' : 'App lock is off')));
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(appLockEnabledProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('App lock')),
      body: FutureBuilder<bool>(
        future: _available,
        builder: (context, snap) {
          final available = snap.data ?? false;
          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              GradientHeader(
                title: enabled ? 'Locked with your fingerprint' : 'App lock is off',
                subtitle: 'Ask for your fingerprint, face or phone PIN when ${AppConfig.appName} opens '
                    'or returns after ${AppLockGate.relockAfter.inSeconds} seconds away.',
                icon: Icons.fingerprint,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: SwitchListTile(
                    title: const Text('Require unlock'),
                    subtitle: Text(snap.connectionState != ConnectionState.done
                        ? 'Checking this device…'
                        : available
                            ? 'Uses the screen lock already set up on this device'
                            : 'This device has no fingerprint, face or PIN lock set up'),
                    value: enabled,
                    onChanged: available ? _toggle : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Turns reminders on (asking for notification permission) or off.
Future<void> setReminders(BuildContext context, WidgetRef ref, bool on) async {
  final messenger = ScaffoldMessenger.of(context);
  if (on && !await ref.read(notificationServiceProvider).requestPermission()) {
    messenger.showSnackBar(const SnackBar(
      content: Text('Notifications are blocked. Allow them for ${AppConfig.appName} in your phone settings.'),
    ));
    return;
  }
  await ref.read(databaseProvider).setSetting(kRemindersEnabledKey, '$on');
  ref.read(remindersEnabledProvider.notifier).state = on;
  messenger.showSnackBar(SnackBar(content: Text(on ? 'Bill reminders are on' : 'Bill reminders are off')));
}
