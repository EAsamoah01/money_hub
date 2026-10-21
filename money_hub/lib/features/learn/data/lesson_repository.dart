import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/lesson.dart';

/// Loads every assets/lessons/*.json file. Drop a new JSON file in that
/// folder (and restart the app) and it appears in the Learn tab.
class LessonRepository {
  LessonRepository(this._bundle);
  final AssetBundle _bundle;

  Future<List<Lesson>> loadAll() async {
    final manifest = await AssetManifest.loadFromAssetBundle(_bundle);
    final paths = manifest
        .listAssets()
        .where((p) => p.startsWith('assets/lessons/') && p.endsWith('.json'))
        .toList();

    final lessons = <Lesson>[];
    for (final path in paths) {
      try {
        final json = jsonDecode(await _bundle.loadString(path)) as Map<String, dynamic>;
        lessons.add(Lesson.fromJson(json));
      } catch (e) {
        // A typo in one lesson file shouldn't take down the whole tab.
        debugPrint('Skipping lesson $path: $e');
      }
    }
    lessons.sort(compareLessons);
    return lessons;
  }
}

final lessonRepositoryProvider = Provider<LessonRepository>((ref) => LessonRepository(rootBundle));

final lessonsProvider = FutureProvider<List<Lesson>>(
  (ref) => ref.watch(lessonRepositoryProvider).loadAll(),
);

final lessonProvider = FutureProvider.family<Lesson?, String>((ref, id) async {
  final all = await ref.watch(lessonsProvider.future);
  for (final l in all) {
    if (l.id == id) return l;
  }
  return null;
});
