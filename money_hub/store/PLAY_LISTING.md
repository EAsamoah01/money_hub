# Google Play listing: Money Core

Copy each block into **Play Console → Grow users → Store presence → Main store listing**.
Character counts are checked against Play's limits.

## App name (26/30)

```
Money Core: Budget & Bills
```

## Short description (74/80)

```
Budget every dollar, never miss a bill, crush debt and learn money basics.
```

## Full description (2058/4000)

```
Money Core puts your budget, bills, debt payoff and money lessons in one simple app. No account, no ads, and your budget stays on your phone.

GIVE EVERY DOLLAR A JOB
• Envelope budgeting: add your income, assign it to envelopes like Rent, Groceries and Fun money, and see what's left at a glance
• Log spending in seconds and watch each envelope update
• Copy last month's budget with one tap
• Clear warnings when an envelope is overspent

NEVER MISS A BILL
• Bills & Alerts tracks rent, phone, insurance and subscriptions in one list
• A reminder on your phone before each due date, as many days ahead as you like
• Free-trial alerts before the first charge hits
• See what your subscriptions really cost each year

GET OUT OF DEBT FASTER
• Track every card and loan with its balance, APR and minimum payment
• Compare snowball and avalanche payoff plans (Pro)
• See your debt-free date and how much interest extra payments save

RUN THE NUMBERS
• Compound interest, FIRE number, debt payoff, "what if I invested", dollar-cost averaging vs lump sum, and inflation calculators
• Pin results to your Home screen and share them

LEARN AS YOU GO
• Short lessons on emergency funds, compound interest, paying off debt, index funds and more
• Quick quizzes and a daily learning streak

AI MONEY COACH (PRO)
• Ask questions about your own budget: "Can I afford a weekend trip?"
• A monthly check-in on where your money went and one thing to try
• Suggests the right envelope when you log spending
• Explains any lesson or calculator result in plain words
AI features only run after you agree, and you can turn them off any time.

PRIVATE BY DESIGN
• No sign-up and no ads
• Your budget is stored on your device, not on our servers
• Optional App lock with your fingerprint, face or PIN

MONEY CORE PRO
Unlock the AI money coach, debt payoff plans, unlimited pinned results and every new Pro feature. Subscriptions renew automatically until cancelled in Google Play.

Money Core is for education and planning. It is not financial, investment, tax or legal advice.
```

## Graphics

| Asset | File / spec |
|---|---|
| App icon | 512 × 512 PNG: export `assets/branding/icon.png` at 512 px (Play adds the rounded mask) |
| Feature graphic | `store/feature_graphic.png` (1024 × 500, ready to upload) |
| Phone screenshots | 4–8, see the plan below |
| 7" and 10" tablet screenshots | Optional but recommended; use the Fold's inner screen |

Feature graphic text: **"Your money, in one place"** with the pills *Budget · Bills & Alerts · Debt payoff · AI coach*.

## Other listing fields

- **Category:** Finance
- **Tags:** Budgeting, Personal finance, Bill reminders, Money management (pick the closest Play offers)
- **Contact email:** your support email (the same one as `CONTACT_EMAIL` in `ai_worker/wrangler.toml`)
- **Website:** your worker URL, or your own site later
- **Privacy policy URL:** `https://money-core-ai.<you>.workers.dev/privacy`

---

# Screenshot plan

**Why not the Fold's outer screen:** Play rejects screenshots whose long side is more than twice the
short side. The Fold6 cover screen (968 × 2376) is about 2.45:1, so those screenshots won't upload.

**Phone screenshots (use an emulator):** in Android Studio → Device Manager, create a **Pixel 2**
(1080 × 1920, 9:16) or any 1080 × 1920 device and run
`flutter run -d emulator-5554 --dart-define-from-file=env.json`. Take screenshots with the emulator's
camera button. Images 1080 px wide or more in 9:16 also qualify for Play's promotional spots.

**Tablet screenshots (use the Fold):** unfold it and take screenshots on the inner screen
(Power + Volume down). Upload them as 7-inch and 10-inch tablet screenshots.

Use **light mode** and turn **Pro on** (demo store in a debug build) so the Pro screens show.

| # | Screen | How to get there | Caption to add (optional) |
|---|---|---|---|
| 1 | Home dashboard | Home, scrolled to the top | Your whole money picture on one screen |
| 2 | Budget envelopes | Budget tab | Give every dollar a job |
| 3 | Bills & Alerts | Budget → Bills & Alerts | Never miss a bill or a free-trial charge |
| 4 | AI money coach | Home ✨ → ask "Can I afford a \$300 weekend trip?" | Ask your AI money coach |
| 5 | Debt payoff plan | Goals → Debts → Plan (avalanche, +\$150) | See your debt-free date |
| 6 | Add spending + AI category | Add spending, type "Trader Joe's", tap ✨ | Log spending in seconds |
| 7 | Compound interest calculator | Tools → Compound Interest, chart visible | Run the numbers |
| 8 | Lesson or quiz | Learn → Emergency fund | Learn money basics in 3 minutes |

Captions are optional. To add them, put each screenshot on a coloured background with the caption above
it (Canva or Figma, 1080 × 1920). Keep the claims factual: no "best", "#1" or prices in the images.

## Sample data for screenshots

Use a fresh install (or clear the app's storage) and enter this, so every screen looks realistic.
**Fix the \$20,000 Telnet test bill first** or clear storage.

**Income:** Paycheck \$2,100 (Oct 1) and Paycheck \$2,100 (Oct 15)

**Assign:** Rent / Mortgage \$1,450 · Utilities \$160 · Phone & Internet \$85 · Insurance \$112 ·
Groceries \$450 · Transport \$140 · Dining Out \$150 · Personal \$120 · Streaming \$27 ·
Emergency Fund \$300 · Extra Debt Payments \$150 · leave the rest unassigned

**Spending (October):** Trader Joe's \$86.40 (Groceries) · Costco \$142.15 (Groceries) ·
Chipotle \$24.80 (Dining Out) · Movie night \$32.00 (Personal) · PG&E \$98.30 (Utilities) ·
Shell \$48.00 (Transport)

**Bills & Alerts:** Rent \$1,450 monthly, due the 1st · Phone \$65 monthly · Car insurance \$112 monthly
(autopay) · Netflix \$15.49 subscription · Spotify \$11.99 subscription with a free trial ending in 5 days

**Debts:** Visa card \$3,200 at 22.99%, min \$95 · Car loan \$9,800 at 6.9%, min \$260 ·
Student loan \$14,500 at 5.5%, min \$160 → Plan: avalanche, extra \$150/month

**Learn:** finish one lesson and its quiz so the streak shows 1+.
**Tools:** pin one compound-interest result to Home.

---

# Data safety form (Play Console → App content → Data safety)

Based on what the app actually does (see `ai_worker/src/pages.js` for the matching privacy policy).

- **Does your app collect or share any of the required user data types?** Yes
- **Is all of the user data collected by your app encrypted in transit?** Yes
- **Do you provide a way for users to request that their data is deleted?** Yes (email request; on-device
  data is deleted by clearing storage or uninstalling)

| Data type | Collected | Shared | Optional? | Purpose |
|---|---|---|---|---|
| Financial info → Purchase history | Yes | No* | Required to buy Pro | App functionality, Account management |
| Financial info → Other financial info (budget summary sent to the AI) | Yes | No* | Optional (AI consent) | App functionality |
| App activity → Other user-generated content (AI questions) | Yes | No* | Optional | App functionality |
| Device or other IDs (RevenueCat's random app user ID) | Yes | No* | Required to buy Pro | App functionality, Fraud prevention, security |

\* Under Play's definitions, sending data to **service providers** that process it for you (RevenueCat,
Cloudflare, Anthropic) is not "sharing". Data that stays on the device (your budget database) is not
"collected".

Do **not** tick "processed ephemerally" for the AI data: our server doesn't store it, but Anthropic may
keep it for a limited time under its terms.

# Other App content forms

- **Privacy policy:** your worker `/privacy` URL
- **Ads:** No, the app does not contain ads (affiliate links aren't ad SDKs, but stay accurate if that changes)
- **App access:** "All functionality is available without special access", and add a note that Pro features
  need a subscription. Google reviewers can use license testing (see LAUNCH.md).
- **Content rating:** complete the questionnaire (category: *All other app types*). No violence or
  gambling. Answer "No" to user-to-user interaction: the AI chat is not between users.
- **Target audience:** 18 and over
- **Financial features:** declare that the app provides **personal finance / budgeting tools**, and that it
  does **not** offer loans, banking, crypto or investment trading.
- **Government apps / Health / News:** No
- **Generative AI:** the app has in-app **Report this answer** buttons (chat and insights card), as Play's
  AI-generated content policy requires.
