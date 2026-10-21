import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../data/lesson_progress_repository.dart';
import '../data/lesson_repository.dart';
import '../domain/lesson.dart';
import '../domain/quiz_session.dart';

class LessonQuizScreen extends ConsumerWidget {
  const LessonQuizScreen({super.key, required this.lessonId});
  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(lessonProvider(lessonId)).when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('$e'))),
          data: (lesson) => lesson == null || lesson.quiz.isEmpty
              ? Scaffold(appBar: AppBar(), body: const Center(child: Text('No quiz for this lesson.')))
              : _Quiz(lesson: lesson),
        );
  }
}

class _Quiz extends ConsumerStatefulWidget {
  const _Quiz({required this.lesson});
  final Lesson lesson;

  @override
  ConsumerState<_Quiz> createState() => _QuizState();
}

class _QuizState extends ConsumerState<_Quiz> {
  late QuizSession _session = QuizSession(widget.lesson.quiz);
  bool _saved = false;

  void _next() {
    setState(_session.next);
    if (_session.finished && !_saved) {
      _saved = true;
      ref.read(lessonProgressRepositoryProvider).recordQuiz(
            widget.lesson.id,
            scorePct: _session.scorePct,
            passed: _session.passed,
            xp: _session.xp,
          );
    }
  }

  void _retry() => setState(() {
        _session = QuizSession(widget.lesson.quiz);
        _saved = false;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title, overflow: TextOverflow.ellipsis),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _session.finished ? _results(context) : _question(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _question(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final q = _session.current;
    final picked = _session.selected;
    final answered = picked != null;

    return ListView(
      children: [
        LinearProgressIndicator(value: (_session.index + (answered ? 1 : 0)) / _session.total),
        const SizedBox(height: 16),
        Text('Question ${_session.index + 1} of ${_session.total}', style: t.textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(q.question, style: t.textTheme.titleLarge),
        const SizedBox(height: 20),
        for (var i = 0; i < q.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OptionButton(
              text: q.options[i],
              state: !answered
                  ? _OptionState.idle
                  : i == q.answer
                      ? _OptionState.correct
                      : i == picked
                          ? _OptionState.wrong
                          : _OptionState.dimmed,
              onTap: answered ? null : () => setState(() => _session.answer(i)),
            ),
          ),
        if (answered) ...[
          const SizedBox(height: 6),
          Text(
            picked == q.answer ? 'Correct!' : 'Not quite.',
            style: t.textTheme.titleMedium?.copyWith(color: picked == q.answer ? Colors.green.shade700 : cs.error),
          ),
          if (q.why != null) ...[
            const SizedBox(height: 4),
            Text(q.why!, style: t.textTheme.bodyMedium),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _next,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: Text(_session.isLast ? 'See results' : 'Next question'),
          ),
        ],
      ],
    );
  }

  Widget _results(BuildContext context) {
    final t = Theme.of(context);
    final passed = _session.passed;

    return ListView(
      children: [
        const SizedBox(height: 24),
        Icon(passed ? Icons.emoji_events : Icons.refresh,
            size: 72, color: passed ? Colors.amber.shade700 : t.colorScheme.primary),
        const SizedBox(height: 12),
        Text('${_session.scorePct}%', textAlign: TextAlign.center, style: t.textTheme.displaySmall),
        Text(
          '${_session.correctCount} of ${_session.total} correct · +${_session.xp} XP',
          textAlign: TextAlign.center,
          style: t.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          passed
              ? 'Lesson complete. Nice work!'
              : 'You need ${QuizSession.passMarkPct}% to complete the lesson. Review it and try again.',
          textAlign: TextAlign.center,
          style: t.textTheme.bodyLarge,
        ),
        const SizedBox(height: 28),
        if (passed)
          FilledButton(
            onPressed: () => context.go(Routes.learn),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: const Text('Back to lessons'),
          )
        else ...[
          FilledButton(
            onPressed: _retry,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: const Text('Try again'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: const Text('Review the lesson'),
          ),
        ],
      ],
    );
  }
}

enum _OptionState { idle, correct, wrong, dimmed }

class _OptionButton extends StatelessWidget {
  const _OptionButton({required this.text, required this.state, required this.onTap});
  final String text;
  final _OptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (Color border, Color fill, IconData? icon) = switch (state) {
      _OptionState.idle => (cs.outline, Colors.transparent, null),
      _OptionState.correct => (Colors.green.shade600, Colors.green.withValues(alpha: 0.12), Icons.check_circle),
      _OptionState.wrong => (cs.error, cs.error.withValues(alpha: 0.10), Icons.cancel),
      _OptionState.dimmed => (cs.outlineVariant, Colors.transparent, null),
    };

    return Material(
      color: fill,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: border, width: state == _OptionState.idle ? 1 : 2),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
              if (icon != null) Icon(icon, color: border),
            ],
          ),
        ),
      ),
    );
  }
}
