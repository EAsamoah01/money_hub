import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Temporary screen used while each feature is being built.
/// Shows the screen name plus optional links so you can click through the
/// whole route map on day one.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    this.details,
    this.links = const {},
    this.pushLinks = true,
  });

  final String title;
  final String? details;

  /// label → location
  final Map<String, String> links;

  /// true = push (keeps back button); false = go (replace stack).
  final bool pushLinks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (details != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(details!, style: Theme.of(context).textTheme.bodyMedium),
            ),
          for (final e in links.entries)
            Card(
              child: ListTile(
                title: Text(e.key),
                subtitle: Text(e.value),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => pushLinks ? context.push(e.value) : context.go(e.value),
              ),
            ),
        ],
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
