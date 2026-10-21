import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tables.dart';

export 'tables.dart';

part 'app_database.g.dart'; // generated: dart run build_runner build

@DriftDatabase(tables: [
  // shared
  Accounts,
  AppSettings,
  // budget
  CategoryGroups,
  Categories,
  BudgetAllocations,
  Transactions,
  RecurringItems,
  // goals
  Debts,
  DebtPlans,
  Holdings,
  NetWorthSnapshots,
  // tools
  SavedCalculations,
  // learn
  LessonProgress,
  ActivityDays,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Bump this and add a step in [migration] whenever the schema changes.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaults();
        },
        onUpgrade: (m, from, to) async {
          // Example for later:
          // if (from < 2) await m.addColumn(debts, debts.someNewColumn);
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Native platforms store a SQLite file in the app's documents folder.
  /// Web runs SQLite compiled to WebAssembly and stores it in the browser
  /// (OPFS or IndexedDB). That needs web/sqlite3.wasm and
  /// web/drift_worker.js; run tool/setup_web_db.ps1 to download them.
  static QueryExecutor _openConnection() => driftDatabase(
        name: 'money_hub',
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      );

  /// Starter envelopes so the Budget tab isn't empty on first launch.
  Future<void> _seedDefaults() async {
    const seed = <String, List<String>>{
      'Bills': ['Rent / Mortgage', 'Utilities', 'Phone & Internet', 'Insurance'],
      'Everyday': ['Groceries', 'Transport', 'Dining Out', 'Personal'],
      'Goals': ['Emergency Fund', 'Investing', 'Extra Debt Payments'],
      'Subscriptions': ['Streaming', 'Software'],
    };

    var groupOrder = 0;
    for (final entry in seed.entries) {
      final groupId = await into(categoryGroups).insert(
        CategoryGroupsCompanion.insert(name: entry.key, sortOrder: Value(groupOrder++)),
      );
      var catOrder = 0;
      for (final name in entry.value) {
        await into(categories).insert(
          CategoriesCompanion.insert(groupId: groupId, name: name, sortOrder: Value(catOrder++)),
        );
      }
    }
  }

  // ─────────── Cross-module queries used by the Home dashboard ───────────

  /// Assets minus liabilities, from accounts flagged for net worth.
  Future<({int assets, int liabilities})> currentNetWorth() async {
    final rows = await (select(accounts)
          ..where((a) => a.includeInNetWorth.equals(true) & a.isArchived.equals(false)))
        .get();
    var assets = 0, liabilities = 0;
    for (final a in rows) {
      if (a.type.isLiability) {
        liabilities += a.balanceCents.abs();
      } else {
        assets += a.balanceCents;
      }
    }
    return (assets: assets, liabilities: liabilities);
  }

  /// Bills/subscriptions due in the next [days] days, soonest first.
  Stream<List<RecurringItem>> watchUpcomingBills({int days = 7}) {
    final until = DateTime.now().add(Duration(days: days));
    return (select(recurringItems)
          ..where((r) => r.isActive.equals(true) & r.nextDueDate.isSmallerOrEqualValue(until))
          ..orderBy([(r) => OrderingTerm.asc(r.nextDueDate)]))
        .watch();
  }

  /// Remaining balance across all unpaid debts.
  Stream<int> watchTotalDebt() {
    final sum = debts.currentBalanceCents.sum();
    final query = selectOnly(debts)
      ..addColumns([sum])
      ..where(debts.isPaidOff.equals(false));
    return query.map((row) => row.read(sum) ?? 0).watchSingle();
  }

  // ─────────── Settings helpers ───────────

  Future<String?> getSetting(String key) async =>
      (await (select(appSettings)..where((s) => s.key.equals(key))).getSingleOrNull())?.value;

  Future<void> setSetting(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(AppSettingsCompanion.insert(key: key, value: value));
}

/// Single database instance shared by every feature.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
