'use client';

import { useEffect, useRef, useState } from 'react';
import Image from 'next/image';
import { useRouter } from 'next/navigation';
import { bn, tk } from '@/lib/money';
import { tierCompare, type Tier } from '@/lib/landing';
import { track, trackPurchaseBrowser, ensureFbc, getFbp, getFbc, getFbclid } from './Pixel';
import { site } from '@/config/site';
import { landingOptions, optionsNote } from '@/config/landing-options';

interface P { code: string; fbId: string; name: string; price: number; image: string; optKey: string }

/**
 * ল্যান্ডিং পেইজের অফার বাছাই + অর্ডার ফর্ম — CartFlows চেকআউটের বদলে।
 *
 * পুরনো ফর্মের মতোই শুধু নাম, ফোন, ঠিকানা আর ডেলিভারি এলাকা। সাইজ-রঙ
 * এখানে চাওয়া হয় না — কল সেন্টার ফোন করে নিশ্চিত করে (পেইজেই লেখা আছে)।
 * ফর্মে ঘর বাড়ালে অর্ডার কমে, তাই ধরন বদলানো হয়নি।
 */
export default function LandingOrder({
  slug, product, tiers, initialQty, shipping, formTitle, noteLabel, noteRequired, thankyou,
}: {
  slug: string; product: P; tiers: Tier[]; initialQty: number;
  shipping: { inside: number; outside: number };
  formTitle: string | null; noteLabel: string | null; noteRequired: boolean; thankyou: string | null;
}) {
  const router = useRouter();
  const [qty, setQty] = useState(initialQty);
  // সাইজ-কালার — কাস্টমার নিজে লিখে দেয়
  const opts = landingOptions[slug];
  // পুরনো চেকআউটে "ঢাকা সিটির বাইরে" আগে থেকে বাছা থাকত (৭০% অর্ডার বাইরের)
  const [city, setCity] = useState<'inside' | 'outside'>('outside');
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState('');
  const [done, setDone] = useState<{ orderNo: number; total: number } | null>(null);
  const openedAt = useRef(Date.now());
  const icFired = useRef(false);

  const tier = tiers.find((t) => t.qty === qty) || tiers[0];
  const ship = shipping[city];
  const total = tier.price + ship;

  const evParams = (t: Tier) => ({
    value: t.price, currency: 'BDT', content_type: 'product',
    content_ids: [product.fbId], content_name: product.name, num_items: t.qty,
    contents: [{ id: product.fbId, quantity: t.qty, item_price: Math.round(t.price / t.qty) }],
  });

  /**
   * পাতা খোলার ইভেন্ট — একবার।
   *
   * পুরনো সাইটে (CartFlows) ল্যান্ডিং পেইজটাই চেকআউট পেইজ, তাই
   * PixelYourSite পাতা খুলতেই InitiateCheckout পাঠাত, ViewContent নয়।
   * এড সেট বা কাস্টম কনভার্শন সেই সংখ্যায় অভ্যস্ত — তাই একই রাখা
   * (site.ts → tracking)।
   */
  useEffect(() => {
    openedAt.current = Date.now();
    // এই effect পিক্সেলের effect-এর আগে চলে — তাই _fbc কুকি এখানেই বসাই,
    // নইলে প্রথম ইভেন্টটা এডের ক্লিক-আইডি ছাড়া যেত
    ensureFbc();
    if (site.tracking.landingViewContent) track('ViewContent', evParams(tier));
    if (site.tracking.landingCheckoutOnLoad) {
      icFired.current = true;
      track('InitiateCheckout', evParams(tier));
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // InitiateCheckout — ফর্মে হাত দিলে, একবারই (CheckoutForm-এর মতো)
  function onFormStart() {
    if (icFired.current) return;
    icFired.current = true;
    track('InitiateCheckout', evParams(tier));
  }

  async function submit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    if (busy) return;
    setErr(''); setBusy(true);

    const f = new FormData(e.currentTarget);
    const utm = new URLSearchParams(window.location.search);

    let res: Response;
    try {
      res = await fetch('/api/order', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: f.get('name'), phone: f.get('phone'), address: f.get('address'),
          cityType: city,
          note: [f.get('note'), opts ? optionsNote(String(f.get('size') || ''), String(f.get('color') || '')) : ''].filter(Boolean).join(' · ') || null,
          website: f.get('website'),
          elapsed: Date.now() - openedAt.current,
          landing: slug,
          items: [{ code: product.code, optKey: product.optKey, colorKey: '', qty: tier.qty }],
          fbp: getFbp(), fbc: getFbc(), fbclid: getFbclid(),
          landingUrl: window.location.href,
          referrer: document.referrer || null,
          utm: {
            source: utm.get('utm_source'), medium: utm.get('utm_medium'),
            campaign: utm.get('utm_campaign'), content: utm.get('utm_content'),
            term: utm.get('utm_term'),
          },
        }),
      });
    } catch {
      setBusy(false);
      setErr('ইন্টারনেট সংযোগে সমস্যা হচ্ছে। আবার চেষ্টা করুন।');
      return;
    }

    const j = await res.json().catch(() => null);
    if (!res.ok || !j?.ok) {
      setBusy(false);
      setErr(j?.error || 'অর্ডার নেওয়া যায়নি। আবার চেষ্টা করুন।');
      return;
    }

    // সার্ভার আগেই Purchase পাঠিয়েছে; এটা একই event_id-র ব্রাউজার জোড়া
    trackPurchaseBrowser(j.eventId, { ...evParams(tier), value: j.value, order_id: String(j.orderNo) });

    /**
     * পুরনো সাইটের মতোই আলাদা ধন্যবাদ পাতায় যাই (/product/thank-you-3/)।
     * এডে যদি "URL-এ thank-you আছে" ধরনের কাস্টম কনভার্শন থাকে, সেটা
     * এতে চালু থাকে। পাতা বদল ক্লায়েন্টেই হয়, তাই পিক্সেলের রিকোয়েস্ট
     * মাঝপথে কাটা পড়ে না।
     */
    if (thankyou) {
      router.push(`/product/${thankyou}/?o=${j.orderNo}&t=${j.total}`);
      return;
    }
    setBusy(false);
    setDone({ orderNo: j.orderNo, total: j.total });
  }

  if (done) {
    return (
      <section id="order" className="mt-8 rounded-3xl border border-line bg-white p-8 text-center">
        <p className="text-5xl">🎉</p>
        <h2 className="mt-3 font-display text-2xl font-extrabold">অর্ডার সফল হয়েছে</h2>
        <p className="mt-2 text-ink-2">অর্ডার নম্বর <b className="tabular-nums">#{bn(done.orderNo)}</b> · মোট <b className="tabular-nums">{tk(done.total)}</b></p>
        <p className="mt-3 text-sm text-ink-3">আমরা শীঘ্রই কল করে অর্ডারটি নিশ্চিত করবো। ফোন খোলা রাখবেন।</p>
      </section>
    );
  }

  return (
    <section id="order" className="mt-8 scroll-mt-4 rounded-3xl border-2 border-brand bg-white p-5 sm:p-7">
      {/* পুরনো পেইজের বোতামগুলো "#check" আর "#order" — দুটো লিংকই এখানে আনে */}
      <span id="check" className="block scroll-mt-4" aria-hidden="true" />
      <h2 className="text-center font-display text-xl font-extrabold sm:text-2xl">
        {formTitle || 'অর্ডার করতে নিচের ফর্মটি পূরণ করুন'}
      </h2>

      {/* অফার বাছাই */}
      <div className="mt-5 space-y-2.5" role="radiogroup" aria-label="অফার">
        {tiers.map((t) => {
          const was = tierCompare(t, product.price);
          const on = t.qty === tier.qty;
          return (
            <label key={t.qty}
              className={`relative flex cursor-pointer items-center gap-3 rounded-xl border-2 p-3 transition ${
                on ? 'border-brand bg-brand-soft' : 'border-line hover:border-brand/50'}`}>
              <input type="radio" name="tier" checked={on} onChange={() => setQty(t.qty)} className="h-5 w-5 accent-brand" />
              {product.image && (
                <Image src={product.image} alt="" width={52} height={52} className="h-[52px] w-[52px] shrink-0 rounded-lg border border-line object-cover" />
              )}
              <span className="min-w-0 flex-1">
                <b className="block font-display leading-tight">{t.label || `${product.name} — ${bn(t.qty)} পিস`}</b>
                {t.tag && <span className="mt-1 inline-block rounded-full bg-gold-bright px-2 py-0.5 text-[11px] font-bold text-ink">{t.tag}</span>}
              </span>
              <span className="text-right">
                <b className="block font-display text-lg text-brand tabular-nums">{tk(t.price)}</b>
                {was && <s className="block text-xs text-ink-3 tabular-nums">{tk(was)}</s>}
              </span>
            </label>
          );
        })}
      </div>

      <form onSubmit={submit} onFocus={onFormStart} className="mt-6">
        <label className="mb-1.5 block text-sm font-semibold" htmlFor="lp-name">আপনার নাম <span className="text-brand">*</span></label>
        <input id="lp-name" name="name" required autoComplete="name" placeholder="আপনার নাম লিখুন" className="field mb-4" />

        <label className="mb-1.5 block text-sm font-semibold" htmlFor="lp-phone">মোবাইল নম্বর <span className="text-brand">*</span></label>
        <input id="lp-phone" name="phone" required type="tel" inputMode="numeric" autoComplete="tel"
          placeholder="০১XXXXXXXXX" className="field mb-4" />

        <label className="mb-1.5 block text-sm font-semibold" htmlFor="lp-address">সম্পূর্ণ ঠিকানা <span className="text-brand">*</span></label>
        <textarea id="lp-address" name="address" required autoComplete="street-address" rows={2}
          placeholder="বাসা/রোড, এলাকা, থানা, জেলা" className="field mb-4" />

        {opts?.size && (
          <>
            <label className="mb-1.5 block text-sm font-semibold" htmlFor="lp-size">সাইজ <span className="text-brand">*</span></label>
            <input id="lp-size" name="size" required placeholder={tier.qty > 1 ? 'যেমন: ৩৬, ৩৮' : 'যেমন: ৩৬'} className="field mb-4" />
          </>
        )}
        {opts?.color && (
          <>
            <label className="mb-1.5 block text-sm font-semibold" htmlFor="lp-color">কালার <span className="text-brand">*</span></label>
            <input id="lp-color" name="color" required placeholder={tier.qty > 1 ? 'যেমন: স্কিন, পার্পল' : 'যেমন: স্কিন'} className="field mb-4" />
          </>
        )}

        {noteLabel && (
          <>
            <label className="mb-1.5 block text-sm font-semibold" htmlFor="lp-note">
              {noteLabel} {noteRequired && <span className="text-brand">*</span>}
            </label>
            <input id="lp-note" name="note" required={noteRequired} className="field mb-4" />
          </>
        )}

        <p className="mb-1.5 text-sm font-semibold">ডেলিভারি এলাকা <span className="text-brand">*</span></p>
        <div className="mb-5 grid grid-cols-2 gap-2.5">
          {([['inside', 'ঢাকা সিটি', shipping.inside], ['outside', 'ঢাকা সিটির বাইরে', shipping.outside]] as const).map(([v, t, c]) => (
            <label key={v} className={`flex cursor-pointer items-center gap-2 rounded-lg border-2 p-3 ${
              city === v ? 'border-brand bg-brand-soft' : 'border-line'}`}>
              <input type="radio" name="city" value={v} checked={city === v} onChange={() => setCity(v)} className="accent-brand" />
              <span className="text-sm"><b className="block font-display">{t}</b><span className="text-ink-3 tabular-nums">{tk(c)}</span></span>
            </label>
          ))}
        </div>

        <input type="text" name="website" tabIndex={-1} autoComplete="off" aria-hidden="true"
          className="absolute -left-[9999px] h-px w-px" />

        <dl className="mb-5 rounded-xl bg-sunk p-4 text-sm">
          <div className="flex justify-between py-1"><dt>{product.name} × {bn(tier.qty)}</dt><dd className="tabular-nums">{tk(tier.price)}</dd></div>
          <div className="flex justify-between py-1"><dt>ডেলিভারি চার্জ</dt><dd className="tabular-nums">{tk(ship)}</dd></div>
          <div className="mt-1 flex justify-between border-t border-line pt-2 font-display text-lg font-extrabold">
            <dt>সর্বমোট</dt><dd className="text-brand tabular-nums">{tk(total)}</dd>
          </div>
        </dl>

        {err && <p className="mb-4 rounded-lg bg-pinkc-soft px-4 py-3 text-sm font-semibold text-pinkc">{err}</p>}

        <button disabled={busy} className="btn-cta w-full py-4 text-lg disabled:opacity-60">
          {busy ? 'অর্ডার পাঠানো হচ্ছে…' : `অর্ডার কনফার্ম করুন · ${tk(total)}`}
        </button>
        <p className="mt-3 text-center text-xs text-ink-3">💵 ক্যাশ অন ডেলিভারি — পণ্য হাতে পেয়ে টাকা দেবেন</p>
      </form>
    </section>
  );
}
