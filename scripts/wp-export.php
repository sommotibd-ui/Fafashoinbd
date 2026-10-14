<?php
/**
 * পুরনো WooCommerce অর্ডার → একটা অস্থায়ী JSON ফাইল
 *
 * WordPress সার্ভারে চলে (Novamira execute-php দিয়ে)। ফাইলের নাম এলোমেলো
 * (fa-x-<৩২ অক্ষর>.json), তারপর অ্যাডমিন লগইন করা অবস্থায়
 * POST /api/admin/wp-import { url } ডাকলে নতুন সাইট ফাইলটা পড়ে Supabase-এ
 * বসায়। কাজ শেষে ফাইলটা মুছে দিন (fa_export_cleanup())।
 *
 * কোনো কি বা টোকেন লাগে না — Supabase-এর সার্ভিস কি WordPress-এ যায় না।
 *
 * বারবার চালানো নিরাপদ: wp_order_id দিয়ে upsert হয়। কাটওভারের দিন আবার
 * চালালে নতুন অর্ডার আর বদলানো স্ট্যাটাস — দুটোই মিলে যায়।
 *
 * ব্যবহার:  require '.../wp-export.php'; return fa_export_orders();
 */

function fa_phone($p) {
	$bn = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
	$d  = preg_replace('/\D/', '', str_replace($bn, range(0, 9), (string) $p));
	if (str_starts_with($d, '00')) $d = substr($d, 2);
	if (str_starts_with($d, '880')) $d = substr($d, 3);
	elseif (str_starts_with($d, '0')) $d = substr($d, 1);
	return (strlen($d) === 10 && $d[0] === '1') ? '880' . $d : null;
}

function fa_export_orders($write = true) {   // false = শুধু গুনে দেখা, ফাইল লেখে না
	global $wpdb; $p = $wpdb->prefix;
	@set_time_limit(600);

	// CartFlows চেকআউট ধাপ → নতুন সাইটের ল্যান্ডিং পেইজ
	$landing = [1486 => 'magic-dreamfit-bra', 1759 => 'mesh-bra', 1398 => 'magnetic-slimming-belt',
		664 => 'hook-slimming-belt', 612 => 'hook-belt', 789 => 'hook-hip-shaper',
		732 => 'waist-shapewear', 1249 => 'organic-collagen'];
	// WooCommerce প্রোডাক্ট আইডি → নতুন কোড (scripts/make_seed.py-র সাথে মেলানো)
	$code = [1483 => 'FA-01', 1747 => 'FA-02', 1402 => 'FA-03', 478 => 'FA-04', 769 => 'FA-05', 734 => 'FA-06',
		1207 => 'FA-07', 573 => 'FA-08', 504 => 'FA-09', 487 => 'FA-10', 283 => 'FA-11', 249 => 'FA-12',
		240 => 'FA-13', 224 => 'FA-14', 582 => 'FA-15', 513 => 'FA-16', 493 => 'FA-17', 469 => 'FA-18',
		296 => 'FA-19', 278 => 'FA-20', 221 => 'FA-21', 216 => 'FA-22', 213 => 'FA-23', 208 => 'FA-24',
		206 => 'FA-25', 70 => 'FA-26'];
	// পুরনো সাইটে "Completed" = পাঠানো/শেষ। trash আনা হয় না।
	$status = ['wc-completed' => 'delivered', 'wc-cancelled' => 'cancelled', 'wc-failed' => 'cancelled',
		'wc-refunded' => 'returned', 'wc-processing' => 'new', 'wc-on-hold' => 'new', 'wc-pending' => 'new'];
	// আগে চেকআউটে থাকা বাড়তি ঘর — নোটে যোগ হয়
	$extra = ['billing_color' => 'কালার', 'billing_size' => 'সাইজ', 'billing_product_option' => 'অপশন',
		'billing_body_info' => 'বডি', 'billing_height_weight' => 'উচ্চতা/ওজন'];
	$mkeys = array_merge(array_keys($extra), ['_wcf_checkout_id', '_wc_order_attribution_utm_source',
		'_wc_order_attribution_utm_medium', '_wc_order_attribution_utm_campaign', '_wc_order_attribution_utm_content',
		'_wc_order_attribution_utm_term', '_wc_order_attribution_session_entry', '_wc_order_attribution_referrer',
		'_wc_order_attribution_user_agent']);
	$in = "'" . implode("','", array_map('esc_sql', $mkeys)) . "'";

	$rows = $wpdb->get_results(
		"SELECT o.id,o.status,o.total_amount,o.date_created_gmt,o.date_updated_gmt,o.customer_note,o.ip_address,
		        a.first_name,a.last_name,a.address_1,a.address_2,a.city,a.state,a.phone
		   FROM {$p}wc_orders o
		   LEFT JOIN {$p}wc_order_addresses a ON a.order_id=o.id AND a.address_type='billing'
		  WHERE o.type='shop_order' ORDER BY o.id", ARRAY_A);
	$meta = [];
	foreach ($wpdb->get_results("SELECT order_id,meta_key,meta_value FROM {$p}wc_orders_meta WHERE meta_key IN ($in)", ARRAY_A) as $m)
		$meta[$m['order_id']][$m['meta_key']] = $m['meta_value'];
	$items = [];
	foreach ($wpdb->get_results(
		"SELECT i.order_id,i.order_item_name name,i.order_item_type type,
		        MAX(CASE WHEN m.meta_key='_qty' THEN m.meta_value END) qty,
		        MAX(CASE WHEN m.meta_key='_product_id' THEN m.meta_value END) pid,
		        MAX(CASE WHEN m.meta_key IN ('_line_total','cost') THEN m.meta_value END) total
		   FROM {$p}woocommerce_order_items i
		   LEFT JOIN {$p}woocommerce_order_itemmeta m ON m.order_item_id=i.order_item_id AND m.meta_key IN ('_qty','_product_id','_line_total','cost')
		  GROUP BY i.order_item_id", ARRAY_A) as $it)
		$items[$it['order_id']][] = $it;

	$orders = []; $lines = []; $skipped = 0;
	$iso = fn($d) => $d ? str_replace(' ', 'T', $d) . 'Z' : null;
	foreach ($rows as $r) {
		if (!isset($status[$r['status']])) { $skipped++; continue; }
		$id = (int) $r['id']; $m = $meta[$id] ?? [];
		$ship = 0; $outside = true; $sub = 0;
		foreach ($items[$id] ?? [] as $it) {
			if ($it['type'] === 'shipping') {
				$ship += (int) round((float) $it['total']);
				$outside = str_contains($it['name'], 'বাইরে');
				continue;
			}
			if ($it['type'] !== 'line_item') continue;
			$q = max(1, (int) $it['qty']); $t = (int) round((float) $it['total']); $sub += $t;
			$lines[] = ['wp_order_id' => $id, 'product_code' => $code[(int) $it['pid']] ?? null,
				'product_name' => $it['name'], 'opt_key' => 'one', 'opt_label' => 'এক সাইজ',
				'qty' => $q, 'unit_price' => (int) round($t / $q), 'line_total' => $t];
		}
		$notes = array_filter([$r['customer_note']]);
		foreach ($extra as $k => $label) if (!empty($m[$k])) $notes[] = "$label: {$m[$k]}";
		$phone = fa_phone($r['phone']);
		$total = (int) round((float) $r['total_amount']);
		$st = $status[$r['status']];
		$orders[] = [
			'order_no' => $id, 'wp_order_id' => $id,
			'name' => mb_substr(trim(($r['first_name'] ?? '') . ' ' . ($r['last_name'] ?? '')) ?: 'কাস্টমার', 0, 100),
			'phone' => $phone ?: (preg_replace('/\D/', '', (string) $r['phone']) ?: 'unknown'),
			'phone_raw' => $r['phone'],
			'address' => mb_substr(trim(implode(', ', array_filter([$r['address_1'], $r['address_2'], $r['city'], $r['state']]))) ?: '—', 0, 300),
			'city_type' => $outside ? 'outside' : 'inside',
			'note' => $notes ? mb_substr(implode(' · ', $notes), 0, 500) : null,
			'subtotal' => $sub ?: max(0, $total - $ship), 'shipping' => $ship, 'total' => $total,
			'status' => $st,
			'landing_slug' => $landing[(int) ($m['_wcf_checkout_id'] ?? 0)] ?? null,
			'client_ip' => $r['ip_address'] ?: null,
			'user_agent' => isset($m['_wc_order_attribution_user_agent']) ? mb_substr($m['_wc_order_attribution_user_agent'], 0, 500) : null,
			'utm_source' => $m['_wc_order_attribution_utm_source'] ?? null,
			'utm_medium' => $m['_wc_order_attribution_utm_medium'] ?? null,
			'utm_campaign' => $m['_wc_order_attribution_utm_campaign'] ?? null,
			'utm_content' => $m['_wc_order_attribution_utm_content'] ?? null,
			'utm_term' => $m['_wc_order_attribution_utm_term'] ?? null,
			'landing_url' => isset($m['_wc_order_attribution_session_entry']) ? mb_substr($m['_wc_order_attribution_session_entry'], 0, 1000) : null,
			'referrer' => $m['_wc_order_attribution_referrer'] ?? null,
			'created_at' => $iso($r['date_created_gmt']),
			'delivered_at' => $st === 'delivered' ? $iso($r['date_updated_gmt'] ?: $r['date_created_gmt']) : null,
		];
	}

	$res = ['orders' => count($orders), 'items' => count($lines), 'skipped_trash' => $skipped,
		'last_wp_id' => $rows ? (int) end($rows)['id'] : 0, 'sum_total' => array_sum(array_column($orders, 'total')),
		'by_status' => array_count_values(array_column($orders, 'status')),
		'by_landing' => array_count_values(array_map(fn($o) => $o['landing_slug'] ?? '-', $orders))];
	if (!$write) return $res;
	$name = 'fa-x-' . bin2hex(random_bytes(20)) . '.json';
	$up = wp_upload_dir();
	file_put_contents($up['basedir'] . '/' . $name, wp_json_encode(['orders' => $orders, 'items' => $lines], JSON_UNESCAPED_UNICODE));
	return $res + ['url' => $up['baseurl'] . '/' . $name];
}

/** ইমপোর্ট শেষে অস্থায়ী ফাইল মুছে ফেলা — কাস্টমারের তথ্য খোলা জায়গায় রাখা যাবে না */
function fa_export_cleanup() {
	$up = wp_upload_dir();
	$n = 0;
	foreach (glob($up['basedir'] . '/fa-x-*.json') as $f) { @unlink($f); $n++; }
	return $n;
}
