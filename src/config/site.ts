/* =====================================================================
 *  এক ক্লায়েন্ট = এই একটি ফাইল
 * =====================================================================
 *
 *  নতুন দোকান বানাতে হলে পুরো প্রজেক্ট কপি করে শুধু এই ফাইলটা বদলান,
 *  আর public/img/ ফোল্ডারে লোগো দুটো রাখুন। কোডের আর কোথাও ব্র্যান্ডের
 *  নাম, রং, ফোন নম্বর বা বাংলা লেখা বসানো নেই।
 *
 *  বদলানোর পর:
 *    1. supabase/seed.sql-এ প্রোডাক্ট বসান
 *    2. .env.local-এ কি-গুলো বসান
 *    3. npm run build
 *
 *  ⚠️ রং বদলালে tailwind.config.ts নিজে থেকেই সেটা তুলে নেয় —
 *     ওই ফাইলে হাত দেওয়ার দরকার নেই।
 * ===================================================================== */

export interface SiteConfig {
  name: string;
  tagline: string;
  domain: string;
  description: string;
  logo: string;
  logoSm: string;
  codePrefix: string;
  facebookDomainVerification?: string;
  adminEmailDomain: string;
  words: Words;
  colors: Colors;
  categories: Category[];
  options: OptionAxis;
  colorSuggestions: ColorOption[];
  combos: CombosConfig;
  contact: Contact;
  shipping: Shipping;
  home: HomeContent;
  about: string[];
  returnPolicy: string;
  /** কোন কুরিয়ারে পার্সেল যায় — অ্যাডমিনের বোতাম ও স্ট্যাটাস আপডেট এটা ধরে */
  courier: 'pathao' | 'steadfast';
  /** ধন্যবাদ পাতার বোতাম — খালি থাকলে বোতাম দেখায় না */
  social?: { facebookPage?: string; facebookGroup?: string };
  /** পিক্সেল ইভেন্ট পুরনো সাইটের মতো রাখা — Ads Manager-এর সংখ্যা যেন হঠাৎ না বদলায় */
  tracking: Tracking;
}

interface Tracking {
  /**
   * Purchase-এর value।
   * 'total' = ডেলিভারিসহ (PixelYourSite এভাবেই পাঠাত — order total),
   * 'subtotal' = শুধু পণ্যের দাম।
   */
  purchaseValue: 'total' | 'subtotal';
  /**
   * ল্যান্ডিং পেইজ খুলতেই InitiateCheckout।
   * CartFlows-এ ল্যান্ডিং পেইজটাই চেকআউট পেইজ, তাই পুরনো সাইট পেইজ
   * খোলার সাথে সাথে InitiateCheckout পাঠাত। false হলে ফর্মে হাত দিলে।
   */
  landingCheckoutOnLoad: boolean;
  /** ল্যান্ডিং পেইজে ViewContent — পুরনো সাইট পাঠাত না */
  landingViewContent: boolean;
}

interface Words {
  /** একটি পণ্যকে কী বলব — "পোশাক", "গহনা", "পণ্য" */
  item: string;
  /** মেনুতে ও শপ পেইজে — "সব পোশাক" */
  allItems: string;
  /** সাইজের অক্ষের নাম — "সাইজ", "বয়স", "মাপ" */
  optionAxis: string;
  /** রঙের অক্ষের নাম — "রঙ", "কালার", "ডিজাইন" */
  colorAxis: string;
  /** সার্চ বক্সের হিন্ট */
  searchHint: string;
}

interface Colors {
  ink: string; ink2: string; ink3: string;
  cream: string; sunk: string; line: string;
  brand: string; brandSoft: string; brandDeep: string;
  gold: string; goldBright: string;
  accent: string; accentSoft: string;
  ok: string; warn: string;
}

interface Category { key: string; label: string }

interface OptionAxis {
  /** false হলে সাইজ বাছার ঘরটাই দেখাবে না — এক পণ্যে এক স্টক */
  enabled: boolean;
  /** নতুন প্রোডাক্টে যে ভ্যারিয়েন্টগুলো বসবে */
  values: { key: string; label: string }[];
  /** enabled=false হলে ভেতরে যে একটিমাত্র ভ্যারিয়েন্ট থাকে */
  singleLabel: string;
}

interface ColorOption { key: string; label: string; hex: string }

interface CombosConfig {
  /** false হলে কম্বো অফার পেইজ ও মেনু লুকানো থাকে */
  enabled: boolean;
  /** "৩ পিস সেট" — {n} জায়গায় সংখ্যা বসে */
  unitLabel: string;
  popularTag: string;
}

interface Contact {
  phone: string; whatsapp: string; email: string; address: string; hours: string;
}

interface Shipping { inside: number; outside: number }

interface HomeContent {
  heroBadge: string;
  heroTitle: string;
  /** শিরোনামের যে অংশটা ব্র্যান্ড রঙে আলাদা দেখাবে */
  heroAccent: string;
  heroTail: string;
  heroSub: string;
  chips: string[];
  trust: [string, string, string][];
  featuredTitle: string;
  featuredSub: string;
  categoryTitle: string;
  categorySub: string;
}

/* ===================================================================== */

export const site: SiteConfig = {
  name: 'FA Shop BD',
  tagline: 'Trusted online shop',
  domain: 'fashopbd.com',
  description:
    'আরামদায়ক লেডিস ইনার, শেপওয়্যার, স্লিমিং বেল্ট ও বিউটি পণ্য — সারা বাংলাদেশে ক্যাশ অন ডেলিভারি।',

  logo: '/img/logo.webp',
  logoSm: '/img/logo-sm.webp',

  /** প্রোডাক্ট কোড — FA-01, FA-02 … */
  codePrefix: 'FA',

  /** Meta Business Settings → Brand safety → Domains থেকে নিন */
  facebookDomainVerification: '',

  /** অ্যাডমিন "fa" লিখে লগইন করবে, পেছনে এই ডোমেইন জুড়ে যাবে */
  adminEmailDomain: 'fashopbd.com',

  words: {
    item: 'পণ্য',
    allItems: 'সব পণ্য',
    optionAxis: 'সাইজ',
    colorAxis: 'রঙ',
    searchHint: 'কোড বা পণ্যের নাম লিখে খুঁজুন…',
  },

  /* রং — পুরনো ল্যান্ডিং পেইজের লাল বোতাম (#EA2027) আর বেগুনি শিরোনাম (#341F97) */
  colors: {
    ink: '#1B1530', ink2: '#463F5C', ink3: '#756E8A',
    cream: '#FBF8FC', sunk: '#F3EEF6', line: '#E5DCEB',
    brand: '#EA2027', brandSoft: '#FDE9EA', brandDeep: '#B3121B',
    gold: '#E0A100', goldBright: '#FFC233',
    accent: '#341F97', accentSoft: '#ECE9FA',
    ok: '#1E8E4E', warn: '#B4541C',
  },

  categories: [
    { key: 'ladies-inner', label: 'লেডিস ইনার' },
    { key: 'shapewear', label: 'শেপওয়্যার ও স্লিমিং' },
    { key: 'beauty', label: 'স্কিন কেয়ার' },
    { key: 'ornaments', label: 'গহনা' },
    { key: 'gadget', label: 'গ্যাজেট' },
  ],

  /* সাইজ ও রঙ কল সেন্টার ফোনে নিশ্চিত করে (পুরনো সাইটের নিয়ম) — তাই
     অর্ডারের সময় বাছার ঘর নেই। এক পণ্যে এক স্টক। */
  options: {
    enabled: false,
    values: [{ key: 'one', label: 'এক সাইজ' }],
    singleLabel: 'এক সাইজ',
  },

  colorSuggestions: [
    { key: 'skin',   label: 'স্কিন',     hex: '#E3BFA3' },
    { key: 'pink',   label: 'পিংক',     hex: '#E8739F' },
    { key: 'sky',    label: 'স্কাই',     hex: '#8EC5E8' },
    { key: 'black',  label: 'কালো',     hex: '#1C1C1E' },
    { key: 'white',  label: 'সাদা',     hex: '#FFFFFF' },
  ],

  combos: {
    enabled: false,
    unitLabel: '{n} পিস প্যাক',
    popularTag: 'সবচেয়ে জনপ্রিয়',
  },

  contact: {
    phone: '01988-006609',
    /** wa.me লিংকের জন্য — দেশের কোডসহ, চিহ্ন ছাড়া */
    whatsapp: '8801988006609',
    email: 'mohammadferdous847@gmail.com',
    address: 'Habib Tower, Canelpar Bridge, Delpara, Fatullah, Narayanganj',
    hours: 'প্রতিদিন সকাল ৯টা – রাত ৯টা',
  },

  shipping: { inside: 70, outside: 120 },

  home: {
    heroBadge: '✨ বিশ্বস্ত অনলাইন শপ',
    heroTitle: 'আরাম আর আত্মবিশ্বাসের ',
    heroAccent: 'বিশ্বস্ত ঠিকানা',
    heroTail: '',
    heroSub:
      'লেডিস ইনার, শেপওয়্যার, স্লিমিং বেল্ট আর বিউটি পণ্য — হাতে পেয়ে, দেখে তারপর টাকা দিন।',
    chips: ['ক্যাশ অন ডেলিভারি', 'অগ্রিম টাকা লাগে না', 'সারা দেশে ডেলিভারি'],
    trust: [
      ['🚚', 'ক্যাশ অন ডেলিভারি', 'পণ্য হাতে পেয়ে টাকা দিন'],
      ['✅', '১০০% অরিজিনাল', 'কোয়ালিটি চেক করে পেমেন্ট'],
      ['🔁', 'সহজ এক্সচেঞ্জ', 'কালার বা সাইজের সমস্যায় বদলে নিন'],
      ['📞', 'কল করে নিশ্চিত', 'সাইজ ও কালার ফোনে কনফার্ম'],
    ],
    featuredTitle: 'জনপ্রিয় পণ্য',
    featuredSub: 'এই মুহূর্তে সবচেয়ে বেশি অর্ডার হচ্ছে যেগুলো',
    categoryTitle: 'ক্যাটাগরি থেকে দেখুন',
    categorySub: 'যা খুঁজছেন তা দ্রুত পেতে ক্যাটাগরি বেছে নিন',
  },

  about: [
    'FA Shop BD — নারীদের আরামদায়ক অন্তর্বাস, শেপওয়্যার, স্লিমিং বেল্ট আর বিউটি পণ্যের বিশ্বস্ত অনলাইন শপ।',
    'আমরা কোনো অগ্রিম টাকা নিই না। পণ্য হাতে পেয়ে, দেখে, কোয়ালিটি চেক করে তারপর মূল্য পরিশোধ করবেন।',
    'অর্ডারের পরে আমাদের কল সেন্টার থেকে ফোন করে পণ্যের কালার ও সাইজ নিশ্চিত করা হয়।',
  ],

  returnPolicy:
    'কালার বা সাইজ জনিত যেকোনো সমস্যায় সহজে রিটার্ন বা এক্সচেঞ্জ করতে পারবেন।',

  courier: 'pathao',

  social: { facebookPage: '', facebookGroup: '' },

  /* PixelYourSite-এর সেটিং থেকে মিলিয়ে নেওয়া (অক্টোবর ২০২৬):
     ল্যান্ডিং পেইজে PageView + InitiateCheckout, Purchase = অর্ডারের মোট */
  tracking: {
    purchaseValue: 'total',
    landingCheckoutOnLoad: true,
    landingViewContent: false,
  },
};

/* ---- ছোট সহায়ক ---- */

export const catLabel = (key: string) =>
  site.categories.find((c) => c.key === key)?.label || key;

export const siteUrl =
  process.env.NEXT_PUBLIC_SITE_URL || `https://${site.domain}`;
