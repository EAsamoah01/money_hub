// Public legal pages for Google Play, RevenueCat and the in-app links.
// Served by the same Worker as the AI proxy:
//   https://moneycore.peprahsoft.com/            (homepage; also shown for shared calculator links)
//   https://moneycore.peprahsoft.com/privacy
//   https://moneycore.peprahsoft.com/terms
//
// Fill in DEVELOPER_NAME, CONTACT_EMAIL, EFFECTIVE_DATE and GOVERNING_LAW in
// wrangler.toml ([vars]). Have someone qualified review these before launch.

const APP = 'Money Core';

function esc(s) {
  return String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
}

export function pageVars(env = {}) {
  return {
    developer: env.DEVELOPER_NAME || 'Peprah Tech',
    email: env.CONTACT_EMAIL || 'support@example.com',
    effective: env.EFFECTIVE_DATE || 'October 26, 2026',
    law: env.GOVERNING_LAW || 'the State of California, USA',
  };
}

function layout(title, body, v) {
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(title)} · ${APP}</title>
<style>
  :root { --bg:#f7faf9; --fg:#14211f; --muted:#51605d; --accent:#0f766e; --card:#ffffff; --line:#d9e3e1; }
  @media (prefers-color-scheme: dark) {
    :root { --bg:#0e1513; --fg:#e4ecea; --muted:#9db0ac; --accent:#5eead4; --card:#151f1d; --line:#2a3a37; }
  }
  * { box-sizing: border-box; }
  body { margin:0; background:var(--bg); color:var(--fg); font:16px/1.65 system-ui,-apple-system,"Segoe UI",Roboto,sans-serif; }
  main { max-width:760px; margin:0 auto; padding:32px 16px 64px; }
  header { display:flex; align-items:center; gap:12px; margin-bottom:8px; }
  .logo { width:40px; height:40px; border-radius:10px; background:linear-gradient(135deg,#0f766e,#15803d); display:grid; place-items:center; color:#fff; font-weight:800; }
  .brand { font-weight:700; color:var(--accent); }
  h1 { font-size:1.9rem; line-height:1.25; margin:16px 0 4px; }
  h2 { font-size:1.2rem; margin:32px 0 8px; }
  p, li { color:var(--fg); }
  .meta { color:var(--muted); margin:0 0 24px; }
  .card { background:var(--card); border:1px solid var(--line); border-radius:14px; padding:16px 20px; margin:16px 0; }
  table { width:100%; border-collapse:collapse; font-size:.95rem; }
  th, td { text-align:left; vertical-align:top; padding:10px 8px; border-bottom:1px solid var(--line); }
  th { color:var(--muted); font-weight:600; }
  a { color:var(--accent); }
  footer { margin-top:48px; color:var(--muted); font-size:.9rem; }
  @media (max-width:560px) { th:nth-child(3), td:nth-child(3) { display:none; } }
</style>
</head>
<body><main>
<header><div class="logo">M</div><span class="brand">${APP}</span></header>
${body}
<footer>${APP} is made by ${esc(v.developer)}. Questions: <a href="mailto:${esc(v.email)}">${esc(v.email)}</a>.
<br><a href="/privacy">Privacy policy</a> · <a href="/terms">Terms of use</a></footer>
</main></body></html>`;
}

export function privacyPage(env) {
  const v = pageVars(env);
  return layout('Privacy policy', `
<h1>Privacy policy</h1>
<p class="meta">Effective ${esc(v.effective)}</p>

<div class="card"><strong>The short version.</strong> ${APP} has no accounts and no ads. Your budget,
transactions, bills, debts and lesson progress are stored only on your phone. Your budget data leaves your
phone only if you choose to use the AI money coach, which asks you first. Subscriptions are handled by Google
Play and RevenueCat. We never sell your data.</div>

<h2>Who we are</h2>
<p>${APP} ("the app", "we", "us") is published by ${esc(v.developer)}. You can contact us at
<a href="mailto:${esc(v.email)}">${esc(v.email)}</a>.</p>

<h2>Information that stays on your device</h2>
<p>Everything you enter (income, spending, budget envelopes, accounts and balances, bills and
subscriptions, debts, saved calculator results, lesson and quiz progress, and settings) is saved in a
database on your device. We do not have a server copy of it and cannot see it. You delete it by clearing
the app's storage or uninstalling the app.</p>
<p><strong>Bill reminders</strong> are scheduled on your device by Android. <strong>App lock</strong> uses
your phone's fingerprint, face or PIN check; the app only learns whether the check passed and never
receives your biometric data.</p>

<h2>Information that leaves your device</h2>
<table>
<tr><th>When</th><th>What is sent</th><th>To whom</th></tr>
<tr><td>You buy, restore or check a Pro subscription</td>
<td>A random app user ID, purchase details and receipts, device and app version information</td>
<td>Google Play and RevenueCat, our subscription provider</td></tr>
<tr><td>You use an AI feature (Pro, after you agree)</td>
<td>Your question and a text summary of this month's budget: envelope names and amounts, recent spending
(date, amount, payee and category), bills and debts. For lesson or calculator explanations, that lesson or
result. Never bank account numbers or passwords.</td>
<td>Our server on Cloudflare, which passes it to Anthropic (Claude) to write the answer</td></tr>
<tr><td>The app loads partner offers</td><td>A standard web request (your IP address)</td>
<td>Our offers file host</td></tr>
<tr><td>You play a lesson video</td><td>Standard YouTube playback data</td><td>Google / YouTube</td></tr>
<tr><td>You tap a link (offer, cancel page, share)</td><td>Whatever that website or app collects</td>
<td>That website or app</td></tr>
</table>

<h2>The AI money coach</h2>
<p>AI features are optional and only run after you agree in the app. Our server checks that you have an
active Pro subscription using your random app user ID, keeps a count of today's AI requests for that ID
(deleted after about a day) and forwards your request to Anthropic. <strong>Our server does not save your
questions, the answers or your budget summary.</strong> The one exception: if you tap
<em>Report this answer</em>, we keep that answer, the question before it and your reason for up to 90 days
so we can review it and improve the app.</p>
<p>Anthropic processes the request to produce the answer under its
<a href="https://www.anthropic.com/legal/commercial-terms">commercial terms</a> and
<a href="https://www.anthropic.com/legal/privacy">privacy policy</a>, which govern how long it keeps such
data and say that data sent through its API is not used to train its models by default.</p>
<p>You can stop all AI data sharing at any time in <em>Settings → AI money coach → Share budget summary
with AI</em>.</p>

<h2>Service providers</h2>
<ul>
<li><strong>Google Play</strong>: app delivery and payments. <a href="https://policies.google.com/privacy">Google privacy policy</a></li>
<li><strong>RevenueCat</strong>: subscription management. <a href="https://www.revenuecat.com/privacy">RevenueCat privacy policy</a></li>
<li><strong>Cloudflare</strong>: runs our AI server and these pages; processes IP addresses for delivery and security. <a href="https://www.cloudflare.com/privacypolicy/">Cloudflare privacy policy</a></li>
<li><strong>Anthropic</strong>: AI answers. <a href="https://www.anthropic.com/legal/privacy">Anthropic privacy policy</a></li>
</ul>
<p>We do not use advertising or analytics tools, and we do not sell personal information or share it for
cross-context behavioral advertising.</p>

<h2>Why we use this information</h2>
<p>Only to provide the features you ask for: to give you the Pro features you paid for, to answer your
AI questions, and to keep the service secure. Where laws such as the GDPR apply, we rely on performing our
contract with you (subscriptions), your consent (AI features, which you can withdraw), and our legitimate
interest in keeping the service secure.</p>

<h2>Your choices and rights</h2>
<ul>
<li><strong>Delete your data:</strong> clear the app's storage or uninstall. We hold no copy of your budget.</li>
<li><strong>Stop AI sharing:</strong> turn it off in Settings.</li>
<li><strong>Subscription records:</strong> email us to request access to or deletion of the records linked
to your app user ID at RevenueCat. Google Play keeps its own purchase records under its policy.</li>
<li>Depending on where you live (for example California or the EU/UK), you may have rights to know,
access, correct or delete personal information and to not be discriminated against for using them.
Contact us and we will respond within the time the law requires.</li>
</ul>

<h2>Security</h2>
<p>Connections to our server and our providers use encryption (HTTPS). Your on-device data is protected by
your phone's security, and you can turn on App lock in Settings. No method is perfectly secure.</p>

<h2>Children</h2>
<p>${APP} is meant for adults (18+) and is not directed to children. We do not knowingly collect data from
children under 13. If you think a child has used the AI features, contact us.</p>

<h2>Changes</h2>
<p>If we change this policy, we will update the date above, and for important changes we will tell you in
the app.</p>
`, v);
}

export function termsPage(env) {
  const v = pageVars(env);
  return layout('Terms of use', `
<h1>Terms of use</h1>
<p class="meta">Effective ${esc(v.effective)}</p>

<p>These terms are an agreement between you and ${esc(v.developer)} about your use of ${APP}. By using the
app you accept them. If you don't agree, please don't use the app.</p>

<h2>1. Education only, not advice</h2>
<p>${APP} helps you budget, track bills and debts, run calculations and learn about money. Everything in
the app, including calculator results, lessons and AI answers, is general educational information. It is
<strong>not financial, investment, tax or legal advice</strong> and does not consider your full situation.
Calculators use simplified assumptions; real returns, rates and fees vary. Talk to a qualified professional
before making important financial decisions.</p>

<h2>2. AI features</h2>
<p>The AI money coach is written by a computer model. It can be wrong, incomplete or out of date, even
when it sounds confident. Check important information yourself. Don't enter passwords, bank account numbers
or other sensitive details. Fair-use daily limits apply.</p>

<h2>3. Pro subscription</h2>
<ul>
<li>Pro is sold as an auto-renewing subscription through Google Play. The price and billing period are
shown before you buy.</li>
<li>If a free trial is offered, you'll be charged when it ends unless you cancel at least 24 hours before.</li>
<li>Your subscription renews automatically until you cancel. Cancel any time in Google Play → Payments
&amp; subscriptions → Subscriptions; you keep Pro until the end of the period you paid for.</li>
<li>Refunds are handled by Google Play under its refund policy.</li>
<li>We may change features or prices. Price changes will follow Google Play's rules and notice
requirements.</li>
</ul>

<h2>4. Your data and backups</h2>
<p>Your budget data is stored on your device. You are responsible for it. If you lose your phone, clear
the app's data or uninstall, it may be gone for good. See our <a href="/privacy">privacy policy</a>.</p>

<h2>5. Partner offers</h2>
<p>Some screens show offers from partners. Some links are affiliate links, which means we may earn a
commission if you sign up, at no extra cost to you. Partners' products and websites are theirs, under their
own terms; we don't control or guarantee them. Offers never change the app's calculations.</p>

<h2>6. Acceptable use</h2>
<p>Don't misuse the app: no attempts to break, overload, reverse-engineer or get around the subscription
or AI limits, and no using the AI features to create harmful or illegal content.</p>

<h2>7. Ownership</h2>
<p>The app, its design, lessons and content belong to ${esc(v.developer)} or its licensors. We give you a
personal, non-transferable license to use the app on devices you own or control, under these terms and
Google Play's terms.</p>

<h2>8. Disclaimers</h2>
<p>The app is provided "as is" and "as available". To the fullest extent the law allows, we make no
warranties, express or implied, including that the app will be error-free, always available, or that its
results are accurate or fit for a particular purpose.</p>

<h2>9. Limitation of liability</h2>
<p>To the fullest extent the law allows, ${esc(v.developer)} is not liable for indirect, incidental,
special or consequential damages, or for financial decisions you make using the app. Our total liability
for any claim is limited to the amount you paid us for the app in the 12 months before the claim. Some
places don't allow these limits, so they may not apply to you.</p>

<h2>10. Ending use</h2>
<p>You can stop using the app at any time by uninstalling it (cancel any subscription in Google Play
first). We may suspend access to online features if you break these terms.</p>

<h2>11. Changes</h2>
<p>We may update these terms. We'll change the date above and, for important changes, tell you in the
app. Continuing to use the app means you accept the new terms.</p>

<h2>12. Law</h2>
<p>These terms are governed by the laws of ${esc(v.law)}, except where the law of the place you live says
otherwise.</p>

<h2>Contact</h2>
<p><a href="mailto:${esc(v.email)}">${esc(v.email)}</a></p>
`, v);
}

export const PLAY_URL = 'https://play.google.com/store/apps/details?id=com.peprahsoft.moneycore';

/** Homepage. Also shown when someone opens a shared calculator or lesson link. */
export function homePage(env, { shared = false } = {}) {
  const v = pageVars(env);
  return layout(shared ? 'Shared from Money Core' : 'Budget, bills and debt in one app', `
<h1>${shared ? 'Someone shared a Money Core result with you' : 'Your money, in one place'}</h1>
<p class="meta">${shared
    ? 'Open it in the Money Core app to see the numbers and try your own.'
    : 'Envelope budgeting, bill reminders, debt payoff plans, money calculators and an AI money coach.'}</p>
<div class="card">
<ul>
<li><strong>Budget:</strong> give every dollar a job with envelopes.</li>
<li><strong>Bills &amp; Alerts:</strong> reminders before every due date and free-trial charge.</li>
<li><strong>Debt payoff:</strong> snowball vs avalanche and your debt-free date.</li>
<li><strong>Calculators:</strong> compound interest, FIRE, inflation and more.</li>
<li><strong>AI money coach (Pro):</strong> ask questions about your own budget.</li>
</ul>
<p><a href="${PLAY_URL}" style="display:inline-block;background:var(--accent);color:var(--bg);padding:12px 20px;border-radius:999px;text-decoration:none;font-weight:700">Get Money Core on Google Play</a></p>
</div>
<p>No account and no ads. Your budget stays on your phone.</p>
`, v);
}

export function htmlResponse(html, status = 200) {
  return new Response(html, {
    status,
    headers: {
      'Content-Type': 'text/html; charset=utf-8',
      'Cache-Control': 'public, max-age=3600',
      'X-Content-Type-Options': 'nosniff',
    },
  });
}
