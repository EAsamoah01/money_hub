// Settings that differ per environment. Values come from --dart-define so
// keys never get committed to git. Put them in env.json (git-ignored):
//
//   {
//     "RC_GOOGLE_KEY": "goog_xxxxxxxx",
//     "RC_APPLE_KEY": "appl_xxxxxxxx",
//     "RC_WEB_KEY": "rcb_xxxxxxxx",
//     "OFFERS_URL": "https://gist.githubusercontent.com/.../affiliate_offers.json",
//     "AI_PROXY_URL": "https://money-core-ai.<you>.workers.dev",
//     "AI_DEV_TOKEN": "same value as the worker's DEV_TOKEN (debug builds only)"
//   }
//
// and run:  flutter run --dart-define-from-file=env.json
// With no keys set, the app uses a demo store (debug builds only).

abstract final class AppConfig {
  /// Shown in the app, store listing and on the home screen.
  static const appName = 'Money Core';

  /// RevenueCat public SDK keys (Project settings → API keys in RevenueCat).
  static const revenueCatGoogleKey = String.fromEnvironment('RC_GOOGLE_KEY');
  static const revenueCatAppleKey = String.fromEnvironment('RC_APPLE_KEY');
  static const revenueCatWebKey = String.fromEnvironment('RC_WEB_KEY');

  /// Entitlement identifier you create in RevenueCat. Must match exactly.
  static const proEntitlement = 'pro';

  /// Optional: where to download live affiliate offers from. Leave empty to
  /// use only assets/config/affiliate_offers.json.
  static const offersUrl = String.fromEnvironment('OFFERS_URL');

  /// Required on the paywall by Apple and Google. By default these are the
  /// pages served by the AI worker (ai_worker/src/pages.js); set PRIVACY_URL /
  /// TERMS_URL in env.json to use pages hosted elsewhere.
  static String get privacyPolicyUrl => _page(const String.fromEnvironment('PRIVACY_URL'), 'privacy');
  static String get termsUrl => _page(const String.fromEnvironment('TERMS_URL'), 'terms');

  static String _page(String override, String path) {
    if (override.isNotEmpty) return override;
    var base = aiProxyUrl.trim();
    while (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }
    return base.isEmpty ? 'https://yourdomain.com/$path' : '$base/$path';
  }

  /// The AI proxy (Cloudflare Worker in ai_worker/). Empty = AI turned off.
  static const aiProxyUrl = String.fromEnvironment('AI_PROXY_URL');

  /// Lets debug builds use AI without a real subscription. Never sent from
  /// release builds.
  static const aiDevToken = String.fromEnvironment('AI_DEV_TOKEN');

  /// Free users can pin this many calculator results to Home.
  static const freePinLimit = 3;
}
