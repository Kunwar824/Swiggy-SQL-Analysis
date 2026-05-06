-- =====================================================
-- File: 01_user_analysis.sql
-- Purpose: Analyze user behavior, retention, and spending
-- Author: Kunwar Satyarth Singh
-- =====================================================

--  Section A: User & Customer Insights
      SELECT * FROM restaurants;
	  SELECT * FROM orders;
	  SELECT * FROM ratings;
	  SELECT * FROM menu_items;
	  SELECT * FROM order_items;
	  SELECT * FROM deliveries;

   
-- Q1: Find the top 10 most active users by total orders placed

SELECT 
    user_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY user_id
ORDER BY total_orders DESC
LIMIT 10;

-- Q2: Calculate repeat purchase rate

WITH user_orders AS (
    SELECT 
        user_id,
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY user_id
)

SELECT 
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS repeat_purchase_rate_percentage
FROM user_orders;

-- Q3: Average order value by user type

SELECT 
    CASE 
        WHEN u.is_premium = TRUE THEN 'Premium User'
        ELSE 'Non-Premium User'
    END AS user_type,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM users u
JOIN orders o 
    ON u.user_id = o.user_id
GROUP BY u.is_premium;

-- Q4: Identify top 5 cities with highest monthly signups

SELECT 
    city,
    TO_CHAR(signup_ts, 'YYYY-MM') AS signup_month,
    COUNT(*) AS total_signups
FROM users
GROUP BY city, TO_CHAR(signup_ts, 'YYYY-MM')
ORDER BY total_signups DESC
LIMIT 5;

-- Q5: Find users who haven’t ordered in last 90 days

SELECT 
    user_id
FROM orders
GROUP BY user_id
HAVING MAX(order_ts) < CURRENT_DATE - INTERVAL '90 days';