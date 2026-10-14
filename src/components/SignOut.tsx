'use client';
import { createBrowserClient } from '@supabase/ssr';
import { useRouter } from 'next/navigation';

export default function SignOut() {
  const router = useRouter();
  const sb = createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
  );
  return (
    <button
      onClick={async () => { await sb.auth.signOut(); router.replace('/admin/login'); router.refresh(); }}
      className="rounded-full border-2 border-line px-4 py-1.5 font-semibold hover:border-brand hover:text-brand">
      লগআউট
    </button>
  );
}
