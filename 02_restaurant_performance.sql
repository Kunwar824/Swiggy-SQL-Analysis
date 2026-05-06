-- =====================================================
-- File: 02_restaurant_performance.sql
-- Purpose: Analyze restaurant revenue, ratings, and cancellations
-- Author: Kunwar Satyarth Singh
-- =====================================================


--  Section B: Restaurant & Menu Insights
      SELECT * FROM restaurants;
	  SELECT * FROM orders;
	  SELECT * FROM ratings;
	  SELECT * FROM menu_items;
	  SELECT * FROM order_items;
	  SELECT * FROM deliveries;

-- Q1: Find top 10 restaurants by total revenue

SELECT 
    o.rest_id,
    r.name AS restaurant_name,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM orders o
JOIN restaurants r 
    ON o.rest_id = r.rest_id
GROUP BY o.rest_id, r.name
ORDER BY total_revenue DESC
LIMIT 10;

-- Q2: Cuisines with highest average user ratings

SELECT 
    r.cuisine,
    ROUND(AVG(ra.rating), 2) AS avg_rating
FROM restaurants r
JOIN ratings ra 
    ON r.rest_id = ra.rest_id
GROUP BY r.cuisine
ORDER BY avg_rating DESC
LIMIT 5;

-- Q3: Restaurants with rating < 3.5 but high sales

SELECT 
    r.rest_id,
    r.name AS restaurant_name,
    r.city,
    r.rating,
    ROUND(SUM(o.total_amount), 2) AS total_sales
FROM restaurants r
JOIN orders o 
    ON r.rest_id = o.rest_id
WHERE r.rating < 3.5
GROUP BY r.rest_id, r.name, r.city, r.rating
ORDER BY total_sales DESC
LIMIT 5;

-- Q4: Most popular menu item categories by quantity sold

SELECT 
    m.category,
    SUM(oi.qty) AS total_quantity_sold
FROM order_items oi
JOIN menu_items m 
    ON oi.item_id = m.item_id
GROUP BY m.category
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- Q5: Top 5 restaurants by repeat customers

WITH repeat_users AS (
    SELECT 
        rest_id,
        user_id
    FROM orders
    GROUP BY rest_id, user_id
    HAVING COUNT(order_id) > 1
)

SELECT 
    r.rest_id,
    r.name AS restaurant_name,
    COUNT(DISTINCT ru.user_id) AS repeat_customers
FROM restaurants r
JOIN repeat_users ru 
    ON r.rest_id = ru.rest_id
GROUP BY r.rest_id, r.name
ORDER BY repeat_customers DESC
LIMIT 5;

-- Q6: Restaurants with highest number of 5-star ratings

SELECT 
    r.rest_id,
    r.name AS restaurant_name,
    r.city,
    COUNT(ra.rating) AS total_5star_ratings
FROM restaurants r
JOIN ratings ra 
    ON r.rest_id = ra.rest_id
WHERE ra.rating = 5
GROUP BY r.rest_id, r.name, r.city
ORDER BY total_5star_ratings DESC;