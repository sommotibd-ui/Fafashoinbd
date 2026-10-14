import { createServerClient, type CookieOptions } from '@supabase/ssr';
import { cookies } from 'next/headers';

/** সার্ভার কম্পোনেন্ট ও রুট হ্যান্ডলারের জন্য Supabase ক্লায়েন্ট */
export async function supabaseServer() {
  const store = await cookies();
  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: () => store.getAll(),
        setAll: (list: { name: string; value: string; options: CookieOptions }[]) => {
          try { list.forEach(({ name, value, options }) => store.set(name, value, options)); }
          catch { /* সার্ভার কম্পোনেন্ট থেকে সেট করা যায় না — ঠিক আছে */ }
        },
      },
    },
  );
}

/** লগইন করা ইউজার অ্যাডমিন কিনা */
export async function requireAdmin() {
  const sb = await supabaseServer();
  const { data: { user } } = await sb.auth.getUser();
  if (!user) return null;
  const { data } = await sb.from('admin_users').select('id, email, role').eq('id', user.id).maybeSingle();
  return data ? { id: user.id, email: user.email!, role: data.role as string } : null;
}
