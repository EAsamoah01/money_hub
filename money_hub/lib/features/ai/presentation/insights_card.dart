import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/router/routes.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/state/app_state.dart';
import '../../../core/widgets/gradient_header.dart';
import '../../budget/domain/budget_math.dart';
import '../data/ai_providers.dart';
import 'ai_gate.dart';

/// Home card: an AI check-in on this month, saved so it costs one request
/// until the user taps refresh. Free users see a Pro teaser.
class InsightsCard extends ConsumerStatefulWidget {
  const InsightsCard({super.key});

  @override
  ConsumerState<InsightsCard> createState() => _InsightsCardState();
}

class _InsightsCardState extends ConsumerState<InsightsCard> {
  bool _busy = false;

  Future<void> _generate() async {
    if (!await ensureAiAllowed(context, ref)) return;
    setState(() => _busy = true);
    final month = monthKey(DateTime.now());
    try {
      final text = await ref.read(aiServiceProvider).ask(
        mode: AiMode.insights,
        messages: const [AiMessage(fromUser: true, text: 'Write my monthly check-in.')],
        context: ref.read(moneyContextProvider),
      );
      await ref.read(databaseProvider).setSetting(insightsKey(month), text);
      ref.invalidate(savedInsightsProvider(month));
    } catch (e) {
      if (mounted) showAiError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final isPro = ref.watch(isProProvider);
    final saved = isPro ? ref.watch(savedInsightsProvider(monthKey(DateTime.now()))).valueOrNull : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const IconBubble(Icons.auto_awesome),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Your month, explained',
                      style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ),
                if (!isPro)
                  Chip(
                    label: const Text('Pro'),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: cs.primaryContainer,
                  )
                else if (saved != null) ...[
                  IconButton(
                    tooltip: 'Report this answer',
                    onPressed: () => reportAiAnswer(context, ref, answer: saved, mode: AiMode.insights),
                    icon: const Icon(Icons.flag_outlined),
                  ),
                  IconButton(
                    tooltip: 'Refresh',
                    onPressed: _busy ? null : _generate,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            if (_busy)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (saved != null)
              Text(saved, style: t.textTheme.bodyMedium?.copyWith(height: 1.4))
            else
              Text(
                'Get a quick AI check-in on where your money went, what\'s due soon and one thing to try.',
                style: t.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (saved == null)
                  FilledButton.icon(
                    onPressed: _busy ? null : _generate,
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: Text(isPro ? 'Get my insights' : 'Unlock with Pro'),
                  ),
                OutlinedButton.icon(
                  onPressed: () => context.push(Loc.coach()),
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Ask the coach'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
