/**
 * POST /api/upload — অ্যাডমিন প্যানেল থেকে প্রোডাক্টের ছবি আপলোড
 *
 * ব্রাউজার থেকে সরাসরি Supabase Storage-এ না পাঠিয়ে এই রুট দিয়ে পাঠানো
 * হয়। কারণ তাহলে বাকেটে "যে কেউ লিখতে পারে" এমন নিয়ম বসাতে হতো।
 * এখানে আগে requireAdmin() দিয়ে যাচাই হয়, তারপর সার্ভারের কি দিয়ে লেখা হয়।
 *
 * ছবি ব্রাউজারেই ছোট করে WebP বানিয়ে পাঠানো হয় (ImageUploader.tsx দেখুন),
 * তাই এখানে সাধারণত ১৫০-৩০০ KB আসে। তবু সার্ভারে আবার মাপ যাচাই করা হয় —
 * ক্লায়েন্টের পাঠানো কিছুতেই ভরসা নয়।
 */
import { NextResponse } from 'next/server';
import { supabaseAdmin } from '@/lib/supabase';
import { requireAdmin } from '@/lib/auth';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const BUCKET = 'products';
const MAX_BYTES = 4 * 1024 * 1024;          // ৪ MB
const OK_TYPES = ['image/webp', 'image/jpeg', 'image/png'];

export async function POST(req: Request) {
  const admin = await requireAdmin();
  if (!admin) return NextResponse.json({ ok: false, error: 'অনুমতি নেই' }, { status: 401 });

  let form: FormData;
  try { form = await req.formData(); }
  catch { return NextResponse.json({ ok: false, error: 'ফাইল পড়া যায়নি।' }, { status: 400 }); }

  const files = form.getAll('file').filter((f): f is File => f instanceof File);
  if (!files.length) {
    return NextResponse.json({ ok: false, error: 'কোনো ছবি পাওয়া যায়নি।' }, { status: 400 });
  }
  if (files.length > 8) {
    return NextResponse.json({ ok: false, error: 'একসাথে সর্বোচ্চ ৮টি ছবি।' }, { status: 400 });
  }

  const db = supabaseAdmin();
  const urls: string[] = [];

  for (const file of files) {
    if (!OK_TYPES.includes(file.type)) {
      return NextResponse.json(
        { ok: false, error: 'শুধু ছবি আপলোড করা যাবে (JPG, PNG বা WebP)।' }, { status: 400 });
    }
    if (file.size > MAX_BYTES) {
      return NextResponse.json(
        { ok: false, error: 'ছবিটি অনেক বড়। ৪ MB-র কম হতে হবে।' }, { status: 400 });
    }

    const ext = file.type === 'image/png' ? 'png' : file.type === 'image/jpeg' ? 'jpg' : 'webp';
    // ফাইলের নাম আমরাই বানাই — ব্যবহারকারীর দেওয়া নামে পথ বদলে দেওয়ার
    // চেষ্টা (../) বা বাংলা/স্পেস থাকতে পারে
    const name = `${Date.now()}-${crypto.randomUUID().slice(0, 8)}.${ext}`;

    const { error } = await db.storage.from(BUCKET).upload(name, file, {
      contentType: file.type,
      cacheControl: '31536000',      // এক বছর — ফাইলের নাম প্রতিবার আলাদা
      upsert: false,
    });

    if (error) {
      return NextResponse.json(
        { ok: false, error: `আপলোড হয়নি: ${error.message}` }, { status: 500 });
    }

    urls.push(db.storage.from(BUCKET).getPublicUrl(name).data.publicUrl);
  }

  await db.from('audit_log').insert({
    actor: admin.id, action: 'image.upload', entity: 'storage',
    detail: { count: urls.length },
  });

  return NextResponse.json({ ok: true, urls });
}

/** DELETE /api/upload?url=… — ছবি মুছে ফেলা */
export async function DELETE(req: Request) {
  const admin = await requireAdmin();
  if (!admin) return NextResponse.json({ ok: false, error: 'অনুমতি নেই' }, { status: 401 });

  const url = new URL(req.url).searchParams.get('url') || '';
  const marker = `/storage/v1/object/public/${BUCKET}/`;
  const i = url.indexOf(marker);
  if (i < 0) {
    // আমাদের বাকেটের ছবি নয় (যেমন /img/mf01.webp) — মোছার কিছু নেই
    return NextResponse.json({ ok: true, skipped: true });
  }

  const name = decodeURIComponent(url.slice(i + marker.length).split('?')[0]);
  const { error } = await supabaseAdmin().storage.from(BUCKET).remove([name]);
  if (error) return NextResponse.json({ ok: false, error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
