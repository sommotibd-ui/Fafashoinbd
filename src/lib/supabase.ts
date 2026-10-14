import { createClient } from '@supabase/supabase-js';

const url = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const anon = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

/** পাবলিক — শুধু active প্রোডাক্ট পড়তে পারে (RLS) */
export const supabasePublic = () => createClient(url, anon, { auth: { persistSession: false } });

/**
 * সার্ভার-অনলি। service_role key RLS বাইপাস করে, তাই এটা কখনো
 * ক্লায়েন্ট বান্ডলে যেতে দেওয়া যাবে না।
 */
export function supabaseAdmin() {
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!key) throw new Error('SUPABASE_SERVICE_ROLE_KEY সেট করা নেই');
  return createClient(url, key, { auth: { persistSession: false } });
}
