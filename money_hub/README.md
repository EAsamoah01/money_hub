# Money Hub — Flutter starter

All-in-one personal finance app: **Budget** (envelopes + bills/subscriptions), **Goals** (debt payoff + net worth), **Tools** (calculators), **Learn** (lessons + quizzes), tied together by a **Home** dashboard.

Stack: `go_router` (navigation + deep links) · `flutter_riverpod` (state) · `drift` (one shared local SQLite database).

---

## 1. Get it running

```bash
flutter create --org com.yourname --project-name money_hub money_hub
# copy this starter's lib/, assets/ and pubspec.yaml over the generated ones
cd money_hub
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates app_database.g.dart
flutter run
```

**Saving data in the browser:** the web build needs `web/sqlite3.wasm` and `web/drift_worker.js`, matching your drift/sqlite3 versions. Download them with:

```powershell
powershell -ExecutionPolicy Bypass -File tool\setup_web_db.ps1
```

Re-run it after upgrading drift or sqlite3. Browser data is stored per address, so always use the same port (`--web-port 8080`).

Every route already has a placeholder screen with links, so you can click through the whole app on day one and replace screens one at a time.

---

## 2. Folder structure

Feature-first: each module owns its `data/` (repositories), `domain/` (pure logic, easy to unit-test) and `presentation/` (screens & widgets). Everything shared lives in `core/`.

```
lib/
├── main.dart                     # ProviderScope + runApp
├── app.dart                      # MaterialApp.router, themes
├── core/
│   ├── database/
│   │   ├── tables.dart           # ALL table definitions + enums
│   │   └── app_database.dart     # @DriftDatabase, migrations, seed data, cross-module queries
│   ├── router/
│   │   ├── routes.dart           # path constants, CalculatorId, Loc.* link builders
│   │   ├── app_router.dart       # GoRouter: guards, shell, every route
│   │   └── app_shell.dart        # bottom NavigationBar (5 tabs)
│   ├── state/app_state.dart      # onboarding + Pro flags the router listens to
│   ├── theme/app_theme.dart
│   ├── services/                 # notifications, purchases, remote config, link launcher
│   ├── utils/                    # money formatting (cents ↔ $), dates
│   └── widgets/                  # shared widgets (placeholder, money text, affiliate card…)
└── features/
    ├── onboarding/presentation/
    ├── paywall/presentation/
    ├── settings/presentation/
    ├── home/        data/ domain/ presentation/
    ├── budget/      data/ domain/ presentation/
    ├── goals/       data/ domain/ presentation/   # debts_repository.dart = pattern to copy
    ├── tools/       data/ domain/ presentation/   # calculator math goes in domain/
    └── learn/       data/ domain/ presentation/
assets/
├── lessons/*.json                # lesson content (ship new lessons with no schema change)
└── config/affiliate_offers.example.json   # shape for Firebase Remote Config
```

**Rule of thumb:** features may import `core/` and other features' `data/` providers, but screens never touch the database directly — always through a repository.

---

## 3. Route map

Five tabs inside a `StatefulShellRoute.indexedStack` (each tab keeps its own back stack). Full-screen routes sit outside the shell. 🔒 = Pro (redirects to `/paywall?from=…`, then back after purchase). ⬆ = opens above the tab bar.

| Path | Screen | Notes |
|---|---|---|
| `/onboarding` | OnboardingScreen | forced until onboarding is done |
| `/paywall?from=` | PaywallScreen | full-screen dialog, returns to `from` |
| `/settings` | SettingsScreen | |
| `/settings/backup` | BackupScreen | |
| `/settings/security` | SecurityScreen | biometric lock |
| **Tab 0 — Home** | | |
| `/home` | HomeScreen | dashboard cards deep-link into every tab |
| **Tab 1 — Budget** | | |
| `/budget?month=2026-10` | BudgetScreen | envelopes for a month |
| `/budget/category/:categoryId` | CategoryScreen | one envelope |
| `/budget/transactions` | TransactionsScreen | |
| `/budget/transactions/new?categoryId=&accountId=` | TransactionFormScreen ⬆ | prefill via query |
| `/budget/transactions/:txId` | TransactionFormScreen ⬆ | edit |
| `/budget/bills` | BillsScreen | bills + subscriptions |
| `/budget/bills/new` | BillFormScreen ⬆ | |
| `/budget/bills/:billId` | BillDetailScreen | |
| `/budget/accounts` | AccountsScreen | |
| `/budget/accounts/:accountId` | AccountDetailScreen | |
| **Tab 2 — Goals** | | |
| `/goals` | GoalsScreen | |
| `/goals/debts` | DebtsScreen | |
| `/goals/debts/new` | DebtFormScreen ⬆ | |
| `/goals/debts/plan` | DebtPlanScreen 🔒 | snowball vs avalanche timeline |
| `/goals/debts/:debtId` | DebtDetailScreen | |
| `/goals/net-worth` | NetWorthScreen 🔒 | |
| `/goals/net-worth/holdings/:accountId` | HoldingsScreen 🔒 | |
| **Tab 3 — Tools** | | |
| `/tools` | ToolsScreen | calculator list |
| `/tools/saved` | SavedCalculationsScreen 🔒 | |
| `/tools/:calculatorId?…prefill` | CalculatorScreen | ids: `compound-interest`, `dca-vs-lump-sum`, `fire`, `what-if`, `inflation`, `retirement-scenarios` 🔒 |
| **Tab 4 — Learn** | | |
| `/learn` | LearnScreen | |
| `/learn/:lessonId` | LessonScreen | text + embedded YouTube video |
| `/learn/:lessonId/quiz` | LessonQuizScreen ⬆ | |

**Linking between modules** — always use the builders in `routes.dart`:

```dart
context.go(Routes.bills);                                   // switch tab + open screen
context.push(Loc.debtDetail(3));                            // push within current tab
context.push(Loc.calculator(CalculatorId.compoundInterest,  // lesson → pre-filled calculator
    {'monthly': '200', 'rate': '7', 'years': '30'}));
```

**Ordering gotcha:** inside a route's `routes:` list, static segments (`new`, `plan`, `saved`) must come **before** `:id` segments or the param route swallows them.

### Deep links (YouTube descriptions, website, emails)

Same paths work from outside the app, e.g. `https://yourdomain.com/tools/fire?age=30&spend=40000`.

**Android** — `android/app/src/main/AndroidManifest.xml`, inside the main `<activity>`:
```xml
<meta-data android:name="flutter_deeplinking_enabled" android:value="true" />
<intent-filter android:autoVerify="true">
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="https" android:host="yourdomain.com" />
</intent-filter>
```
Host `/.well-known/assetlinks.json` on your domain.

**iOS** — add Associated Domains capability `applinks:yourdomain.com`, set `FlutterDeepLinkingEnabled` = YES in `Info.plist`, host `/.well-known/apple-app-site-association`.

---

## 4. Database schema (Drift / SQLite)

Conventions: money = **integer cents**; rates = **integer basis points** (19.99% → `1999`); enums stored as text; `createdAt`/`updatedAt` on mutable tables so cloud sync can be added later.

```
                         ┌──────────────┐
          ┌──────────────│   accounts   │──────────────┐
          │              └──────┬───────┘              │
          │ account_id          │ account_id           │ account_id (optional link)
 ┌────────▼───────┐   ┌─────────▼────────┐    ┌────────▼───────┐
 │  transactions  │   │ recurring_items  │    │     debts      │
 └──┬──────┬──────┘   │ (bills & subs)   │    └────────────────┘
    │      │          └─────────┬────────┘            ▲
    │      └── recurring_item_id┘                     │ debt_id
    │ category_id                                     │
 ┌──▼─────────┐   ┌─────────────────────┐    transactions.debt_id
 │ categories │◄──│ budget_allocations  │
 └──┬─────────┘   └─────────────────────┘
    │ group_id                                  holdings ──► accounts
 ┌──▼───────────────┐                           net_worth_snapshots
 │ category_groups  │                           debt_plans
 └──────────────────┘                           saved_calculations
                                                lesson_progress, activity_days
                                                app_settings
```

| Table | Module | Purpose | Key columns |
|---|---|---|---|
| `accounts` | shared | where money lives; assets & liabilities | `type` (cash…mortgage), `balance_cents`, `include_in_net_worth`, `include_in_budget` |
| `category_groups` | Budget | envelope groups ("Bills", "Everyday") | `name`, `sort_order` |
| `categories` | Budget | envelopes | `group_id`, `name`, `icon`, `color` |
| `budget_allocations` | Budget | amount assigned per envelope per month | `category_id`, `month` ("2026-10"), `assigned_cents` — unique(category, month) |
| `transactions` | Budget (+ all) | every money movement | `account_id`, `category_id?`, `transfer_account_id?`, `recurring_item_id?`, `debt_id?`, `type`, signed `amount_cents`, `date` |
| `recurring_items` | Budget | bills & subscriptions | `kind`, `amount_cents`, `frequency`, `next_due_date`, `trial_ends_at?`, `remind_days_before`, `cancel_url?` |
| `debts` | Goals | debts to pay off | `account_id?`, `starting/current_balance_cents`, `apr_basis_points`, `minimum_payment_cents`, `custom_order`, `is_paid_off` |
| `debt_plans` | Goals | active payoff strategy | `strategy` (snowball/avalanche/custom), `extra_monthly_cents` |
| `holdings` | Goals | positions inside investment accounts | `account_id`, `symbol`, `quantity`, `cost_basis_cents?`, `last_price_cents?` |
| `net_worth_snapshots` | Goals | history for the chart | `date` (unique), `assets_cents`, `liabilities_cents`, `net_worth_cents` |
| `saved_calculations` | Tools | saved "what if" scenarios | `calculator`, `inputs_json`, `result_summary`, `is_pinned_to_home` |
| `lesson_progress` | Learn | per-lesson progress (content is in JSON assets) | PK `lesson_id`, `completed_at?`, `best_quiz_score`, `attempts` |
| `activity_days` | Learn | streaks | PK `day` ("2026-10-16"), `xp_earned` |
| `app_settings` | core | key/value prefs | PK `key`, `value` |

**How modules share data**
- A credit card is one `accounts` row (type `creditCard`) → it shows in **Net Worth** as a liability *and* can be linked from a `debts` row in **Debt Payoff**.
- Paying a bill creates a `transactions` row with `recurring_item_id` set → **Budget** spending and **Bills** history both update.
- `DebtsRepository.recordPayment` updates the debt, the budget transaction and both account balances in **one DB transaction** — copy that pattern for any cross-module write.
- **Home** reads from `AppDatabase.currentNetWorth()`, `watchUpcomingBills()`, `watchTotalDebt()`.

**Migrations:** bump `schemaVersion` and add steps in `onUpgrade`. Run `dart run drift_dev schema dump` before each release to keep a schema history for migration tests.

---

## 4b. Budget tab (how the numbers work)

- **Income** transactions add to "ready to assign". **Assigning** money to an envelope (`budget_allocations`, per month) moves it out of "ready to assign".
- **Spending** in an envelope reduces what's available in it. Available = assigned − spent this month.
- Debt payments logged from Goals and spending without a category show as **Uncategorized**.
- **Mark as paid** on a bill logs an expense in the bill's category/account and moves the due date forward one period (Jan 31 → Feb 28).
- Every transaction change updates the account balance in the same database transaction; deleting a debt payment puts the amount back on the debt.
- Logic lives in `features/budget/domain/budget_math.dart` (tested in `test/budget_test.dart`).

## 5. Build order

1. **v1** — Home, Tools (calculators in `tools/domain/`), Learn. No sensitive data; fastest to ship.
2. **v1.1** — Debt payoff (`debts`, `debt_plans`).
3. **v1.2** — Budget + Bills (`accounts`, `categories`, `transactions`, `recurring_items`, notifications) and turn on RevenueCat Pro.
4. **v2** — Net worth + holdings, encrypted backup, optional bank sync.

## 6. Before you publish

- "Educational only — not financial advice" in onboarding, calculators and lessons.
- Affiliate disclosure next to every affiliate link (FTC).
- Privacy policy (required by both stores for finance apps); say clearly that data stays on-device.
- Persist `onboardingCompleteProvider` via `app_settings`, and drive `isProProvider` from RevenueCat — both are in-memory in this starter.
