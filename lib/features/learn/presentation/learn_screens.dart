import 'package:flutter/material.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/placeholder_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Learn',
        details: 'Lessons loaded from assets/lessons/*.json; progress from LessonProgress.',
        links: {
          'Compound interest basics': Loc.lesson('compound-interest-basics'),
          'Snowball vs avalanche': Loc.lesson('debt-snowball-vs-avalanche'),
        },
      );
}

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.lessonId});
  final String lessonId;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Lesson: $lessonId',
        details: 'Text + embedded YouTube video (youtube_player_iframe).',
        links: {
          'Take the quiz': Loc.lessonQuiz(lessonId),
          // Cross-module link: open a calculator pre-filled with the lesson example.
          'Try it: \$200/mo for 30 years at 7%': Loc.calculator(
            CalculatorId.compoundInterest,
            {'principal': '0', 'monthly': '200', 'rate': '7', 'years': '30'},
          ),
        },
      );
}

class LessonQuizScreen extends StatelessWidget {
  const LessonQuizScreen({super.key, required this.lessonId});
  final String lessonId;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(title: 'Quiz: $lessonId');
}
