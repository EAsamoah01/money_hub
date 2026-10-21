import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/placeholder_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'Saved (Pro)',
            onPressed: () => context.push(Routes.savedCalculations),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final c in CalculatorId.values)
            Card(
              child: ListTile(
                title: Text(c.title),
                subtitle: Text(Loc.calculator(c)),
                trailing: c.isPro ? const Chip(label: Text('Pro')) : const Icon(Icons.chevron_right),
                onTap: () => context.push(Loc.calculator(c)),
              ),
            ),
        ],
      ),
    );
  }
}

/// One screen hosts every calculator; the body switches on [calculator].
/// [prefill] comes from query params, so links from lessons, YouTube
/// descriptions or the website open with inputs already filled in.
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key, required this.calculator, this.prefill = const {}});
  final CalculatorId calculator;
  final Map<String, String> prefill;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: calculator.title,
        details: 'Prefill: ${prefill.isEmpty ? '(none)' : prefill}\n\n'
            'Below the result: "Share result" card, related lesson, and the affiliate CTA '
            '(loaded from Remote Config).',
      );
}

class SavedCalculationsScreen extends StatelessWidget {
  const SavedCalculationsScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Saved scenarios');
}
