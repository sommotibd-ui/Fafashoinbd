# লাইভে নেওয়ার ধাপ — এড না থামিয়ে

পুরনো WordPress শেষ ধাপ পর্যন্ত চালু থাকবে। নতুন সাইট আগে টেস্ট ঠিকানায়
চলবে, সব মিললে তবেই ডোমেইন বদল। এডে কিছু বদলাতে হবে না — লিংক একই।

## ১. GitHub
- [x] রিপো `sommotibd-ui/fafashoinbd` — কোড পুশ করা হয়েছে

## ২. Supabase (নতুন ইমেইলে নতুন অ্যাকাউন্ট)
- [ ] নতুন প্রজেক্ট `fashopbd`, রিজিয়ন **Singapore**
- [ ] SQL Editor-এ এই ক্রমে: `supabase/schema.sql` → `supabase/stock-functions.sql` → `supabase/seed.sql`
- [ ] Storage → `products` নামে **পাবলিক** বাকেট
- [ ] Authentication → Add user → `fa@fashopbd.com`, Auto Confirm ✔ → README-র `insert into admin_users …` লাইন

## ৩. Meta
- [ ] Events Manager → পিক্সেল `2070399363542962` → Settings → Conversions API → **Generate access token**
- [ ] টোকেন শুধু Hostinger-এ বসাবেন, চ্যাটে নয়

## ৪. Pathao (FA-র নিজের মার্চেন্ট অ্যাকাউন্ট)
- [ ] Developer's API → client_id, client_secret; Stores থেকে Store ID
- [ ] নিজে একটা লম্বা র‍্যান্ডম লেখা → `PATHAO_WEBHOOK_PATH`
- [ ] লাইভের পরে Webhook URL `https://fashopbd.com/api/pathao/webhook/<PATHAO_WEBHOOK_PATH>` → সিক্রেট `PATHAO_WEBHOOK_SECRET`

## ৫. Hostinger — টেস্ট ঠিকানায়
- [ ] Web Apps → নতুন Node.js অ্যাপ → GitHub `sommotibd-ui/fafashoinbd` → টেম্প ঠিকানা
- [ ] Environment variables (`.env.example`):
  - `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`
  - `NEXT_PUBLIC_FB_PIXEL_ID=2070399363542962`
  - `FB_CAPI_ACCESS_TOKEN=<৩ নম্বরের টোকেন>`
  - `FB_TEST_EVENT_CODE=<Test events-এর কোড>` ← **শুধু টেস্টের সময়**
  - `NEXT_PUBLIC_SITE_URL=https://fashopbd.com`
  - `REVALIDATE_SECRET=<লম্বা র‍্যান্ডম লেখা>`
  - `PATHAO_BASE_URL=https://api-hermes.pathao.com`, `PATHAO_CLIENT_ID`, `PATHAO_CLIENT_SECRET`, `PATHAO_USERNAME`, `PATHAO_PASSWORD`, `PATHAO_STORE_ID`, `PATHAO_WEBHOOK_SECRET`, `PATHAO_WEBHOOK_PATH`

## ৬. টেস্ট (টেস্ট ঠিকানায়)
- [ ] ৮টা ল্যান্ডিং পেইজ খুলে লেখা, ছবি, দাম মিলিয়ে দেখা
- [ ] magic-dreamfit-bra-তে টেস্ট অর্ডার → `thank-you-5` আসে কিনা
- [ ] Events Manager → Test events: PageView, InitiateCheckout (পেইজ খুলতেই), Purchase — Browser + Server, deduplicated, value ডেলিভারিসহ
- [ ] অ্যাডমিন → পিক্সেল ইভেন্ট: `sent`
- [ ] পুরনো অর্ডার ইমপোর্ট (প্রথমবার) — Claude করবে, তারপর অ্যাডমিনে মিলিয়ে দেখা (৯৭৯টা, মোট ৳৭,৩৬,২৮৭ — ১৪ অক্টোবর পর্যন্ত)
- [ ] টেস্ট অর্ডার মুছে দেওয়া

## ৭. ডোমেইন বদল (রাত ২-৫টা)
- [ ] ⚠️ `FB_TEST_EVENT_CODE` খালি করা
- [ ] পুরনো WordPress-এর ডাটাবেসের পুরো কপি সার্ভারে রাখা (ডোমেইন বদলালে Hostinger-এর পুরনো ব্যাকআপ মুছে যায়)
- [ ] পুরনো WordPress-কে অস্থায়ী ডোমেইনে সরানো, Node অ্যাপে `fashopbd.com` (+www) যোগ
- [ ] পুরনো অর্ডার **আবার** ইমপোর্ট — কাটওভারের মাঝে আসা অর্ডার আর স্ট্যাটাস বদল মেলে
- [ ] SSL চালু হলে `https://fashopbd.com/product/magic-dreamfit-bra/` খুলে দেখা, মোবাইল ডাটায় একটা আসল অর্ডার দিয়ে বাতিল
- [ ] WordPress-এর অস্থায়ী এক্সপোর্ট ফাইল মুছে ফেলা (`fa_export_cleanup()`)

## ৮. প্রথম ২৪ ঘণ্টা
- [ ] Ads Manager-এ Purchase আসছে কিনা, অ্যাডমিনে অর্ডার আসছে কিনা
- [ ] পুরনো WordPress ৭ দিন অস্থায়ী ডোমেইনে রেখে তারপর বন্ধ

## যদি কিছু ভাঙে
Hostinger-এ ডোমেইন আবার পুরনো WordPress-এ ফিরিয়ে দিন — এড একই লিংকে চলছে।
