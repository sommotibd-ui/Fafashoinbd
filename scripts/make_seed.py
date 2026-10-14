"""fashopbd — পুরনো WordPress এক্সপোর্ট থেকে seed.sql + ছবি বানানো।

চালান: python3 make_seed.py   (export.json, imgmap.json, clean/ লাগবে)
"""
import json, re, html, os, shutil

W = '/home/claude/work'
OUT = '/home/claude/fashopbd'
rv = json.load(open(f'{W}/export.json'))
im = json.load(open(f'{W}/imgmap.json'))
MAP, DIMS = im['map'], im['dims']

# ---------------------------------------------------------------- ছবি
used = {}  # webp ফাইল → পাবলিক পাথ


def pic(url, folder, alt=None):
    u = url.replace('http://', 'https://')
    f = MAP[u]
    dest = f'/lp-img/{folder}/{f}'
    os.makedirs(f'{OUT}/public/lp-img/{folder}', exist_ok=True)
    shutil.copy(f'{W}/clean/{f}', f'{OUT}/public{dest}')
    w, h = DIMS[f]
    d = {'src': dest, 'w': w, 'h': h}
    if alt:
        d['alt'] = alt
    return d


def txt(h):
    h = re.sub(r'<br\s*/?>|</p>', '\n', h)
    t = html.unescape(re.sub(r'<[^>]+>', '', h))
    t = t.replace('\xa0', ' ')
    return '\n'.join(l.strip() for l in t.split('\n') if l.strip())


# ---------------------------------------------------------------- প্রোডাক্ট
CAT = {'Ladies inner': 'ladies-inner', 'Slimming belt': 'shapewear', 'Slimming Items': 'shapewear',
       'Skin Care': 'beauty', 'cosmetics': 'beauty', 'Ornaments': 'ornaments', 'Gadget': 'gadget'}
UNCAT = {1747: 'ladies-inner', 1483: 'ladies-inner', 734: 'shapewear'}
FIRST = [1483, 1747, 1402, 478, 769, 734, 1207]   # ল্যান্ডিং পেইজের পণ্য আগে

prods = {p['id']: p for p in rv['products'] if p['status'] == 'publish'}
order = FIRST + sorted([i for i in prods if i not in FIRST], key=lambda i: -int(prods[i]['total_sales'] or 0))
code_of = {}
P_ROWS = []
for n, wid in enumerate(order, 1):
    p = prods[wid]
    code = f'FA-{n:02d}'
    code_of[wid] = code
    cat = UNCAT.get(wid) or next((CAT[c] for c in p['cats'] if c in CAT), 'shapewear')
    imgs = [pic(u, 'products')['src'] for u in p['images']]
    price = round(float(p['price'] or 0))
    reg = round(float(p['regular'] or 0))
    raw = (p['short'] or '') + '\n' + (p['desc'] or '')
    vids = re.findall(r'https?://(?:www\.)?(?:youtube\.com/(?:watch\?v=|shorts/)|youtu\.be/)[\w-]+', raw)
    raw = re.sub(r'\[/?(embed|gallery|caption)[^\]]*\]', '\n', raw)
    desc = txt(raw)
    desc = '\n'.join(l for l in desc.split('\n') if len(l) > 2 and not re.match(r'^https?://\S+$', l))[:4000] or None
    P_ROWS.append(dict(code=code, fb_id=str(wid), name=p['name'].strip(), slug=f"{code.lower()}",
                       category=cat, price=price, compare=reg if reg > price else None,
                       images=imgs, desc=desc, video=vids[0] if vids else None, sort=n))

# ---------------------------------------------------------------- ল্যান্ডিং পেইজ
# CartFlows-এর "discount_price" = প্রতি পিসে টাকা ছাড় → (দাম − ছাড়) × পিস।
# অর্ডারের আসল লাইন টোটালের সাথে মিলিয়ে দেখা: ৪৮০/৯০০/১২০০, ৪৫০/৮৫০/১২০০,
# ৪৯০/৯০০, ৪৫০/৮৫৯ — সব মিলেছে।
def tiers_of(step):
    out = []
    for it in step['products']:
        wp = prods[int(it['product'])]
        q = int(it['quantity'])
        unit = float(wp['price'])
        if it.get('discount_type') == 'discount_price' and it.get('discount_value'):
            unit -= float(it['discount_value'])
        elif it.get('discount_type') == 'discount_percent' and it.get('discount_value'):
            unit *= 1 - float(it['discount_value']) / 100
        out.append({'qty': q, 'price': round(unit * q)})
    return out


def blocks_of(step, folder):
    B = []
    pend_title = None
    first_head = True
    for b in step['blocks']:
        w = b['w']
        if w == 'checkout-form':
            break
        if w == 'heading':
            t = txt(b.get('title', ''))
            if pend_title:
                B.append({'t': 'heading', 'size': 'lg', 'text': pend_title})
            pend_title = None
            if first_head:
                B.append({'t': 'heading', 'size': 'xl', 'text': t}); first_head = False
            else:
                pend_title = t
            continue
        if w == 'text-editor':
            t = txt(b.get('editor', ''))
            if first_head and len(t) < 160:
                B.append({'t': 'heading', 'size': 'xl', 'text': t}); first_head = False
            elif pend_title:
                B.append({'t': 'heading', 'size': 'lg', 'text': pend_title}); pend_title = None
                B.append({'t': 'text', 'text': t})
            else:
                B.append({'t': 'text', 'text': t})
            continue
        if w == 'icon-list':
            items = [txt(x) for x in b['icon_list'] if txt(x)]
            if B and B[-1]['t'] == 'list' and pend_title is None and B[-1].get('_open'):
                for x in items:
                    if x not in B[-1]['items']:
                        B[-1]['items'].append(x)
            else:
                d = {'t': 'list', 'items': items, '_open': True}
                if pend_title:
                    d['title'] = pend_title; pend_title = None
                B.append(d)
            continue
        if B and B[-1].get('_open'):
            B[-1].pop('_open')
        if pend_title:
            B.append({'t': 'heading', 'size': 'lg', 'text': pend_title}); pend_title = None
        if w == 'image':
            B.append({'t': 'image', 'img': pic(b['image'], folder)})
        elif w == 'image-gallery':
            B.append({'t': 'gallery', 'cols': 2, 'images': [pic(u, folder) for u in b['wp_gallery']]})
        elif w == 'video':
            B.append({'t': 'video', 'url': b['youtube_url']})
        elif w == 'button':
            B.append({'t': 'cta', 'text': b.get('text') or None})
        # divider ইত্যাদি বাদ
    if pend_title:
        B.append({'t': 'heading', 'size': 'lg', 'text': pend_title})
    for x in B:
        x.pop('_open', None)
        if x.get('t') == 'cta' and not x.get('text'):
            x.pop('text', None)
    return B


steps = {s['slug']: s for s in rv['steps'].values()}
# ল্যান্ডিং → ধন্যবাদ পাতা (CartFlows ফ্লো-র পরের ধাপ)
TY = {'magic-dreamfit-bra': 'thank-you-5', 'mesh-bra': 'thank-you-5-2', 'magnetic-slimming-belt': 'thank-you-4',
      'hook-slimming-belt': 'thank-you', 'hook-belt': 'thank-you-woo', 'hook-hip-shaper': 'thank-you-2-2',
      'waist-shapewear': 'thank-you-2', 'organic-collagen': 'thank-you-3'}
TITLES = {'magic-dreamfit-bra': 'ম্যাজিক ড্রিমফিট ব্রা', 'mesh-bra': 'ব্রিদেবল মেশ ব্রা',
          'magnetic-slimming-belt': 'ম্যাগনেটিক স্লিমিং বেল্ট', 'hook-slimming-belt': 'স্লিমিং হুক বেল্ট',
          'hook-belt': 'স্লিমিং হুক বেল্ট', 'hook-hip-shaper': 'হুক হিপ শেপার',
          'waist-shapewear': 'প্রিমিয়াম হাই-ওয়েস্ট শেপওয়্যার', 'organic-collagen': 'অরগানিক কোলাজেন'}
ORDER = ['magic-dreamfit-bra', 'mesh-bra', 'magnetic-slimming-belt', 'hook-slimming-belt', 'hook-belt',
         'hook-hip-shaper', 'waist-shapewear', 'organic-collagen']
FORM = {'organic-collagen': 'অর্ডার করতে নিচের ফর্মটি পূরণ করুন'}

L_ROWS = []
for n, slug in enumerate(ORDER, 1):
    st = steps[slug]
    wid = int(st['products'][0]['product'])
    tiers = tiers_of(st)
    if slug == 'mesh-bra':
        # পুরনো পেইজটা হাতে লেখা HTML — সোহা শপে একই পেইজ ব্লকে আনা হয়েছিল,
        # এখানে FA-র দাম, কালার আর ছবি দিয়ে
        g = lambda f: pic(f'https://fashopbd.com/wp-content/uploads/2026/09/{f}', slug)
        blocks = [
            {'t': 'heading', 'size': 'xl', 'text': 'গরমের জন্য আরামদায়ক মেশ ব্রা'},
            {'t': 'text', 'text': 'গরমেও থাকুন সতেজ ও আরামদায়ক— ফোম ছাড়া ব্রেথেবল মেশ ব্রা। সফট মেশ ফেব্রিক, তারবিহীন আরাম এবং সামনে সহজ বাটন—দৈনন্দিন ব্যবহার ও ব্রেস্টফিডিংয়ের সময় ব্যবহারোপযোগী একটি আরামদায়ক ব্রা।'},
            {'t': 'image', 'img': g('4-1.webp')},
            {'t': 'heading', 'size': 'md', 'text': 'কম্বো অফার: ১ পিস ৳৪৫০ | ২ পিস ৳৮৫০ | ৩ পিস ৳১,২০০'},
            {'t': 'cta', 'text': 'এখনই অফার বেছে নিন'},
            {'t': 'features', 'title': 'সারাদিনের আরামের জন্য প্রয়োজনীয় সব সুবিধা', 'items': [
                {'title': 'ব্রেথেবল মেশ', 'desc': 'বাতাস চলাচলে সহায়ক মেশ ফেব্রিক'},
                {'title': 'সুপার সফট', 'desc': 'নরম ও হালকা ফেব্রিকের আরাম'},
                {'title': 'তারবিহীন ডিজাইন', 'desc': 'হার্ড ওয়্যার ছাড়াই আরামদায়ক ব্যবহার'},
                {'title': 'আরামদায়ক', 'desc': 'দৈনন্দিন দীর্ঘ সময় ব্যবহারে উপযোগী'},
                {'title': 'সামনে বাটন', 'desc': 'পরা ও খোলা সহজ এবং ঝামেলাহীন'},
                {'title': 'ফিডিং ফ্রেন্ডলি', 'desc': 'ব্রেস্টফিডিংয়ের সময় ব্যবহার সহজ'},
                {'title': 'ফোম ছাড়া', 'desc': 'হালকা অনুভূতির জন্য foamless design'},
                {'title': 'দৈনন্দিন ব্যবহার', 'desc': 'বাসা ও নিয়মিত ব্যবহারের জন্য উপযোগী'},
                {'title': 'বিভিন্ন বয়সে উপযোগী', 'desc': 'আরামকে গুরুত্ব দেওয়া নারীদের জন্য'},
                {'title': 'সহজ ও সুবিধাজনক', 'desc': 'ব্যবহারবান্ধব ডিজাইন ও আরামদায়ক ফিট'}]},
            {'t': 'compare', 'title': 'সাধারণ ভারী ব্রার বদলে কেন বেছে নেবেন ব্রেথেবল মেশ ব্রা?',
             'bad': {'title': 'সাধারণ ফোম বা ওয়্যারযুক্ত ব্রা', 'items': [
                 'গরমে ভারী ও অস্বস্তিকর লাগতে পারে', 'ফোমের কারণে বাতাস চলাচল তুলনামূলক কম',
                 'ওয়্যার দীর্ঘ সময় ব্যবহারে চাপ তৈরি করতে পারে', 'পরা ও খোলা অনেক সময় ঝামেলার হতে পারে',
                 'দৈনন্দিন ব্যবহারে সবসময় হালকা অনুভূতি নাও দিতে পারে']},
             'good': {'title': 'ব্রেথেবল মেশ ফ্রন্ট-বাটন ব্রা', 'items': [
                 'হালকা ও breathable mesh fabric', 'ফোম ছাড়া হওয়ায় তুলনামূলক হালকা অনুভূতি',
                 'তারবিহীন ডিজাইন—দৈনন্দিন ব্যবহারে আরামদায়ক', 'সামনে বাটন থাকায় পরা ও খোলা সহজ',
                 'গরম ও নিয়মিত ব্যবহারের জন্য সুবিধাজনক ডিজাইন']}},
            {'t': 'heading', 'size': 'md', 'text': 'পাওয়া যাচ্ছে এই কালারগুলোতে: স্কিন, পিংক, স্কাই'},
            {'t': 'gallery', 'cols': 3, 'images': [g('3-1.webp'), g('2-1.webp'), g('4-1.webp')]},
            {'t': 'cta', 'text': 'আমার পছন্দের কম্বো দেখুন'},
            {'t': 'text', 'text': 'কম্বোর প্রতিটি পিসের সাইজ ও কালার অর্ডারের পরে ফোনে জেনে নেওয়া হবে।'},
            {'t': 'text', 'text': 'পণ্যের রঙ স্ক্রিনের সেটিং অনুযায়ী কিছুটা ভিন্ন দেখাতে পারে। এটি কোনো চিকিৎসা সামগ্রী নয় এবং কোনো রোগ নিরাময় বা নিশ্চিত শারীরিক ফলাফলের দাবি করে না।'},
        ]
        for t in tiers:
            if t['qty'] == 3:
                t['default'] = True
            if t['qty'] == 2:
                t['tag'] = 'সবচেয়ে জনপ্রিয়'
    else:
        blocks = blocks_of(st, slug)
    L_ROWS.append(dict(slug=slug, code=code_of[wid], title=TITLES[slug], blocks=blocks, tiers=tiers,
                       form=FORM.get(slug, 'অর্ডার করতে নিচের ফর্মটি পূরণ করুন'), ty=TY[slug], sort=n))

# ---------------------------------------------------------------- SQL
q = lambda s: 'null' if s is None else "'" + str(s).replace("'", "''") + "'"
J = lambda o: q(json.dumps(o, ensure_ascii=False)) + '::jsonb'
out = ['''-- =====================================================================
--  FA Shop BD — প্রোডাক্ট, ল্যান্ডিং পেইজ ও সেটিংস
--  schema.sql ও stock-functions.sql চালানোর পরে একবার চালান।
--  পুরনো WordPress (CartFlows) থেকে আনা — দাম, অফার ও লেখা হুবহু।
--  scripts/make_seed.py থেকে তৈরি — হাতে বদলালে স্ক্রিপ্টেও বদলান।
-- =====================================================================

insert into settings (key, value) values
  ('shipping', '{"inside":70,"outside":120}'::jsonb)
on conflict (key) do update set value = excluded.value;
''']
for p in P_ROWS:
    imgs = 'array[' + ','.join(q(i) for i in p['images']) + ']::text[]' if p['images'] else "'{}'::text[]"
    out.append(f"""insert into products (code, fb_id, name, slug, category, price, compare_price, images, description, video_url, active, sort)
values ({q(p['code'])}, {q(p['fb_id'])}, {q(p['name'])}, {q(p['slug'])}, {q(p['category'])}, {p['price']}, {p['compare'] or 'null'}, {imgs}, {q(p['desc'])}, {q(p['video'])}, true, {p['sort']})
on conflict (code) do update set fb_id = excluded.fb_id, name = excluded.name, price = excluded.price,
  compare_price = excluded.compare_price, images = excluded.images, description = excluded.description,
  video_url = excluded.video_url;
insert into product_variants (product_id, opt_key, opt_label, color_key, stock, sort)
select id, 'one', 'এক সাইজ', '', 100000, 0 from products where code = {q(p['code'])}
on conflict (product_id, opt_key, color_key) do nothing;
""")
out.append('-- সাইজ-রঙ ফোনে নিশ্চিত হয়, তাই একটাই স্টকের ঘর। পুরনো সাইটে স্টক গোনা হতো না —\n-- তাই বড় সংখ্যা, যাতে এড চলার মাঝে "স্টক শেষ" বলে অর্ডার না আটকায়।\n')
for l in L_ROWS:
    out.append(f"""insert into landing_pages (slug, product_id, title, blocks, tiers, form_title, note_label, note_required, thankyou_slug, active, sort)
select {q(l['slug'])}, id, {q(l['title'])}, {J(l['blocks'])}, {J(l['tiers'])}, {q(l['form'])}, null, false, {q(l['ty'])}, true, {l['sort']}
from products where code = {q(l['code'])}
on conflict (slug) do update set blocks = excluded.blocks, tiers = excluded.tiers, title = excluded.title,
  product_id = excluded.product_id, form_title = excluded.form_title, note_label = excluded.note_label,
  thankyou_slug = excluded.thankyou_slug;
""")
open(f'{OUT}/supabase/seed.sql', 'w').write('\n'.join(out))
json.dump({'code_of': {str(k): v for k, v in code_of.items()}, 'landings': L_ROWS, 'products': P_ROWS},
          open(f'{W}/seed_data.json', 'w'), ensure_ascii=False, indent=1)
print(len(P_ROWS), 'products', len(L_ROWS), 'landings')
for l in L_ROWS:
    print(l['slug'], l['code'], l['tiers'], l['ty'], [b['t'] for b in l['blocks']])
