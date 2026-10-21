// Shared schema for every module.
//
// Conventions
// - All money is stored as INTEGER minor units (cents) to avoid float errors.
// - Rates (APR, return %) are stored as INTEGER basis points (19.99% = 1999).
// - Every table has createdAt / updatedAt so you can add cloud sync later.
// - Enums are stored as text (textEnum) so reordering an enum never corrupts data.

import 'package:drift/drift.dart';

// ───────────────────────────── Enums ─────────────────────────────

enum AccountType {
  cash,
  checking,
  savings,
  brokerage,
  retirement,
  crypto,
  property,
  vehicle,
  otherAsset,
  creditCard,
  loan,
  mortgage,
  otherLiability;

  bool get isLiability =>
      this == creditCard || this == loan || this == mortgage || this == otherLiability;
}

enum TransactionType { expense, income, transfer }

enum RecurringKind { bill, subscription }

enum Frequency { weekly, biweekly, monthly, quarterly, yearly }

enum DebtStrategy { snowball, avalanche, custom }

enum CalculatorType { compoundInterest, dcaVsLumpSum, fire, whatIf, inflation, debtPayoff }

// ──────────────────────── Shared: Accounts ────────────────────────
// Used by Budget (where money lives), Net Worth (assets/liabilities)
// and Debts (a debt can point at its credit-card or loan account).

@DataClassName('Account')
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get type => textEnum<AccountType>()();
  TextColumn get currency => text().withLength(min: 3, max: 3).withDefault(const Constant('USD'))();
  IntColumn get balanceCents => integer().withDefault(const Constant(0))();
  BoolColumn get includeInNetWorth => boolean().withDefault(const Constant(true))();
  BoolColumn get includeInBudget => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ──────────────────────── Budget module ────────────────────────

@DataClassName('CategoryGroup')
class CategoryGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)(); // e.g. "Bills", "Everyday"
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();
}

/// A budget category = an "envelope".
@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().references(CategoryGroups, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  TextColumn get icon => text().nullable()();   // material icon name or emoji
  IntColumn get color => integer().nullable()(); // ARGB int
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();
}

/// How much was assigned to an envelope in a given month (zero-based budgeting).
@DataClassName('BudgetAllocation')
class BudgetAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  TextColumn get month => text().withLength(min: 7, max: 7)(); // "2026-10"
  IntColumn get assignedCents => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {categoryId, month},
      ];
}

@DataClassName('MoneyTransaction') // avoids clashing with drift's Transaction
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  /// For transfers: the other side of the transfer.
  IntColumn get transferAccountId =>
      integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  /// Set when this payment was generated from a bill or subscription.
  IntColumn get recurringItemId =>
      integer().nullable().references(RecurringItems, #id, onDelete: KeyAction.setNull)();
  /// Set when this payment was made toward a debt.
  IntColumn get debtId => integer().nullable().references(Debts, #id, onDelete: KeyAction.setNull)();
  TextColumn get type => textEnum<TransactionType>()();
  /// Signed: negative = money out of the account, positive = money in.
  IntColumn get amountCents => integer()();
  TextColumn get payee => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isCleared => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Bills and subscriptions (Bill & Subscription tracker).
@DataClassName('RecurringItem')
class RecurringItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get kind => textEnum<RecurringKind>()();
  IntColumn get amountCents => integer()();
  TextColumn get frequency => textEnum<Frequency>()();
  DateTimeColumn get nextDueDate => dateTime()();
  /// Free-trial end date — reminder fires before the first charge.
  DateTimeColumn get trialEndsAt => dateTime().nullable()();
  IntColumn get accountId =>
      integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  IntColumn get remindDaysBefore => integer().withDefault(const Constant(2))();
  BoolColumn get autoPay => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get cancelUrl => text().nullable()(); // link to the provider's cancel page
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ──────────────────────── Goals: Debt payoff ────────────────────────

@DataClassName('Debt')
class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  /// Optional link to the credit-card/loan account so balances stay in sync
  /// with Net Worth.
  IntColumn get accountId =>
      integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();
  IntColumn get startingBalanceCents => integer()();
  IntColumn get currentBalanceCents => integer()();
  IntColumn get aprBasisPoints => integer()(); // 19.99% → 1999
  IntColumn get minimumPaymentCents => integer()();
  IntColumn get dueDayOfMonth => integer().nullable()(); // 1–31
  /// Position when strategy == custom.
  IntColumn get customOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isPaidOff => boolean().withDefault(const Constant(false))();
  DateTimeColumn get paidOffAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// One row: the user's active payoff plan.
@DataClassName('DebtPlan')
class DebtPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get strategy => textEnum<DebtStrategy>()();
  /// Extra money per month on top of all minimum payments.
  IntColumn get extraMonthlyCents => integer().withDefault(const Constant(0))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ──────────────────────── Goals: Net worth ────────────────────────

/// Individual positions inside a brokerage/retirement/crypto account.
@DataClassName('Holding')
class Holdings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  TextColumn get symbol => text().withLength(min: 1, max: 20)(); // "VTI", "BTC"
  TextColumn get name => text().nullable()();
  RealColumn get quantity => real()(); // fractional shares / crypto
  IntColumn get costBasisCents => integer().nullable()();
  IntColumn get lastPriceCents => integer().nullable()();
  DateTimeColumn get lastPriceAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Daily (or on-change) snapshot powering the net-worth-over-time chart.
@DataClassName('NetWorthSnapshot')
class NetWorthSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().unique()();
  IntColumn get assetsCents => integer()();
  IntColumn get liabilitiesCents => integer()();
  IntColumn get netWorthCents => integer()();
}

// ──────────────────────── Tools: Calculators ────────────────────────

/// Saved "What if" scenarios the user wants to revisit or share.
@DataClassName('SavedCalculation')
class SavedCalculations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get calculator => textEnum<CalculatorType>()();
  TextColumn get title => text().withLength(min: 1, max: 80)();
  /// Raw inputs as JSON, e.g. {"principal":1000000,"monthly":50000,"rateBp":700,"years":30}
  TextColumn get inputsJson => text()();
  /// Cached headline result for list views, e.g. "$612,438 after 30 years".
  TextColumn get resultSummary => text().nullable()();
  BoolColumn get isPinnedToHome => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ──────────────────────── Learn module ────────────────────────
// Lesson CONTENT lives in assets/lessons/*.json (or remote JSON) so you can
// ship new lessons without a schema change. Only PROGRESS is stored here.

@DataClassName('LessonProgressEntry')
class LessonProgress extends Table {
  TextColumn get lessonId => text()(); // matches the id in the lesson JSON
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get bestQuizScore => integer().nullable()(); // 0–100
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {lessonId};
}

/// One row per day the user completed something — powers the streak.
@DataClassName('ActivityDay')
class ActivityDays extends Table {
  TextColumn get day => text().withLength(min: 10, max: 10)(); // "2026-10-16"
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {day};
}

// ──────────────────────── Core: settings ────────────────────────

/// Simple key/value store: onboarding done, currency, theme, last backup, etc.
/// (Pro entitlement should come from RevenueCat, not from here.)
@DataClassName('AppSetting')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
