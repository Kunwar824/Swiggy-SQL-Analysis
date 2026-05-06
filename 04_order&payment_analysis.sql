-- =====================================================
-- File: 03_rider&delivery_performance.sql
-- Purpose: Analyze rider and delivery performance
-- Author: Kunwar Satyarth Singh
-- =====================================================

--  Section D: Order & Payment Analysis

   SELECT * FROM orders;
   SELECT * FROM riders;
   SELECT * FROM deliveries;
   SELECT * FROM ratings;
   SELECT * FROM order_items;
   SELECT * FROM menu_items;


-- Q1: Percentage of completed orders by payment method

SELECT 
    payment_method,
    ROUND(
        SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),
        2
    ) AS completed_order_percentage
FROM orders
GROUP BY payment_method
ORDER BY completed_order_percentage DESC;

-- Q2: Monthly revenue trend across platforms

SELECT 
    platform,
    TO_CHAR(order_ts, 'YYYY-MM') AS order_month,
    SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY platform, TO_CHAR(order_ts, 'YYYY-MM')
ORDER BY platform, order_month;

-- Q3: Promo code usage percentage and average discount

WITH order_level_amount AS (
    SELECT 
        o.order_id,
        o.promo_code,
        o.total_amount,
        SUM(oi.qty * oi.item_price) AS original_amount
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.promo_code, o.total_amount
)

SELECT 
    ROUND(
        SUM(CASE WHEN promo_code IS NOT NULL THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS promo_order_percentage,

    ROUND(
        AVG(GREATEST(original_amount - total_amount, 0)),
        2
    ) AS avg_discount
FROM order_level_amount;

-- Q4: Orders where total_amount ≠ sum of order_items

SELECT 
    o.order_id,
    o.total_amount,
    SUM(oi.qty * oi.item_price) AS calculated_amount,
    ROUND(o.total_amount - SUM(oi.qty * oi.item_price), 2) AS difference
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
HAVING o.total_amount <> SUM(oi.qty * oi.item_price)
ORDER BY ABS(o.total_amount - SUM(oi.qty * oi.item_price)) DESC;

-- Q5: Identify peak order days and hours

SELECT 
    TRIM(TO_CHAR(order_ts, 'Day')) AS day_of_week,
    EXTRACT(HOUR FROM order_ts) AS hour_of_day,
    COUNT(*) AS total_orders
FROM orders
GROUP BY day_of_week, hour_of_day
ORDER BY total_orders DESC
LIMIT 10;
