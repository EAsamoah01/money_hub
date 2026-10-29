import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/offers_service.dart';
import 'gradient_header.dart';

/// Shows the partner offer configured for [placement], with the affiliate
/// disclosure right next to it (required by the FTC in the US).
/// Renders nothing if there's no offer, so placements are safe to sprinkle.
class AffiliateSlot extends ConsumerWidget {
  const AffiliateSlot({super.key, required this.placement, this.margin = const EdgeInsets.only(top: 16)});
  final String placement;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(offersProvider).valueOrNull;
    final offer = config?.forPlacement(placement);
    if (config == null || offer == null) return const SizedBox.shrink();

    final t = Theme.of(context);
    final cs = t.colorScheme;

    return Padding(
      padding: margin,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => launchUrl(offer.trackedUri, mode: LaunchMode.externalApplication),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: cs.outline),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Partner offer', style: t.textTheme.labelSmall),
                    ),
                    if (offer.partner.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(offer.partner, style: t.textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                    if (kDebugMode && offer.isPlaceholder) ...[
                      const Spacer(),
                      Text('placeholder link', style: t.textTheme.labelSmall?.copyWith(color: cs.error)),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IconBubble(Icons.local_offer_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(offer.title, style: t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                          if (offer.body != null) ...[
                            const SizedBox(height: 2),
                            Text(offer.body!, style: t.textTheme.bodySmall),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonalIcon(
                    onPressed: () => launchUrl(offer.trackedUri, mode: LaunchMode.externalApplication),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text(offer.cta ?? 'Learn more'),
                  ),
                ),
                const SizedBox(height: 6),
                Text(config.disclosure, style: t.textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
