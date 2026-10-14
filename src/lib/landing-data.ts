import { unstable_cache } from 'next/cache';
import { supabasePublic } from './supabase';
import type { Landing } from './landing';

const SELECT =
  '*, product:products(*, product_variants(id, product_id, opt_key, opt_label, color_key, color_label, color_hex, stock, sort))';

export const getLandings = unstable_cache(
  async (): Promise<Landing[]> => {
    const { data } = await supabasePublic().from('landing_pages').select(SELECT).eq('active', true).order('sort');
    return (data || []) as Landing[];
  },
  ['landings'],
  { tags: ['catalog', 'landing'], revalidate: 300 },
);

export const getLanding = async (slug: string) =>
  (await getLandings()).find((l) => l.slug === slug.toLowerCase()) || null;

/** /product/thank-you-3/ — কোন পেইজের ধন্যবাদ পাতা */
export const getLandingByThankyou = async (slug: string) =>
  (await getLandings()).find((l) => l.thankyou_slug === slug.toLowerCase()) || null;
