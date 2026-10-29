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
| `learn.<lesson id>` | Under a lesson, e.g. `learn.index-funds-101`, `learn.compound-interest-basics`, `learn.emergency-fund-basics`, `learn.inflation-and-cash`, `learn.fire-and-the-4-percent-rule` |

Any lesson can get an offer just by adding `learn.<its id>` to the file; no code change needed.

### Add or change a real offer (no app update)
The live list is **`ai_worker/offers.json`**, served at `https://moneycore.peprahsoft.com/offers.json`.

1. Join partner programs (robo-advisors, brokerages, IRA providers, high-yield savings, balance-transfer cards), directly or through networks such as Impact, CJ or FlexOffers. Read each program's rules: many restrict wording or in-app placement.
2. Edit `ai_worker/offers.json`: set `title`, `body`, `partner`, `cta`, `url` (your tracked link) and `enabled: true`. Set `enabled: false` to pause an offer.
3. `cd ai_worker` then `npx wrangler deploy`. Phones pick up the change on their next app start.
4. Copy the same file to `assets/config/affiliate_offers.json` before your next app release. That copy is the offline fallback, and a test checks the two match.

Links containing `example.com` or `YOUR_ID` are **placeholders**: they show in debug builds (marked "placeholder link") and are **hidden in release builds**.

### Click tracking
Taps on real offers go through `https://moneycore.peprahsoft.com/go/<placement>`. The server adds one to that offer's monthly count, then redirects to the partner. It stores no user ID, IP or device data, and it only redirects to links in its own offers file.

See the counts: open `https://moneycore.peprahsoft.com/stats?token=<your DEV_TOKEN>` in a browser. Compare them with each partner's dashboard to see which offers earn.

### Compliance (US)
- **FTC:** the disclosure must sit next to the link (done) and be clear. Edit `disclosure` in the JSON if a partner needs specific wording.
- Keep calculator results **independent of offers**. Never change numbers to favour a partner.
- Money Core is educational. Offers must not be framed as personal advice ("you should open X").
