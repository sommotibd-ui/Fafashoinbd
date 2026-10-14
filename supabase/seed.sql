-- =====================================================================
--  FA Shop BD — প্রোডাক্ট, ল্যান্ডিং পেইজ ও সেটিংস
--  schema.sql ও stock-functions.sql চালানোর পরে একবার চালান।
--  পুরনো WordPress (CartFlows) থেকে আনা — দাম, অফার ও লেখা হুবহু।
--  scripts/make_seed.py থেকে তৈরি — হাতে বদলালে স্ক্রিপ্টেও বদলান।
-- =====================================================================

insert into settings (key, value) values
  ('shipping', '{"inside":70,"outside":120}'::jsonb)
on conflict (key) do update set value = excluded.value;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-01', '1483', 'Magic Dreamfit Bra', 'fa-01', 'ladies-inner', 480, null, array['/lp-img/products/whatsapp-image-2026-07-13-at-7-35-56-pm.webp']::text[], null, null, true, 1)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-01'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-02', '1747', 'ব্রিদেবল মেশ ব্রা', 'fa-02', 'ladies-inner', 450, null, array['/lp-img/products/2-1.webp']::text[], null, null, true, 2)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-02'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-03', '1402', 'Magnetic Slimming Belt', 'fa-03', 'shapewear', 490, null, array['/lp-img/products/whatsapp-image-2026-07-09-at-7-27-32-pm.webp']::text[], null, null, true, 3)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-03'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-04', '478', 'S.Hook belt', 'fa-04', 'shapewear', 450, 650, array['/lp-img/products/s-hook-belt-3.webp','/lp-img/products/s-hook-belt-3.webp','/lp-img/products/s-hook-belt-2.webp','/lp-img/products/s-hook-belt-4.webp','/lp-img/products/s-hook-belt-1.webp']::text[], 'এই ২ টি কালার পাওয়া যাবে স্কিন ও কালো.
১। পড়ার সাথে সাথে পেটের মেদ কম দেখাবে
২। নিয়মিত ব্যবহারে স্থায়ীভবে স্লিম করবে
৩। কোন ধরনের পার্শ্বপ্রতিক্রিয়া নেই
৪। সামনে হুক থাকায় ব্যবহার করা খুবই সহজ
৫। মেদ অনুযায়ী ছোট বড় করে ব্যবহার করা যাবে', 'https://www.youtube.com/watch?v=B4K1xlhgqlA', true, 4)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-04'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-05', '769', 'হুক হিপ শেপার', 'fa-05', 'shapewear', 599, null, array['/lp-img/products/3.webp']::text[], null, null, true, 5)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-05'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-06', '734', 'প্রিমিয়াম হাই-ওয়েস্ট শেপওয়্যার', 'fa-06', 'shapewear', 690, null, array['/lp-img/products/whatsapp-image-2026-02-23-at-1-22-40-am.webp']::text[], null, null, true, 6)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-06'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-07', '1207', 'Organic Collagen Australia', 'fa-07', 'beauty', 1190, 2000, array['/lp-img/products/54dcfd4b-bae5-4fb3-993c-cd2cd8a12411.webp','/lp-img/products/77e18157-691d-4ea2-b24e-117477fcbf54.webp','/lp-img/products/be6064c6-0bc0-403b-b0e0-59a61d017be3.webp','/lp-img/products/813a1zbgnwl-ac-sl1500.webp']::text[], 'Organic Collagen Australia (120 Capsules) 1 month course
স্কিনে আনুন ন্যাচারাল গ্লো,
ভেতর থেকে বিউটি কেয়ার শুরু হোক আজই
অস্ট্রেলিয়ান কোলাজেন
এখন শুধু একটি সাপ্লিমেন্ট নয়, এটি আপনার স্কিন, চুল ও নখের সম্পূর্ণ বিউটি সাপোর্ট
যেসব কাজে দারুণ উপকারীঃ
ত্বক টানটান ও ইয়াং লুক রাখতে সাহায্য করে
স্কিনের রুক্ষতা কমিয়ে সফট ও গ্লোয়িং করে
ফাইন লাইন ও বলিরেখা কমাতে সহায়তা করে
ব্রণ বা দাগের পর স্কিন রিপেয়ারে সাহায্য করে
চুল পড়া কমিয়ে চুলকে শক্ত ও স্বাস্থ্যকর রাখতে সহায়ক
নখ ভাঙা কমিয়ে নখকে মজবুত করে
ভেতর থেকে স্কিনের ইলাস্টিসিটি বাড়াতে সাহায্য করে
প্রতিদিনের ব্যস্ততায় নিজের যত্ন নিন সহজেই
কারণ সুন্দর স্কিন শুধু মেকআপে নয়, সঠিক কেয়ারেও আসে
Healthy Skin
Strong Hair
Stronger Nails
Natural Beauty Glow
নিজেকে দিন প্রিমিয়াম কেয়ারের অনুভূতি
WhatsApp :- +8801566063229', null, true, 7)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-07'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-08', '573', 'Long Support', 'fa-08', 'shapewear', 890, 990, array['/lp-img/products/2-1-2.webp','/lp-img/products/3-2.webp','/lp-img/products/4-1.webp','/lp-img/products/5.webp','/lp-img/products/6.webp','/lp-img/products/received-4744437288072762.webp','/lp-img/products/whatsapp-image-2025-01-11-at-11-43-45-am-2.webp']::text[], 'এই স্টাইলিশ ও আরামদায়ক বডি শেপার ভেস্টটি আপনার কোমর ও পেটকে সুন্দরভাবে শেপ দিতে সাহায্য করে। নিয়মিত ব্যবহারে এটি ফিগার স্লিম দেখাতে সহায়ক এবং দৈনন্দিন পোশাকের নিচে পরার জন্য খুবই উপযোগী।
🔹 প্রধান বৈশিষ্ট্য
✅ কোমর ও পেট স্লিম দেখাতে সহায়ক
✅ সামনে হুক সিস্টেম – সহজে পরা ও খোলা যায়
✅ ব্যাক সাইডে আধুনিক কাট ডিজাইন
✅ ব্রেস্ট সাপোর্টসহ কমফোর্টেবল ফিট
✅ শরীরের সঙ্গে সুন্দরভাবে মানিয়ে যায়
✅ হালকা ও শ্বাস-প্রশ্বাসযোগ্য ফেব্রিক
🔹 মেটেরিয়াল
উচ্চমানের নাইলন + স্প্যানডেক্স
নরম, ইলাস্টিক ও স্কিন-ফ্রেন্ডলি
🔹 ব্যবহার উপযোগিতা
👗 দৈনন্দিন ব্যবহার
👗 অফিস / পার্টি / ফাংশন
👗 শাড়ি, কুর্তি, ড্রেস বা টপের নিচে পরার জন্য উপযুক্ত', null, true, 8)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-08'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-09', '504', 'রিমোট কন্ট্রোল হোল্ডার', 'fa-09', 'gadget', 499, 750, array['/lp-img/products/578013619-122197078562311010-2238618367017452783.webp','/lp-img/products/575686704-1562924588478832-1996609027203538992-n.webp','/lp-img/products/578722122-1374223764336633-959670855063857172-n.webp','/lp-img/products/576573615-1373108297492114-7448060954918171936-n.webp']::text[], 'রিমোট কন্ট্রোল হোল্ডার: বিছানায় শুয়েই আলো বন্ধ! আপনার জীবন হোক আরও স্মার্ট! এই Smart AC220V Wireless Remote Control Lamp Holder-টি আপনার সাধারণ বাল্বকে করে তুলবে স্মার্ট লাইট। এখন আর রাতে বিছানা ছেড়ে উঠে গিয়ে সুইচ বন্ধ করার প্রয়োজন নেই! এর ওয়্যারলেস রিমোট কন্ট্রোলের মাধ্যমে আপনি যেকোনো জায়গা থেকে আলো জ্বালাতে বা নেভাতে পারবেন। এটি আপনার ঘরের সুবিধাকে বাড়িয়ে তুলবে। হাইলাইটস:ওয়্যারলেস রিমোট কন্ট্রোল: যেকোনো স্থান থেকে আলো নিয়ন্ত্রণের সুবিধা।সহজে ইনস্টলেশন: আপনার বিদ্যমান বাল্বের সাথে সহজেই ব্যবহার করা যায়।AC220V সাপোর্ট: বাংলাদেশের বিদ্যুতের সাথে সম্পূর্ণরূপে সামঞ্জস্যপূর্ণ।স্মার্ট লাইটিং: আপনার দৈনন্দিন জীবনের জন্য একটি স্মার্ট সমাধান।', 'https://www.youtube.com/shorts/sQk4oHLizVM', true, 9)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-09'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-10', '487', 'The Ordinary Salicylic Acid 2% Solution', 'fa-10', 'beauty', 999, 1850, array['/lp-img/products/the-ordinary-salicylic-acid-2-solution.webp','/lp-img/products/the-ordinary-salicylic-acid-2-solution-2.webp','/lp-img/products/the-ordinary-salicylic-acid-2-solution-3.webp','/lp-img/products/rn-image-picker-lib-temp-acc1305f-d384-4efc-b36e.webp']::text[], 'ব্রণ কমায় ও প্রতিরোধ করে
ডেড সেল রিমুভ করে
পোরস unclog করে পরিষ্কার করে
ব্ল‍্যাকহেডস কমাতে সহায়তা করে
বয়স বাড়লেও ত্বকে যেন না পড়ে বয়সের ছাপ —
এই জাদুকরী সেরাম ত্বকের সূক্ষ্ম রেখা ও বলিরেখা কমিয়ে ত্বককে করে তোলে আরও মসৃণ, টাইট এবং উজ্জ্বল। 🌸
💎 মূল উপকারিতা:
✅ ফাইন লাইন ও বলিরেখা কমায়
✅ চোখ ও কপালের চারপাশে দৃশ্যমান উন্নতি আনে
✅ হালকা, তেল-মুক্ত এবং দ্রুত শোষিত হয়
✅ ত্বককে রাখে হাইড্রেটেড ও ইয়ুথফুল
🧴 ব্যবহার পদ্ধতি:
পরিষ্কার মুখে কয়েক ফোঁটা নিয়ে চোখ, কপাল বা বলিরেখাযুক্ত জায়গায় লাগান।
👉 ময়েশ্চারাইজারের আগে ব্যবহার করুন।
🌙 ব্যবহার সময়:
সকাল ও রাতে — দিনে দুইবারই ব্যবহার করা যায়।
💬 Skin Caring & Beauty বলছে:
✨ “বয়স শুধু সংখ্যা, ত্বক বলবে তুমি এখনো তরুণ!” 💖', 'https://www.youtube.com/shorts/cw38zX76tLE', true, 10)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-10'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-11', '283', 'Abdominal Belt', 'fa-11', 'shapewear', 444, 650, array['/lp-img/products/whatsapp-image-2025-09-20-at-20-17-00-5eacd1f3.webp','/lp-img/products/whatsapp-image-2025-09-20-at-20-17-04-5f48dd8b.webp','/lp-img/products/whatsapp-image-2025-09-20-at-20-17-04-25e61000.webp']::text[], 'আপনাকে ইনস্ট্যান্ট স্লিম দেখাবে।
মাজা এবং কোমরের ব্যথা রিমুভ করে এই বেল্ট।
নিয়মিত ব্যবহারে আপনার পেটের মেদ-ভুঁড়ি কমবে
দ্রুত পেটের মেদ কমিয়ে আপনাকে স্লিম ও আকর্ষণীয় করে তুলবে।
ব্যবহারে স্বস্তি ও আরামদায়ক, তাই যে কোন সময় ব্যবহার করতে পারবেন।
সাধারণ ভাবে ধোয়ার উপযোগী এবং সম্পূর্ন পার্শ্বপ্রতিক্রিয়া মুক্ত।
অর্ডার করতে এবং মূল্য জানতে ORDER NOW বাটনে ক্লিক করুন', 'https://www.youtube.com/shorts/Y1VfvAESDTY', true, 11)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-11'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-12', '249', 'Aura circle Ear ring', 'fa-12', 'ornaments', 380, 650, array['/lp-img/products/whatsapp-image-2025-09-18-at-19-41-55-9ba80963.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-41-56-03d8ceb1.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-41-55-9ba80963-1.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-41-56-b3f5cf9e.webp']::text[], 'আপনার স্টাইলকে নতুন উচ্চতায় নিয়ে যেতে হাজির হয়েছে Round Ear Ring
গোলাপের অনন্য ডিজাইন আর সোনালী ঝলমলে ফিনিশ একসাথে এনে দেবে রাজকীয় আভিজাত্য।
যেকোনো পার্টি, বিয়ে বা বিশেষ দিনে এই দুল হবে আপনার লুকের সবচেয়ে আকর্ষণীয় অংশ।
হালকা ও আরামদায়ক হওয়ায় দীর্ঘক্ষণ পরলেও কোনো অস্বস্তি হবে না।
এই দুল না কিনলে আপনি মিস করবেন আপনার স্টাইলকে এক ধাপ এগিয়ে নেওয়ার সেরা সুযোগ!', 'https://www.youtube.com/watch?v=W6_4nZTnWV4', true, 12)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-12'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-13', '240', 'Twinkle bell ear ring', 'fa-13', 'ornaments', 390, 650, array['/lp-img/products/whatsapp-image-2025-09-18-at-19-53-23-da0c8975.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-53-23-da0c8975.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-53-22-ec27c9d3.webp']::text[], 'অরজিনাল মায়সানাইট ডায়মন্ড ঝুমকা ।স্বর্ণের মত ঝলমলে গোল্ড ফিনিশ — যেকোনো অনুষ্ঠানে আপনি হবেন সবার নজরে!
🔸 কালার ফেড হওয়ার ভয় নেই
🔸 রেগুলার ব্যবহারেও থাকবে নতুনের মতো
🔸 ৩ বছরের কালার গ্যারান্টি
🔸 থাকছে রিপ্লেসমেন্ট সুবিধাও!', 'https://www.youtube.com/watch?v=d3fK-37JGew', true, 13)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-13'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-14', '224', 'Petal Charm 3-in-1 ear ring', 'fa-14', 'ornaments', 390, 650, array['/lp-img/products/whatsapp-image-2025-09-18-at-19-41-57-a1cc0922.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-41-58-6cf9c58f.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-41-58-98e83aa1.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-53-24-96633498.webp']::text[], '🔥অরজিনাল মায়সানাইট ডায়মন্ড ইয়ার রিং ।স্বর্ণের মত ঝলমলে গোল্ড ফিনিশ — যেকোনো অনুষ্ঠানে আপনি হবেন সবার নজরে!
🔸 কালার ফেড হওয়ার ভয় নেই
🔸 রেগুলার ব্যবহারেও থাকবে নতুনের মতো
🔸 ৩ বছরের কালার গ্যারান্টি
🔸 থাকছে রিপ্লেসমেন্ট সুবিধাও!', 'https://www.youtube.com/watch?v=U32RwOytW1I', true, 14)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-14'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-15', '582', 'Designing Tops', 'fa-15', 'shapewear', 650, 950, array['/lp-img/products/5508350121659811828.webp','/lp-img/products/39740385-104749157.webp','/lp-img/products/1338692333-908712651.webp','/lp-img/products/1780188754-1904399023.webp','/lp-img/products/received-1121852915825512.webp']::text[], '🌸 আরাম, স্টাইল আর সাপোর্ট—সব একসাথে! 🌸
এই সুন্দর ও সফট Women’s Lace Innerwear / Camisole Top আপনার দৈনন্দিন পোশাককে করবে আরও কমফোর্টেবল ও কনফিডেন্ট 💚
✨ প্রোডাক্ট ডিটেলস:✔️ নরম ও স্ট্রেচেবল ফেব্রিক✔️ ব্রেস্ট সাপোর্টসহ আরামদায়ক ফিট✔️ ঘাম শোষণকারী ও শ্বাস-প্রশ্বাসযোগ্য✔️ স্লিভলেস ডিজাইন – গরমের জন্য পারফেক্ট✔️ লেইস ডিটেইলিং – দেয় এলিগেন্ট লুক✔️ টপ, কুর্তি বা ড্রেসের নিচে পরার জন্য উপযুক্ত', null, true, 15)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-15'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-16', '513', 'Hip and Bellay shaper', 'fa-16', 'shapewear', 850, 1290, array['/lp-img/products/whatsapp-image-2025-11-17-at-17-30-36-7032720e.webp','/lp-img/products/whatsapp-image-2025-11-18-at-18-23-12-79c2360a.webp','/lp-img/products/whatsapp-image-2025-11-18-at-18-23-12-367f37b7.webp','/lp-img/products/whatsapp-image-2025-11-18-at-18-23-12-888863d0.webp','/lp-img/products/whatsapp-image-2025-11-18-at-18-23-13-3d5a1c1f.webp','/lp-img/products/whatsapp-image-2025-11-18-at-18-23-13-7ba23d8d.webp','/lp-img/products/whatsapp-image-2025-11-18-at-18-23-13-95b7836a.webp']::text[], 'আমাদের প্রোডাক্ট হচ্ছে শতভাগ অরিজিনাল তাই আমাদের প্রোডাক্ট সারা বাংলাদেশে ডেলিভারি চার্জ ফ্রি
Current
✅ High Waist Design: কোমর থেকে পেট পর্যন্ত সম্পূর্ণ কাভারেজ, নিখুঁতভাবে মেদ ঢেকে রাখে।
✅ Light Compression: আরামদায়ক চাপ, সারাদিন পরলেও ত্বকে চেপে বসে না।
✅ Breathable & Stretchable Fabric: নরম, হালকা এবং ঘাম প্রতিরোধী।
✅ Invisible Under Clothes: কোনো প্যান্টি লাইন নয় – যেকোনো পোশাকের নিচে একদম নিখুঁত ফিনিশ।
✅ No Rolling, No Digging: কোমরে শক্ত ইলাস্টিক ব্যান্ড, যেটা জায়গা থেকে সরে যায় না।', 'https://www.youtube.com/shorts/VDpDEK2mey0', true, 16)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-16'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-17', '493', 'ফোম ছাড়া ফ্রন্ট বাটন ব্রা', 'fa-17', 'ladies-inner', 399, 500, array['/lp-img/products/front-button-bra-1.webp','/lp-img/products/front-button-bra-2.webp','/lp-img/products/front-button-bra-3.webp','/lp-img/products/front-button-bra-4.webp','/lp-img/products/front-button-bra-5.webp']::text[], 'Size Available 36--46
👉সামনে বাটন থাকায় খুব সহজেই ব্যবহার করা যায়
👉উন্নত মানের ১০০% কটন কাপড় দিয়ে তৈরী, তাই শীত ও গরম উভয় সময় ব্যাবহারে উপযোগী।
👉অনেক বেশি নরম ও আরামদায়ক
👉ব্রেস্ট ফিডিং ব্রা হিসেবে ব্যাবহার করা যায়
👉রেগুলার ব্রা হিসেবে ব্যাবহারে অন্যতম
👉যেকোন ড্রেসের সাথে অনায়াসে পড়া যাবে', 'https://youtu.be/71URX7VAUKw', true, 17)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-17'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-18', '469', 'Hook hip Shaper', 'fa-18', 'shapewear', 599, 999, array['/lp-img/products/hook-hip-shiper-4.webp','/lp-img/products/hook-hip-shiper-1.webp','/lp-img/products/hook-hip-shiper-2.webp','/lp-img/products/hook-hip-shiper-3.webp','/lp-img/products/hook-hip-shiper-5.webp','/lp-img/products/hook-hip-shiper-6.webp','/lp-img/products/hook-hip-shiper-7.webp']::text[], 'কোন কালারটি নিতে চাচ্ছেন?
কালার: স্কিন
কালার: ব্ল্যাক
১. এটি ব্যাবহারে আপনাকে ইন্সট্যান্ট স্লিম দেখাবে।
২. পেটের ও পিঠের মেদ কমিয়ে আপনাকে আকর্ষনীয় করে তুলবে।
৩.স্থাই ভাবে স্লিম করবে।ব্যবহারে আরামদায়ক
৪. সাধারন ভাবে ধোয়ার উপযোগী, কোন পার্শ্বপ্রতিক্রিয়া নেই।
৫. নিয়মিত ভাবে ৪৫-৬০ দিন ব্যাবহারে আপনার মেদ, ভুঁড়ি কমিয়ে আপনাকে স্লিম ও আকোর্ষনীয় করবে।', 'https://youtube.com/shorts/CJangtuU8ZA', true, 18)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-18'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-19', '296', 'Shoulder Support Bra', 'fa-19', 'ladies-inner', 399, 580, array['/lp-img/products/whatsapp-image-2025-09-20-at-20-16-58-f9394079.webp','/lp-img/products/whatsapp-image-2025-09-20-at-20-16-44-ad386496.webp','/lp-img/products/whatsapp-image-2025-09-20-at-20-16-45-4a79d2d7.webp','/lp-img/products/whatsapp-image-2025-09-20-at-20-16-57-2e9affc8.webp','/lp-img/products/whatsapp-image-2025-09-20-at-20-16-57-73a6b873.webp']::text[], 'ফোম ছাড়া সুতি কাপড়ের ফ্রন্ট বাটন ব্রা।
কাঁধের ফিতা বাড়ানো কমানো যায়।
ঝু-লে পড়া ব্রেস্টকে বডির সাথে পারফেক্ট ফিটিং এনে দিবে।
সারাদিন পরে থাকার মত আরামদায়ক সুতি ব্রা।
সামনে বাটন থাকায় পরা ও খোলা সহজ।
শীতে আরামদায়ক উষ্ণতা প্রদান করবে।
অ্যালার্জি প্রতিরোধকঃ অ্যালার্জি বা চুলকানির সমস্যায় ভোগেন, তাদের জন্য কটন ব্রাই সহজ সমাধান।
ব্রার কোয়ালিটি দেখে পেমেন্ট করবেন। ১ টাকাও অগ্রিম দিতে হবে না।
সাইজঃ ৩২,৩৪,৩৬,৩৮,৪০,৪২,৪৪,৪৬', 'https://www.youtube.com/watch?v=gOkaYZqLPL8', true, 19)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-19'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-20', '278', 'Front Button Net Bra', 'fa-20', 'ladies-inner', 499, 650, array['/lp-img/products/whatsapp-image-2025-09-20-at-20-00-11-1e20610c.webp','/lp-img/products/whatsapp-image-2025-09-20-at-19-59-55-a225929a.webp']::text[], 'স্টাইলিশ ফুল প্রিন্ট, ফ্রন্ট হুক ডিজাইন, আর একদম নরম কাপড়।
যা ঘামে না, চেপে ধরে না – আর সারাদিন জুড়ে দেয় দারুণ আরাম!
ওয়্যারলেস সাপোর্ট – কোন হুক বা তার নেই
বায়ু চলাচলের জন্য রয়েছে ছিদ্রযুক্ত ফেব্রিক
সহজে পরা যায় – ফ্রন্ট বোতাম ডিজাইন
ঘরের কাজ, বাইরে যাওয়া, এমনকি ঘুমানোর সময়েও পরার জন্য পারফেক্ট,', 'https://www.youtube.com/shorts/Y1VfvAESDTY', true, 20)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-20'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-21', '221', 'Royal Bloom Ear Rings', 'fa-21', 'ornaments', 380, 650, array['/lp-img/products/whatsapp-image-2025-09-18-at-19-41-55-17e8117f.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-53-23-579183b5.webp']::text[], 'প্রতিদিনের লুকেও থাকুক রাজকীয় ছোঁয়া।
এই Golden রোজ ফ্লাওয়ার ইয়ারিংস শুধু একটি গহনা নয়—এটি প্রতিটি নারীর সৌন্দর্যের পরিপূর্ণতা।
পারফেক্ট গিফট, পারফেক্ট লুক—এখনই অর্ডার করুন!
কারণ আপনি—সর্বদা সেরা কিছু ডিজার্ভ করেন। “
প্রতিটি প্রোডাক্ট এর সাথে পাচ্ছেন একটি আকর্ষণীয় গিফট বক্স
পণ্য হাতে পেয়ে মুল্য পরিশোধ করুন
সারা বাংলাদেশে হোম ডেলিভারি
অর্ডার করতে অথবা বিস্তারিত জানতে Order Now বাটনে ক্লিক করুন।', 'https://www.youtube.com/watch?v=5LsjJDix33w', true, 21)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-21'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-22', '216', 'Golden Vibe Necklace', 'fa-22', 'ornaments', 390, 650, array['/lp-img/products/whatsapp-image-2025-09-18-at-19-53-23-a4e538c6.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-53-23-a4e538c6.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-41-55-10130678.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-41-55-f210cd31-c.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-41-55-ffb0168a.webp']::text[], null, 'https://www.youtube.com/watch?v=WQg6wqsrDFY', true, 22)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-22'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-23', '213', 'Golden Glow Necklace', 'fa-23', 'ornaments', 390, 650, array['/lp-img/products/whatsapp-image-2025-09-18-at-19-53-24-78193087-1.webp']::text[], 'Stylish 18K gold plated necklace
Elegant copper pendant with zircon stone
Durable stainless steel chain with lip-style links
Lightweight and comfortable to wear
Designed for girls aged 14–30
Great for gifting or personal use', 'https://www.youtube.com/watch?v=WlkmCSvUFfw', true, 23)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-23'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-24', '208', 'Eternal Rose Glow ear rings', 'fa-24', 'ornaments', 390, 650, array['/lp-img/products/whatsapp-image-2025-09-18-at-19-41-57-518012a3.webp','/lp-img/products/whatsapp-image-2025-09-12-at-12-40-54-6c0fbe8d.webp','/lp-img/products/whatsapp-image-2025-09-12-at-12-40-55-1b083053.webp','/lp-img/products/whatsapp-image-2025-09-12-at-12-40-55-a5a3899c.webp']::text[], 'যেটি আপনার লুকে দেবে এক অনন্য আভিজাত্য।
সোনালী গোলাপের কারুকাজ আর ঝলমলে ঝুলন্ত চেইন আপনাকে করে তুলবে সবার দৃষ্টি-কেন্দ্র।
পার্টি, বিয়ে বা ক্যাজুয়াল যেকোনো অনুষ্ঠানে এই দুল পরলেই আপনার স্টাইল হবে এক ধাপ এগিয়ে।
এটি শুধু একটি দুল নয়, এটি আপনার আত্মবিশ্বাস ও সৌন্দর্যের প্রতীক।
একে না কিনলে সত্যিই মিস করবেন আপনার লুকে সেই ম্যাজিক, যা সবাইকে আকৃষ্ট করবে!', 'https://www.youtube.com/watch?v=9rs2l8ZZePo', true, 24)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-24'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-25', '206', 'Rose Flower Diamond Earrings', 'fa-25', 'ornaments', 380, 650, array['/lp-img/products/whatsapp-image-2025-09-18-at-19-41-57-401abfba.webp','/lp-img/products/whatsapp-image-2025-09-18-at-19-41-57-49a56c6d.webp']::text[], 'প্রতিদিনের লুকেও থাকুক রাজকীয় ছোঁয়া।
এই Golden রোজ ফ্লাওয়ার ইয়ারিংস শুধু একটি গহনা নয়—এটি প্রতিটি নারীর সৌন্দর্যের পরিপূর্ণতা।
পারফেক্ট গিফট, পারফেক্ট লুক—এখনই অর্ডার করুন!
কারণ আপনি—সর্বদা সেরা কিছু ডিজার্ভ করেন। "
প্রতিটি প্রোডাক্ট এর সাথে পাচ্ছেন একটি আকর্ষণীয় গিফট বক্স
পণ্য হাতে পেয়ে মুল্য পরিশোধ করুন
সারা বাংলাদেশে হোম ডেলিভারি
অর্ডার করতে অথবা বিস্তারিত জানতে Order Now বাটনে ক্লিক করুন।', 'https://www.youtube.com/watch?v=rE3XIzmT1tk', true, 25)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-25'
on conflict (product_id, opt_key, color_key) do nothing;

insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ('FA-26', '70', 'Slimming belt', 'fa-26', 'shapewear', 490, null, array['/lp-img/products/hb4a50bc2d4d04f10be7662bcf351ad1e4.webp']::text[], 'আপনাকে ইনস্ট্যান্ট স্লিম দেখাবে।
মাজা এবং কোমরের ব্যথা রিমুভ করে এই বেল্ট।
নিয়মিত ব্যবহারে আপনার পেটের মেদ-ভুঁড়ি কমবে
দ্রুত পেটের মেদ কমিয়ে আপনাকে স্লিম ও আকর্ষণীয় করে তুলবে।
ব্যবহারে স্বস্তি ও আরামদায়ক, তাই যে কোন সময় ব্যবহার করতে পারবেন।
সাধারণ ভাবে ধোয়ার উপযোগী এবং সম্পূর্ন পার্শ্বপ্রতিক্রিয়া মুক্ত।
অর্ডার করতে এবং মূল্য জানতে ORDER NOW বাটনে ক্লিক করুন', 'https://www.youtube.com/shorts/Y1VfvAESDTY', true, 26)
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = 'FA-26'
on conflict (product_id, opt_key, color_key) do nothing;

-- সাইজ-রঙ ফোনে নিশ্চিত হয়, তাই একটাই স্টকের ঘর। পুরনো সাইটে স্টক গোনা হতো না —
-- তাই বড় সংখ্যা, যাতে এড চলার মাঝে "স্টক শেষ" বলে অর্ডার না আটকায়।

insert into landing_pages (slug, product_id, title, blocks, tiers, form_title, note_label, note_required, thankyou_slug, active, sort)
select 'magic-dreamfit-bra', id, 'ম্যাজিক ড্রিমফিট ব্রা', '[{"t": "heading", "size": "xl", "text": "ম্যাজিক ড্রিমফিট ব্রা ১ পিস ৪৮০/- টাকা, ৩ পিস অফার মূল্য মাত্র ১২০০/- টাকা"}, {"t": "video", "url": "https://www.youtube.com/watch?v=IGsBrFQi-kI"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "heading", "size": "lg", "text": "ম্যাজিক ড্রিমফিট ব্রা কেন কিনবেন?"}, {"t": "list", "items": ["প্রিমিয়াম আইস সিল্ক ফেব্রিক, যা গরমেও আরামদায়ক অনুভূতি দেয়", "ফ্রন্ট বাটন ডিজাইন, তাই সহজে পরা ও খোলা যায়", "যেকোন ড্রেসের সাথে স্বাচ্ছন্দে ব্যবহার করা যাবে", "সাইজ- ৩৪, ৩৬, ৩৮, ৪০, ৪২, ৪৪, ৪৬", "সকল বয়সী নারীদের জন্য উপযুক্ত", "বুককে দেয় সুন্দর ও প্রাকৃতিক শেপ", "তার, হুক ও ভারী ফোম ছাড়াই আরামদায়ক সাপোর্ট", "দীর্ঘক্ষণ ব্যবহার করলেও অস্বস্তি অনুভূত হয় না", "দৈনন্দিন ব্যবহার, বাসা কিংবা ঘুমানোর সময়ও উপযোগী", "৪ টি আকর্ষনীয় কালারে পাওয়া যাচ্ছে"]}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "gallery", "cols": 2, "images": [{"src": "/lp-img/magic-dreamfit-bra/whatsapp-image-2026-07-18-at-1-39-37-pmere.webp", "w": 800, "h": 800}, {"src": "/lp-img/magic-dreamfit-bra/whatsapp-image-2026-07-18-at-1-39-38-pmdfed.webp", "w": 800, "h": 800}, {"src": "/lp-img/magic-dreamfit-bra/whatsapp-image-2026-07-18-at-1-39-37-pm.webp", "w": 800, "h": 800}, {"src": "/lp-img/magic-dreamfit-bra/whatsapp-image-2026-07-18-at-1-39-37-pmgcgf.webp", "w": 800, "h": 800}]}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "heading", "size": "lg", "text": "২ টি গুরুত্বপূর্ন বিষয়"}, {"t": "text", "text": "১। আমরা কোনো অগ্রিম টাকা নেই না। ইনশাল্লাহ সবাই ক্যাশ অন ডেলিভারিতে পন্য রিসিভ করবেন।\n২। অর্ডার করার পরে আমাদের কল সেন্টার থেকে ফোন করে পন্যের কালার ও সাইজ কনফার্ম করা হবে।"}]'::jsonb, '[{"qty": 1, "price": 480}, {"qty": 2, "price": 900}, {"qty": 3, "price": 1200}]'::jsonb, 'অর্ডার করতে নিচের ফর্মটি পূরণ করুন', null, false, 'thank-you-5', true, 1
from products where code = 'FA-01'
on conflict (slug) do update set blocks = excluded.blocks, tiers = excluded.tiers, title = excluded.title,
  product_id = excluded.product_id, form_title = excluded.form_title, note_label = excluded.note_label,
  thankyou_slug = excluded.thankyou_slug;

insert into landing_pages (slug, product_id, title, blocks, tiers, form_title, note_label, note_required, thankyou_slug, active, sort)
select 'mesh-bra', id, 'ব্রিদেবল মেশ ব্রা', '[{"t": "heading", "size": "xl", "text": "গরমের জন্য আরামদায়ক মেশ ব্রা"}, {"t": "text", "text": "গরমেও থাকুন সতেজ ও আরামদায়ক— ফোম ছাড়া ব্রেথেবল মেশ ব্রা। সফট মেশ ফেব্রিক, তারবিহীন আরাম এবং সামনে সহজ বাটন—দৈনন্দিন ব্যবহার ও ব্রেস্টফিডিংয়ের সময় ব্যবহারোপযোগী একটি আরামদায়ক ব্রা।"}, {"t": "image", "img": {"src": "/lp-img/mesh-bra/4-1-2.webp", "w": 1000, "h": 1000}}, {"t": "heading", "size": "md", "text": "কম্বো অফার: ১ পিস ৳৪৫০ | ২ পিস ৳৮৫০ | ৩ পিস ৳১,২০০"}, {"t": "cta", "text": "এখনই অফার বেছে নিন"}, {"t": "features", "title": "সারাদিনের আরামের জন্য প্রয়োজনীয় সব সুবিধা", "items": [{"title": "ব্রেথেবল মেশ", "desc": "বাতাস চলাচলে সহায়ক মেশ ফেব্রিক"}, {"title": "সুপার সফট", "desc": "নরম ও হালকা ফেব্রিকের আরাম"}, {"title": "তারবিহীন ডিজাইন", "desc": "হার্ড ওয়্যার ছাড়াই আরামদায়ক ব্যবহার"}, {"title": "আরামদায়ক", "desc": "দৈনন্দিন দীর্ঘ সময় ব্যবহারে উপযোগী"}, {"title": "সামনে বাটন", "desc": "পরা ও খোলা সহজ এবং ঝামেলাহীন"}, {"title": "ফিডিং ফ্রেন্ডলি", "desc": "ব্রেস্টফিডিংয়ের সময় ব্যবহার সহজ"}, {"title": "ফোম ছাড়া", "desc": "হালকা অনুভূতির জন্য foamless design"}, {"title": "দৈনন্দিন ব্যবহার", "desc": "বাসা ও নিয়মিত ব্যবহারের জন্য উপযোগী"}, {"title": "বিভিন্ন বয়সে উপযোগী", "desc": "আরামকে গুরুত্ব দেওয়া নারীদের জন্য"}, {"title": "সহজ ও সুবিধাজনক", "desc": "ব্যবহারবান্ধব ডিজাইন ও আরামদায়ক ফিট"}]}, {"t": "compare", "title": "সাধারণ ভারী ব্রার বদলে কেন বেছে নেবেন ব্রেথেবল মেশ ব্রা?", "bad": {"title": "সাধারণ ফোম বা ওয়্যারযুক্ত ব্রা", "items": ["গরমে ভারী ও অস্বস্তিকর লাগতে পারে", "ফোমের কারণে বাতাস চলাচল তুলনামূলক কম", "ওয়্যার দীর্ঘ সময় ব্যবহারে চাপ তৈরি করতে পারে", "পরা ও খোলা অনেক সময় ঝামেলার হতে পারে", "দৈনন্দিন ব্যবহারে সবসময় হালকা অনুভূতি নাও দিতে পারে"]}, "good": {"title": "ব্রেথেবল মেশ ফ্রন্ট-বাটন ব্রা", "items": ["হালকা ও breathable mesh fabric", "ফোম ছাড়া হওয়ায় তুলনামূলক হালকা অনুভূতি", "তারবিহীন ডিজাইন—দৈনন্দিন ব্যবহারে আরামদায়ক", "সামনে বাটন থাকায় পরা ও খোলা সহজ", "গরম ও নিয়মিত ব্যবহারের জন্য সুবিধাজনক ডিজাইন"]}}, {"t": "heading", "size": "md", "text": "পাওয়া যাচ্ছে এই কালারগুলোতে: স্কিন, পিংক, স্কাই"}, {"t": "gallery", "cols": 3, "images": [{"src": "/lp-img/mesh-bra/3-1.webp", "w": 1000, "h": 1000}, {"src": "/lp-img/mesh-bra/2-1.webp", "w": 1000, "h": 1000}, {"src": "/lp-img/mesh-bra/4-1-2.webp", "w": 1000, "h": 1000}]}, {"t": "cta", "text": "আমার পছন্দের কম্বো দেখুন"}, {"t": "text", "text": "কম্বোর প্রতিটি পিসের সাইজ ও কালার অর্ডারের পরে ফোনে জেনে নেওয়া হবে।"}, {"t": "text", "text": "পণ্যের রঙ স্ক্রিনের সেটিং অনুযায়ী কিছুটা ভিন্ন দেখাতে পারে। এটি কোনো চিকিৎসা সামগ্রী নয় এবং কোনো রোগ নিরাময় বা নিশ্চিত শারীরিক ফলাফলের দাবি করে না।"}]'::jsonb, '[{"qty": 1, "price": 450}, {"qty": 2, "price": 850, "tag": "সবচেয়ে জনপ্রিয়"}, {"qty": 3, "price": 1200, "default": true}]'::jsonb, 'অর্ডার করতে নিচের ফর্মটি পূরণ করুন', null, false, 'thank-you-5-2', true, 2
from products where code = 'FA-02'
on conflict (slug) do update set blocks = excluded.blocks, tiers = excluded.tiers, title = excluded.title,
  product_id = excluded.product_id, form_title = excluded.form_title, note_label = excluded.note_label,
  thankyou_slug = excluded.thankyou_slug;

insert into landing_pages (slug, product_id, title, blocks, tiers, form_title, note_label, note_required, thankyou_slug, active, sort)
select 'magnetic-slimming-belt', id, 'ম্যাগনেটিক স্লিমিং বেল্ট', '[{"t": "image", "img": {"src": "/lp-img/magnetic-slimming-belt/chatgpt-image-jan-13-2026-01-50-20-pm-1.webp", "w": 640, "h": 640}}, {"t": "heading", "size": "xl", "text": "স্লিমিং হুক বেল্ট ১ পিস ৪৯০/- টাকা, ২ পিস ৯০০/- টাকা"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "video", "url": "https://youtube.com/shorts/shcDxsezn8o?si=GrpIyw53gNdDs0uQ"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "list", "items": ["রক্ত সঞ্চালনের মাধ্যমে আপনার অতিরিক্ত চর্বি❤️‍🔥 গলিয়ে❤️‍🔥 ফেলবে!", "নিয়মিত ব্যবহারে স্থায়ীভাবে স্লিম দেখাবে", "একটা বায়োমেট্রিক ম্যাগনেট থাকবে যেটা মাধ্যমে মেদ কমাবেন", "কোন ধরনের পার্শ্বপ্রতিক্রিয়া নেই", "মেদ অনুযায়ী সাইজ দেয়া যাবে", "স্কিন ও কালো এই ২ টি কালার পাওয়া যাবে"], "title": "ম্যাগনেটিক স্লিমিং বেল্ট কেন ব্যবহার করবেন?"}, {"t": "image", "img": {"src": "/lp-img/magnetic-slimming-belt/whatsapp-image-2026-07-09-at-7-27-32-pm.webp", "w": 1000, "h": 1000}}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "list", "items": ["১০০% অরিজিনাল পন্য", "কোন অগ্রিম টাকা ছাড়া পন্য অর্ডার করুন", "পন্য রিসিভ করে মূল্য পরিশোধ করুন", "কালার বা সাইজ জনিত যেকোন সমস্যায় সহজে রিটার্ন বা এক্সচেঞ্জ করার সুবিধা", "সঠিক সময়ে পন্য ডেলিভারির নিশ্চয়তা"], "title": "আমাদের কাছ থেকে কেন কিনবেন?"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "heading", "size": "lg", "text": "২ টি গুরুত্বপূর্ন বিষয়"}, {"t": "text", "text": "১। আমরা কোনো অগ্রিম টাকা নেই না। ইনশাল্লাহ সবাই ক্যাশ অন ডেলিভারিতে পন্য রিসিভ করবেন।\n২। অর্ডার করার পরে আমাদের কল সেন্টার থেকে ফোন করে পন্যের কালার ও সাইজ কনফার্ম করা হবে।"}]'::jsonb, '[{"qty": 1, "price": 490}, {"qty": 2, "price": 900}]'::jsonb, 'অর্ডার করতে নিচের ফর্মটি পূরণ করুন', null, false, 'thank-you-4', true, 3
from products where code = 'FA-03'
on conflict (slug) do update set blocks = excluded.blocks, tiers = excluded.tiers, title = excluded.title,
  product_id = excluded.product_id, form_title = excluded.form_title, note_label = excluded.note_label,
  thankyou_slug = excluded.thankyou_slug;

insert into landing_pages (slug, product_id, title, blocks, tiers, form_title, note_label, note_required, thankyou_slug, active, sort)
select 'hook-slimming-belt', id, 'স্লিমিং হুক বেল্ট', '[{"t": "image", "img": {"src": "/lp-img/hook-slimming-belt/chatgpt-image-jan-13-2026-01-50-20-pm-1.webp", "w": 640, "h": 640}}, {"t": "heading", "size": "xl", "text": "স্লিমিং হুক বেল্ট ১ পিস ৪৫০/- টাকা"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "video", "url": "https://youtube.com/shorts/S-YS-qwSeN0?si=PEQWUV66feHg3m8K"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "list", "items": ["বেল্টটি পড়ার সাথে সাথে পেটের মেদ কম দেখাবে", "নিয়মিত ব্যবহারে স্থায়ীভাবে স্লিম দেখাবে", "সামনে হুক থাকায় ব্যবহার করা খুবই সহজ", "কোন ধরনের পার্শ্বপ্রতিক্রিয়া নেই", "মেদ অনুযায়ী সাইজ ছোট বড় করে ব্যবহার করা যাবে", "স্কিন ও কালো এই ২ টি কালার পাওয়া যাবে"], "title": "স্লিমিং হুক বেল্ট কেন ব্যবহার করবেন?"}, {"t": "image", "img": {"src": "/lp-img/hook-slimming-belt/s-hook-belt-3.webp", "w": 720, "h": 720}}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "list", "items": ["১০০% অরিজিনাল পন্য", "কোন অগ্রিম টাকা ছাড়া পন্য অর্ডার করুন", "পন্য রিসিভ করে মূল্য পরিশোধ করুন", "কালার বা সাইজ জনিত যেকোন সমস্যায় সহজে রিটার্ন বা এক্সচেঞ্জ করার সুবিধা", "সঠিক সময়ে পন্য ডেলিভারির নিশ্চয়তা"], "title": "আমাদের কাছ থেকে কেন কিনবেন?"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "heading", "size": "lg", "text": "২ টি গুরুত্বপূর্ন বিষয়"}, {"t": "text", "text": "১। আমরা কোনো অগ্রিম টাকা নেই না। ইনশাল্লাহ সবাই ক্যাশ অন ডেলিভারিতে পন্য রিসিভ করবেন।\n২। অর্ডার করার পরে আমাদের কল সেন্টার থেকে ফোন করে পন্যের কালার ও সাইজ কনফার্ম করা হবে।"}]'::jsonb, '[{"qty": 1, "price": 450}, {"qty": 2, "price": 859}]'::jsonb, 'অর্ডার করতে নিচের ফর্মটি পূরণ করুন', null, false, 'thank-you', true, 4
from products where code = 'FA-04'
on conflict (slug) do update set blocks = excluded.blocks, tiers = excluded.tiers, title = excluded.title,
  product_id = excluded.product_id, form_title = excluded.form_title, note_label = excluded.note_label,
  thankyou_slug = excluded.thankyou_slug;

insert into landing_pages (slug, product_id, title, blocks, tiers, form_title, note_label, note_required, thankyou_slug, active, sort)
select 'hook-belt', id, 'স্লিমিং হুক বেল্ট', '[{"t": "image", "img": {"src": "/lp-img/hook-belt/chatgpt-image-jan-13-2026-01-50-20-pm-1.webp", "w": 640, "h": 640}}, {"t": "heading", "size": "xl", "text": "স্লিমিং হুক বেল্ট ১ পিস ৪২০/- টাকা, ২ পিস অফার মূল্য মাত্র ৭৯৯/- টাকা"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "video", "url": "https://youtu.be/slKDMChkdaQ"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "list", "items": ["বেল্টটি পড়ার সাথে সাথে পেটের মেদ কম দেখাবে", "নিয়মিত ব্যবহারে স্থায়ীভাবে স্লিম দেখাবে", "সামনে হুক থাকায় ব্যবহার করা খুবই সহজ", "কোন ধরনের পার্শ্বপ্রতিক্রিয়া নেই", "মেদ অনুযায়ী সাইজ ছোট বড় করে ব্যবহার করা যাবে", "স্কিন ও কালো এই ২ টি কালার পাওয়া যাবে"], "title": "স্লিমিং হুক বেল্ট কেন ব্যবহার করবেন?"}, {"t": "image", "img": {"src": "/lp-img/hook-belt/s-hook-belt-3.webp", "w": 720, "h": 720}}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "list", "items": ["১০০% অরিজিনাল পন্য", "কোন অগ্রিম টাকা ছাড়া পন্য অর্ডার করুন", "পন্য রিসিভ করে মূল্য পরিশোধ করুন", "কালার বা সাইজ জনিত যেকোন সমস্যায় সহজে রিটার্ন বা এক্সচেঞ্জ করার সুবিধা", "সঠিক সময়ে পন্য ডেলিভারির নিশ্চয়তা"], "title": "আমাদের কাছ থেকে কেন কিনবেন?"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "heading", "size": "lg", "text": "২ টি গুরুত্বপূর্ন বিষয়"}, {"t": "text", "text": "১। আমরা কোনো অগ্রিম টাকা নেই না। ইনশাল্লাহ সবাই ক্যাশ অন ডেলিভারিতে পন্য রিসিভ করবেন।\n২। অর্ডার করার পরে আমাদের কল সেন্টার থেকে ফোন করে পন্যের কালার ও সাইজ কনফার্ম করা হবে।"}]'::jsonb, '[{"qty": 1, "price": 450}, {"qty": 2, "price": 859}]'::jsonb, 'অর্ডার করতে নিচের ফর্মটি পূরণ করুন', null, false, 'thank-you-woo', true, 5
from products where code = 'FA-04'
on conflict (slug) do update set blocks = excluded.blocks, tiers = excluded.tiers, title = excluded.title,
  product_id = excluded.product_id, form_title = excluded.form_title, note_label = excluded.note_label,
  thankyou_slug = excluded.thankyou_slug;

insert into landing_pages (slug, product_id, title, blocks, tiers, form_title, note_label, note_required, thankyou_slug, active, sort)
select 'hook-hip-shaper', id, 'হুক হিপ শেপার', '[{"t": "image", "img": {"src": "/lp-img/hook-hip-shaper/chatgpt-image-jan-13-2026-01-50-20-pm-1.webp", "w": 640, "h": 640}}, {"t": "heading", "size": "xl", "text": "হুক হিপ শেপার মাত্র ৫৯৯/- টাকা"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "image", "img": {"src": "/lp-img/hook-hip-shaper/3.webp", "w": 421, "h": 421}}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "list", "items": ["স্পেশাল হুক দেয়া আছে যা পেটের মেদ কমাতে বিশেষভাবে সাহায্য করবে", "বেল্টটি পড়ার সাথে সাথে ইন্সট্যান্ট স্লিম দেখাবে", "আলাদা হুক দেয়া আছে তাই যেকোন বডিতে সহজেই ফিট হবে", "নিয়মিত ধুয়ে ব্যবহার করা যাবে", "কোন ধরনের পার্শ্বপ্রতিক্রিয়া নেই তাই যেকোন বয়সের মানুষ অনায়াসে ব্যবহার করতে পারবে", "থাই এর মেদ কমাবে", "হিপ এর শেইপ আকর্ষনীয় দেখাতে সাহায্য করবে"], "title": "স্লিমিং হুক হিপ শেপার কেন ব্যবহার করবেন?"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "list", "items": ["১০০% অরিজিনাল পন্য", "কোন অগ্রিম টাকা ছাড়া পন্য অর্ডার করুন", "পন্য রিসিভ করে মূল্য পরিশোধ করুন", "কালার বা সাইজ জনিত যেকোন সমস্যায় সহজে রিটার্ন বা এক্সচেঞ্জ করার সুবিধা", "সঠিক সময়ে পন্য ডেলিভারির নিশ্চয়তা"], "title": "আমাদের কাছ থেকে কেন কিনবেন?"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "heading", "size": "lg", "text": "২ টি গুরুত্বপূর্ন বিষয়"}, {"t": "text", "text": "১। আমরা কোনো অগ্রিম টাকা নেই না। ইনশাল্লাহ সবাই ক্যাশ অন ডেলিভারিতে পন্য রিসিভ করবেন।\n২। অর্ডার করার পরে আমাদের কল সেন্টার থেকে ফোন করে পন্যের কালার ও সাইজ কনফার্ম করা হবে।"}]'::jsonb, '[{"qty": 1, "price": 599}]'::jsonb, 'অর্ডার করতে নিচের ফর্মটি পূরণ করুন', null, false, 'thank-you-2-2', true, 6
from products where code = 'FA-05'
on conflict (slug) do update set blocks = excluded.blocks, tiers = excluded.tiers, title = excluded.title,
  product_id = excluded.product_id, form_title = excluded.form_title, note_label = excluded.note_label,
  thankyou_slug = excluded.thankyou_slug;

insert into landing_pages (slug, product_id, title, blocks, tiers, form_title, note_label, note_required, thankyou_slug, active, sort)
select 'waist-shapewear', id, 'প্রিমিয়াম হাই-ওয়েস্ট শেপওয়্যার', '[{"t": "image", "img": {"src": "/lp-img/waist-shapewear/chatgpt-image-jan-13-2026-01-50-20-pm-1.webp", "w": 640, "h": 640}}, {"t": "heading", "size": "xl", "text": "প্রিমিয়াম হাই-ওয়েস্ট শেপওয়্যার ১ পিস ৮৯০/- টাকা"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "image", "img": {"src": "/lp-img/waist-shapewear/whatsapp-image-2026-02-23-at-1-22-40-am.webp", "w": 1000, "h": 1000}}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "list", "items": ["হাই-ওয়েস্ট ডিজাইন – টামি কন্ট্রোল ও কোমর স্লিম লুক", "ব্রিদেবল ও সফট ফেব্রিক – সারাদিন আরামদায়ক", "পার্টি, অফিস বা ডেইলি ইউজের জন্য উপযোগী", "কালার অপশন: ব্ল্যাক, স্কিন, পিচ", "স্টাইলিশ লেস প্যানেল – এলিগ্যান্ট ও ফেমিনিন টাচ", "বাট লিফট ইফেক্ট – ন্যাচারাল কার্ভ হাইলাইট", "মাল্টি-লেয়ার কমপ্রেশন – পেট ও সাইড ফ্যাট স্মুথ করে", "সাইজ: M- L- XL- 2XL- 3XL"], "title": "স্লিমিং হুক বেল্ট কেন ব্যবহার করবেন?"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "list", "items": ["১০০% অরিজিনাল পন্য", "কোন অগ্রিম টাকা ছাড়া পন্য অর্ডার করুন", "পন্য রিসিভ করে মূল্য পরিশোধ করুন", "কালার বা সাইজ জনিত যেকোন সমস্যায় সহজে রিটার্ন বা এক্সচেঞ্জ করার সুবিধা", "সঠিক সময়ে পন্য ডেলিভারির নিশ্চয়তা"], "title": "আমাদের কাছ থেকে কেন কিনবেন?"}, {"t": "cta", "text": "অর্ডার করতে ক্লিক করুন"}, {"t": "heading", "size": "lg", "text": "২ টি গুরুত্বপূর্ন বিষয়"}, {"t": "text", "text": "১। আমরা কোনো অগ্রিম টাকা নেই না। ইনশাল্লাহ সবাই ক্যাশ অন ডেলিভারিতে পন্য রিসিভ করবেন।\n২। অর্ডার করার পরে আমাদের কল সেন্টার থেকে ফোন করে পন্যের কালার ও সাইজ কনফার্ম করা হবে।"}]'::jsonb, '[{"qty": 1, "price": 690}]'::jsonb, 'অর্ডার করতে নিচের ফর্মটি পূরণ করুন', null, false, 'thank-you-2', true, 7
from products where code = 'FA-06'
on conflict (slug) do update set blocks = excluded.blocks, tiers = excluded.tiers, title = excluded.title,
  product_id = excluded.product_id, form_title = excluded.form_title, note_label = excluded.note_label,
  thankyou_slug = excluded.thankyou_slug;

insert into landing_pages (slug, product_id, title, blocks, tiers, form_title, note_label, note_required, thankyou_slug, active, sort)
select 'organic-collagen', id, 'অরগানিক কোলাজেন', '[{"t": "text", "text": "✨ স্কিনে আনুন ন্যাচারাল গ্লো, ভেতর থেকে বিউটি কেয়ার শুরু হোক আজই ✨\nঅস্ট্রেলিয়ান কোলাজেন এখন শুধু একটি সাপ্লিমেন্ট নয়, এটি আপনার স্কিন, চুল ও নখের সম্পূর্ণ বিউটি সাপোর্ট 💖"}, {"t": "video", "url": "https://youtube.com/shorts/y74DA7P_EI0?si=2Rc1RbSkuBIAfG6R"}, {"t": "cta", "text": "অর্ডার করতে চাই"}, {"t": "heading", "size": "xl", "text": "অরগানিক কোলাজেন এর বিশেষ বৈশিষ্ট্যসমূহ"}, {"t": "list", "items": ["ত্বক টানটান ও ইয়াং লুক রাখতে সাহায্য করে", "স্কিনের রুক্ষতা কমিয়ে সফট ও গ্লোয়িং করে", "ফাইন লাইন ও বলিরেখা কমাতে সহায়তা করে", "ব্রণ বা দাগের পর স্কিন রিপেয়ারে সাহায্য করে", "চুল পড়া কমিয়ে চুলকে শক্ত ও স্বাস্থ্যকর রাখতে সহায়ক", "ভেতর থেকে স্কিনের ইলাস্টিসিটি বাড়াতে সাহায্য করে"]}, {"t": "cta", "text": "অর্ডার করতে চাই"}, {"t": "image", "img": {"src": "/lp-img/organic-collagen/77e18157-691d-4ea2-b24e-117477fcbf54.webp", "w": 1000, "h": 1000}}, {"t": "cta", "text": "অর্ডার করতে চাই"}, {"t": "list", "items": ["প্রোডাক্ট হাতে পেয়ে, দেখে,কোয়ালিটি চেক করে পেমেন্টে করার সুবিধা ।", "প্রোডাক্ট পছন্দ না হলে ডেলিভারি চার্জ দিয়ে সাথে সাথে রিটার্ন দিতে পারবেন।", "সারা বাংলাদেশে কুরিয়ারের মাধ্যমে হোম ডেলিভারি পাবেন।", "যে কোন সময় আমাদের সাথে যোগাযোগ করতে পারবেন।"], "title": "আমাদের উপর কেন আস্থা রাখবেন?"}]'::jsonb, '[{"qty": 1, "price": 1190}]'::jsonb, 'অর্ডার করতে নিচের ফর্মটি পূরণ করুন', null, false, 'thank-you-3', true, 8
from products where code = 'FA-07'
on conflict (slug) do update set blocks = excluded.blocks, tiers = excluded.tiers, title = excluded.title,
  product_id = excluded.product_id, form_title = excluded.form_title, note_label = excluded.note_label,
  thankyou_slug = excluded.thankyou_slug;
