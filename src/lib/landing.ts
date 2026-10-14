import type { Product } from './types';

/* ---------------------------------------------------------------------
 *  এই ফাইলে শুধু ধরন আর ছোট হিসাব — ব্রাউজারেও লাগে। ডাটাবেস থেকে পড়া
 *  landing-data.ts-এ, নইলে Supabase-এর পুরো লাইব্রেরি ফোনে চলে যেত।
 *
 *  ল্যান্ডিং পেইজের অংশ — CartFlows/Elementor-এর উইজেটের বদলে।
 *  ইচ্ছে করেই অল্প কয়েকটা ধরন: এতেই পুরনো সব পেইজ বানানো গেছে, আর
 *  কম ধরন মানে অ্যাডমিন থেকে ভুল করার সুযোগও কম।
 * ------------------------------------------------------------------- */
export type Img = { src: string; w: number; h: number; alt?: string; caption?: string };

export type Block =
  | { t: 'heading'; text: string; size?: 'xl' | 'lg' | 'md' }
  | { t: 'text'; text: string }
  | { t: 'image'; img: Img }
  | { t: 'gallery'; images: Img[]; cols?: 1 | 2 | 3 }
  | { t: 'video'; url: string }
  | { t: 'list'; title?: string; items: string[] }
  | { t: 'features'; title?: string; items: { title: string; desc?: string }[] }
  | { t: 'compare'; title?: string; bad: { title: string; items: string[] }; good: { title: string; items: string[] } }
  | { t: 'cta'; text?: string };

export interface Tier {
  qty: number;
  /** ওই সংখ্যার মোট দাম — প্রতি পিসের নয় */
  price: number;
  label?: string;
  tag?: string;
  default?: boolean;
}

export interface Landing {
  id: string;
  slug: string;
  product_id: string | null;
  title: string;
  blocks: Block[];
  tiers: Tier[];
  form_title: string | null;
  note_label: string | null;
  note_required: boolean;
  thankyou_slug: string | null;
  active: boolean;
  product?: Product | null;
}

/** তালিকার মধ্যে যেটা আগে থেকে বাছা থাকবে */
export const defaultTier = (tiers: Tier[]) => tiers.find((t) => t.default) || tiers[0];

/** কাটা দাম — এক পিসের দাম × সংখ্যা। বেশি না হলে দেখানোর মানে নেই। */
export const tierCompare = (t: Tier, unitPrice: number) =>
  unitPrice * t.qty > t.price ? unitPrice * t.qty : null;

/**
 * অ্যাডমিন থেকে আসা দাম-ধাপ পরিষ্কার করা — সার্ভার এটার উপর ভরসা করে
 * দাম হিসাব করে, তাই আজেবাজে মান এখানেই আটকানো।
 */
export function cleanTiers(raw: unknown): Tier[] {
  if (!Array.isArray(raw)) return [];
  const seen = new Set<number>();
  const out: Tier[] = [];
  for (const r of raw as any[]) {
    const qty = Math.round(Number(r?.qty));
    const price = Math.round(Number(r?.price));
    if (!(qty >= 1 && qty <= 50) || !(price > 0) || seen.has(qty)) continue;
    seen.add(qty);
    out.push({
      qty, price,
      label: String(r?.label || '').trim() || undefined,
      tag: String(r?.tag || '').trim() || undefined,
      default: !!r?.default,
    });
  }
  return out.sort((a, b) => a.qty - b.qty);
}
