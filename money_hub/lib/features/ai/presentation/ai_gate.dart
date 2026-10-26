import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/database/app_database.dart';
import '../../../core/router/routes.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/state/app_state.dart';

/// Whether the user has agreed to send data to the AI (Settings can revoke).
final aiConsentProvider = FutureProvider<bool>(
  (ref) async => await ref.watch(databaseProvider).getSetting(kAiConsentKey) == 'true',
);

Future<void> setAiConsent(WidgetRef ref, bool on) async {
  await ref.read(databaseProvider).setSetting(kAiConsentKey, '$on');
  ref.invalidate(aiConsentProvider);
}

/// Call before any AI request. Sends free users to the paywall and asks for
/// data-sharing consent the first time. Returns true when it's OK to go ahead.
Future<bool> ensureAiAllowed(BuildContext context, WidgetRef ref) async {
  if (!ref.read(isProProvider)) {
    final from = GoRouterState.of(context).uri.toString();
    context.push(Loc.paywall(from: from));
    return false;
  }
  if (await ref.read(aiConsentProvider.future)) return true;
  if (!context.mounted) return false;

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.auto_awesome),
      title: const Text('Use the AI money coach?'),
      content: const SingleChildScrollView(
        child: Text(
          'To answer you, ${AppConfig.appName} sends your question and a summary of this month\'s '
          'budget (envelope names and amounts, recent spending, bills and debts) to Claude, an AI by '
          'Anthropic, through our server.\n\n'
          'We don\'t store your questions or your data on our server. Bank account numbers are never sent.\n\n'
          'AI answers can be wrong. They are for education only, not financial advice.\n\n'
          'You can turn this off any time in Settings.',
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Not now')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('I agree')),
      ],
    ),
  );
  if (ok != true) return false;
  await setAiConsent(ref, true);
  return true;
}

/// Friendly message for an AI error, with a "Go Pro" action when relevant.
void showAiError(BuildContext context, Object error) {
  final e = error is AiException ? error : null;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(e?.message ?? 'Something went wrong. Try again.'),
    action: e?.kind == AiFailure.notPro
        ? SnackBarAction(label: 'Go Pro', onPressed: () => context.push(Routes.paywall))
        : null,
  ));
}

/// "Report this answer": lets the user flag harmful or wrong AI content
/// without leaving the app (a Google Play requirement for AI features).
Future<void> reportAiAnswer(
  BuildContext context,
  WidgetRef ref, {
  required String answer,
  String? question,
  AiMode mode = AiMode.coach,
}) async {
  final reason = await showDialog<String>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: const Text('Report this answer'),
      children: [
        for (final r in const ['Harmful or offensive', 'Wrong or misleading', 'Something else'])
          SimpleDialogOption(onPressed: () => Navigator.pop(ctx, r), child: Text(r)),
      ],
    ),
  );
  if (reason == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  final ok = await ref.read(aiServiceProvider).report(answer: answer, reason: reason, question: question, mode: mode);
  messenger.showSnackBar(SnackBar(
    content: Text(ok ? "Thanks. We'll review this answer." : "Couldn't send the report. Check your connection."),
  ));
}
