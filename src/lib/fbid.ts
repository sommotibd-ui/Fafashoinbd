/**
 * পিক্সেলে পণ্যের পরিচয় (content_id)।
 *
 * পুরনো সাইটে PixelYourSite WooCommerce-এর প্রোডাক্ট আইডি পাঠাত (যেমন 1483)।
 * Meta-র অডিয়েন্স, ক্যাটালগ আর রিপোর্ট সেই আইডিতে বাঁধা — নতুন কোড (FA-01)
 * পাঠালে Meta এগুলোকে নতুন পণ্য ভাবত। তাই পুরনো আইডিটাই পাঠাই, নতুন
 * পণ্যে (fb_id খালি) নিজের কোড।
 */
export const fbId = (p: { fb_id?: string | null; code: string }) => p.fb_id || p.code;
export const lineFbId = (l: { fbId?: string | null; code: string }) => l.fbId || l.code;
