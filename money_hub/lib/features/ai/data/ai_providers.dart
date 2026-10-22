import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../budget/data/bills_repository.dart';
import '../../budget/data/budget_repository.dart';
import '../../budget/domain/budget_math.dart';
import '../../goals/data/debts_repository.dart';
import '../domain/money_context.dart';

/// The current month's money summary sent with coach and insight requests.
final moneyContextProvider = Provider<String>((ref) {
  final now = DateTime.now();
  final month = monthKey(now);
  final names = ref.watch(categoryNamesProvider);
  final txs = ref.watch(monthTransactionsProvider(month)).valueOrNull ?? const <MoneyTransaction>[];
  final bills = ref.watch(billsProvider).valueOrNull ?? const <RecurringItem>[];
  final debts = ref.watch(activeDebtsProvider).valueOrNull ?? const <Debt>[];
  final plan = ref.watch(debtPlanProvider).valueOrNull;

  final spending = [
    for (final t in txs)
      if (t.type == TransactionType.expense)
        (
          date: t.date,
          payee: t.payee,
          category: t.categoryId == null ? null : names[t.categoryId],
          amountCents: -t.amountCents,
        ),
  ]..sort((a, b) => b.date.compareTo(a.date));

  return buildMoneyContext(
    now: now,
    summary: ref.watch(budgetSummaryProvider(month)),
    recentSpending: spending,
    bills: [
      for (final b in bills)
        if (b.isActive)
          (
            name: b.name,
            subscription: b.kind == RecurringKind.subscription,
            amountCents: b.amountCents,
            frequency: b.frequency,
            nextDue: b.nextDueDate,
            autoPay: b.autoPay,
          ),
    ],
    debts: [
      for (final d in debts)
        (
          name: d.name,
          balanceCents: d.currentBalanceCents,
          aprBasisPoints: d.aprBasisPoints,
          minimumCents: d.minimumPaymentCents,
        ),
    ],
    debtPlan: plan == null ? null : (strategy: plan.strategy, extraMonthlyCents: plan.extraMonthlyCents),
  );
});

/// Saved monthly insight text, keyed by month ("ai_insights_2026-10").
String insightsKey(String month) => 'ai_insights_$month';

final savedInsightsProvider = FutureProvider.family<String?, String>(
  (ref, month) => ref.watch(databaseProvider).getSetting(insightsKey(month)),
);
