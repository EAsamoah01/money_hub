# Making money with Money Core

Two income streams are built in:

1. **Pro subscription** (RevenueCat, App Store, Google Play, web)
2. **Affiliate offers** (partner links shown next to relevant results, changeable without an app update)

Everything works out of the box in **demo mode**: the paywall, plans and "Pro" unlock run locally in debug builds with no real payment. Follow the steps below to switch on real money.

---

## 1. Pro subscription with RevenueCat

### What Pro unlocks today
| Feature | Where |
|---|---|
| Debt payoff plan (snowball/avalanche + extra payments, saved) | Goals → Debts → Plan |
| Unlimited pinned results (free = `AppConfig.freePinLimit`, 3) | Any calculator → Pin to Home |
| Retirement scenarios, net worth tracker | Coming soon (listed on the paywall as "coming soon") |

Pro-only routes are listed in `Routes.proOnly` (`lib/core/router/routes.dart`). Add a route there and the router sends free users to the paywall automatically, then back after purchase.

### Setup (one time)
1. **Store accounts:** Google Play Console ($25 once) and/or Apple Developer Program ($99/year).
2. **Create subscription products** in each store, e.g. `pro_monthly` and `pro_yearly`.
3. **RevenueCat** (free until you earn a meaningful amount): create a project, add your Android and/or iOS app, and connect the store credentials RevenueCat asks for.
4. In RevenueCat create:
   - an **entitlement** with identifier **`pro`** (must match `AppConfig.proEntitlement`),
   - an **offering** marked as *current*, with a **Monthly** and an **Annual** package pointing at your store products.
5. Copy the **public SDK keys** from RevenueCat's API keys page.

### Run with real purchases
```powershell
copy env.example.json env.json      # env.json is git-ignored, never commit it
# edit env.json → paste RC_GOOGLE_KEY / RC_APPLE_KEY
flutter run --dart-define-from-file=env.json
```
With no key for the current platform, the app falls back to the demo store. In **release** builds the demo store refuses purchases, so Pro can't be unlocked for free by accident.

Test purchases with Google Play license testers / Apple sandbox accounts before going live.

### Platform notes
- **Android:** minSdk must be at least what `purchases_flutter` requires (see its pub.dev page). Billing permission is added by the plugin.
- **iOS:** enable the *In-App Purchase* capability in Xcode.
- **Web:** needs RevenueCat Web Billing (separate setup + `RC_WEB_KEY`). Optional.
- **Windows:** not supported by RevenueCat. The demo store is used.

### Store rules to respect
- The paywall shows price, billing period, auto-renew terms, **Restore purchases**, and links to **Terms** and **Privacy** (set `PRIVACY_URL` / `TERMS_URL`). Both stores require these.
- Don't link to an outside payment page for Pro from inside the app.

---

## 2. Affiliate offers

Offers appear in these placements (one card each, with the disclosure printed under it):

| Placement key | Screen |
|---|---|
| `tools.compound-interest.result` | Compound interest calculator |
| `tools.fire.result` | FIRE calculator |
| `tools.what-if.result` | What-if calculator |
| `tools.dca.result` | DCA vs lump sum |
| `tools.inflation.result` | Inflation calculator |
| `tools.debt-payoff.result` | Debt payoff calculator |
| `goals.debt.detail` | A debt's detail page |
| `budget.overview` | Budget tab |

### Add a real offer
1. Join partner programs (brokers, high-yield savings, balance-transfer cards, budgeting tools), directly or through affiliate networks. Read each program's rules. Many forbid certain wording or require approval of placements.
2. Edit `assets/config/affiliate_offers.json`: set `title`, `partner`, `url` (your tracked link), `enabled: true`.
3. Links containing `example.com` or `YOUR_ID` are treated as **placeholders**: they show in debug builds (marked "placeholder link") and are **hidden in release builds**.

### Change offers without an app update
1. Create a **public GitHub Gist** (or any static host) with your `affiliate_offers.json`.
2. Click **Raw** and copy that URL.
3. Put it in `env.json` as `OFFERS_URL` and rebuild once.

The app downloads it on start, caches it for offline use, and falls back to the bundled file. From then on, editing the gist changes offers for everyone.

### Compliance (US)
- **FTC:** the disclosure must sit next to the link (done) and be clear. Edit `disclosure` in the JSON if a partner needs specific wording.
- Keep calculator results **independent of offers**. Never change numbers to favour a partner.
- Money Core is educational. Offers must not be framed as personal advice ("you should open X").
