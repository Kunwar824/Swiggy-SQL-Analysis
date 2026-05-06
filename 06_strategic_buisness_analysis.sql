-- =====================================================
-- File: 06_strategic&buisness_analysis.sql
-- Purpose: Analyze rider and delivery performance
-- Author: Kunwar Satyarth Singh
-- =====================================================



--  Section F: Strategic Business Insights
   
   SELECT * FROM users;
   SELECT * FROM orders;
   SELECT * FROM restaurants;
   SELECT * FROM riders;
   SELECT * FROM deliveries;
   SELECT * FROM ratings;
   SELECT * FROM order_items;
   SELECT * FROM menu_items;


-- Q1: Find top 10 high-value customers contributing the most revenue

SELECT 
    u.user_id,
    u.name,
    SUM(o.total_amount) AS total_revenue
FROM users u
JOIN orders o 
    ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
ORDER BY total_revenue DESC
LIMIT 10;

-- Q2: Identify top-performing cities by GMV

SELECT 
    o.city,
    SUM(oi.qty * oi.item_price) AS gmv_city
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY o.city
ORDER BY gmv_city DESC;

-- Q3: Calculate churn rate (% users inactive for last 90 days)

WITH last_order AS (
    SELECT 
        user_id,
        MAX(order_ts) AS last_order_date
    FROM orders
    GROUP BY user_id
)

SELECT 
    ROUND(
        SUM(
            CASE 
                WHEN CURRENT_DATE - last_order_date > INTERVAL '90 days' THEN 1 
                ELSE 0 
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM last_order;

-- Q4: Estimate restaurant profitability (₹10 per km delivery cost)

SELECT 
    r.rest_id,
    r.name,
    ROUND(SUM(o.total_amount), 2) AS total_revenue,
    ROUND(SUM(d.distance_km * 10), 2) AS estimated_delivery_cost,
    ROUND(SUM(o.total_amount) - SUM(d.distance_km * 10), 2) AS estimated_profit
FROM restaurants r
JOIN orders o 
    ON r.rest_id = o.rest_id
JOIN deliveries d 
    ON o.order_id = d.order_id
GROUP BY r.rest_id, r.name
ORDER BY estimated_profit DESC
LIMIT 10;

-- Q5: Monthly order trend with MoM growth

WITH monthly_orders AS (
    SELECT 
        TO_CHAR(order_ts, 'YYYY-MM') AS month,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY TO_CHAR(order_ts, 'YYYY-MM')
)

SELECT 
    month,
    total_orders,
    LAG(total_orders) OVER (ORDER BY month) AS prev_month_orders,
    ROUND(
        (total_orders - LAG(total_orders) OVER (ORDER BY month))::NUMERIC
        / LAG(total_orders) OVER (ORDER BY month) * 100,
        2
    ) AS mom_growth_percent
FROM monthly_orders;

-- Q6: Rank cities by delivery efficiency (time per km)

WITH city_efficiency AS (
    SELECT 
        o.city,
        AVG(EXTRACT(EPOCH FROM (d.dropped_ts - d.picked_ts))) / AVG(d.distance_km) AS delivery_efficiency
    FROM deliveries d
    JOIN orders o 
        ON d.order_id = o.order_id
    GROUP BY o.city
)

SELECT 
    city,
    ROUND(delivery_efficiency, 2) AS delivery_efficiency,
    RANK() OVER (ORDER BY delivery_efficiency ASC) AS efficiency_rank
FROM city_efficiency;

-- Q7: Identify missing or inconsistent data

SELECT 
    (SELECT COUNT(*) 
     FROM ratings 
     WHERE rating IS NULL) AS null_ratings,

    (SELECT COUNT(*) 
     FROM users 
     WHERE phone_number IS NULL 
        OR phone_number !~ '^[0-9]{10}$') AS invalid_phone_numbers,

    (SELECT COUNT(*) 
     FROM restaurants 
     WHERE name IS NULL 
        OR cuisine IS NULL 
        OR city IS NULL) AS missing_restaurant_info;

-- Q8: Validate referential integrity

SELECT
    (SELECT COUNT(*) 
     FROM orders o
     LEFT JOIN users u 
        ON o.user_id = u.user_id
     WHERE u.user_id IS NULL) AS orders_without_users,

    (SELECT COUNT(*) 
     FROM deliveries d
     LEFT JOIN riders r 
        ON d.rider_id = r.rider_id
     WHERE r.rider_id IS NULL) AS deliveries_without_riders;

-- Q9: Daily KPI summary

WITH order_summary AS (
    SELECT 
        DATE(order_ts) AS order_date,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_revenue
    FROM orders
    GROUP BY DATE(order_ts)
),

delivery_summary AS (
    SELECT 
        o.order_id,
        DATE(o.order_ts) AS order_date,
        EXTRACT(EPOCH FROM (d.dropped_ts - d.picked_ts)) / 60 AS delivery_time_mins
    FROM orders o
    JOIN deliveries d 
        ON o.order_id = d.order_id
),

rating_summary AS (
    SELECT 
        order_id,
        rating
    FROM ratings
)

SELECT 
    os.order_date,
    os.total_orders,
    ROUND(os.total_revenue, 2) AS total_revenue,
    ROUND(AVG(ds.delivery_time_mins), 2) AS avg_delivery_time_mins,
    ROUND(AVG(rs.rating), 2) AS avg_rating
FROM order_summary os
LEFT JOIN delivery_summary ds 
    ON os.order_date = ds.order_date
LEFT JOIN rating_summary rs 
    ON ds.order_id = rs.order_id
GROUP BY os.order_date, os.total_orders, os.total_revenue
ORDER BY os.order_date;

--NOTE:- GMV (Gross Merchandise Value) = Total value of all orders placed on the platform during a given period — before deducting any discounts, returns, or platform fees.
--NOTE:- Churn rate measures how many customers stop using your service over a certain period — usually shown as a percentage.It tells you how quickly you’re losing customers.