-- =====================================================================
--  ল্যান্ডিং পেইজ (CartFlows-এর বদলে)
--  পুরনো ইনস্টলে একবার চালান। নতুন সাইটে লাগে না — schema.sql-এ আছে।
-- =====================================================================

-- এক পেইজ = এক পণ্য + তার অফার। কম্বো টেবিলটা পুরো দোকানের জন্য এক,
-- কিন্তু ল্যান্ডিং পেইজে প্রতিটা পণ্যের নিজস্ব দাম-ধাপ লাগে
-- (ব্রা ২টা ৳৯৫০, টামি শেপার ২টা ৳১,২০০) — তাই আলাদা টেবিল।
create table if not exists landing_pages (
  id            uuid primary key default gen_random_uuid(),
  slug          text not null unique,               -- /product/<slug>/ — এডের লিংক এটাই, বদলাবেন না
  product_id    uuid references products(id) on delete set null,
  title         text not null,                      -- ব্রাউজার ট্যাব ও শেয়ারের শিরোনাম
  blocks        jsonb not null default '[]',        -- পেইজের অংশগুলো ক্রমানুসারে
  -- [{ "qty": 2, "price": 950, "label": "২ পিস", "tag": "জনপ্রিয়", "default": true }]
  -- price = ওই সংখ্যার মোট দাম, প্রতি পিসের নয়
  tiers         jsonb not null default '[]',
  form_title    text,
  note_label    text,                               -- যেমন "পছন্দের ড্রেসের কোড" — খালি হলে ঘরটাই নেই
  note_required boolean not null default false,
  thankyou_slug text,                               -- অর্ডারের পরে /product/<এটা>/ — পুরনো সাইটের মতোই
  active        boolean not null default true,
  sort          integer not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);
create index if not exists landing_thankyou_idx on landing_pages (thankyou_slug);

drop trigger if exists t_landing_touch on landing_pages;
create trigger t_landing_touch before update on landing_pages
  for each row execute function touch_updated_at();

alter table landing_pages enable row level security;

drop policy if exists "public reads active landing" on landing_pages;
create policy "public reads active landing" on landing_pages
  for select to anon, authenticated using (active);

drop policy if exists "admin all landing" on landing_pages;
create policy "admin all landing" on landing_pages for all to authenticated
  using (is_admin()) with check (is_admin());

-- কোন পেইজ থেকে অর্ডার এল — এড অনুযায়ী হিসাবের জন্য
alter table orders add column if not exists landing_slug text;
create index if not exists orders_landing_idx on orders (landing_slug, created_at desc);

-- ৩ পিস ৳১,৩৯০ হলে প্রতি পিস ৳৪৬৩.৩৩ — পূর্ণসংখ্যায় রাখলে ৩ × ৪৬৩ = ১,৩৮৯
-- হয়ে এক টাকা হারায়। তাই সারির আসল মোটটা আলাদা করে রাখা।
alter table order_items add column if not exists line_total integer;
