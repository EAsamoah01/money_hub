import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'gradient_header.dart';

/// Temporary screen used while each feature is being built. Uses the
/// current tab's colors, and lists links so every route can be clicked.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    this.details,
    this.links = const {},
    this.pushLinks = true,
    this.icon = Icons.construction_outlined,
  });

  final String title;
  final String? details;

  /// label → location
  final Map<String, String> links;

  /// true = push (keeps back button); false = go (replace stack).
  final bool pushLinks;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              GradientHeader(
                title: title,
                subtitle: details ?? 'Coming soon',
                icon: icon,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (final e in links.entries)
                      Card(
                        child: ListTile(
                          leading: const IconBubble(Icons.arrow_forward),
                          title: Text(e.key),
                          subtitle: Text(e.value, style: TextStyle(color: cs.onSurfaceVariant)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => pushLinks ? context.push(e.value) : context.go(e.value),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.location});
  final String location;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Not found')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('No page at $location'),
              const SizedBox(height: 12),
              FilledButton(onPressed: () => context.go('/home'), child: const Text('Go home')),
            ],
          ),
        ),
      );
}
