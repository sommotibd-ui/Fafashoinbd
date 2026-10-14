'use client';

import { useSearchParams } from 'next/navigation';
import { Suspense } from 'react';
import { bn, tk } from '@/lib/money';
import { site } from '@/config/site';

/** অর্ডারের পরের পাতা — পুরনো CartFlows-এর "Thank You" ধাপের জায়গায় */
function Inner() {
  const q = useSearchParams();
  const orderNo = Number(q.get('o')) || 0;
  const total = Number(q.get('t')) || 0;
  const social = site.social || {};

  return (
    <div className="mx-auto max-w-lg px-4 py-10">
      <div className="rounded-3xl border border-line bg-white p-8 text-center">
        <p className="text-5xl">🎉</p>
        <h1 className="mt-3 font-display text-2xl font-extrabold">আপনার অর্ডার কনফার্ম করার জন্য ধন্যবাদ</h1>
        {orderNo > 0 && (
          <p className="mt-2 text-ink-2">
            অর্ডার নম্বর <b className="tabular-nums">#{bn(orderNo)}</b>
            {total > 0 && <> · মোট <b className="tabular-nums">{tk(total)}</b></>}
          </p>
        )}
        {/* পুরনো সাইটের ধন্যবাদ পাতার লেখাই */}
        <ol className="mt-4 space-y-2 text-left text-sm leading-relaxed text-ink-2">
          <li>১। আমরা কোনো অগ্রিম টাকা নেই না। ইনশাল্লাহ সবাই ক্যাশ অন ডেলিভারিতে পন্য রিসিভ করবেন।</li>
          <li>২। অর্ডার করার পরে আমাদের কল সেন্টার থেকে ফোন করে পন্যের কালার ও সাইজ কনফার্ম করা হবে।</li>
          <li>৩। ঢাকা সিটিতে ১-২ দিনের মধ্যে পন্য পাবেন, ঢাকা সিটির বাইরে ২-৩ দিনের মধ্যে পন্য পাবেন।</li>
        </ol>

        {(social.facebookPage || social.facebookGroup) && (
          <div className="mt-6 border-t border-line pt-5">
            <b className="font-display">আমাদের সাথে যুক্ত হোন</b>
            <p className="mt-1 text-xs text-ink-3">নিয়মিত আপডেট পেতে আমাদের ফেসবুক পেইজ ও গ্রুপের সাথে থাকুন।</p>
            <div className="mt-3 flex flex-wrap justify-center gap-2">
              {social.facebookPage && <a href={social.facebookPage} className="btn-cta px-5 py-2.5 text-sm">ফেসবুক পেইজ</a>}
              {social.facebookGroup && <a href={social.facebookGroup} className="btn-out px-5 py-2.5 text-sm">ফেসবুক গ্রুপ</a>}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default function ThankYou() {
  return <Suspense><Inner /></Suspense>;
}
