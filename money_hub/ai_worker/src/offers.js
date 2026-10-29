// Partner offers: the app downloads /offers.json, and taps go through
// /go/<placement>, which counts the click and redirects to the partner.
// Clicks are counted per placement per month. No user ID, IP or device data.
//
// To change offers: edit ../offers.json, then `npx wrangler deploy`.
// To see clicks:    open /stats?token=<your DEV_TOKEN> in a browser.

import offers from '../offers.json' with { type: 'json' };

export const OFFERS = offers;

/** The partner link for a placement, only if it's a live (enabled, http) offer. */
export function offerUrl(placement, cfg = OFFERS) {
  const o = cfg?.placements?.[placement];
  if (!o || o.enabled === false || typeof o.url !== 'string') return null;
  return /^https?:\/\//.test(o.url) ? o.url : null;
}

const month = (d = new Date()) => d.toISOString().slice(0, 7);

export async function handleGo(placement, env, ctx) {
  const url = offerUrl(placement);
  if (!url) return new Response('Offer not found', { status: 404 });
  if (env.USAGE) {
    const key = `clicks:${month()}:${placement}`;
    ctx.waitUntil(
      (async () => {
        const n = Number((await env.USAGE.get(key)) || 0);
        await env.USAGE.put(key, String(n + 1));
      })(),
    );
  }
  return new Response(null, { status: 302, headers: { Location: url, 'Cache-Control': 'no-store' } });
}

/** Click counts for this month and last month, grouped by month. */
export async function clickStats(env) {
  const out = {};
  if (!env.USAGE) return out;
  const now = new Date();
  const last = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - 1, 1));
  for (const m of [month(now), month(last)]) {
    out[m] = {};
    const list = await env.USAGE.list({ prefix: `clicks:${m}:` });
    for (const k of list.keys) {
      out[m][k.name.slice(`clicks:${m}:`.length)] = Number((await env.USAGE.get(k.name)) || 0);
    }
  }
  return out;
}
