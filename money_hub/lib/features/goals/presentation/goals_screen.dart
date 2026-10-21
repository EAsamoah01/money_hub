import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/routes.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/gradient_header.dart';
import '../data/debts_repository.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(debtSummaryProvider);
    final t = Theme.of(context);
    final freeDate = s?.debtFreeDate;

    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              GradientHeader(
                title: 'Your goals',
                subtitle: 'Pay off debt, then grow what you own.',
                icon: Icons.flag,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    HeaderStat(
                      label: 'debt left',
                      value: s == null ? '…' : fmtMoney(s.totalOwedCents / 100),
                      icon: Icons.trending_down,
                    ),
                    HeaderStat(
                      label: 'debt-free',
                      value: freeDate == null ? '—' : DateFormat.yMMM().format(freeDate),
                      icon: Icons.celebration_outlined,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _GoalCard(
                      icon: Icons.credit_card_off_outlined,
                      color: t.colorScheme.primary,
                      title: 'Debt payoff',
                      subtitle: s == null || !s.hasDebts
                          ? 'Add your debts to get a debt-free date'
                          : '${s.openCount} open · ${(s.progress * 100).round()}% paid off',
                      progress: s?.hasDebts == true ? s!.progress : null,
                      onTap: () => context.go(Routes.debts),
                    ),
                    _GoalCard(
                      icon: Icons.show_chart,
                      color: const Color(0xFF0E7490),
                      title: 'Net worth',
                      subtitle: 'Everything you own minus everything you owe',
                      badge: 'Pro · soon',
                      onTap: () => context.push(Routes.netWorth),
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

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.progress,
    this.badge,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final double? progress;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBubble(icon, color: color, size: 48),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(subtitle, style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(badge!, style: t.textTheme.labelSmall?.copyWith(color: color)),
                    )
                  else
                    const Icon(Icons.chevron_right),
                ],
              ),
              if (progress != null) ...[
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(value: progress, minHeight: 8, color: color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
