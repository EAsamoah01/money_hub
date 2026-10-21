import 'dart:async';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/streak.dart';

class LessonStatus {
  const LessonStatus({this.completed = false, this.bestScore, this.attempts = 0});
  final bool completed;
  final int? bestScore;
  final int attempts;
}

abstract class LessonProgressRepository {
  Stream<Map<String, LessonStatus>> watchAll();
  Stream<int> watchStreak();
  Future<void> markStarted(String lessonId);
  Future<void> recordQuiz(String lessonId, {required int scorePct, required bool passed, required int xp});
}

// ───────────────────────── Drift (all platforms) ─────────────────────────

class DriftLessonProgressRepository implements LessonProgressRepository {
  DriftLessonProgressRepository(this._db);
  final AppDatabase _db;

  @override
  Stream<Map<String, LessonStatus>> watchAll() => _db.select(_db.lessonProgress).watch().map((rows) => {
        for (final r in rows)
          r.lessonId: LessonStatus(
            completed: r.completedAt != null,
            bestScore: r.bestQuizScore,
            attempts: r.attempts,
          ),
      });

  @override
  Stream<int> watchStreak() => _db
      .select(_db.activityDays)
      .watch()
      .map((rows) => computeStreak(rows.map((r) => r.day), DateTime.now()));

  @override
  Future<void> markStarted(String lessonId) => _db.into(_db.lessonProgress).insert(
        LessonProgressCompanion.insert(lessonId: lessonId),
        mode: InsertMode.insertOrIgnore,
      );

  @override
  Future<void> recordQuiz(String lessonId, {required int scorePct, required bool passed, required int xp}) {
    return _db.transaction(() async {
      final existing = await (_db.select(_db.lessonProgress)..where((p) => p.lessonId.equals(lessonId)))
          .getSingleOrNull();

      await _db.into(_db.lessonProgress).insertOnConflictUpdate(LessonProgressCompanion(
            lessonId: Value(lessonId),
            bestQuizScore: Value(math.max(existing?.bestQuizScore ?? 0, scorePct)),
            attempts: Value((existing?.attempts ?? 0) + 1),
            completedAt: Value(existing?.completedAt ?? (passed ? DateTime.now() : null)),
          ));

      final key = dayKey(DateTime.now());
      final today =
          await (_db.select(_db.activityDays)..where((d) => d.day.equals(key))).getSingleOrNull();
      await _db.into(_db.activityDays).insertOnConflictUpdate(ActivityDaysCompanion(
            day: Value(key),
            xpEarned: Value((today?.xpEarned ?? 0) + xp),
          ));
    });
  }
}

// ───────────────────────── In-memory (tests) ─────────────────────────
// Nothing is saved. Handy for widget tests or a quick demo without a database.

class MemoryLessonProgressRepository implements LessonProgressRepository {
  final _status = <String, LessonStatus>{};
  final _days = <String>{};
  final _changes = StreamController<void>.broadcast();

  @override
  Stream<Map<String, LessonStatus>> watchAll() async* {
    yield Map.of(_status);
    await for (final _ in _changes.stream) {
      yield Map.of(_status);
    }
  }

  @override
  Stream<int> watchStreak() async* {
    yield computeStreak(_days, DateTime.now());
    await for (final _ in _changes.stream) {
      yield computeStreak(_days, DateTime.now());
    }
  }

  @override
  Future<void> markStarted(String lessonId) async {
    _status.putIfAbsent(lessonId, () => const LessonStatus());
    _changes.add(null);
  }

  @override
  Future<void> recordQuiz(String lessonId, {required int scorePct, required bool passed, required int xp}) async {
    final old = _status[lessonId] ?? const LessonStatus();
    _status[lessonId] = LessonStatus(
      completed: old.completed || passed,
      bestScore: math.max(old.bestScore ?? 0, scorePct),
      attempts: old.attempts + 1,
    );
    _days.add(dayKey(DateTime.now()));
    _changes.add(null);
  }
}

// ───────────────────────── Providers ─────────────────────────

/// Drift on every platform, including web (see AppDatabase._openConnection).
/// Override with MemoryLessonProgressRepository in widget tests.
final lessonProgressRepositoryProvider = Provider<LessonProgressRepository>(
  (ref) => DriftLessonProgressRepository(ref.watch(databaseProvider)),
);

final lessonProgressProvider = StreamProvider<Map<String, LessonStatus>>(
  (ref) => ref.watch(lessonProgressRepositoryProvider).watchAll(),
);

final learningStreakProvider = StreamProvider<int>(
  (ref) => ref.watch(lessonProgressRepositoryProvider).watchStreak(),
);
