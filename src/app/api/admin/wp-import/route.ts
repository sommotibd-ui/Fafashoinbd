/**
 * POST /api/admin/wp-import — পুরনো WordPress অর্ডার আনা (শুধু অ্যাডমিন)।
 *
 * WordPress সার্ভার অর্ডারগুলো একটা অস্থায়ী JSON ফাইলে লেখে (এলোমেলো নাম),
 * এখানে সেটা সার্ভার থেকে পড়ে Supabase-এ বসানো হয়, তারপর ফাইলটা মুছে
 * ফেলা হয়। wp_order_id দিয়ে upsert — বারবার চালানো নিরাপদ, আর WordPress-এ
 * স্ট্যাটাস বদলালে এখানেও বদলায়।
 *
 * body: { url, offset, size }  → ফাইলের [offset, offset+size) অংশ
 */
import { NextResponse } from 'next/server';
import { supabaseAdmin } from '@/lib/supabase';
import { requireAdmin } from '@/lib/auth';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';
export const maxDuration = 120;

// শুধু পুরনো WordPress-এর স্যান্ডবক্স ফোল্ডার থেকে — অন্য কোথাও থেকে নয়
const ALLOWED = /^https:\/\/[a-z0-9.-]+\/wp-content\/(novamira-sandbox|uploads)\/fa-x-[a-f0-9]{32,}\.json$/;

let cache: { url: string; data: { orders: any[]; items: any[] } } | null = null;

export async function POST(req: Request) {
  const admin = await requireAdmin();
  if (!admin) return NextResponse.json({ ok: false, error: 'Not allowed' }, { status: 401 });
  const { url, offset = 0, size = 500 } = await req.json().catch(() => ({}));
  if (typeof url !== 'string' || !ALLOWED.test(url)) return NextResponse.json({ ok: false, error: 'Bad url' }, { status: 400 });

  if (!cache || cache.url !== url) {
    const r = await fetch(url, { cache: 'no-store' });
    if (!r.ok) return NextResponse.json({ ok: false, error: `fetch ${r.status}` }, { status: 400 });
    cache = { url, data: await r.json() };
  }
  const { orders, items } = cache.data;
  const part = orders.slice(offset, offset + size);
  if (!part.length) return NextResponse.json({ ok: true, done: true, total: orders.length });

  const db = supabaseAdmin();
  const { data: saved, error } = await db.from('orders')
    .upsert(part, { onConflict: 'wp_order_id' }).select('id, wp_order_id');
  if (error) return NextResponse.json({ ok: false, error: error.message }, { status: 500 });

  const map = new Map((saved || []).map((s: any) => [Number(s.wp_order_id), s.id]));
  const ids = [...map.values()];
  for (let i = 0; i < ids.length; i += 200) {
    const { error: de } = await db.from('order_items').delete().in('order_id', ids.slice(i, i + 200));
    if (de) return NextResponse.json({ ok: false, error: de.message }, { status: 500 });
  }
  const wanted = new Set(part.map((o: any) => Number(o.wp_order_id)));
  const rows = items.filter((it: any) => wanted.has(Number(it.wp_order_id)) && map.has(Number(it.wp_order_id)))
    .map(({ wp_order_id, ...it }: any) => ({ ...it, order_id: map.get(Number(wp_order_id)) }));
  for (let i = 0; i < rows.length; i += 500) {
    const { error: ie } = await db.from('order_items').insert(rows.slice(i, i + 500));
    if (ie) return NextResponse.json({ ok: false, error: ie.message }, { status: 500 });
  }
  return NextResponse.json({ ok: true, done: offset + size >= orders.length, total: orders.length, saved: part.length, items: rows.length });
}
