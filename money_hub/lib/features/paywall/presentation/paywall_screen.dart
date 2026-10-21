import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/routes.dart';
import '../../../core/services/purchases_service.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_header.dart';

const _proSeed = Color(0xFF6D28D9); // violet, only used on the paywall

const _features = <(IconData, String, String)>[
  (Icons.route_outlined, 'Debt payoff plans', 'Snowball vs avalanche with extra payments, saved to your dashboard'),
  (Icons.push_pin_outlined, 'Unlimited pinned results', 'Free accounts can pin ${AppConfig.freePinLimit}'),
  (Icons.beach_access_outlined, 'Retirement scenarios', 'Compare retirement ages and savings rates (coming soon)'),
  (Icons.show_chart, 'Net worth tracker', 'Everything you own minus everything you owe (coming soon)'),
];

/// One paywall for every Pro feature. [returnTo] is the screen the user was
/// trying to open; after purchase they go straight there.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, this.returnTo});
  final String? returnTo;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  late Future<List<ProPlan>> _plans = ref.read(purchasesServiceProvider).plans();
  String? _selectedId;
  bool _busy = false;

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _leave() {
    if (widget.returnTo != null) {
      context.go(widget.returnTo!);
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  Future<void> _buy(ProPlan plan) async {
    setState(() => _busy = true);
    final (outcome, message) = await ref.read(purchasesServiceProvider).purchase(plan);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (outcome) {
      case PurchaseOutcome.success:
        ref.read(isProProvider.notifier).state = true;
        _toast('Welcome to Pro! 🎉');
        _leave();
      case PurchaseOutcome.cancelled:
        break;
      case PurchaseOutcome.failed:
      case PurchaseOutcome.unavailable:
        _toast(message ?? 'Purchase failed. You have not been charged.');
    }
  }

  Future<void> _restore() async {
    setState(() => _busy = true);
    try {
      final pro = await ref.read(purchasesServiceProvider).restore();
      if (!mounted) return;
      ref.read(isProProvider.notifier).state = pro;
      _toast(pro ? 'Pro restored 🎉' : 'No active Pro subscription found on this account.');
      if (pro) _leave();
    } catch (e) {
      if (mounted) _toast('Could not restore: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(isProProvider);
    final service = ref.watch(purchasesServiceProvider);
    final b = Theme.of(context).brightness;

    return Theme(
      data: AppTheme.forSeed(_proSeed, b),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.close), onPressed: _leave),
            title: const Text('Money Hub Pro'),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: isPro ? _alreadyPro(context, service) : _offer(context, service),
            ),
          ),
        );
      }),
    );
  }

  Widget _alreadyPro(BuildContext context, PurchasesService service) {
    final t = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 24),
        Icon(Icons.workspace_premium, size: 84, color: t.colorScheme.primary),
        const SizedBox(height: 12),
        Text("You're a Pro member", textAlign: TextAlign.center, style: t.textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Thanks for supporting Money Hub. Every Pro feature is unlocked.', textAlign: TextAlign.center),
        const SizedBox(height: 28),
        FilledButton(onPressed: _leave, child: const Text('Continue')),
        const SizedBox(height: 8),
        if (!service.isDemo)
          OutlinedButton(
            onPressed: () async {
              final url = await service.manageUrl();
              if (url != null) await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            },
            child: const Text('Manage subscription'),
          ),
      ],
    );
  }

  Widget _offer(BuildContext context, PurchasesService service) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        const GradientHeader(
          title: 'Go Pro',
          subtitle: 'Get out of debt faster and keep every plan in one place.',
          icon: Icons.workspace_premium,
        ),
        if (service.isDemo)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Card(
              color: cs.tertiaryContainer,
              child: ListTile(
                leading: Icon(Icons.science_outlined, color: cs.onTertiaryContainer),
                title: Text(kDebugMode ? 'Demo mode' : 'Coming soon',
                    style: TextStyle(color: cs.onTertiaryContainer, fontWeight: FontWeight.w700)),
                subtitle: Text(
                  kDebugMode
                      ? 'No real payment is taken. Add your RevenueCat keys to sell for real (see MONETIZATION.md).'
                      : 'Pro subscriptions are not available yet.',
                  style: TextStyle(color: cs.onTertiaryContainer),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (icon, title, body) in _features)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: IconBubble(icon),
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(body),
                ),
              const SizedBox(height: 12),
              FutureBuilder<List<ProPlan>>(
                future: _plans,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final plans = snap.data ?? const <ProPlan>[];
                  if (snap.hasError || plans.isEmpty) {
                    return Column(
                      children: [
                        Text(
                          snap.hasError ? 'Could not load plans. Check your connection.' : 'No plans available yet.',
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () => setState(() => _plans = ref.read(purchasesServiceProvider).plans()),
                          child: const Text('Try again'),
                        ),
                      ],
                    );
                  }
                  return _planPicker(context, plans);
                },
              ),
              const SizedBox(height: 4),
              TextButton(onPressed: _busy ? null : _restore, child: const Text('Restore purchases')),
              const SizedBox(height: 4),
              Text(
                'Subscriptions renew automatically until cancelled. Cancel anytime in your '
                'App Store or Google Play account settings at least 24 hours before renewal.',
                textAlign: TextAlign.center,
                style: t.textTheme.bodySmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => launchUrl(Uri.parse(AppConfig.termsUrl)),
                    child: const Text('Terms'),
                  ),
                  const Text('·'),
                  TextButton(
                    onPressed: () => launchUrl(Uri.parse(AppConfig.privacyPolicyUrl)),
                    child: const Text('Privacy'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _planPicker(BuildContext context, List<ProPlan> plans) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    ProPlan? find(int months) {
      for (final p in plans) {
        if (p.months == months) return p;
      }
      return null;
    }

    final yearly = find(12);
    final savings = yearlySavingsPercent(find(1), yearly);
    final selected = plans.firstWhere((p) => p.id == _selectedId, orElse: () => yearly ?? plans.first);
    final currency = selected.priceLabel.isNotEmpty && !RegExp(r'\d').hasMatch(selected.priceLabel[0])
        ? selected.priceLabel[0]
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final p in plans)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: p.id == selected.id ? cs.primaryContainer : cs.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: p.id == selected.id ? cs.primary : cs.outlineVariant, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => setState(() => _selectedId = p.id),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(p.id == selected.id ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: cs.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(p.title, style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                                if (p == yearly && savings != null) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(8)),
                                    child: Text('Save $savings%',
                                        style: t.textTheme.labelSmall?.copyWith(color: cs.onPrimary)),
                                  ),
                                ],
                              ],
                            ),
                            if (p.trialLabel != null || p.perMonthLabel(currency) != null)
                              Text(
                                [if (p.trialLabel != null) p.trialLabel!, if (p.perMonthLabel(currency) != null) p.perMonthLabel(currency)!]
                                    .join(' · '),
                                style: t.textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                      Text(p.priceLabel, style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 6),
        FilledButton(
          onPressed: _busy ? null : () => _buy(selected),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
          child: _busy
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
              : Text(selected.trialLabel != null
                  ? 'Start free trial'
                  : 'Subscribe for ${selected.priceLabel}${selected.months == 12 ? '/year' : selected.months == 1 ? '/month' : ''}'),
        ),
      ],
    );
  }
}
