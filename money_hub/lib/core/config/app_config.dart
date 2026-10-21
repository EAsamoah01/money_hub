// Settings that differ per environment. Values come from --dart-define so
// keys never get committed to git. Put them in env.json (git-ignored):
//
//   {
//     "RC_GOOGLE_KEY": "goog_xxxxxxxx",
//     "RC_APPLE_KEY": "appl_xxxxxxxx",
//     "RC_WEB_KEY": "rcb_xxxxxxxx",
//     "OFFERS_URL": "https://gist.githubusercontent.com/.../affiliate_offers.json"
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

  /// Required on the paywall by Apple and Google. Replace with your pages.
  static const privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_URL',
    defaultValue: 'https://yourdomain.com/privacy',
  );
  static const termsUrl = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: 'https://yourdomain.com/terms',
  );

  /// Free users can pin this many calculator results to Home.
  static const freePinLimit = 3;
}
