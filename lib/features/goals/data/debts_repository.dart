import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';

/// Pattern to copy for every feature: screens talk to a repository,
/// the repository talks to the shared AppDatabase.
class DebtsRepository {
  DebtsRepository(this._db);
  final AppDatabase _db;

  Stream<List<Debt>> watchActive() => (_db.select(_db.debts)
        ..where((d) => d.isPaidOff.equals(false))
        ..orderBy([(d) => OrderingTerm.asc(d.currentBalanceCents)]))
      .watch();

  Future<int> add({
    required String name,
    required int balanceCents,
    required int aprBasisPoints,
    required int minimumPaymentCents,
    int? accountId,
    int? dueDayOfMonth,
  }) =>
      _db.into(_db.debts).insert(DebtsCompanion.insert(
            name: name,
            startingBalanceCents: balanceCents,
            currentBalanceCents: balanceCents,
            aprBasisPoints: aprBasisPoints,
            minimumPaymentCents: minimumPaymentCents,
            accountId: Value(accountId),
            dueDayOfMonth: Value(dueDayOfMonth),
          ));

  /// Records a payment in ONE database transaction so the debt, the linked
  /// account (Net Worth) and the Budget transaction log never disagree.
  Future<void> recordPayment({
    required int debtId,
    required int fromAccountId,
    required int amountCents,
    int? categoryId, // e.g. the "Extra Debt Payments" envelope
    DateTime? date,
  }) {
    return _db.transaction(() async {
      final debt = await (_db.select(_db.debts)..where((d) => d.id.equals(debtId))).getSingle();
      final newBalance = math.max(0, debt.currentBalanceCents - amountCents);

      await (_db.update(_db.debts)..where((d) => d.id.equals(debtId))).write(DebtsCompanion(
        currentBalanceCents: Value(newBalance),
        isPaidOff: Value(newBalance == 0),
        paidOffAt: Value(newBalance == 0 ? DateTime.now() : null),
        updatedAt: Value(DateTime.now()),
      ));

      await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
            accountId: fromAccountId,
            categoryId: Value(categoryId),
            transferAccountId: Value(debt.accountId),
            debtId: Value(debtId),
            type: debt.accountId != null ? TransactionType.transfer : TransactionType.expense,
            amountCents: -amountCents,
            payee: Value(debt.name),
            date: date ?? DateTime.now(),
          ));

      // Keep the liability account balance in sync (liabilities stored as negatives).
      if (debt.accountId != null) {
        await _db.customUpdate(
          'UPDATE accounts SET balance_cents = balance_cents + ?, updated_at = ? WHERE id = ?',
          variables: [
            Variable.withInt(amountCents),
            Variable.withDateTime(DateTime.now()),
            Variable.withInt(debt.accountId!),
          ],
          updates: {_db.accounts},
        );
      }
      await _db.customUpdate(
        'UPDATE accounts SET balance_cents = balance_cents - ?, updated_at = ? WHERE id = ?',
        variables: [
          Variable.withInt(amountCents),
          Variable.withDateTime(DateTime.now()),
          Variable.withInt(fromAccountId),
        ],
        updates: {_db.accounts},
      );
    });
  }
}

final debtsRepositoryProvider =
    Provider<DebtsRepository>((ref) => DebtsRepository(ref.watch(databaseProvider)));

final activeDebtsProvider =
    StreamProvider<List<Debt>>((ref) => ref.watch(debtsRepositoryProvider).watchActive());
