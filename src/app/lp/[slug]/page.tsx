import { notFound, permanentRedirect } from 'next/navigation';
import { legacyProductSlugs } from '@/config/redirects.mjs';
import { defaultTier } from '@/lib/landing';
import { getLanding, getLandingByThankyou, getLandings } from '@/lib/landing-data';
import { getSettings } from '@/lib/catalog';
import { siteUrl } from '@/config/site';
import LandingBlocks from '@/components/LandingBlocks';
import LandingOrder from '@/components/LandingOrder';
import ThankYou from '@/components/ThankYou';

export const revalidate = 300;

export async function generateStaticParams() {
  const all = await getLandings();
  return all.flatMap((l) => [{ slug: l.slug }, ...(l.thankyou_slug ? [{ slug: l.thankyou_slug }] : [])]);
}

export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const l = await getLanding(slug);
  if (l) {
    const img = l.product?.images?.[0];
    return {
      title: l.title,
      description: `${l.product?.name || l.title} — ক্যাশ অন ডেলিভারি।`,
      // পুরনো সাইটের ঠিকানাটাই আসল — স্ল্যাশসহ
      alternates: { canonical: `${siteUrl}/product/${l.slug}/` },
      openGraph: img ? { images: [img.startsWith('http') ? img : `${siteUrl}${img}`] } : undefined,
    };
  }
  if (await getLandingByThankyou(slug)) return { title: 'ধন্যবাদ', robots: { index: false } };
  return {};
}

export default async function LandingPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const [l, settings] = await Promise.all([getLanding(slug), getSettings()]);

  if (!l) {
    const owner = await getLandingByThankyou(slug);
    if (owner) return <ThankYou />;
    // পুরনো WooCommerce প্রোডাক্ট লিংক (বাংলা স্লাগ)
    const to = (legacyProductSlugs as Record<string, string>)[safeDecode(slug)];
    if (to) permanentRedirect(to);
    notFound();
  }
  if (!l.product || !l.tiers.length) notFound();

  return (
    <div className="mx-auto max-w-3xl px-4 pb-6 pt-5">
      <LandingBlocks blocks={l.blocks} />
      <LandingOrder
        slug={l.slug}
        product={{
          code: l.product.code,
          fbId: l.product.fb_id || l.product.code,
          name: l.product.name,
          price: l.product.price,
          image: l.product.images?.[0] || '',
          optKey: l.product.product_variants?.[0]?.opt_key || 'one',
        }}
        tiers={l.tiers}
        initialQty={defaultTier(l.tiers).qty}
        shipping={settings.shipping}
        formTitle={l.form_title}
        noteLabel={l.note_label}
        noteRequired={l.note_required}
        thankyou={l.thankyou_slug}
      />
    </div>
  );
}

function safeDecode(s: string) {
  try { return decodeURIComponent(s); } catch { return s; }
}
