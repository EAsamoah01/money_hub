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
