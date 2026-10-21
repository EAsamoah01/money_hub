import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/gradient_header.dart';
import '../../budget/data/bills_repository.dart';
import '../../budget/data/budget_repository.dart';
import '../../budget/domain/budget_math.dart';
import '../../goals/data/debts_repository.dart';
import '../../learn/data/lesson_progress_repository.dart';
import '../../learn/data/lesson_repository.dart';
import '../../learn/domain/lesson.dart';
import '../../tools/data/saved_calculations_repository.dart';
import '../../tools/presentation/tools_screens.dart' show calculatorColors, calculatorIcon;

/// Dashboard: one card per module, each in that module's color, each
/// opening the matching tab.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static String _greeting(DateTime now) {
    if (now.hour < 12) return 'Good morning';
    if (now.hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final lessons = ref.watch(lessonsProvider).valueOrNull ?? const <Lesson>[];
    final progress = ref.watch(lessonProgressProvider).valueOrNull ?? const <String, LessonStatus>{};
    final streak = ref.watch(learningStreakProvider).valueOrNull ?? 0;
    final debt = ref.watch(debtSummaryProvider);
    final done = lessons.where((l) => progress[l.id]?.completed ?? false).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Hub'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              GradientHeader(
                title: _greeting(now),
                subtitle: DateFormat('EEEE, MMMM d').format(now),
                icon: Icons.savings_outlined,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    HeaderStat(
                      label: 'day streak',
                      value: '$streak',
                      icon: streak > 0 ? Icons.local_fire_department : Icons.local_fire_department_outlined,
                    ),
                    HeaderStat(label: 'lessons done', value: '$done/${lessons.length}', icon: Icons.school_outlined),
                    if (debt != null && debt.hasDebts)
                      HeaderStat(
                        label: 'debt left',
                        value: fmtMoney(debt.totalOwedCents / 100),
                        icon: Icons.trending_down,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Budget ──
                    SectionTitle(
                      DateFormat.MMMM().format(now),
                      action: TextButton(onPressed: () => context.go(Routes.budget), child: const Text('Budget')),
                    ),
                    const ModuleTheme(module: AppModule.budget, child: _BudgetCard()),

                    // ── Learn ──
                    SectionTitle(
                      'Keep learning',
                      action: TextButton(onPressed: () => context.go(Routes.learn), child: const Text('All lessons')),
                    ),
                    ModuleTheme(
                      module: AppModule.learn,
                      child: _NextLessonCard(lessons: lessons, progress: progress),
                    ),

                    // ── Debt ──
                    SectionTitle(
                      'Debt payoff',
                      action: TextButton(onPressed: () => context.go(Routes.debts), child: const Text('View debts')),
                    ),
                    ModuleTheme(module: AppModule.goals, child: _DebtCard(summary: debt)),

                    // ── Pinned results ──
                    SectionTitle(
                      'Pinned results',
                      action: TextButton(onPressed: () => context.go(Routes.tools), child: const Text('Tools')),
                    ),
                    const ModuleTheme(module: AppModule.tools, child: _PinnedResults()),

                    // ── Quick tools ──
                    const SectionTitle('Quick tools'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final c in CalculatorId.values.where((c) => !c.isPro))
                          ActionChip(
                            avatar: Icon(calculatorIcon(c), color: calculatorColors[c], size: 18),
                            label: Text(c.title),
                            onPressed: () => context.go(Loc.calculator(c)),
                          ),
                      ],
                    ),

                    // ── Coming soon ──
                    const SectionTitle('Coming soon'),
                    const ModuleTheme(
                      module: AppModule.goals,
                      child: _SoonTile(
                        icon: Icons.show_chart,
                        title: 'Net worth tracker',
                        subtitle: 'Everything you own minus everything you owe, over time',
                        location: Routes.netWorth,
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

// ───────────────────────── Budget ─────────────────────────

class _BudgetCard extends ConsumerWidget {
  const _BudgetCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final now = DateTime.now();
    final s = ref.watch(budgetSummaryProvider(monthKey(now)));
    final bill = ref.watch(nextBillProvider);

    if (s == null) return const Card(child: ListTile(title: Text('Loading…')));

    final Widget top;
    if (s.incomeCents == 0 && s.assignedCents == 0) {
      top = Row(
        children: [
          const IconBubble(Icons.account_balance_wallet_outlined, size: 48),
          const SizedBox(width: 14),
          const Expanded(child: Text('Add this month\'s income and give every dollar a job.')),
          const SizedBox(width: 8),
          FilledButton.tonal(
            onPressed: () => context.go(Loc.transactionNew(income: true)),
            child: const Text('Add income'),
          ),
        ],
      );
    } else {
      final left = s.leftToSpendCents;
      final used = s.assignedCents <= 0 ? 0.0 : (s.categorizedSpentCents / s.assignedCents).clamp(0.0, 1.0).toDouble();
      top = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBubble(Icons.account_balance_wallet, size: 48),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fmtMoney(left / 100),
                        style: t.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: left < 0 ? cs.error : null,
                        )),
                    Text(
                      s.overspentCount > 0
                          ? 'left to spend · ${s.overspentCount} envelope${s.overspentCount == 1 ? '' : 's'} overspent'
                          : 'left to spend this month',
                      style: t.textTheme.bodyMedium?.copyWith(color: s.overspentCount > 0 ? cs.error : cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (s.toBudgetCents != 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: (s.toBudgetCents > 0 ? cs.primary : cs.error).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    s.toBudgetCents > 0
                        ? '${fmtMoney(s.toBudgetCents / 100)} to assign'
                        : '${fmtMoney(-s.toBudgetCents / 100)} over',
                    style: t.textTheme.labelMedium?.copyWith(
                      color: s.toBudgetCents > 0 ? cs.primary : cs.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: used, minHeight: 8, backgroundColor: cs.surfaceContainerHighest),
          ),
          const SizedBox(height: 6),
          Text(
            'Spent ${fmtMoney(s.spentCents / 100)} of ${fmtMoney(s.incomeCents / 100)} income',
            style: t.textTheme.bodySmall,
          ),
        ],
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(Routes.budget),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              top,
              if (bill != null) ...[
                const Divider(height: 24),
                InkWell(
                  onTap: () => context.go(Loc.billDetail(bill.id)),
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long_outlined, color: cs.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: 'Next bill: '),
                          TextSpan(text: bill.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                          TextSpan(text: ' · ${fmtMoney(bill.amountCents / 100, cents: true)}'),
                        ])),
                      ),
                      Text(
                        dueLabel(bill.nextDueDate, now),
                        style: t.textTheme.labelMedium?.copyWith(
                          color: daysUntil(bill.nextDueDate, now) < 0 ? cs.error : cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Next lesson ─────────────────────────

class _NextLessonCard extends StatelessWidget {
  const _NextLessonCard({required this.lessons, required this.progress});
  final List<Lesson> lessons;
  final Map<String, LessonStatus> progress;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    if (lessons.isEmpty) {
      return const Card(child: ListTile(title: Text('Loading lessons…')));
    }

    Lesson? next;
    for (final l in lessons) {
      if (!(progress[l.id]?.completed ?? false)) {
        next = l;
        break;
      }
    }

    if (next == null) {
      return Card(
        color: cs.primaryContainer,
        child: ListTile(
          leading: const Text('🎉', style: TextStyle(fontSize: 28)),
          title: Text('All ${lessons.length} lessons complete', style: TextStyle(color: cs.onPrimaryContainer)),
          subtitle: Text('New lessons are on the way.', style: TextStyle(color: cs.onPrimaryContainer)),
        ),
      );
    }

    final lesson = next;
    final started = progress.containsKey(lesson.id);
    return Card(
      color: cs.primaryContainer,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(Loc.lesson(lesson.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(14)),
                child: Icon(lesson.hasVideo ? Icons.play_arrow_rounded : Icons.menu_book_rounded,
                    color: cs.onPrimary, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      started ? 'Continue' : 'Up next',
                      style: t.textTheme.labelMedium?.copyWith(color: cs.onPrimaryContainer.withValues(alpha: 0.8)),
                    ),
                    Text(
                      lesson.title,
                      style: t.textTheme.titleMedium?.copyWith(color: cs.onPrimaryContainer, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${lesson.trackTitle} · ${lesson.minutes} min',
                      style: t.textTheme.bodySmall?.copyWith(color: cs.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: cs.onPrimaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Debt ─────────────────────────

class _DebtCard extends StatelessWidget {
  const _DebtCard({required this.summary});
  final DebtSummary? summary;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final s = summary;

    if (s == null) return const Card(child: ListTile(title: Text('Loading…')));

    if (!s.hasDebts) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const IconBubble(Icons.credit_card_off_outlined, size: 48),
              const SizedBox(width: 14),
              const Expanded(child: Text('Add your debts to see your debt-free date and the fastest way to get there.')),
              const SizedBox(width: 8),
              FilledButton.tonal(onPressed: () => context.go(Routes.debtNew), child: const Text('Add')),
            ],
          ),
        ),
      );
    }

    final free = s.debtFreeDate;
    final payoff = s.payoff;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(Routes.debts),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const IconBubble(Icons.trending_down, size: 48),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fmtMoney(s.totalOwedCents / 100),
                            style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                        Text(
                          s.openCount == 0
                              ? 'All paid off!'
                              : free != null
                                  ? 'Debt-free by ${DateFormat.yMMMM().format(free)}'
                                  : (payoff != null && !payoff.paysOff)
                                      ? "Payments don't cover the interest"
                                      : '${s.openCount} debts',
                          style: t.textTheme.bodyMedium?.copyWith(
                            color: (payoff != null && !payoff.paysOff) ? cs.error : cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('${(s.progress * 100).round()}%',
                      style: t.textTheme.titleLarge?.copyWith(color: cs.primary, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(value: s.progress, minHeight: 8, backgroundColor: cs.surfaceContainerHighest),
              ),
              const SizedBox(height: 6),
              Text('${fmtMoney(s.paidCents / 100)} paid off so far', style: t.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Pinned results ─────────────────────────

class _PinnedResults extends ConsumerWidget {
  const _PinnedResults();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinned = ref.watch(pinnedResultsProvider).valueOrNull ?? const <PinnedResult>[];
    final t = Theme.of(context);

    if (pinned.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const IconBubble(Icons.push_pin_outlined, size: 48),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Open any calculator and tap "Pin to Home" to keep the result here.',
                  style: t.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final p in pinned)
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(14, 4, 4, 4),
              leading: IconBubble(calculatorIcon(p.calculator), color: calculatorColors[p.calculator]),
              title: Text(p.calculator.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(p.summary),
              trailing: IconButton(
                tooltip: 'Unpin',
                icon: const Icon(Icons.close),
                onPressed: () => ref.read(savedCalculationsRepositoryProvider).unpin(p.id),
              ),
              onTap: () => context.go(p.location),
            ),
          ),
      ],
    );
  }
}

// ───────────────────────── Coming soon ─────────────────────────

class _SoonTile extends StatelessWidget {
  const _SoonTile({required this.icon, required this.title, required this.subtitle, required this.location});
  final IconData icon;
  final String title;
  final String subtitle;
  final String location;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(location),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBubble(icon),
              const SizedBox(height: 10),
              Text(title, style: t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Text(subtitle, style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
