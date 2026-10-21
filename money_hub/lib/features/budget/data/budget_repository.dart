import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/budget_math.dart';

// ───────────────────────── Shared helpers ─────────────────────────

/// Returns the first checking account, creating "Everyday account" if the
/// user has none yet. Used whenever money moves without a chosen account.
Future<int> ensureDefaultAccountIn(AppDatabase db) async {
  final existing = await (db.select(db.accounts)
        ..where((a) => a.type.equalsValue(AccountType.checking) & a.isArchived.equals(false))
        ..orderBy([(a) => OrderingTerm.asc(a.id)])
        ..limit(1))
      .getSingleOrNull();
  if (existing != null) return existing.id;
  return db.into(db.accounts).insert(AccountsCompanion.insert(
        name: 'Everyday account',
        type: AccountType.checking,
        includeInBudget: const Value(true),
      ));
}

/// Adds [deltaCents] to an account's balance (negative = money out).
Future<void> applyAccountDelta(AppDatabase db, int accountId, int deltaCents) => db.customUpdate(
      'UPDATE accounts SET balance_cents = balance_cents + ?, updated_at = ? WHERE id = ?',
      variables: [Variable.withInt(deltaCents), Variable.withDateTime(DateTime.now()), Variable.withInt(accountId)],
      updates: {db.accounts},
    );

// ───────────────────────── Repository ─────────────────────────

/// Categories ("envelopes"), monthly allocations, transactions and accounts.
/// Money is in cents; expenses are stored as negative amounts.
class BudgetRepository {
  BudgetRepository(this._db);
  final AppDatabase _db;

  // ── Categories ──

  Stream<List<CategoryGroup>> watchGroups() => (_db.select(_db.categoryGroups)
        ..where((g) => g.isHidden.equals(false))
        ..orderBy([(g) => OrderingTerm.asc(g.sortOrder), (g) => OrderingTerm.asc(g.id)]))
      .watch();

  Stream<List<Category>> watchCategories() => (_db.select(_db.categories)
        ..where((c) => c.isHidden.equals(false))
        ..orderBy([(c) => OrderingTerm.asc(c.sortOrder), (c) => OrderingTerm.asc(c.id)]))
      .watch();

  Future<int> addCategory({required int groupId, required String name}) async {
    final count = await (_db.select(_db.categories)..where((c) => c.groupId.equals(groupId))).get();
    return _db.into(_db.categories).insert(
          CategoriesCompanion.insert(groupId: groupId, name: name, sortOrder: Value(count.length)),
        );
  }

  Future<void> renameCategory(int id, String name) =>
      (_db.update(_db.categories)..where((c) => c.id.equals(id))).write(CategoriesCompanion(name: Value(name)));

  /// Deletes an envelope. Its transactions stay but become uncategorized.
  Future<void> deleteCategory(int id) => _db.transaction(() async {
        await (_db.update(_db.transactions)..where((t) => t.categoryId.equals(id)))
            .write(const TransactionsCompanion(categoryId: Value(null)));
        await (_db.update(_db.recurringItems)..where((r) => r.categoryId.equals(id)))
            .write(const RecurringItemsCompanion(categoryId: Value(null)));
        await (_db.delete(_db.budgetAllocations)..where((a) => a.categoryId.equals(id))).go();
        await (_db.delete(_db.categories)..where((c) => c.id.equals(id))).go();
      });

  // ── Allocations ──

  Stream<List<BudgetAllocation>> watchAllocations(String month) =>
      (_db.select(_db.budgetAllocations)..where((a) => a.month.equals(month))).watch();

  /// Sets (not adds) how much is assigned to an envelope for a month.
  Future<void> setAssigned({required int categoryId, required String month, required int cents}) =>
      _db.transaction(() async {
        final existing = await (_db.select(_db.budgetAllocations)
              ..where((a) => a.categoryId.equals(categoryId) & a.month.equals(month)))
            .getSingleOrNull();
        if (existing == null) {
          await _db.into(_db.budgetAllocations).insert(BudgetAllocationsCompanion.insert(
                categoryId: categoryId,
                month: month,
                assignedCents: Value(cents),
              ));
        } else {
          await (_db.update(_db.budgetAllocations)..where((a) => a.id.equals(existing.id)))
              .write(BudgetAllocationsCompanion(assignedCents: Value(cents)));
        }
      });

  /// Copies last month's assigned amounts into [month] (only where empty).
  Future<int> copyAssignmentsFromPreviousMonth(String month) => _db.transaction(() async {
        final prev = await (_db.select(_db.budgetAllocations)
              ..where((a) => a.month.equals(shiftMonth(month, -1))))
            .get();
        final current = await (_db.select(_db.budgetAllocations)..where((a) => a.month.equals(month))).get();
        final already = {for (final a in current) if (a.assignedCents != 0) a.categoryId};
        var copied = 0;
        for (final a in prev) {
          if (a.assignedCents == 0 || already.contains(a.categoryId)) continue;
          await setAssigned(categoryId: a.categoryId, month: month, cents: a.assignedCents);
          copied++;
        }
        return copied;
      });

  // ── Transactions ──

  Stream<List<MoneyTransaction>> watchMonthTransactions(String month) => (_db.select(_db.transactions)
        ..where((t) =>
            t.date.isBiggerOrEqualValue(monthStart(month)) & t.date.isSmallerThanValue(monthEnd(month)))
        ..orderBy([(t) => OrderingTerm.desc(t.date), (t) => OrderingTerm.desc(t.id)]))
      .watch();

  Stream<List<MoneyTransaction>> watchAccountTransactions(int accountId) => (_db.select(_db.transactions)
        ..where((t) => t.accountId.equals(accountId))
        ..orderBy([(t) => OrderingTerm.desc(t.date), (t) => OrderingTerm.desc(t.id)]))
      .watch();

  Future<MoneyTransaction?> getTransaction(int id) =>
      (_db.select(_db.transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Creates or updates a transaction and keeps the account balance in sync.
  Future<void> saveTransaction({
    int? id,
    required TransactionType type,
    required int amountCents, // always positive here
    required int accountId,
    int? categoryId,
    String? payee,
    String? note,
    required DateTime date,
  }) {
    final signed = type == TransactionType.income ? amountCents.abs() : -amountCents.abs();
    return _db.transaction(() async {
      if (id == null) {
        await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
              accountId: accountId,
              categoryId: Value(type == TransactionType.income ? null : categoryId),
              type: type,
              amountCents: signed,
              payee: Value(payee),
              note: Value(note),
              date: date,
            ));
      } else {
        final old = await (_db.select(_db.transactions)..where((t) => t.id.equals(id))).getSingle();
        await applyAccountDelta(_db, old.accountId, -old.amountCents); // undo old effect
        await (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(TransactionsCompanion(
          accountId: Value(accountId),
          categoryId: Value(type == TransactionType.income ? null : categoryId),
          type: Value(type),
          amountCents: Value(signed),
          payee: Value(payee),
          note: Value(note),
          date: Value(date),
          updatedAt: Value(DateTime.now()),
        ));
      }
      await applyAccountDelta(_db, accountId, signed);
    });
  }

  /// Deletes a transaction, reversing its effect on the account and, for a
  /// debt payment, putting the amount back on the debt.
  Future<void> deleteTransaction(int id) => _db.transaction(() async {
        final old = await (_db.select(_db.transactions)..where((t) => t.id.equals(id))).getSingleOrNull();
        if (old == null) return;
        await applyAccountDelta(_db, old.accountId, -old.amountCents);
        final debtId = old.debtId;
        if (debtId != null) {
          await _db.customUpdate(
            'UPDATE debts SET current_balance_cents = current_balance_cents + ?, '
            'is_paid_off = 0, paid_off_at = NULL, updated_at = ? WHERE id = ?',
            variables: [Variable.withInt(-old.amountCents), Variable.withDateTime(DateTime.now()), Variable.withInt(debtId)],
            updates: {_db.debts},
          );
        }
        await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
      });

  // ── Accounts ──

  Stream<List<Account>> watchAccounts() => (_db.select(_db.accounts)
        ..where((a) => a.isArchived.equals(false))
        ..orderBy([(a) => OrderingTerm.asc(a.sortOrder), (a) => OrderingTerm.asc(a.id)]))
      .watch();

  Stream<Account?> watchAccount(int id) =>
      (_db.select(_db.accounts)..where((a) => a.id.equals(id))).watchSingleOrNull();

  Future<int> ensureDefaultAccount() => ensureDefaultAccountIn(_db);

  Future<int> addAccount({required String name, required AccountType type, required int balanceCents}) =>
      _db.into(_db.accounts).insert(AccountsCompanion.insert(
            name: name,
            type: type,
            balanceCents: Value(balanceCents),
            includeInBudget: Value(!type.isLiability),
          ));

  Future<void> renameAccount(int id, String name) => (_db.update(_db.accounts)..where((a) => a.id.equals(id)))
      .write(AccountsCompanion(name: Value(name), updatedAt: Value(DateTime.now())));

  Future<void> archiveAccount(int id) => (_db.update(_db.accounts)..where((a) => a.id.equals(id)))
      .write(AccountsCompanion(isArchived: const Value(true), updatedAt: Value(DateTime.now())));
}

// ───────────────────────── Providers ─────────────────────────

final budgetRepositoryProvider = Provider((ref) => BudgetRepository(ref.watch(databaseProvider)));

final categoryGroupsProvider =
    StreamProvider<List<CategoryGroup>>((ref) => ref.watch(budgetRepositoryProvider).watchGroups());

final categoriesProvider =
    StreamProvider<List<Category>>((ref) => ref.watch(budgetRepositoryProvider).watchCategories());

final accountsProvider = StreamProvider<List<Account>>((ref) => ref.watch(budgetRepositoryProvider).watchAccounts());

final accountProvider =
    StreamProvider.family<Account?, int>((ref, id) => ref.watch(budgetRepositoryProvider).watchAccount(id));

final allocationsProvider = StreamProvider.family<List<BudgetAllocation>, String>(
  (ref, month) => ref.watch(budgetRepositoryProvider).watchAllocations(month),
);

final monthTransactionsProvider = StreamProvider.family<List<MoneyTransaction>, String>(
  (ref, month) => ref.watch(budgetRepositoryProvider).watchMonthTransactions(month),
);

final accountTransactionsProvider = StreamProvider.family<List<MoneyTransaction>, int>(
  (ref, id) => ref.watch(budgetRepositoryProvider).watchAccountTransactions(id),
);

/// Category id → name, for labelling transactions.
final categoryNamesProvider = Provider<Map<int, String>>((ref) {
  final cats = ref.watch(categoriesProvider).valueOrNull ?? const <Category>[];
  return {for (final c in cats) c.id: c.name};
});

final accountNamesProvider = Provider<Map<int, String>>((ref) {
  final accounts = ref.watch(accountsProvider).valueOrNull ?? const <Account>[];
  return {for (final a in accounts) a.id: a.name};
});

/// Envelope summary for one month; null while anything is still loading.
final budgetSummaryProvider = Provider.family<BudgetMonthSummary?, String>((ref, month) {
  final cats = ref.watch(categoriesProvider).valueOrNull;
  final allocs = ref.watch(allocationsProvider(month)).valueOrNull;
  final txs = ref.watch(monthTransactionsProvider(month)).valueOrNull;
  if (cats == null || allocs == null || txs == null) return null;
  return BudgetMonthSummary.compute(
    categories: [for (final c in cats) (id: c.id, groupId: c.groupId, name: c.name)],
    assignedByCategory: {for (final a in allocs) a.categoryId: a.assignedCents},
    transactions: [for (final t in txs) (categoryId: t.categoryId, type: t.type, amountCents: t.amountCents)],
  );
});
