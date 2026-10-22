import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../config/app_config.dart';
import '../database/app_database.dart';

/// One subscription option shown on the paywall.
class ProPlan {
  const ProPlan({
    required this.id,
    required this.title,
    required this.priceLabel,
    required this.price,
    required this.months,
    this.trialLabel,
    this.raw,
  });

  final String id;
  final String title; // "Yearly"
  final String priceLabel; // "$39.99"
  final double price;

  /// Billing period in months (1 = monthly, 12 = yearly, 0 = lifetime).
  final int months;
  final String? trialLabel; // "7-day free trial"

  /// The underlying store object (a RevenueCat Package).
  final Object? raw;

  /// "$3.33/mo" for yearly plans.
  String? perMonthLabel(String currencySymbol) =>
      months > 1 ? '$currencySymbol${(price / months).toStringAsFixed(2)}/mo' : null;
}

/// Percent saved by [yearly] vs paying [monthly] for 12 months, or null.
int? yearlySavingsPercent(ProPlan? monthly, ProPlan? yearly) {
  if (monthly == null || yearly == null || monthly.price <= 0 || yearly.months != 12) return null;
  final full = monthly.price * 12;
  final pct = ((full - yearly.price) / full * 100).round();
  return pct > 0 ? pct : null;
}

enum PurchaseOutcome { success, cancelled, failed, unavailable }

/// What the rest of the app talks to. Swap implementations without touching
/// screens: RevenueCat in production, [DemoPurchasesService] while building.
abstract class PurchasesService {
  /// true if purchases are simulated (no real money).
  bool get isDemo;

  /// Emits whenever Pro status changes (purchase, restore, expiry).
  Stream<bool> get proChanges;

  Future<bool> isPro();
  Future<List<ProPlan>> plans();
  Future<(PurchaseOutcome, String?)> purchase(ProPlan plan);
  Future<bool> restore();

  /// Store page where the user manages/cancels the subscription.
  Future<String?> manageUrl();

  /// Id the AI server uses to check this user's subscription.
  Future<String> userId();
}

// ───────────────────────── RevenueCat ─────────────────────────

class RevenueCatPurchasesService implements PurchasesService {
  RevenueCatPurchasesService._();

  final _changes = StreamController<bool>.broadcast();

  static Future<RevenueCatPurchasesService> create(String apiKey) async {
    if (kDebugMode) await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(PurchasesConfiguration(apiKey));
    final s = RevenueCatPurchasesService._();
    Purchases.addCustomerInfoUpdateListener((info) => s._changes.add(_hasPro(info)));
    return s;
  }

  static bool _hasPro(CustomerInfo info) => info.entitlements.active.containsKey(AppConfig.proEntitlement);

  @override
  bool get isDemo => false;

  @override
  Stream<bool> get proChanges => _changes.stream;

  @override
  Future<bool> isPro() async => _hasPro(await Purchases.getCustomerInfo());

  @override
  Future<List<ProPlan>> plans() async {
    final offerings = await Purchases.getOfferings();
    final packages = offerings.current?.availablePackages ?? const <Package>[];
    return [
      for (final p in packages)
        ProPlan(
          id: p.identifier,
          title: switch (p.packageType) {
            PackageType.annual => 'Yearly',
            PackageType.monthly => 'Monthly',
            PackageType.weekly => 'Weekly',
            PackageType.lifetime => 'Lifetime',
            _ => p.storeProduct.title,
          },
          priceLabel: p.storeProduct.priceString,
          price: p.storeProduct.price,
          months: switch (p.packageType) {
            PackageType.annual => 12,
            PackageType.sixMonth => 6,
            PackageType.threeMonth => 3,
            PackageType.twoMonth => 2,
            PackageType.monthly => 1,
            _ => 0,
          },
          trialLabel: p.storeProduct.introductoryPrice?.price == 0 ? 'Free trial included' : null,
          raw: p,
        ),
    ];
  }

  @override
  Future<(PurchaseOutcome, String?)> purchase(ProPlan plan) async {
    final pkg = plan.raw;
    if (pkg is! Package) return (PurchaseOutcome.unavailable, 'Plan not available');
    try {
      await Purchases.purchasePackage(pkg);
      final pro = await isPro();
      return pro ? (PurchaseOutcome.success, null) : (PurchaseOutcome.failed, 'Purchase did not unlock Pro');
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) return (PurchaseOutcome.cancelled, null);
      return (PurchaseOutcome.failed, e.message);
    }
  }

  @override
  Future<bool> restore() async => _hasPro(await Purchases.restorePurchases());

  @override
  Future<String?> manageUrl() async => (await Purchases.getCustomerInfo()).managementURL;

  @override
  Future<String> userId() => Purchases.appUserID;
}

// ───────────────────────── Demo (no store) ─────────────────────────

/// Fake store for building and testing the paywall without RevenueCat.
/// Pro status is saved in app_settings so it survives restarts.
/// Purchases only work in debug builds, so a release build can never hand
/// out Pro for free.
class DemoPurchasesService implements PurchasesService {
  DemoPurchasesService(this._db);
  final AppDatabase _db;
  final _changes = StreamController<bool>.broadcast();
  static const _key = 'demo_pro';

  @override
  bool get isDemo => true;

  @override
  Stream<bool> get proChanges => _changes.stream;

  @override
  Future<bool> isPro() async {
    try {
      return await _db.getSetting(_key) == 'true';
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<ProPlan>> plans() async => const [
        ProPlan(id: 'demo_yearly', title: 'Yearly', priceLabel: r'$39.99', price: 39.99, months: 12,
            trialLabel: '7-day free trial'),
        ProPlan(id: 'demo_monthly', title: 'Monthly', priceLabel: r'$4.99', price: 4.99, months: 1),
      ];

  @override
  Future<(PurchaseOutcome, String?)> purchase(ProPlan plan) async {
    if (!kDebugMode) return (PurchaseOutcome.unavailable, 'Subscriptions are not set up yet.');
    await _set(true);
    return (PurchaseOutcome.success, null);
  }

  @override
  Future<bool> restore() => isPro();

  @override
  Future<String?> manageUrl() async => null;

  @override
  Future<String> userId() async => 'demo';

  /// Debug helper used from Settings.
  Future<void> resetDemo() => _set(false);

  Future<void> _set(bool v) async {
    await _db.setSetting(_key, '$v');
    _changes.add(v);
  }
}

/// Picks RevenueCat when a key for this platform is configured, else demo.
Future<PurchasesService> createPurchasesService(AppDatabase db) async {
  String key = '';
  if (kIsWeb) {
    key = AppConfig.revenueCatWebKey;
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    key = AppConfig.revenueCatGoogleKey;
  } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
    key = AppConfig.revenueCatAppleKey;
  }
  if (key.isNotEmpty) {
    try {
      return await RevenueCatPurchasesService.create(key);
    } catch (e) {
      debugPrint('RevenueCat failed to start, using demo store: $e');
    }
  }
  return DemoPurchasesService(db);
}

/// Overridden in main() with the real instance.
final purchasesServiceProvider = Provider<PurchasesService>(
  (ref) => throw UnimplementedError('purchasesServiceProvider must be overridden in main()'),
);
