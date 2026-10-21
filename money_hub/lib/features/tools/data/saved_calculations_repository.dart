import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/router/routes.dart';

/// A calculator result pinned to the Home dashboard.
class PinnedResult {
  const PinnedResult({
    required this.id,
    required this.calculator,
    required this.inputs,
    required this.summary,
    required this.createdAt,
  });
  final int id;
  final CalculatorId calculator;
  final Map<String, String> inputs;
  final String summary;
  final DateTime createdAt;

  /// Re-opens the calculator with the same inputs.
  String get location => Loc.calculator(calculator, inputs);
}

class SavedCalculationsRepository {
  SavedCalculationsRepository(this._db);
  final AppDatabase _db;

  Stream<List<PinnedResult>> watchPinned() => (_db.select(_db.savedCalculations)
        ..where((s) => s.isPinnedToHome.equals(true))
        ..orderBy([(s) => OrderingTerm.desc(s.createdAt)]))
      .watch()
      .map((rows) => [
            for (final r in rows)
              if (_toCalculatorId(r.calculator) case final calc?)
                PinnedResult(
                  id: r.id,
                  calculator: calc,
                  inputs: _decode(r.inputsJson),
                  summary: r.resultSummary ?? '',
                  createdAt: r.createdAt,
                ),
          ]);

  Future<void> pin({
    required CalculatorId calculator,
    required Map<String, String> inputs,
    required String summary,
  }) {
    final type = CalculatorType.values.asNameMap()[calculator.name];
    if (type == null) throw ArgumentError('${calculator.name} cannot be pinned');
    return _db.into(_db.savedCalculations).insert(SavedCalculationsCompanion.insert(
          calculator: type,
          title: calculator.title,
          inputsJson: jsonEncode(inputs),
          resultSummary: Value(summary),
          isPinnedToHome: const Value(true),
        ));
  }

  Future<void> unpin(int id) =>
      (_db.delete(_db.savedCalculations)..where((s) => s.id.equals(id))).go();

  static CalculatorId? _toCalculatorId(CalculatorType t) => CalculatorId.values.asNameMap()[t.name];

  static Map<String, String> _decode(String json) {
    try {
      final m = jsonDecode(json) as Map<String, dynamic>;
      return {for (final e in m.entries) e.key: '${e.value}'};
    } catch (_) {
      return const {};
    }
  }
}

final savedCalculationsRepositoryProvider =
    Provider((ref) => SavedCalculationsRepository(ref.watch(databaseProvider)));

final pinnedResultsProvider =
    StreamProvider<List<PinnedResult>>((ref) => ref.watch(savedCalculationsRepositoryProvider).watchPinned());
