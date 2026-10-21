// Lesson content model. Lessons live as JSON files in assets/lessons/,
// so you can add a lesson without touching code or the database.
//
// Section types supported in "sections":
//   {"type": "text",           "body": "..."}
//   {"type": "callout",        "body": "..."}                 // highlighted tip
//   {"type": "bullets",        "items": ["...", "..."]}
//   {"type": "calculatorLink", "label": "...", "calculator": "fire",
//                              "prefill": {"spend": "40000"}}
// Unknown types are skipped, so older app versions don't break on new content.

sealed class LessonSection {
  const LessonSection();

  static LessonSection? fromJson(Map<String, dynamic> j) {
    switch (j['type']) {
      case 'text':
        return TextSection('${j['body'] ?? ''}');
      case 'callout':
        return CalloutSection('${j['body'] ?? ''}');
      case 'bullets':
        return BulletsSection([for (final i in (j['items'] as List? ?? const [])) '$i']);
      case 'calculatorLink':
        final prefill = (j['prefill'] as Map?) ?? const {};
        return CalculatorLinkSection(
          label: '${j['label'] ?? 'Open calculator'}',
          calculator: '${j['calculator'] ?? ''}',
          prefill: {for (final e in prefill.entries) '${e.key}': '${e.value}'},
        );
      default:
        return null;
    }
  }
}

class TextSection extends LessonSection {
  const TextSection(this.body);
  final String body;
}

class CalloutSection extends LessonSection {
  const CalloutSection(this.body);
  final String body;
}

class BulletsSection extends LessonSection {
  const BulletsSection(this.items);
  final List<String> items;
}

class CalculatorLinkSection extends LessonSection {
  const CalculatorLinkSection({required this.label, required this.calculator, required this.prefill});
  final String label;

  /// Calculator slug, e.g. "compound-interest" (see CalculatorId).
  final String calculator;
  final Map<String, String> prefill;
}

class QuizQuestion {
  const QuizQuestion({required this.question, required this.options, required this.answer, this.why});
  final String question;
  final List<String> options;

  /// Index into [options].
  final int answer;

  /// Optional explanation shown after answering.
  final String? why;

  factory QuizQuestion.fromJson(Map<String, dynamic> j) => QuizQuestion(
        question: '${j['q'] ?? ''}',
        options: [for (final o in (j['options'] as List? ?? const [])) '$o'],
        answer: (j['answer'] as num?)?.toInt() ?? 0,
        why: j['why'] as String?,
      );
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.track,
    required this.trackTitle,
    required this.trackOrder,
    required this.order,
    required this.minutes,
    required this.sections,
    required this.quiz,
    this.youtubeId,
    this.disclaimer,
  });

  final String id;
  final String title;
  final String track;
  final String trackTitle;
  final int trackOrder;
  final int order;
  final int minutes;
  final String? youtubeId;
  final List<LessonSection> sections;
  final List<QuizQuestion> quiz;
  final String? disclaimer;

  /// False while the JSON still has the "REPLACE_WITH_…" placeholder.
  bool get hasVideo {
    final id = youtubeId?.trim() ?? '';
    return id.isNotEmpty && !id.startsWith('REPLACE');
  }

  factory Lesson.fromJson(Map<String, dynamic> j) {
    final track = '${j['track'] ?? 'general'}';
    return Lesson(
      id: '${j['id']}',
      title: '${j['title'] ?? j['id']}',
      track: track,
      trackTitle: (j['trackTitle'] as String?) ?? _titleCase(track),
      trackOrder: (j['trackOrder'] as num?)?.toInt() ?? 99,
      order: (j['order'] as num?)?.toInt() ?? 99,
      minutes: (j['minutes'] as num?)?.toInt() ?? 3,
      youtubeId: j['youtubeId'] as String?,
      sections: [
        for (final s in (j['sections'] as List? ?? const []))
          if (s is Map<String, dynamic>) LessonSection.fromJson(s),
      ].whereType<LessonSection>().toList(),
      quiz: [
        for (final q in (j['quiz'] as List? ?? const []))
          if (q is Map<String, dynamic>) QuizQuestion.fromJson(q),
      ],
      disclaimer: j['disclaimer'] as String?,
    );
  }

  static String _titleCase(String slug) => slug
      .split(RegExp(r'[-_]'))
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

/// Sort by track, then by order inside the track.
int compareLessons(Lesson a, Lesson b) {
  final t = a.trackOrder.compareTo(b.trackOrder);
  if (t != 0) return t;
  final tt = a.track.compareTo(b.track);
  if (tt != 0) return tt;
  return a.order.compareTo(b.order);
}
