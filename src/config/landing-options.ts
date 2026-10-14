/**
 * ল্যান্ডিং পেইজের অর্ডার ফর্মে সাইজ ও কালারের ঘর।
 *
 * কাস্টমার নিজে লিখে দেয় (একাধিক পিস হলে যেমন "৩৬, ৩৮")। লেখাটা অর্ডারের
 * নোটে বসে ("সাইজ: ৩৬, ৩৮ · কালার: স্কিন, পার্পল") — অ্যাডমিনের অর্ডার
 * তালিকায় সরাসরি দেখা যায়।
 *
 * কোন পেইজে লাগবে, স্লাগ ধরে এখানে লিখুন। না থাকলে ফর্ম আগের মতোই।
 */
export interface LandingOptions {
  size?: boolean;
  color?: boolean;
}

export const landingOptions: Record<string, LandingOptions> = {
  'magic-dreamfit-bra': { size: true, color: true },
};

/** ব্রাউজার ও সার্ভার দুই জায়গাতেই এক নিয়ম */
export function optionsNote(size?: string, color?: string) {
  return [size?.trim() && `সাইজ: ${size.trim()}`, color?.trim() && `কালার: ${color.trim()}`]
    .filter(Boolean).join(' · ');
}
