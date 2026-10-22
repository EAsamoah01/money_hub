// Every path in the app, in one place.
//
// Deep links map 1:1 to these paths:
//   moneyhub://app/tools/fire              (custom scheme)
//   https://yourdomain.com/tools/fire      (universal/app link)
// Use the location builders below instead of hand-writing strings.

/// Public web address used in share links. Change to your real domain.
const kWebBaseUrl = 'https://yourdomain.com';

/// Calculator ids used in /tools/:calculatorId — also the URL slug.
enum CalculatorId {
  compoundInterest('compound-interest', 'Compound Interest', isPro: false),
  fire('fire', 'FIRE Number', isPro: false),
  debtPayoff('debt-payoff', 'Debt Payoff: Snowball vs Avalanche', isPro: false),
  whatIf('what-if', 'What If I Invested…', isPro: false),
  dcaVsLumpSum('dca-vs-lump-sum', 'DCA vs Lump Sum', isPro: false),
  inflation('inflation', 'Inflation Erosion', isPro: false),
  retirementScenarios('retirement-scenarios', 'Retirement Scenarios', isPro: true);

  const CalculatorId(this.slug, this.title, {required this.isPro});
  final String slug;
  final String title;
  final bool isPro;

  static CalculatorId? fromSlug(String slug) {
    for (final c in values) {
      if (c.slug == slug) return c;
    }
    return null;
  }
}

abstract final class Routes {
  // ── Outside the tab shell ──
  static const onboarding = '/onboarding';
  static const paywall = '/paywall'; // ?from=<path to return to>
  static const settings = '/settings';
  static const settingsBackup = '/settings/backup';
  static const settingsSecurity = '/settings/security';
  static const coach = '/coach'; // AI chat. ?ask=&lesson=&topic=

  // ── Tab 0: Home ──
  static const home = '/home';

  // ── Tab 1: Budget ──
  static const budget = '/budget'; // ?month=2026-10
  static const budgetCategory = '/budget/category/:categoryId';
  static const transactions = '/budget/transactions';
  static const transactionNew = '/budget/transactions/new'; // ?categoryId=&accountId=
  static const transactionEdit = '/budget/transactions/:txId';
  static const bills = '/budget/bills';
  static const billNew = '/budget/bills/new';
  static const billDetail = '/budget/bills/:billId';
  static const billEdit = '/budget/bills/:billId/edit';
  static const accounts = '/budget/accounts';
  static const accountDetail = '/budget/accounts/:accountId';

  // ── Tab 2: Goals ──
  static const goals = '/goals';
  static const debts = '/goals/debts';
  static const debtNew = '/goals/debts/new';
  static const debtPlan = '/goals/debts/plan'; // snowball vs avalanche timeline
  static const debtDetail = '/goals/debts/:debtId';
  static const debtEdit = '/goals/debts/:debtId/edit';
  static const netWorth = '/goals/net-worth';
  static const holdings = '/goals/net-worth/holdings/:accountId';

  // ── Tab 3: Tools ──
  static const tools = '/tools';
  static const calculator = '/tools/:calculatorId'; // query params pre-fill inputs
  static const savedCalculations = '/tools/saved';

  // ── Tab 4: Learn ──
  static const learn = '/learn';
  static const lesson = '/learn/:lessonId';
  static const lessonQuiz = '/learn/:lessonId/quiz';

  /// Routes that need an active Pro subscription.
  static const proOnly = <String>{
    netWorth,
    holdings,
    debtPlan,
    savedCalculations,
    coach,
  };
}

/// Type-safe location builders — use these for context.go / push and links.
abstract final class Loc {
  static String budget({String? month}) =>
      Uri(path: Routes.budget, queryParameters: month == null ? null : {'month': month}).toString();
  static String budgetCategory(int id, {String? month}) =>
      Uri(path: '/budget/category/$id', queryParameters: month == null ? null : {'month': month}).toString();
  static String transactionNew({int? categoryId, int? accountId, bool income = false}) {
    final q = {
      if (categoryId != null) 'categoryId': '$categoryId',
      if (accountId != null) 'accountId': '$accountId',
      if (income) 'type': 'income',
    };
    return Uri(path: Routes.transactionNew, queryParameters: q.isEmpty ? null : q).toString();
  }
  static String transactionEdit(int id) => '/budget/transactions/$id';
  static String billDetail(int id) => '/budget/bills/$id';
  static String billEdit(int id) => '/budget/bills/$id/edit';
  static String accountDetail(int id) => '/budget/accounts/$id';
  static String debtDetail(int id) => '/goals/debts/$id';
  static String debtEdit(int id) => '/goals/debts/$id/edit';
  static String holdings(int accountId) => '/goals/net-worth/holdings/$accountId';
  static String lesson(String id) => '/learn/$id';
  static String lessonQuiz(String id) => '/learn/$id/quiz';
  /// AI coach chat. [ask] is sent as the first question; [lessonId] or
  /// [topic] switch it to explaining that lesson or calculator result.
  static String coach({String? ask, String? lessonId, String? topic}) {
    final q = {
      if (ask != null) 'ask': ask,
      if (lessonId != null) 'lesson': lessonId,
      if (topic != null) 'topic': topic,
    };
    return Uri(path: Routes.coach, queryParameters: q.isEmpty ? null : q).toString();
  }

  static String paywall({String? from}) =>
      Uri(path: Routes.paywall, queryParameters: from == null ? null : {'from': from}).toString();

  /// e.g. Loc.calculator(CalculatorId.compoundInterest, {'principal': '10000', 'years': '30'})
  /// → /tools/compound-interest?principal=10000&years=30
  /// Lessons use this to open a calculator pre-filled with the lesson's example.
  static String calculator(CalculatorId c, [Map<String, String>? prefill]) => Uri(
        path: '/tools/${c.slug}',
        queryParameters: (prefill == null || prefill.isEmpty) ? null : prefill,
      ).toString();
}
