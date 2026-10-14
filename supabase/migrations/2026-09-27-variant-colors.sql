-- সাইজের পাশাপাশি রঙ
--
-- আগে প্রতিটি প্রোডাক্টের ভ্যারিয়েন্ট ছিল একটাই অক্ষে — সাইজ। এখন দুটো:
-- সাইজ আর রঙ। প্রতিটি সারি এখন একটি জোড়া — "লাল ৩৬", "কালো ৩৬"।
-- স্টক গোনা হয় ওই জোড়া ধরে, তাই একটা রঙের একটা সাইজ শেষ হলে শুধু
-- সেটাই "স্টক নেই" দেখায়, বাকিগুলো বিক্রি হতে থাকে।
--
-- পুরনো ৪২টি প্রোডাক্ট অক্ষত থাকে: তাদের color_key হয় খালি স্ট্রিং,
-- যার মানে "এই পণ্যের রঙের ঘর নেই"। প্রোডাক্ট পেইজে তখন রঙ বাছার
-- ঘরটাই দেখায় না, আগে যেমন ছিল ঠিক তেমনই।
--
-- Supabase → SQL Editor-এ একবার চালান।

-- ১) ভ্যারিয়েন্টে রঙের ঘর
alter table product_variants add column if not exists color_key   text not null default '';
alter table product_variants add column if not exists color_label text;
alter table product_variants add column if not exists color_hex   text;

-- ২) একই প্রোডাক্টে একই সাইজ একাধিক রঙে থাকতে পারবে।
--    পুরনো নিয়মটা (product_id + opt_key) সেটা আটকে দিত।
alter table product_variants drop constraint if exists product_variants_product_id_opt_key_key;
create unique index if not exists variants_combo_uniq
  on product_variants (product_id, opt_key, color_key);

-- ৩) অর্ডারেও রঙটা লিখে রাখি।
--    ইচ্ছে করেই ভ্যারিয়েন্টের আইডি নয়, নাম — পরে ওই রঙটা দোকান থেকে
--    তুলে দিলেও পুরনো অর্ডারে "লাল" লেখাটা থেকে যাবে।
alter table order_items add column if not exists color_key   text;
alter table order_items add column if not exists color_label text;
