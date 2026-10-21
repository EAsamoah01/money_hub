import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/gradient_header.dart';
import '../data/lesson_progress_repository.dart';
import '../data/lesson_repository.dart';
import '../domain/lesson.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(lessonsProvider);
    final progress = ref.watch(lessonProgressProvider).valueOrNull ?? const {};
    final streak = ref.watch(learningStreakProvider).valueOrNull ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: lessons.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load lessons.\n$e', textAlign: TextAlign.center)),
        data: (all) {
          if (all.isEmpty) {
            return const Center(child: Text('No lessons yet. Add JSON files to assets/lessons/.'));
          }
          final done = all.where((l) => progress[l.id]?.completed ?? false).length;

          // Group by track, keeping the sorted order.
          final tracks = <String, List<Lesson>>{};
          for (final l in all) {
            tracks.putIfAbsent(l.trackTitle, () => []).add(l);
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  _ProgressHeader(done: done, total: all.length, streak: streak),
                  for (final entry in tracks.entries) ...[
                    SectionTitle(entry.key),
                    for (final l in entry.value) _LessonTile(lesson: l, status: progress[l.id]),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.done, required this.total, required this.streak});
  final int done;
  final int total;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).colorScheme.onPrimary;
    return GradientHeader(
      margin: const EdgeInsets.only(bottom: 4),
      title: 'Learn money skills',
      subtitle: 'Short lessons, quick quizzes. Keep your streak going.',
      icon: Icons.school,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              minHeight: 8,
              color: fg,
              backgroundColor: fg.withValues(alpha: 0.25),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              HeaderStat(label: 'lessons done', value: '$done / $total', icon: Icons.check_circle_outline),
              HeaderStat(
                label: 'day streak',
                value: '$streak',
                icon: streak > 0 ? Icons.local_fire_department : Icons.local_fire_department_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson, required this.status});
  final Lesson lesson;
  final LessonStatus? status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final completed = status?.completed ?? false;
    final best = status?.bestScore;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: completed ? cs.primary : cs.surfaceContainerHighest,
          foregroundColor: completed ? cs.onPrimary : cs.onSurfaceVariant,
          child: Icon(completed ? Icons.check : (lesson.hasVideo ? Icons.play_arrow : Icons.menu_book)),
        ),
        title: Text(lesson.title),
        subtitle: Text([
          '${lesson.minutes} min',
          if (lesson.quiz.isNotEmpty) '${lesson.quiz.length}-question quiz',
          if (best != null) 'best $best%',
        ].join(' · ')),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(Loc.lesson(lesson.id)),
      ),
    );
  }
}
