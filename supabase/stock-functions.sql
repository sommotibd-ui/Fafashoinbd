-- =====================================================================
-- স্টক অ্যাটমিকভাবে কমানো-বাড়ানো
--
-- কেন দরকার:
--   আগে কোড করত — স্টক পড়ো, বিয়োগ করো, লিখে দাও। দুজন ক্রেতা একই
--   সাইজে একই মুহূর্তে অর্ডার করলে দুজনেই পুরনো সংখ্যাটা পড়ত, আর
--   দুজনেই একই নতুন সংখ্যা লিখত — ২ পিস বিক্রি হয়ে স্টক কমত ১।
--   ভাইরাল বিজ্ঞাপনে একটা সাইজ শেষ হওয়ার সময় ঠিক এটাই ঘটে।
--
--   এখানে পড়া আর লেখা একই UPDATE-এ, তাই Postgres নিজেই সারি লক করে।
--   দ্বিতীয়জন প্রথমজনের লেখা সংখ্যাটাই দেখে।
-- =====================================================================

-- স্টক ধরে রাখা। স্টক কম পড়লে null ফেরত — অর্ডার নেওয়া হবে না।
create or replace function reserve_stock(p_variant_id uuid, p_qty integer)
returns integer
language plpgsql
as $$
declare
  left_stock integer;
begin
  if p_qty is null or p_qty <= 0 then
    return null;
  end if;

  update product_variants
     set stock = stock - p_qty
   where id = p_variant_id
     and stock >= p_qty          -- এই শর্তেই ওভারসেলিং আটকায়
  returning stock into left_stock;

  return left_stock;             -- null = পর্যাপ্ত স্টক ছিল না
end;
$$;

-- ধরে রাখা স্টক ফেরত দেওয়া (অর্ডার ব্যর্থ হলে, বা অর্ডার মুছলে)
create or replace function release_stock(p_variant_id uuid, p_qty integer)
returns integer
language plpgsql
as $$
declare
  left_stock integer;
begin
  if p_qty is null or p_qty <= 0 then
    return null;
  end if;

  update product_variants
     set stock = stock + p_qty
   where id = p_variant_id
  returning stock into left_stock;

  return left_stock;
end;
$$;

-- অ্যাডমিন প্যানেলের − / + ও "সব সাইজে +N" — এখানেও একই দৌড়ের ঝুঁকি ছিল
create or replace function adjust_stock(p_variant_id uuid, p_delta integer)
returns integer
language plpgsql
as $$
declare
  left_stock integer;
begin
  update product_variants
     set stock = greatest(0, stock + coalesce(p_delta, 0))
   where id = p_variant_id
  returning stock into left_stock;

  return left_stock;
end;
$$;

-- এগুলো শুধু সার্ভার থেকেই ডাকা হয়, ব্রাউজার থেকে নয়
revoke execute on function reserve_stock(uuid, integer) from anon, authenticated;
revoke execute on function release_stock(uuid, integer) from anon, authenticated;
revoke execute on function adjust_stock(uuid, integer)  from anon, authenticated;
