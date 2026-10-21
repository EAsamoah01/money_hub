import 'package:flutter/material.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/placeholder_screen.dart';

// Placeholder screens for the Budget tab. Replace one at a time.
// Suggested files once they grow: budget_screen.dart, category_screen.dart,
// transactions_screen.dart, transaction_form_screen.dart, bills_screen.dart …

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key, this.month});
  final String? month; // "2026-10"; null = current month

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Budget ${month ?? '(this month)'}',
        details: 'Envelopes grouped by CategoryGroups, with assigned / spent / available.',
        links: {
          'Groceries envelope': Loc.budgetCategory(1),
          'Transactions': Routes.transactions,
          'Bills & subscriptions': Routes.bills,
          'Accounts': Routes.accounts,
        },
      );
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.categoryId});
  final int categoryId;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Envelope #$categoryId',
        links: {'Add spending here': Loc.transactionNew(categoryId: categoryId)},
      );
}

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Transactions',
        links: {'New transaction': Loc.transactionNew(), 'Edit #1': Loc.transactionEdit(1)},
      );
}

class TransactionFormScreen extends StatelessWidget {
  const TransactionFormScreen({super.key, this.txId, this.categoryId, this.accountId});
  final int? txId;
  final int? categoryId;
  final int? accountId;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: txId == null ? 'New transaction' : 'Edit transaction #$txId',
        details: 'Prefill → category: $categoryId, account: $accountId',
      );
}

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Bills & subscriptions',
        details: 'Upcoming list + yearly cost total.',
        links: {'Add bill': Routes.billNew, 'Bill #1': Loc.billDetail(1)},
      );
}

class BillFormScreen extends StatelessWidget {
  const BillFormScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'New bill / subscription');
}

class BillDetailScreen extends StatelessWidget {
  const BillDetailScreen({super.key, required this.billId});
  final int billId;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Bill #$billId',
        details: 'Payment history, reminder settings, "how to cancel" link.',
      );
}

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Accounts',
        links: {'Account #1': Loc.accountDetail(1)},
      );
}

class AccountDetailScreen extends StatelessWidget {
  const AccountDetailScreen({super.key, required this.accountId});
  final int accountId;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
        title: 'Account #$accountId',
        links: {'Add transaction': Loc.transactionNew(accountId: accountId)},
      );
}
