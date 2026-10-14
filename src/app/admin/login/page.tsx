'use client';
import { useState } from 'react';
import { createBrowserClient } from '@supabase/ssr';
import { useRouter } from 'next/navigation';
import { toLoginEmail, ADMIN_USERNAME_HINT } from '@/lib/admin-user';
import { site } from '@/config/site';

export default function Login() {
  const router = useRouter();
  const [userId, setUserId] = useState('');
  const [pass, setPass] = useState('');
  const [err, setErr] = useState('');
  const [busy, setBusy] = useState(false);

  const sb = createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
  );

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setBusy(true); setErr('');
    // ইউজারনেম লিখলে পেছনে ডোমেইন জুড়ে যায়; পুরো ইমেইল লিখলে সেটাই যায়
    const { error } = await sb.auth.signInWithPassword({ email: toLoginEmail(userId), password: pass });
    setBusy(false);
    if (error) { setErr('ইউজারনেম বা পাসওয়ার্ড মিলছে না।'); return; }
    router.replace('/admin');
    router.refresh();
  }

  return (
    <div className="grid min-h-screen place-items-center bg-cream px-4 text-ink">
      <form onSubmit={submit} className="w-full max-w-sm rounded-xl2 border border-line bg-white p-7">
        <h1 className="font-display text-2xl font-extrabold">অ্যাডমিন লগইন</h1>
        <p className="mb-6 mt-1 text-sm text-ink-3">{site.name}</p>

        <label className="mb-1.5 block text-sm font-semibold" htmlFor="userid">ইউজারনেম</label>
        <input id="userid" type="text" required autoComplete="username" autoCapitalize="none" spellCheck={false}
          placeholder={ADMIN_USERNAME_HINT} value={userId} onChange={(e) => setUserId(e.target.value)}
          className="mb-4 w-full rounded-lg border-2 border-line bg-cream px-4 py-2.5 outline-none focus:border-brand" />

        <label className="mb-1.5 block text-sm font-semibold" htmlFor="pass">পাসওয়ার্ড</label>
        <input id="pass" type="password" required autoComplete="current-password" value={pass} onChange={(e) => setPass(e.target.value)}
          className="mb-5 w-full rounded-lg border-2 border-line bg-cream px-4 py-2.5 outline-none focus:border-brand" />

        {err && <p className="mb-4 rounded-lg bg-pinkc-soft px-3 py-2 text-sm text-pinkc">{err}</p>}

        <button disabled={busy}
          className="w-full rounded-full bg-brand py-3 font-display font-bold text-white disabled:opacity-60">
          {busy ? 'অপেক্ষা করুন…' : 'লগইন করুন'}
        </button>
      </form>
    </div>
  );
}
