-- =====================================================================
--  Pathao কুরিয়ার + কাস্টমারের ডেলিভারি সাকসেস রেট
--  পুরনো ইনস্টলে একবার চালান। নতুন সাইটে লাগে না — schema.sql-এ আছে।
-- =====================================================================

-- Pathao থেকে আনা কাস্টমারের ইতিহাস (সব মার্চেন্ট মিলিয়ে), ফোন নম্বর ধরে।
-- ক্যাশ — একই নম্বর ২৪ ঘণ্টায় একবারের বেশি Pathao-কে জিজ্ঞেস করা হয় না।
create table if not exists customer_courier_stats (
  phone       text primary key,                    -- 01XXXXXXXXX
  courier     text not null default 'pathao',
  total       integer not null default 0,           -- মোট পার্সেল
  success     integer not null default 0,           -- ডেলিভার্ড
  rating      text,                                 -- excellent_customer, risky_customer …
  error       text,                                 -- শেষবার আনতে না পারলে কেন
  fetched_at  timestamptz not null default now()
);
alter table customer_courier_stats enable row level security;
drop policy if exists "admin reads courier stats" on customer_courier_stats;
create policy "admin reads courier stats" on customer_courier_stats for select to authenticated
  using (is_admin());

-- কুরিয়ারের চার্জ — লাভ-ক্ষতির হিসাবের জন্য
alter table orders add column if not exists courier_fee integer;
