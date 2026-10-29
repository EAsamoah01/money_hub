// Run with:  npm test   (Node 18+)
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { cleanMessages, buildClaudeRequest, hasActiveEntitlement, MODES } from '../src/index.js';

test('cleanMessages drops leading assistant turns and merges repeats', () => {
  const m = cleanMessages([
    { role: 'assistant', content: 'hi' },
    { role: 'user', content: 'a' },
    { role: 'user', content: 'b' },
    { role: 'assistant', content: 'c' },
    { role: 'system', content: 'ignore me' },
    { role: 'user', content: '   ' },
  ]);
  assert.deepEqual(m, [
    { role: 'user', content: 'a\n\nb' },
    { role: 'assistant', content: 'c' },
  ]);
});

test('cleanMessages trims long messages and keeps only the last 20', () => {
  const many = Array.from({ length: 30 }, (_, i) => ({ role: i % 2 ? 'assistant' : 'user', content: 'x'.repeat(5000) }));
  const m = cleanMessages(many);
  assert.ok(m.length <= 20);
  assert.equal(m[0].role, 'user');
  assert.equal(m[0].content.length, 4000);
});

test('buildClaudeRequest wraps context and uses the mode budget', () => {
  const r = buildClaudeRequest({ mode: 'categorize', messages: [{ role: 'user', content: 'Walmart $40' }], context: 'Groceries' }, 'm');
  assert.equal(r.model, 'm');
  assert.equal(r.max_tokens, MODES.categorize.maxTokens);
  assert.match(r.system, /<user_data>\nGroceries\n<\/user_data>/);
});

test('hasActiveEntitlement', () => {
  const now = Date.parse('2026-10-21T00:00:00Z');
  const sub = (expires) => ({ subscriber: { entitlements: { pro: { expires_date: expires } } } });
  assert.equal(hasActiveEntitlement(sub('2026-11-01T00:00:00Z'), 'pro', now), true);
  assert.equal(hasActiveEntitlement(sub('2026-10-01T00:00:00Z'), 'pro', now), false);
  assert.equal(hasActiveEntitlement(sub(null), 'pro', now), true);
  assert.equal(hasActiveEntitlement({ subscriber: { entitlements: {} } }, 'pro', now), false);
});

import { privacyPage, termsPage } from '../src/pages.js';

test('legal pages fill in the developer details and escape them', () => {
  const env = { DEVELOPER_NAME: 'Acme <Co>', CONTACT_EMAIL: 'help@acme.test' };
  const p = privacyPage(env);
  assert.match(p, /Acme &lt;Co&gt;/);
  assert.match(p, /mailto:help@acme\.test/);
  assert.match(p, /does not save your\s+questions/);
  assert.match(termsPage(env), /not financial, investment, tax or legal advice/);
});

import { handleReport } from '../src/index.js';

test('report endpoint stores the flagged answer', async () => {
  const saved = [];
  const env = { USAGE: { put: async (k, v, o) => saved.push({ k, v: JSON.parse(v), o }) } };
  const req = new Request('https://w/report', {
    method: 'POST',
    headers: { 'X-User-Id': 'u1' },
    body: JSON.stringify({ reason: 'Wrong or misleading', answer: 'Buy stocks!', question: 'hi', mode: 'coach' }),
  });
  const res = await handleReport(req, env);
  assert.equal(res.status, 200);
  assert.equal(saved.length, 1);
  assert.match(saved[0].k, /^report:/);
  assert.equal(saved[0].v.answer, 'Buy stocks!');
  assert.equal(saved[0].o.expirationTtl, 60 * 60 * 24 * 90);
});

import worker from '../src/index.js';

test('homepage and shared links show the Get Money Core page', async () => {
  const home = await worker.fetch(new Request('https://w/'), {}, {});
  assert.equal(home.status, 200);
  assert.match(await home.text(), /Your money, in one place/);
  const shared = await worker.fetch(new Request('https://w/tools/fire?spend=40000'), {}, {});
  assert.match(await shared.text(), /shared a Money Core result/);
  assert.match(await (await worker.fetch(new Request('https://w/privacy'), {}, {})).text(), /Privacy policy/);
});

import { secret } from '../src/index.js';

test('secret() cleans up pasted values', () => {
  assert.equal(secret('﻿sk-ant-abc\r\n'), 'sk-ant-abc');
  assert.equal(secret('"sk-ant-abc"'), 'sk-ant-abc');
  assert.equal(secret(undefined), '');
});

import { offerUrl, clickStats } from '../src/offers.js';

test('offers: served, tracked and redirect only to listed partners', async () => {
  const store = new Map();
  const env = {
    DEV_TOKEN: 'tok',
    USAGE: {
      get: async (k) => store.get(k) ?? null,
      put: async (k, v) => store.set(k, v),
      list: async ({ prefix }) => ({ keys: [...store.keys()].filter((k) => k.startsWith(prefix)).map((name) => ({ name })) }),
    },
  };
  const waits = [];
  const ctx = { waitUntil: (p) => waits.push(p) };

  const list = await worker.fetch(new Request('https://w/offers.json'), env, ctx);
  const cfg = await list.json();
  assert.ok(cfg.placements['learn.index-funds-101']);

  const go = await worker.fetch(new Request('https://w/go/tools.fire.result'), env, ctx);
  assert.equal(go.status, 302);
  assert.equal(go.headers.get('Location'), offerUrl('tools.fire.result'));
  await Promise.all(waits);

  assert.equal((await worker.fetch(new Request('https://w/go/https%3A%2F%2Fevil.test'), env, ctx)).status, 404);
  assert.equal(offerUrl('x', { placements: { x: { url: 'javascript:alert(1)' } } }), null);
  assert.equal(offerUrl('x', { placements: { x: { url: 'https://a.test', enabled: false } } }), null);

  const stats = await clickStats(env);
  const thisMonth = new Date().toISOString().slice(0, 7);
  assert.equal(stats[thisMonth]['tools.fire.result'], 1);
  assert.equal((await worker.fetch(new Request('https://w/stats'), env, ctx)).status, 401);
  assert.equal((await worker.fetch(new Request('https://w/stats?token=tok'), env, ctx)).status, 200);
});
