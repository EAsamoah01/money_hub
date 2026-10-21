// Building blocks shared by every calculator screen.

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/widgets/affiliate_slot.dart';
import '../../data/saved_calculations_repository.dart';

export '../../../../core/widgets/affiliate_slot.dart' show AffiliateSlot;

// ───────────────────────── Form state ─────────────────────────

/// Holds one TextEditingController per input. Initial values come from the
/// URL query (deep-link prefill) and fall back to [defaults].
class CalcFields {
  CalcFields(Map<String, String> prefill, Map<String, String> defaults, VoidCallback onChanged) {
    for (final e in defaults.entries) {
      _c[e.key] = TextEditingController(text: prefill[e.key] ?? e.value)..addListener(onChanged);
    }
  }

  final _c = <String, TextEditingController>{};

  TextEditingController operator [](String key) => _c[key]!;
  double number(String key) => parseNum(_c[key]!.text);
  int whole(String key) => parseNum(_c[key]!.text).round();

  /// Current inputs as a map — used for share links and saved scenarios.
  Map<String, String> get values => {for (final e in _c.entries) e.key: e.value.text.trim()};

  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
  }
}

class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.controller,
    required this.label,
    this.prefix,
    this.suffix,
    this.helper,
    this.allowDecimal = true,
  });

  final TextEditingController controller;
  final String label;
  final String? prefix;
  final String? suffix;
  final String? helper;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(allowDecimal ? r'[0-9.,]' : r'[0-9,]')),
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        suffixText: suffix,
        helperText: helper,
      ),
    );
  }
}

/// Lays out inputs two per row on wide screens, one per row on phones.
class FieldGrid extends StatelessWidget {
  const FieldGrid({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final twoCols = c.maxWidth >= 520;
      final w = twoCols ? (c.maxWidth - 12) / 2 : c.maxWidth;
      return Wrap(
        spacing: 12,
        runSpacing: 14,
        children: [for (final child in children) SizedBox(width: w, child: child)],
      );
    });
  }
}

// ───────────────────────── Page shell ─────────────────────────

class CalcScaffold extends StatelessWidget {
  const CalcScaffold({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      );
}

// ───────────────────────── Result ─────────────────────────

class ResultRow {
  const ResultRow(this.label, this.value);
  final String label;
  final String value;
}

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.headline,
    required this.caption,
    this.rows = const [],
    this.warning,
  });

  final String headline;
  final String caption;
  final List<ResultRow> rows;
  final String? warning;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    // Text colors below use onPrimaryContainer; remap it to white-on-gradient.
    final fg = cs.onPrimary;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cs.primary, Color.lerp(cs.primary, cs.tertiary, 0.55)!],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(caption, style: t.textTheme.labelLarge?.copyWith(color: fg)),
            const SizedBox(height: 4),
            Text(
              headline,
              style: t.textTheme.headlineMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (warning != null) ...[
              const SizedBox(height: 8),
              Text(warning!, style: t.textTheme.bodyMedium?.copyWith(color: const Color(0xFFFFE082), fontWeight: FontWeight.w600)),
            ],
            if (rows.isNotEmpty) const SizedBox(height: 12),
            for (final r in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(r.label,
                          style: t.textTheme.bodyMedium?.copyWith(color: fg)),
                    ),
                    Text(
                      r.value,
                      style: t.textTheme.bodyMedium?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Chart ─────────────────────────

class ChartLine {
  const ChartLine({required this.label, required this.spots, this.dashed = false});
  final String label;

  /// x = years from today, y = dollars.
  final List<FlSpot> spots;
  final bool dashed;
}

/// Multi-line money-over-time chart. x axis is in years.
class MoneyLineChart extends StatelessWidget {
  const MoneyLineChart({super.key, required this.lines, this.height = 240});
  final List<ChartLine> lines;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final palette = [cs.primary, cs.tertiary, cs.secondary, cs.error];
    final small = Theme.of(context).textTheme.bodySmall;

    final maxX = lines.expand((l) => l.spots).fold<double>(0, (m, s) => math.max(m, s.x));
    final xInterval = maxX <= 10 ? 1.0 : (maxX / 6).ceilToDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: height,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: maxX <= 0 ? 1 : maxX,
              minY: 0,
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    getTitlesWidget: (v, meta) => Text(fmtMoneyCompact(v), style: small),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 26,
                    interval: xInterval,
                    getTitlesWidget: (v, meta) => Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text('${v.round()}y', style: small),
                    ),
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touched) => [
                    for (final s in touched)
                      LineTooltipItem(
                        '${lines[s.barIndex].label}\n${fmtMoney(s.y)}',
                        const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                  ],
                ),
              ),
              lineBarsData: [
                for (var i = 0; i < lines.length; i++)
                  LineChartBarData(
                    spots: lines[i].spots,
                    color: palette[i % palette.length],
                    barWidth: 2.5,
                    isCurved: false,
                    dashArray: lines[i].dashed ? [6, 4] : null,
                    dotData: const FlDotData(show: false),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          runSpacing: 6,
          children: [
            for (var i = 0; i < lines.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 14, height: 3, color: palette[i % palette.length]),
                  const SizedBox(width: 6),
                  Text(lines[i].label, style: small),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

// ───────────────────────── Footer ─────────────────────────

/// Pin to Home, share, related lesson, affiliate slot and the disclaimer.
class CalcFooter extends ConsumerWidget {
  const CalcFooter({
    super.key,
    required this.shareText,
    this.lessonLabel,
    this.lessonLocation,
    this.affiliatePlacement,
    this.calculator,
    this.inputs,
    this.pinSummary,
  });

  final String shareText;
  final String? lessonLabel;
  final String? lessonLocation;

  /// Key into the affiliate_offers Remote Config map, e.g. "tools.fire.result".
  final String? affiliatePlacement;

  /// Set all three to show "Pin to Home".
  final CalculatorId? calculator;
  final Map<String, String>? inputs;

  /// One line shown on the Home card, e.g. "FIRE number \$1,000,000 · 19 yrs".
  final String? pinSummary;

  Future<void> _share(BuildContext context) async {
    if (kIsWeb) {
      // Desktop browsers rarely support the share sheet, so copy instead.
      await Clipboard.setData(ClipboardData(text: shareText));
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Result copied to clipboard')));
      }
    } else {
      await Share.share(shareText);
    }
  }

  Future<void> _pin(BuildContext context, WidgetRef ref) async {
    // Free plan: a few pins. Pro: unlimited.
    final pinnedCount = (ref.read(pinnedResultsProvider).valueOrNull ?? const []).length;
    if (!ref.read(isProProvider) && pinnedCount >= AppConfig.freePinLimit) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Free accounts can pin ${AppConfig.freePinLimit} results. Unpin one or go Pro.'),
        action: SnackBarAction(
          label: 'Go Pro',
          onPressed: () => context.push(Loc.paywall(from: GoRouterState.of(context).uri.toString())),
        ),
      ));
      return;
    }
    try {
      await ref.read(savedCalculationsRepositoryProvider).pin(
            calculator: calculator!,
            inputs: inputs!,
            summary: pinSummary!,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Pinned to Home'),
          action: SnackBarAction(label: 'View', onPressed: () => context.go(Routes.home)),
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not pin: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final small = Theme.of(context).textTheme.bodySmall;
    final canPin = calculator != null && inputs != null && pinSummary != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            if (canPin)
              FilledButton.icon(
                onPressed: () => _pin(context, ref),
                icon: const Icon(Icons.push_pin_outlined, size: 18),
                label: const Text('Pin to Home'),
              ),
            FilledButton.tonalIcon(
              onPressed: () => _share(context),
              icon: const Icon(Icons.ios_share, size: 18),
              label: const Text('Share result'),
            ),
            if (lessonLocation != null)
              OutlinedButton.icon(
                onPressed: () => context.push(lessonLocation!),
                icon: const Icon(Icons.school_outlined, size: 18),
                label: Text(lessonLabel ?? 'Related lesson'),
              ),
          ],
        ),
        if (affiliatePlacement != null) AffiliateSlot(placement: affiliatePlacement!),
        const SizedBox(height: 20),
        Text(
          'Educational estimate only, not financial advice. Assumes a constant return; '
          'real returns vary and can be negative.',
          style: small,
        ),
      ],
    );
  }
}
