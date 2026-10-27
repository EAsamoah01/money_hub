# Launching Money Core on Google Play

Work through these in order. The listing text, screenshot plan and Data safety answers are in
[`store/PLAY_LISTING.md`](store/PLAY_LISTING.md). AI server setup is in [`AI.md`](AI.md).

| # | Step | Time |
|---|---|---|
| 1 | Put the privacy policy and terms online | 10 min |
| 2 | Create your upload key (release signing) | 10 min |
| 3 | Create the Play Console account and the app | 1 hr + Google's identity check |
| 4 | Build the release bundle (.aab) and upload it to Internal testing | 20 min |
| 5 | Create the Pro subscription and connect RevenueCat | 1 hr + up to 36 hrs to activate |
| 6 | Test a purchase with a license tester | 15 min |
| 7 | Closed test: 12 testers for 14 days (new personal accounts) | 14 days |
| 8 | Apply for production and release | Google's review takes up to 7 days |

---

## 1. Privacy policy and terms

The AI worker also serves `/privacy` and `/terms` (`ai_worker/src/pages.js`).

1. In `ai_worker/wrangler.toml`, under `[vars]`, set:
   - `DEVELOPER_NAME`: your name or business name exactly as it will appear on Google Play
   - `CONTACT_EMAIL`: a support address you check (it's shown publicly)
   - `EFFECTIVE_DATE`: the day you publish
   - `GOVERNING_LAW`: the state or country whose law applies (California is the default; change it if
     you or your business are elsewhere)
2. Deploy: `cd ai_worker` then `npx wrangler deploy`
3. Open `https://moneycore.peprahsoft.com/privacy` and `/terms` to check them (see AI.md, "Custom domain").

The app's Privacy and Terms links use these pages automatically once `AI_PROXY_URL` is in `env.json`.

> These pages were written to match what the app actually does, but they are not legal advice. Have them
> reviewed, especially if you add analytics, ads, accounts or cloud backup later (each of these changes the
> policy and the Data safety form).

## 2. Release signing (upload key)

Google Play only accepts bundles signed with your own key. You make it once and **keep it forever**.

```powershell
mkdir C:\money_hub_keys
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v `
  -keystore C:\money_hub_keys\money-core-upload.jks `
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

It asks for a password and your name or organization. (If `keytool.exe` isn't at that path, run
`flutter doctor -v` and look for the Java folder it lists.)

Then copy `android\key.properties.example` to `android\key.properties` and fill in the password(s) and the
path. Both files are git-ignored; **never commit them**.

**Back up `money-core-upload.jks` and the passwords** to a password manager or a USB drive. With Play App
Signing (on by default), Google holds the real signing key, so if you lose the upload key you can ask Google
support to reset it, but that takes days.

## 3. Play Console account and app

1. Go to play.google.com/console, sign up (one-time registration fee, currently US$25) and complete
   identity verification. Choose a **personal** or **organization** account. Organization accounts need a
   D-U-N-S number but skip the 12-tester rule in step 7.
2. **Create app** with app name *Money Core: Budget & Bills*, default language English (US), type **App**,
   **Free** (subscriptions are allowed in free apps).
3. Fill in the **Store listing** and every **App content** form using `store/PLAY_LISTING.md`.
4. Set up a **payments profile** (Settings → Payments profile) so you can sell subscriptions.

## 4. Build and upload the release bundle

`env.json` for release needs your real keys: `RC_GOOGLE_KEY` (from step 5) and `AI_PROXY_URL`.
`AI_DEV_TOKEN` is ignored in release builds.

```powershell
cd C:\money_hub_dev\money_hub_starter\money_hub
flutter clean
flutter pub get
flutter build appbundle --release --dart-define-from-file=env.json
```

The bundle is `build\app\outputs\bundle\release\app-release.aab`.

- Upload it in Play Console → **Testing → Internal testing → Create new release**. Internal testing goes
  live in minutes for up to 100 testers you list by email.
- Every new upload needs a higher build number. Bump the `+N` in `pubspec.yaml`
  (`version: 1.0.0+1` → `1.0.0+2`).
- The app targets Android 16 (API 36), as Play requires for new apps.

## 5. Pro subscription + RevenueCat

You can create subscriptions only after a bundle has been uploaded (step 4).

### In Play Console (Monetize with Play → Products → Subscriptions)

1. **Create subscription**: Product ID `money_core_pro`, name *Money Core Pro*.
2. Add two **base plans** (auto-renewing):
   - `monthly`: billing period 1 month, e.g. US$4.99
   - `yearly`: billing period 1 year, e.g. US$39.99 (the paywall shows the "Save X%" badge automatically)
3. Optional: on `yearly`, add an **offer** `yearly-free-trial`: free trial 7 days, eligibility *New
   customer acquisition*.
4. **Activate** both base plans (and the offer).

Product IDs can never be reused, so get them right the first time.

### In RevenueCat

1. **Project → Apps → + New → Google Play**, package name `com.peprahtech.moneycore`.
2. **Service account credentials:** follow RevenueCat's guide *Creating Play Service Credentials* (in
   Google Cloud, enable the Play Android Developer API, create a service account and a JSON key; in Play
   Console → Users and permissions, invite the service account email with: *View app information*, *View
   financial data*, *Manage orders and subscriptions*, *Manage store presence*). Upload the JSON to
   RevenueCat. **It can take up to 36 hours to start working.**
3. **Products → Import** `money_core_pro:monthly` and `money_core_pro:yearly`.
4. **Entitlements → + New** with identifier `pro` (it must match `AppConfig.proEntitlement`), then
   attach both products.
5. **Offerings → `default`** (mark it *Current*) with two packages: **Monthly** (`$rc_monthly`) →
   `money_core_pro:monthly`, and **Annual** (`$rc_annual`) → `money_core_pro:yearly`.
6. **API keys:** copy the public **Google** key (`goog_…`) into `env.json` as `RC_GOOGLE_KEY`. Create a
   **secret** key for the AI worker (`npx wrangler secret put REVENUECAT_SECRET_KEY`).

Rebuild (step 4) after adding `RC_GOOGLE_KEY`. Without it, the app falls back to the demo store, which can't
sell anything in release builds.

## 6. Test a real purchase (free)

1. Play Console → **Settings → License testing**: add your Gmail and your testers' Gmails.
2. Install from the Internal testing link on the Fold (uninstall the debug build first; the signatures
   differ).
3. Open the paywall and buy. License testers aren't charged, and subscriptions renew quickly (a monthly
   plan renews every few minutes), so you can test renewal and expiry.
4. Check: Pro unlocks, **Restore purchases** works after reinstalling, the AI coach answers (the worker
   sees Pro through RevenueCat), and cancelling in Play removes Pro when the period ends.

## 7. Closed test (new personal accounts)

New personal developer accounts must run a **closed test with at least 12 testers opted in for 14 days in a
row** before they can publish to production.

1. **Testing → Closed testing → Create track**, then upload the same bundle (or a newer one).
2. Add testers by email list or a Google Group, and share the opt-in link.
3. Ask testers to actually use it (add income, bills, try the coach) and send feedback. Google asks about
   engagement and what you changed when you apply.
4. Keep at least 12 opted in for 14 straight days. Someone who leaves and rejoins restarts their count.

## 8. Production

Dashboard → **Apply for production**. Answer the form (about the closed test, the app and its audience, and
the changes you made). After approval, create a production release, roll it out (start at 20% if you
like), and send it for review.

---

## Before every release

- [ ] `flutter analyze` and `flutter test` pass
- [ ] Bump `version` in `pubspec.yaml`
- [ ] `env.json` has the live `RC_GOOGLE_KEY` and `AI_PROXY_URL`
- [ ] Privacy policy still matches the app (new SDKs, data, features?)
- [ ] Test the paywall, restore, reminders and the AI coach on the Fold (inner and outer screens)
