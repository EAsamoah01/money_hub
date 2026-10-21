// Run with:  flutter test

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:money_hub/features/learn/domain/lesson.dart';
import 'package:money_hub/features/learn/domain/quiz_session.dart';
import 'package:money_hub/features/learn/domain/streak.dart';

const _sample = '''
{
  "id": "x", "title": "Sample", "track": "money-basics", "order": 2, "minutes": 5,
  "youtubeId": "REPLACE_WITH_YOUR_VIDEO_ID",
  "sections": [
    {"type": "text", "body": "Hello"},
    {"type": "bullets", "items": ["a", "b"]},
    {"type": "calculatorLink", "label": "Go", "calculator": "fire", "prefill": {"spend": 40000}},
    {"type": "somethingNew", "body": "ignored"}
  ],
  "quiz": [
    {"q": "Q1", "options": ["a", "b"], "answer": 1},
    {"q": "Q2", "options": ["a", "b", "c"], "answer": 0, "why": "because"}
  ]
}
''';

void main() {
  group('Lesson.fromJson', () {
    final lesson = Lesson.fromJson(jsonDecode(_sample) as Map<String, dynamic>);

    test('parses known sections and skips unknown ones', () {
      expect(lesson.sections.length, 3);
      expect(lesson.sections[0], isA<TextSection>());
      expect(lesson.sections[1], isA<BulletsSection>());
      final link = lesson.sections[2] as CalculatorLinkSection;
      expect(link.calculator, 'fire');
      expect(link.prefill, {'spend': '40000'}); // numbers become strings
    });

    test('fills defaults', () {
      expect(lesson.trackTitle, 'Money Basics');
      expect(lesson.trackOrder, 99);
      expect(lesson.hasVideo, isFalse); // placeholder id
      expect(lesson.quiz[1].why, 'because');
    });

    test('every bundled lesson file parses', () {
      final files = Directory('assets/lessons').listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
      expect(files, isNotEmpty);
      for (final f in files) {
        final l = Lesson.fromJson(jsonDecode(f.readAsStringSync()) as Map<String, dynamic>);
        expect(l.sections, isNotEmpty, reason: f.path);
        for (final q in l.quiz) {
          expect(q.answer, inInclusiveRange(0, q.options.length - 1), reason: '${f.path}: ${q.question}');
        }
      }
    });
  });

  group('QuizSession', () {
    const qs = [
      QuizQuestion(question: 'a', options: ['x', 'y'], answer: 0),
      QuizQuestion(question: 'b', options: ['x', 'y'], answer: 1),
      QuizQuestion(question: 'c', options: ['x', 'y'], answer: 1),
    ];

    test('all correct passes', () {
      final s = QuizSession(qs);
      for (final q in qs) {
        s.answer(q.answer);
        s.next();
      }
      expect(s.finished, isTrue);
      expect(s.scorePct, 100);
      expect(s.passed, isTrue);
      expect(s.xp, 25);
    });

    test('first answer locks; 1 of 3 fails', () {
      final s = QuizSession(qs);
      s.answer(0);
      s.answer(1); // ignored
      expect(s.selected, 0);
      s.next();
      s.answer(0);
      s.next();
      s.answer(0);
      s.next();
      expect(s.correctCount, 1);
      expect(s.scorePct, 33);
      expect(s.passed, isFalse);
    });

    test("can't skip a question without answering", () {
      final s = QuizSession(qs);
      s.next();
      expect(s.index, 0);
    });
  });

  group('computeStreak', () {
    final today = DateTime(2026, 10, 18);

    test('counts consecutive days ending today', () {
      expect(computeStreak(['2026-10-16', '2026-10-17', '2026-10-18'], today), 3);
    });

    test('still counts if last activity was yesterday', () {
      expect(computeStreak(['2026-10-16', '2026-10-17'], today), 2);
    });

    test('a gap resets it', () {
      expect(computeStreak(['2026-10-15', '2026-10-18'], today), 1);
      expect(computeStreak(['2026-10-15'], today), 0);
    });

    test('works across month boundaries', () {
      expect(computeStreak(['2026-09-30', '2026-10-01'], DateTime(2026, 10, 1)), 2);
    });
  });
}
