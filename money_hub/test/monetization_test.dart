// Run with:  flutter test

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:money_hub/core/services/offers_service.dart';
import 'package:money_hub/core/services/purchases_service.dart';

void main() {
  group('OffersConfig.fromJson', () {
    test('parses offers, skips broken entries, honours enabled', () {
      final cfg = OffersConfig.fromJson({
        'disclosure': 'We may earn a commission.',
        'placements': {
          'a': {'title': 'Offer A', 'partner': 'P', 'url': 'https://partner.test/?ref=me'},
          'b': {'title': 'Offer B', 'url': 'https://partner.test/b', 'enabled': false},
          'broken': {'title': 'No url'},
          'notAMap': 42,
        },
      });
      expect(cfg.disclosure, 'We may earn a commission.');
      expect(cfg.placements.keys, containsAll(['a', 'b']));
      expect(cfg.placements.containsKey('broken'), isFalse);
      expect(cfg.forPlacement('a')?.title, 'Offer A');
      expect(cfg.forPlacement('b'), isNull); // disabled
      expect(cfg.forPlacement('missing'), isNull);
    });

    test('falls back to the default disclosure', () {
      expect(OffersConfig.fromJson({'placements': {}}).disclosure, kDefaultDisclosure);
    });

    test('flags placeholder links', () {
      const o = AffiliateOffer(placement: 'x', title: 't', partner: '', url: 'https://example.com/?ref=YOUR_ID');
      expect(o.isPlaceholder, isTrue);
    });

    test('bundled offers file is valid', () {
      final file = File('assets/config/affiliate_offers.json');
      final cfg = OffersConfig.fromJson(jsonDecode(file.readAsStringSync()) as Map<String, dynamic>);
      expect(cfg.placements, isNotEmpty);
      for (final o in cfg.placements.values) {
        expect(o.url, startsWith('https://'), reason: o.placement);
      }
    });
  });

  group('yearlySavingsPercent', () {
    const monthly = ProPlan(id: 'm', title: 'Monthly', priceLabel: r'$4.99', price: 4.99, months: 1);
    const yearly = ProPlan(id: 'y', title: 'Yearly', priceLabel: r'$39.99', price: 39.99, months: 12);

    test('computes the discount vs 12 monthly payments', () {
      // 4.99 × 12 = 59.88 → 39.99 saves 33%
      expect(yearlySavingsPercent(monthly, yearly), 33);
    });

    test('null when a plan is missing or there is no saving', () {
      expect(yearlySavingsPercent(null, yearly), isNull);
      const pricey = ProPlan(id: 'y2', title: 'Yearly', priceLabel: r'$99', price: 99, months: 12);
      expect(yearlySavingsPercent(monthly, pricey), isNull);
    });

    test('per-month label for yearly plans only', () {
      expect(yearly.perMonthLabel(r'$'), r'$3.33/mo');
      expect(monthly.perMonthLabel(r'$'), isNull);
    });
  });

  test('real offers open through the click-counting redirect', () {
    const real = AffiliateOffer(placement: 'tools.fire.result', title: 'T', partner: 'P', url: 'https://partner.test/?ref=1');
    expect(real.trackedUri.toString(), endsWith('/go/tools.fire.result'));
    const placeholder = AffiliateOffer(placement: 'x', title: 'T', partner: 'P', url: 'https://example.com/?ref=YOUR_ID');
    expect(placeholder.trackedUri.toString(), 'https://example.com/?ref=YOUR_ID');
  });

  test('bundled and server offers files match', () {
    expect(File('assets/config/affiliate_offers.json').readAsStringSync(),
        File('ai_worker/offers.json').readAsStringSync());
  });
}
