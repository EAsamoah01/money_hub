# AI money coach (Claude)

Money Core's AI features are **Pro only**:

| Feature | Where |
|---|---|
| Money coach chat (knows this month's budget, bills, debts) | Home ✨ button, Home "Money coach" card, Settings |
| Monthly insights | Home → "Your month, explained" card |
| Auto-categorize spending | Add spending → ✨ in the "Paid to" box |
| Explain a lesson / calculator result | ✨ on a lesson's top bar, "Explain (AI)" under calculator results |

## How it works

```
App ──► Cloudflare Worker (ai_worker/) ──► Claude Haiku (Anthropic API)
         • checks Pro with RevenueCat
         • daily limit per user (100 by default)
         • holds the Anthropic key (never in the app)
```

The app sends the question plus a short text summary of the user's month
(`lib/features/ai/domain/money_context.dart`). The first time, the user must
agree to this in a dialog; they can turn it off in Settings → AI money coach.

## One-time setup (about 15 minutes)

You need: an Anthropic API key (console.anthropic.com → API keys, add a few
dollars of credit), your RevenueCat **secret** API key (RevenueCat → Project
settings → API keys → "+ New secret key", V1), and a free Cloudflare account.

In PowerShell:

```powershell
cd C:\money_hub_dev\money_hub_starter\money_hub\ai_worker
npm install
npx wrangler login                      # opens the browser once
npx wrangler kv namespace create USAGE  # copy the id it prints into wrangler.toml
npx wrangler secret put ANTHROPIC_API_KEY
npx wrangler secret put REVENUECAT_SECRET_KEY
npx wrangler secret put DEV_TOKEN       # any long random text; lets your debug build test without paying
npx wrangler deploy
```

`deploy` prints your URL, e.g. `https://money-core-ai.yourname.workers.dev`.
Check it: open `https://money-core-ai.yourname.workers.dev/health` → `{"ok":true}`.

### Custom domain

The app's share links and the privacy policy use **`https://moneycore.peprahsoft.com`**. Attach it once:
Cloudflare → **Workers & Pages → money-core-ai → Settings → Domains & Routes → Add →
Custom domain** → `moneycore.peprahsoft.com` (peprahsoft.com must be in the same Cloudflare
account). Check `https://moneycore.peprahsoft.com/health`.

Then add to `money_hub\env.json` (git-ignored):

```json
"AI_PROXY_URL": "https://moneycore.peprahsoft.com",
"AI_DEV_TOKEN": "the same DEV_TOKEN text"
```

and run with `flutter run -d RFCY50S7AAV --dart-define-from-file=env.json`.

In a debug build with the demo store: tap **Upgrade to Pro** (free in demo
mode), then try the coach. The dev token is only sent from debug builds, so
release builds always need a real subscription.

## Costs and limits

- Claude Haiku is the low-cost model; a typical coach answer costs a fraction
  of a cent. `DAILY_LIMIT` in `wrangler.toml` caps each user per day.
- Set a monthly spend limit in the Anthropic console as a safety net.
- To change the model, edit `MODEL` in `wrangler.toml` and redeploy.
- Cloudflare's free plan covers 100,000 requests a day.

## Reports and policies

- Every AI answer has a **Report this answer** button, as Google Play's
  AI-generated content policy requires. Reports are kept 90 days in KV. To list them:
  `npx wrangler kv key list --binding USAGE --prefix report:`
- The privacy policy served at `/privacy` already covers the AI features.
  Data safety answers are in `store/PLAY_LISTING.md`.

## Worker tests

```powershell
cd ai_worker
npm test
```
