import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../database/app_database.dart';

const kDefaultDisclosure = 'Some links are affiliate links. We may earn a commission if you sign up, '
    'at no extra cost to you. This never changes our calculations.';

/// One partner offer shown in a specific place in the app.
class AffiliateOffer {
  const AffiliateOffer({
    required this.placement,
    required this.title,
    required this.partner,
    required this.url,
    this.body,
    this.cta,
    this.enabled = true,
  });

  final String placement;
  final String title;
  final String partner;
  final String url;
  final String? body;
  final String? cta;
  final bool enabled;

  /// Placeholder links from the example file must never reach real users.
  bool get isPlaceholder => url.contains('example.com') || url.contains('YOUR_ID');

  /// Whether this offer may be shown in the current build.
  bool get showable => enabled && url.startsWith('http') && (kDebugMode || !isPlaceholder);
}

class OffersConfig {
  const OffersConfig({required this.disclosure, required this.placements});

  final String disclosure;
  final Map<String, AffiliateOffer> placements;

  static const empty = OffersConfig(disclosure: kDefaultDisclosure, placements: {});

  AffiliateOffer? forPlacement(String placement) {
    final o = placements[placement];
    return (o != null && o.showable) ? o : null;
  }

  /// Accepts the JSON shape in assets/config/affiliate_offers.json.
  /// Bad entries are skipped rather than crashing the app.
  factory OffersConfig.fromJson(Map<String, dynamic> j) {
    final raw = j['placements'];
    final map = <String, AffiliateOffer>{};
    if (raw is Map) {
      for (final e in raw.entries) {
        final v = e.value;
        if (v is! Map) continue;
        final url = v['url'];
        final title = v['title'];
        if (url is! String || title is! String) continue;
        map['${e.key}'] = AffiliateOffer(
          placement: '${e.key}',
          title: title,
          partner: (v['partner'] as String?) ?? '',
          url: url,
          body: v['body'] as String?,
          cta: v['cta'] as String?,
          enabled: v['enabled'] != false,
        );
      }
    }
    final disclosure = j['disclosure'];
    return OffersConfig(
      disclosure: disclosure is String && disclosure.trim().isNotEmpty ? disclosure : kDefaultDisclosure,
      placements: map,
    );
  }
}

const _cacheKey = 'offers_cache_json';

/// Loads offers in this order, so the app always has something sensible:
///   1. live JSON from AppConfig.offersUrl (and caches it),
///   2. the last cached copy,
///   3. the file bundled in assets/config/affiliate_offers.json.
/// Change offers by editing the hosted JSON. No app update needed.
Future<OffersConfig> loadOffers({AppDatabase? db, http.Client? client}) async {
  OffersConfig? parse(String s) {
    try {
      return OffersConfig.fromJson(jsonDecode(s) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Bad offers JSON: $e');
      return null;
    }
  }

  if (AppConfig.offersUrl.isNotEmpty) {
    try {
      final c = client ?? http.Client();
      final res = await c.get(Uri.parse(AppConfig.offersUrl)).timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final cfg = parse(res.body);
        if (cfg != null) {
          try {
            await db?.setSetting(_cacheKey, res.body);
          } catch (_) {}
          return cfg;
        }
      }
    } catch (e) {
      debugPrint('Could not download offers: $e');
    }
    try {
      final cached = await db?.getSetting(_cacheKey);
      if (cached != null) {
        final cfg = parse(cached);
        if (cfg != null) return cfg;
      }
    } catch (_) {}
  }

  try {
    final bundled = await rootBundle.loadString('assets/config/affiliate_offers.json');
    return parse(bundled) ?? OffersConfig.empty;
  } catch (e) {
    debugPrint('No bundled offers: $e');
    return OffersConfig.empty;
  }
}

final offersProvider = FutureProvider<OffersConfig>((ref) => loadOffers(db: ref.watch(databaseProvider)));
