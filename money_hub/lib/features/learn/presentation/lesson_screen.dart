import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/affiliate_slot.dart';
import '../data/lesson_progress_repository.dart';
import '../data/lesson_repository.dart';
import '../domain/lesson.dart';
import 'widgets/lesson_video.dart';

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key, required this.lessonId});
  final String lessonId;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  @override
  void initState() {
    super.initState();
    // Record that the lesson was opened (no-op if already started).
    Future.microtask(() => ref.read(lessonProgressRepositoryProvider).markStarted(widget.lessonId));
  }

  @override
  Widget build(BuildContext context) {
    final lessonAsync = ref.watch(lessonProvider(widget.lessonId));
    final status = ref.watch(lessonProgressProvider).valueOrNull?[widget.lessonId];

    return lessonAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('$e'))),
      data: (lesson) {
        if (lesson == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Lesson not found')),
            body: Center(child: Text('No lesson with id "${widget.lessonId}".')),
          );
        }
        return _LessonBody(lesson: lesson, status: status);
      },
    );
  }
}

class _LessonBody extends StatelessWidget {
  const _LessonBody({required this.lesson, required this.status});
  final Lesson lesson;
  final LessonStatus? status;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final completed = status?.completed ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.trackTitle),
        actions: [
          IconButton(
            tooltip: 'Explain this lesson (AI)',
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => context.push(Loc.coach(
              lessonId: lesson.id,
              ask: 'Explain this lesson more simply, with an everyday example.',
            )),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                Text(lesson.title, style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  [
                    '${lesson.minutes} min read',
                    if (completed) 'Completed ✓',
                    if (status?.bestScore != null) 'Best quiz score ${status!.bestScore}%',
                  ].join(' · '),
                  style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                if (lesson.hasVideo) ...[
                  LessonVideo(videoId: lesson.youtubeId!.trim()),
                  const SizedBox(height: 8),
                ],
                for (final s in lesson.sections) _Section(section: s),
                // Partner offer for this lesson, if the offers file has one
                // (e.g. learn.index-funds-101). Shows nothing otherwise.
                AffiliateSlot(placement: 'learn.${lesson.id}'),
                const SizedBox(height: 24),
                if (lesson.quiz.isNotEmpty)
                  FilledButton.icon(
                    onPressed: () => context.push(Loc.lessonQuiz(lesson.id)),
                    icon: const Icon(Icons.quiz_outlined),
                    label: Text(completed
                        ? 'Retake the quiz'
                        : 'Take the quiz (${lesson.quiz.length} questions)'),
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  ),
                if (lesson.disclaimer != null) ...[
                  const SizedBox(height: 20),
                  Text(lesson.disclaimer!, style: t.textTheme.bodySmall),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.section});
  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final bodyStyle = t.textTheme.bodyLarge?.copyWith(height: 1.5);

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: switch (section) {
        TextSection(:final body) => Text(body, style: bodyStyle),
        CalloutSection(body: final text) => Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: t.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: t.colorScheme.onSecondaryContainer),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(text, style: bodyStyle?.copyWith(color: t.colorScheme.onSecondaryContainer)),
                ),
              ],
            ),
          ),
        BulletsSection(:final items) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('•  ', style: bodyStyle),
                      Expanded(child: Text(item, style: bodyStyle)),
                    ],
                  ),
                ),
            ],
          ),
        CalculatorLinkSection(:final label, :final calculator, :final prefill) =>
          _CalculatorLink(label: label, slug: calculator, prefill: prefill),
      },
    );
  }
}

class _CalculatorLink extends StatelessWidget {
  const _CalculatorLink({required this.label, required this.slug, required this.prefill});
  final String label;
  final String slug;
  final Map<String, String> prefill;

  @override
  Widget build(BuildContext context) {
    final calc = CalculatorId.fromSlug(slug);
    if (calc == null) return const SizedBox.shrink(); // unknown slug in the JSON
    return OutlinedButton.icon(
      onPressed: () => context.push(Loc.calculator(calc, prefill)),
      icon: const Icon(Icons.calculate_outlined),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
