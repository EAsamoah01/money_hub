import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/debt_payoff.dart';

/// Pattern to copy for every feature: screens talk to a repository,
/// the repository talks to the shared AppDatabase.
/// All money is stored in cents and APR in basis points (19.99% → 1999).
class DebtsRepository {
  DebtsRepository(this._db);
  final AppDatabase _db;

  // ───────────── Reads ─────────────

  /// Open debts first (smallest balance on top), then paid-off ones.
  Stream<List<Debt>> watchAll() => (_db.select(_db.debts)
        ..orderBy([
          (d) => OrderingTerm.asc(d.isPaidOff),
          (d) => OrderingTerm.asc(d.currentBalanceCents),
        ]))
      .watch();

  Stream<Debt?> watchDebt(int id) =>
      (_db.select(_db.debts)..where((d) => d.id.equals(id))).watchSingleOrNull();

  /// Payments made toward one debt, newest first.
  Stream<List<MoneyTransaction>> watchPayments(int debtId) => (_db.select(_db.transactions)
        ..where((t) => t.debtId.equals(debtId))
        ..orderBy([(t) => OrderingTerm.desc(t.date)]))
      .watch();

  Stream<DebtPlan?> watchPlan() => (_db.select(_db.debtPlans)..limit(1)).watchSingleOrNull();

  // ───────────── Writes ─────────────

  Future<int> add({
    required String name,
    required int balanceCents,
    required int aprBasisPoints,
    required int minimumPaymentCents,
    int? dueDayOfMonth,
  }) =>
      _db.into(_db.debts).insert(DebtsCompanion.insert(
            name: name,
            startingBalanceCents: balanceCents,
            currentBalanceCents: balanceCents,
            aprBasisPoints: aprBasisPoints,
            minimumPaymentCents: minimumPaymentCents,
            dueDayOfMonth: Value(dueDayOfMonth),
          ));

  Future<void> edit(
    int id, {
    required String name,
    required int balanceCents,
    required int aprBasisPoints,
    required int minimumPaymentCents,
    int? dueDayOfMonth,
  }) async {
    final old = await (_db.select(_db.debts)..where((d) => d.id.equals(id))).getSingle();
    await (_db.update(_db.debts)..where((d) => d.id.equals(id))).write(DebtsCompanion(
      name: Value(name),
      currentBalanceCents: Value(balanceCents),
      // If the balance went up (new charges), raise the starting point too so
      // progress never shows more than 100%.
      startingBalanceCents: Value(math.max(old.startingBalanceCents, balanceCents)),
      aprBasisPoints: Value(aprBasisPoints),
      minimumPaymentCents: Value(minimumPaymentCents),
      dueDayOfMonth: Value(dueDayOfMonth),
      isPaidOff: Value(balanceCents <= 0),
      paidOffAt: Value(balanceCents <= 0 ? (old.paidOffAt ?? DateTime.now()) : null),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Deletes the debt. Its payment history stays in transactions (debtId is
  /// set to null by the foreign key).
  Future<void> remove(int id) => (_db.delete(_db.debts)..where((d) => d.id.equals(id))).go();

  /// Records a payment in ONE database transaction so the debt, the
  /// account it came from and the transaction log never disagree.
  /// [fromAccountId] defaults to an "Everyday account", created on first use
  /// (the Budget tab will let users pick real accounts later).
  Future<void> recordPayment({
    required int debtId,
    required int amountCents,
    int? fromAccountId,
    DateTime? date,
  }) {
    return _db.transaction(() async {
      final debt = await (_db.select(_db.debts)..where((d) => d.id.equals(debtId))).getSingle();
      final accountId = fromAccountId ?? await _defaultAccountId();
      final paid = math.min(amountCents, debt.currentBalanceCents);
      final newBalance = debt.currentBalanceCents - paid;
      final now = DateTime.now();

      await (_db.update(_db.debts)..where((d) => d.id.equals(debtId))).write(DebtsCompanion(
        currentBalanceCents: Value(newBalance),
        isPaidOff: Value(newBalance <= 0),
        paidOffAt: Value(newBalance <= 0 ? now : null),
        updatedAt: Value(now),
      ));

      await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
            accountId: accountId,
            debtId: Value(debtId),
            type: TransactionType.expense,
            amountCents: -paid,
            payee: Value(debt.name),
            note: const Value('Debt payment'),
            date: date ?? now,
          ));

      await _db.customUpdate(
        'UPDATE accounts SET balance_cents = balance_cents - ?, updated_at = ? WHERE id = ?',
        variables: [Variable.withInt(paid), Variable.withDateTime(now), Variable.withInt(accountId)],
        updates: {_db.accounts},
      );
    });
  }

  Future<int> _defaultAccountId() async {
    final existing = await (_db.select(_db.accounts)
          ..where((a) => a.type.equalsValue(AccountType.checking) & a.isArchived.equals(false))
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) return existing.id;
    return _db.into(_db.accounts).insert(AccountsCompanion.insert(
          name: 'Everyday account',
          type: AccountType.checking,
          includeInBudget: const Value(true),
        ));
  }

  Future<void> savePlan({required DebtStrategy strategy, required int extraMonthlyCents}) async {
    final existing = await (_db.select(_db.debtPlans)..limit(1)).getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.debtPlans).insert(DebtPlansCompanion.insert(
            strategy: strategy,
            startDate: DateTime.now(),
            extraMonthlyCents: Value(extraMonthlyCents),
          ));
    } else {
      await (_db.update(_db.debtPlans)..where((p) => p.id.equals(existing.id))).write(DebtPlansCompanion(
        strategy: Value(strategy),
        extraMonthlyCents: Value(extraMonthlyCents),
        updatedAt: Value(DateTime.now()),
      ));
    }
  }
}

// ───────────── Summary used by Goals and Home ─────────────

class DebtSummary {
  const DebtSummary({
    required this.openCount,
    required this.totalOwedCents,
    required this.totalStartCents,
    required this.payoff,
    required this.strategy,
    required this.extraMonthlyCents,
  });

  final int openCount;
  final int totalOwedCents;
  final int totalStartCents;

  /// Simulation of the saved plan (or avalanche with no extra if none saved).
  final DebtPayoffResult? payoff;
  final PayoffStrategy strategy;
  final int extraMonthlyCents;

  bool get hasDebts => totalStartCents > 0;
  int get paidCents => math.max(0, totalStartCents - totalOwedCents);
  double get progress => totalStartCents == 0 ? 0 : paidCents / totalStartCents;

  DateTime? get debtFreeDate {
    final p = payoff;
    if (p == null || !p.paysOff) return null;
    final now = DateTime.now();
    return DateTime(now.year, now.month + p.months);
  }

  static PayoffStrategy strategyOf(DebtPlan? plan) =>
      plan?.strategy == DebtStrategy.snowball ? PayoffStrategy.snowball : PayoffStrategy.avalanche;

  factory DebtSummary.from(List<Debt> debts, DebtPlan? plan) {
    final open = debts.where((d) => !d.isPaidOff && d.currentBalanceCents > 0).toList();
    final strategy = strategyOf(plan);
    final extra = plan?.extraMonthlyCents ?? 0;
    return DebtSummary(
      openCount: open.length,
      totalOwedCents: open.fold(0, (s, d) => s + d.currentBalanceCents),
      totalStartCents: debts.fold(0, (s, d) => s + d.startingBalanceCents),
      strategy: strategy,
      extraMonthlyCents: extra,
      payoff: open.isEmpty
          ? null
          : simulatePayoff(
              [for (final d in open) toDebtInput(d)],
              strategy: strategy,
              extraMonthly: extra / 100,
            ),
    );
  }
}

DebtInput toDebtInput(Debt d) => DebtInput(
      name: d.name,
      balance: d.currentBalanceCents / 100,
      aprPct: d.aprBasisPoints / 100,
      minPayment: d.minimumPaymentCents / 100,
    );

// ───────────── Providers ─────────────

final debtsRepositoryProvider =
    Provider<DebtsRepository>((ref) => DebtsRepository(ref.watch(databaseProvider)));

final allDebtsProvider = StreamProvider<List<Debt>>((ref) => ref.watch(debtsRepositoryProvider).watchAll());

/// Kept for code that only wants unpaid debts.
final activeDebtsProvider = Provider<AsyncValue<List<Debt>>>(
  (ref) => ref.watch(allDebtsProvider).whenData((all) => all.where((d) => !d.isPaidOff).toList()),
);

final debtPlanProvider = StreamProvider<DebtPlan?>((ref) => ref.watch(debtsRepositoryProvider).watchPlan());

final debtProvider = StreamProvider.family<Debt?, int>((ref, id) => ref.watch(debtsRepositoryProvider).watchDebt(id));

final debtPaymentsProvider = StreamProvider.family<List<MoneyTransaction>, int>(
  (ref, id) => ref.watch(debtsRepositoryProvider).watchPayments(id),
);

/// null while loading.
final debtSummaryProvider = Provider<DebtSummary?>((ref) {
  final debts = ref.watch(allDebtsProvider).valueOrNull;
  final plan = ref.watch(debtPlanProvider);
  if (debts == null || plan.isLoading) return null;
  return DebtSummary.from(debts, plan.valueOrNull);
});
