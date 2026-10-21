import 'lesson.dart';

/// State of one quiz attempt: one question at a time, answers lock once chosen.
class QuizSession {
  QuizSession(this.questions) : _answers = List<int?>.filled(questions.length, null);

  static const passMarkPct = 70;

  final List<QuizQuestion> questions;
  final List<int?> _answers;
  int _index = 0;
  bool _finished = false;

  int get index => _index;
  int get total => questions.length;
  QuizQuestion get current => questions[_index];
  bool get finished => _finished || questions.isEmpty;
  bool get isLast => _index >= questions.length - 1;

  /// Option the user picked for the current question, or null.
  int? get selected => questions.isEmpty ? null : _answers[_index];
  bool get answeredCurrent => selected != null;

  /// First answer counts; changing your mind isn't allowed.
  void answer(int option) {
    if (finished || _answers[_index] != null) return;
    if (option < 0 || option >= current.options.length) return;
    _answers[_index] = option;
  }

  void next() {
    if (!answeredCurrent) return;
    if (isLast) {
      _finished = true;
    } else {
      _index++;
    }
  }

  bool isCorrect(int questionIndex) => _answers[questionIndex] == questions[questionIndex].answer;

  int get correctCount => [for (var i = 0; i < questions.length; i++) if (isCorrect(i)) i].length;

  int get scorePct => questions.isEmpty ? 100 : (correctCount * 100 / questions.length).round();

  bool get passed => scorePct >= passMarkPct;

  /// XP for the streak/progress system: a pass is worth more than practice.
  int get xp => passed ? 10 + correctCount * 5 : correctCount * 2;
}
