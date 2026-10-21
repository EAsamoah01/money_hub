import 'package:flutter/material.dart';

/// Colored banner at the top of a tab, using the current module's colors.
class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.child,
    this.margin = const EdgeInsets.fromLTRB(16, 4, 16, 12),
  });

  final String title;
  final String? subtitle;
  final IconData? icon;

  /// Extra content under the title, e.g. stat pills.
  final Widget? child;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final fg = cs.onPrimary;

    return Container(
      margin: margin,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cs.primary, Color.lerp(cs.primary, cs.tertiary, 0.55)!],
        ),
        boxShadow: [
          BoxShadow(color: cs.primary.withValues(alpha: 0.25), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: t.textTheme.headlineSmall?.copyWith(color: fg, fontWeight: FontWeight.w800)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(subtitle!, style: t.textTheme.bodyMedium?.copyWith(color: fg.withValues(alpha: 0.88))),
                    ],
                  ],
                ),
              ),
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: fg.withValues(alpha: 0.16), shape: BoxShape.circle),
                  child: Icon(icon, color: fg, size: 28),
                ),
            ],
          ),
          if (child != null) ...[const SizedBox(height: 16), child!],
        ],
      ),
    );
  }
}

/// Small translucent stat chip for use inside a [GradientHeader].
class HeaderStat extends StatelessWidget {
  const HeaderStat({super.key, required this.label, required this.value, this.icon});
  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final fg = t.colorScheme.onPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: fg.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 18, color: fg), const SizedBox(width: 8)],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: t.textTheme.titleMedium?.copyWith(color: fg, fontWeight: FontWeight.w700)),
              Text(label, style: t.textTheme.labelSmall?.copyWith(color: fg.withValues(alpha: 0.85))),
            ],
          ),
        ],
      ),
    );
  }
}

/// Section title used on dashboard-style pages.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.action});
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
        child: Row(
          children: [
            Expanded(
              child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            ),
            if (action != null) action!,
          ],
        ),
      );
}

/// Round tinted icon used in list tiles.
class IconBubble extends StatelessWidget {
  const IconBubble(this.icon, {super.key, this.color, this.size = 40});
  final IconData icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: c.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: c, size: size * 0.55),
    );
  }
}
