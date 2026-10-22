import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/ai_service.dart';
import '../../../core/state/app_state.dart';
import '../../learn/data/lesson_repository.dart';
import '../data/ai_providers.dart';
import '../domain/money_context.dart';
import 'ai_gate.dart';

const _suggestions = [
  'Where is my money going this month?',
  'Can I afford a \$300 weekend trip?',
  'Which debt should I pay off first?',
  'How do I start an emergency fund?',
];

/// Chat with the AI money coach.
///
/// Opened plain from Home (coach mode, knows your budget), or about a lesson
/// ([lessonId]) or calculator result ([topic]) to explain it (explain mode).
/// [ask] is sent automatically as the first question.
class CoachScreen extends ConsumerStatefulWidget {
  const CoachScreen({super.key, this.ask, this.lessonId, this.topic});
  final String? ask;
  final String? lessonId;
  final String? topic;

  @override
  ConsumerState<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends ConsumerState<CoachScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _messages = <AiMessage>[];
  bool _busy = false;
  bool _allowed = false;
  String? _error;

  bool get _explaining => widget.lessonId != null || widget.topic != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final ok = await ensureAiAllowed(context, ref);
    if (!mounted) return;
    if (!ok) {
      // Consent declined: close the chat. (Free users never get here; the
      // router sends them to the paywall instead.)
      if (ref.read(isProProvider) && context.canPop()) context.pop();
      return;
    }
    setState(() => _allowed = true);
    final ask = widget.ask?.trim();
    if (ask != null && ask.isNotEmpty) _send(ask);
  }

  Future<String> _context() async {
    if (widget.lessonId != null) {
      final lesson = await ref.read(lessonProvider(widget.lessonId!).future);
      return lesson == null ? '' : lessonContext(lesson);
    }
    if (widget.topic != null) return widget.topic!;
    return ref.read(moneyContextProvider);
  }

  Future<void> _send(String text) async {
    final q = text.trim();
    if (q.isEmpty || _busy) return;
    _input.clear();
    setState(() {
      _messages.add(AiMessage(fromUser: true, text: q));
      _busy = true;
      _error = null;
    });
    _scrollToEnd();
    try {
      final answer = await ref.read(aiServiceProvider).ask(
            mode: _explaining ? AiMode.explain : AiMode.coach,
            messages: List.of(_messages),
            context: await _context(),
          );
      if (!mounted) return;
      setState(() => _messages.add(AiMessage(fromUser: false, text: answer)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is AiException ? e.message : 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
      _scrollToEnd();
    }
  }

  void _retry() {
    final last = _messages.lastWhere((m) => m.fromUser, orElse: () => const AiMessage(fromUser: true, text: ''));
    if (last.text.isEmpty) return;
    setState(() => _messages.removeLast());
    _send(last.text);
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, color: cs.primary),
            const SizedBox(width: 8),
            Text(_explaining ? 'Explain it' : 'Money coach'),
          ],
        ),
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              tooltip: 'New chat',
              icon: const Icon(Icons.refresh),
              onPressed: _busy ? null : () => setState(() {
                _messages.clear();
                _error = null;
              }),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    children: [
                      if (_messages.isEmpty && !_explaining) _Welcome(enabled: _allowed && !_busy, onPick: _send),
                      for (final m in _messages) _Bubble(message: m),
                      if (_busy) const _Typing(),
                      if (_error != null)
                        Card(
                          color: cs.errorContainer,
                          child: ListTile(
                            leading: Icon(Icons.error_outline, color: cs.onErrorContainer),
                            title: Text(_error!, style: TextStyle(color: cs.onErrorContainer)),
                            trailing: TextButton(onPressed: _retry, child: const Text('Retry')),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _input,
                          enabled: _allowed,
                          minLines: 1,
                          maxLines: 5,
                          maxLength: 1000,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.send,
                          onSubmitted: _send,
                          decoration: InputDecoration(
                            hintText: _explaining ? 'Ask a follow-up…' : 'Ask about your money…',
                            counterText: '',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: 'Send',
                        onPressed: _allowed && !_busy ? () => _send(_input.text) : null,
                        icon: const Icon(Icons.arrow_upward),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    'AI can make mistakes. Education only, not financial advice.',
                    style: t.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.enabled, required this.onPick});
  final bool enabled;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: t.colorScheme.primaryContainer,
            child: Icon(Icons.auto_awesome, size: 36, color: t.colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 14),
          Text('Ask your money coach', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            'It can see this month\'s budget, bills and debts, so answers use your numbers.',
            textAlign: TextAlign.center,
            style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in _suggestions)
                ActionChip(label: Text(s), onPressed: enabled ? () => onPick(s) : null),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});
  final AiMessage message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mine = message.fromUser;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.85),
        child: GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: message.text));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied')));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: mine ? cs.primary : cs.surfaceContainerHigh,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(mine ? 18 : 4),
                bottomRight: Radius.circular(mine ? 4 : 18),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(color: mine ? cs.onPrimary : cs.onSurface, height: 1.35),
            ),
          ),
        ),
      ),
    );
  }
}

class _Typing extends StatelessWidget {
  const _Typing();

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 10),
              Text('Thinking…'),
            ],
          ),
        ),
      );
}
