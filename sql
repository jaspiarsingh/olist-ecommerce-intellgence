use ecommerce;
SET SESSION wait_timeout = 600;
SET SESSION interactive_timeout = 600;
/* 
Query 1 — Monthly Revenue Trend
Joins orders with order_items to calculate monthly revenue, order count, and average order value. 
Filters to delivered orders only and groups by month to show growth trends over time.
*/
SELECT 
  DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
  ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;


/* 
Query 2 — Revenue by Product Category
Joins order_items, products, and category_translation to get English category names. 
Aggregates total revenue and average item price per category to identify top performing product lines.
*/
SELECT 
  ct.product_category_name_english AS category,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  ROUND(SUM(oi.price), 2) AS total_revenue,
  ROUND(AVG(oi.price), 2) AS avg_item_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category ct ON p.product_category_name = ct.product_category_name
WHERE ct.product_category_name_english IS NOT NULL
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 15;

/*
Query 3 — Delivery Performance by State
Calculates average delivery days and late delivery percentage per Brazilian state.
 Uses DATEDIFF to measure actual vs estimated delivery dates, revealing which states have the worst logistics performance.
*/
SELECT 
  c.customer_state AS state,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_delivery_days,
  ROUND(SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_delivery_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY state
ORDER BY late_delivery_pct DESC;


/* 
Query 4 — Review Score vs Delivery Performance by Category
Links reviews, delivery timing, and product categories to show whether late deliveries are driving lower review scores. 
The HAVING total_orders > 100 filters out categories with too few orders to be statistically meaningful.
*/
SELECT 
  ct.product_category_name_english AS category,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_delivery_days,
  ROUND(SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_delivery_pct,
  COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
JOIN (
  SELECT DISTINCT oi.order_id, ct.product_category_name_english
  FROM order_items oi
  JOIN products p ON oi.product_id = p.product_id
  JOIN category ct ON p.product_category_name = ct.product_category_name
  WHERE ct.product_category_name_english IS NOT NULL
) AS category_map ON o.order_id = category_map.order_id
JOIN category ct ON category_map.product_category_name_english = ct.product_category_name_english
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY category
HAVING total_orders > 100
ORDER BY avg_review_score ASC
LIMIT 15;

/*
Query 5 — Payment Behavior Analysis
Aggregates payment data by type (credit card, boleto, voucher, debit) 
showing total revenue, average order value, and average installments per payment method. 
Reveals how customers prefer to pay and which method drives higher spend.
*/
SELECT 
  payment_type,
  COUNT(DISTINCT order_id) AS total_orders,
  ROUND(SUM(payment_value), 2) AS total_revenue,
  ROUND(AVG(payment_value), 2) AS avg_order_value,
  ROUND(AVG(payment_installments), 1) AS avg_installments
FROM payments
WHERE payment_type != 'not_defined'
GROUP BY payment_type
ORDER BY total_revenue DESC;

/*
Query 6 — Seller Performance Scorecard
Creates a performance scorecard for each seller showing revenue, review score, average delivery days, and late delivery rate. 
The HAVING total_orders > 50 ensures we only evaluate sellers with enough volume to be meaningful — not someone who sold 2 items.
*/
SELECT 
  oi.seller_id,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  ROUND(SUM(oi.price), 2) AS total_revenue,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_delivery_days,
  ROUND(SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_delivery_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
HAVING total_orders > 50
ORDER BY total_revenue DESC
LIMIT 20;




