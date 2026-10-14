# fashopbd.com — FA Shop BD

লেডিস ইনার, শেপওয়্যার, স্লিমিং বেল্ট, স্কিন কেয়ার ও গহনা। ফেইসবুক এড →
ল্যান্ডিং পেইজ → ক্যাশ অন ডেলিভারি। আগে WordPress + CartFlows + PixelYourSite
ছিল, অক্টোবর ২০২৬-এ এই স্ট্যাকে আনা হচ্ছে। sohashopbd-র কোড থেকে বানানো
(টেমপ্লেট `bd-shop-kit`), পুরনো অর্ডার ইমপোর্ট mtmshopbd থেকে।

**মালিক:** Tamim · কথা বলুন **বাংলায়**।

## স্ট্যাক

| কী | কোথায় |
|---|---|
| কোড | `github.com/sommotibd-ui/fafashoinbd` (প্রাইভেট, sommotibd-ui অ্যাকাউন্টে) |
| হোস্টিং | Hostinger Cloud → Web Apps (Node.js), GitHub থেকে অটো-ডিপ্লয় |
| ডাটাবেস | Supabase — নতুন ইমেইলে নতুন অ্যাকাউন্ট, প্রজেক্ট `fashopbd`, Singapore |
| কুরিয়ার | Pathao (`site.ts → courier`) |
| ট্র্যাকিং | Meta Pixel `2070399363542962` (পুরনো সাইটেরটাই) + Conversions API |

## এড চলছে — যা কখনো বদলাবেন না

- ল্যান্ডিং পেইজ (শেষের স্ল্যাশসহ): `/product/magic-dreamfit-bra/` (অক্টোবর ২০২৬-এ
  প্রায় সব অর্ডার এখান থেকে), `/product/mesh-bra/`, `/product/magnetic-slimming-belt/`,
  `/product/hook-slimming-belt/`, `/product/hook-belt/`, `/product/hook-hip-shaper/`,
  `/product/waist-shapewear/`, `/product/organic-collagen/`।
- ধন্যবাদ পাতা: `thank-you-5`, `thank-you-5-2`, `thank-you-4`, `thank-you`,
  `thank-you-woo`, `thank-you-2-2`, `thank-you-2`, `thank-you-3`।
- পিক্সেল আইডি।

## ট্র্যাকিং — PixelYourSite-এর মতোই (`site.ts → tracking`)

- ল্যান্ডিং পেইজ খুলতেই **PageView + InitiateCheckout** (CartFlows-এ পেইজটাই
  চেকআউট ছিল)। ViewContent পাঠানো হয় না — পুরনো সাইটও পাঠাত না।
- Purchase value = **ডেলিভারিসহ মোট** (PYS `order->get_total()`)।
- content_id = পুরনো WooCommerce প্রোডাক্ট আইডি (`products.fb_id`, যেমন 1483)।
- প্রতিটা ইভেন্ট ব্রাউজার + সার্ভার, একই event_id। Purchase সার্ভার থেকে
  `/api/order`-এ, ব্রাউজারেরটা অর্ডারের পরে।

## দাম (CartFlows থেকে, আসল অর্ডারের সাথে মিলিয়ে)

ম্যাজিক ব্রা ৪৮০/৯০০/১২০০ · মেশ ব্রা ৪৫০/৮৫০/১২০০ (৩ পিস আগে বাছা) ·
ম্যাগনেটিক বেল্ট ৪৯০/৯০০ · হুক বেল্ট ৪৫০/৮৫৯ · হিপ শেপার ৫৯৯ ·
ওয়েস্ট শেপওয়্যার ৬৯০ · কোলাজেন ১১৯০। ডেলিভারি ঢাকা ৭০ / বাইরে ১২০
("বাইরে" আগে থেকে বাছা, পুরনো চেকআউটের মতো)।

পুরনো পেইজের লেখায় দুটো অমিল ছিল, হুবহু রাখা: hook-belt-এ লেখা ৪২০/৭৯৯
(চার্জ হয় ৪৫০/৮৫৯), waist-shapewear-এ লেখা ৮৯০ (চার্জ হয় ৬৯০)।

## পুরনো অর্ডার

WooCommerce-এর অর্ডার (#২১০৫ পর্যন্ত, trash বাদে ৯৭৯টা) তাদের আসল নম্বরেই
(`wp_order_id`)। নতুন অর্ডার #৩০০১ থেকে। এক্সপোর্ট `scripts/wp-export.php`
(WordPress-এ চলে, এলোমেলো নামের JSON লেখে), ইমপোর্ট
`POST /api/admin/wp-import {url}` (অ্যাডমিন লগইন লাগে)। বারবার চালানো নিরাপদ।
"Completed" → delivered। আগের চেকআউটের কালার/সাইজ ঘর নোটে।

## যা মনে রাখতে হবে

- **পুরনো WordPress ম্যালওয়্যারে আক্রান্ত** (sohashopbd-র মতোই: `sc_*` অপশন,
  mu-plugins `retro-wrapper-go.php`, Ethereum RPC; শেষ সক্রিয় ২৩ সেপ্টেম্বর ২০২৬)।
  সন্দেহজনক অ্যাডমিন: `backup_d31f26`, `root`। ওখান থেকে শুধু লেখা আর ছবি আনা
  (ছবি দুবার নতুন করে এনকোড)। ফাইল মুছবেন না, রিনেম করুন।
- ল্যান্ডিং পেইজ ও প্রোডাক্ট `scripts/make_seed.py` থেকে `supabase/seed.sql`।
- সাইজ-কালার ফর্মে নেই — কল সেন্টার ফোনে নেয়। এক পণ্যে এক স্টকের ঘর।
- **কোনো কি বা টোকেন চ্যাটে দেখাবেন না** — Tamim নিজে বসান।
- **ডাটাবেস মাইগ্রেশন আগে, পুশ পরে।**
- লাইভে যাওয়ার ধাপ: `GO-LIVE.md`।

## কাজের ধরন

Tamim ডেভেলপার নন — ব্যাখ্যা নয়, কাজ চান। কোডের মন্তব্য বাংলায়।
পরিবর্তন লাইভে যাচাই করে তারপর বলবেন যে হয়েছে।
