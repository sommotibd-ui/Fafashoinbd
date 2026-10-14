/**
 * পুরনো সাইটের লিংক → নতুন ঠিকানা। দোকান-নির্দিষ্ট — নতুন ক্লায়েন্টে
 * দুটো তালিকাই খালি রেখে শুরু করুন।
 *
 * ⚠️ এখানে কখনো এমন লিংক রাখবেন না যেখানে এড চলছে — রিডাইরেক্টে
 * এডের ভিজিটরের একটা বাড়তি আসা-যাওয়া হয়। এড চলা পাতা ল্যান্ডিং পেইজ
 * হিসেবে একই ঠিকানায় বানান।
 */

/** সাধারণ পাতা — next.config.mjs-এ বসে (স্ল্যাশসহ ও ছাড়া দুটোই) */
/** @type {[string, string][]} */
export const legacyRedirects = [
  ['/cart', '/checkout'],
  ['/my-account', '/'],
  ['/sample-page', '/'],
  ['/product-category/:slug*', '/shop'],
];

/**
 * /product/<পুরনো স্লাগ> → নতুন ঠিকানা।
 * এগুলো আলাদা, কারণ WordPress-এর প্রোডাক্ট স্লাগ বাংলায় — next.config-এর
 * রিডাইরেক্ট এনকোড করা বাংলা ঠিকানা নির্ভরযোগ্যভাবে মেলাতে পারে না।
 * তাই ল্যান্ডিং পেইজের রুট (app/lp/[slug]) নিজে এই তালিকা দেখে পাঠায়।
 * কী = ডিকোড করা স্লাগ।
 *
 * @type {Record<string, string>}
 */
export const legacyProductSlugs = {
  // WooCommerce প্রোডাক্ট পেইজ → সেই পণ্যের ল্যান্ডিং পেইজ, না থাকলে দোকানের পাতা
  'ব্রিদেবল-মেশ-ব্রা': '/product/mesh-bra/',
  'organic-collagen-australia-120-capsules': '/product/organic-collagen/',
  'হুক-হিপ-শেপার': '/product/hook-hip-shaper/',
  'প্রিমিয়াম-হাই-ওয়েস্ট-শ': '/product/waist-shapewear/',
  'designing-tops': '/product/FA-15',
  'long-support': '/product/FA-08',
  'tummy-new-shaper': '/product/FA-16',
  'রিমোট-কন্ট্রোল-হোল্ডার': '/product/FA-09',
  '✅ফোম-ছাড়া-ফ্রন্ট-বাটন-ব্': '/product/FA-17',
  'the-ordinary-salicylic-acid-2-solution': '/product/FA-10',
  's-hook-belt': '/product/hook-slimming-belt/',
  'shoulder-support-bra': '/product/FA-19',
  'abdominal-belt': '/product/FA-11',
  'front-button-bra': '/product/FA-20',
  'round-ear-ring': '/product/FA-12',
  'jhumka-ring': '/product/FA-13',
  'blue-dimond-shape-3-in-1-flower-earrings': '/product/FA-14',
  'royal-bloom-earrings': '/product/FA-21',
  'women-jewelry-stainless-steel-dangle-love-heart-drop-necklaces-18k-gold-plated-clavicle-chain-choker-rinlok': '/product/FA-22',
  'elegant-18k-gold-plated-ladies-necklace-copper-pendant-stainless-steel-chain': '/product/FA-23',
  'golden-glow-rose-earrings-24k-edition': '/product/FA-24',
  'rose-flower-diamond-earrings': '/product/FA-25',
  'slimming-belt': '/product/FA-26',
};
