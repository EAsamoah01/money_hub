import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/budget_math.dart';
import 'budget_repository.dart';

/// Bills and subscriptions (the recurring_items table).
class BillsRepository {
  BillsRepository(this._db);
  final AppDatabase _db;

  /// Active first, soonest due first.
  Stream<List<RecurringItem>> watchAll() => (_db.select(_db.recurringItems)
        ..orderBy([
          (r) => OrderingTerm.desc(r.isActive),
          (r) => OrderingTerm.asc(r.nextDueDate),
        ]))
      .watch();

  Stream<RecurringItem?> watchBill(int id) =>
      (_db.select(_db.recurringItems)..where((r) => r.id.equals(id))).watchSingleOrNull();

  Stream<List<MoneyTransaction>> watchPayments(int billId) => (_db.select(_db.transactions)
        ..where((t) => t.recurringItemId.equals(billId))
        ..orderBy([(t) => OrderingTerm.desc(t.date)]))
      .watch();

  Future<int> save({
    int? id,
    required String name,
    required RecurringKind kind,
    required int amountCents,
    required Frequency frequency,
    required DateTime nextDueDate,
    DateTime? trialEndsAt,
    int? categoryId,
    int? accountId,
    required int remindDaysBefore,
    required bool autoPay,
    String? cancelUrl,
  }) async {
    final companion = RecurringItemsCompanion(
      name: Value(name),
      kind: Value(kind),
      amountCents: Value(amountCents),
      frequency: Value(frequency),
      nextDueDate: Value(nextDueDate),
      trialEndsAt: Value(trialEndsAt),
      categoryId: Value(categoryId),
      accountId: Value(accountId),
      remindDaysBefore: Value(remindDaysBefore),
      autoPay: Value(autoPay),
      cancelUrl: Value(cancelUrl),
      updatedAt: Value(DateTime.now()),
    );
    if (id == null) return _db.into(_db.recurringItems).insert(companion);
    await (_db.update(_db.recurringItems)..where((r) => r.id.equals(id))).write(companion);
    return id;
  }

  Future<void> setActive(int id, bool active) => (_db.update(_db.recurringItems)..where((r) => r.id.equals(id)))
      .write(RecurringItemsCompanion(isActive: Value(active), updatedAt: Value(DateTime.now())));

  /// Deletes the bill. Past payments stay in your transactions.
  Future<void> remove(int id) => _db.transaction(() async {
        await (_db.update(_db.transactions)..where((t) => t.recurringItemId.equals(id)))
            .write(const TransactionsCompanion(recurringItemId: Value(null)));
        await (_db.delete(_db.recurringItems)..where((r) => r.id.equals(id))).go();
      });

  /// Logs the payment as an expense (in the bill's category and account)
  /// and moves the due date forward one period.
  Future<void> markPaid(RecurringItem bill, {int? amountCents, DateTime? paidOn}) => _db.transaction(() async {
        final accountId = bill.accountId ?? await ensureDefaultAccountIn(_db);
        final cents = amountCents ?? bill.amountCents;
        final when = paidOn ?? DateTime.now();

        await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
              accountId: accountId,
              categoryId: Value(bill.categoryId),
              recurringItemId: Value(bill.id),
              type: TransactionType.expense,
              amountCents: -cents,
              payee: Value(bill.name),
              note: Value(bill.kind == RecurringKind.subscription ? 'Subscription' : 'Bill payment'),
              date: when,
            ));
        await applyAccountDelta(_db, accountId, -cents);

        await (_db.update(_db.recurringItems)..where((r) => r.id.equals(bill.id))).write(RecurringItemsCompanion(
          nextDueDate: Value(nextDueDate(bill.nextDueDate, bill.frequency)),
          trialEndsAt: const Value(null), // once you've paid, the trial is over
          updatedAt: Value(DateTime.now()),
        ));
      });
}

final billsRepositoryProvider = Provider((ref) => BillsRepository(ref.watch(databaseProvider)));

final billsProvider = StreamProvider<List<RecurringItem>>((ref) => ref.watch(billsRepositoryProvider).watchAll());

final billProvider =
    StreamProvider.family<RecurringItem?, int>((ref, id) => ref.watch(billsRepositoryProvider).watchBill(id));

final billPaymentsProvider = StreamProvider.family<List<MoneyTransaction>, int>(
  (ref, id) => ref.watch(billsRepositoryProvider).watchPayments(id),
);

final recurringTotalsProvider = Provider<RecurringTotals?>((ref) {
  final bills = ref.watch(billsProvider).valueOrNull;
  if (bills == null) return null;
  return recurringTotals([
    for (final b in bills) (amountCents: b.amountCents, frequency: b.frequency, kind: b.kind, active: b.isActive),
  ]);
});

/// The soonest active bill, for the Home dashboard.
final nextBillProvider = Provider<RecurringItem?>((ref) {
  final bills = ref.watch(billsProvider).valueOrNull ?? const <RecurringItem>[];
  RecurringItem? next;
  for (final b in bills) {
    if (!b.isActive) continue;
    if (next == null || b.nextDueDate.isBefore(next.nextDueDate)) next = b;
  }
  return next;
});
