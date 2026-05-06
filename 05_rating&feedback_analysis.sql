-- =====================================================
-- File: 03_rider&delivery_performance.sql
-- Purpose: Analyze rider and delivery performance
-- Author: Kunwar Satyarth Singh
-- =====================================================

--  Section E: Rating & Feedback Analytics

   SELECT * FROM orders;
   SELECT * FROM restaurants;
   SELECT * FROM riders;
   SELECT * FROM deliveries;
   SELECT * FROM ratings;
   SELECT * FROM order_items;
   SELECT * FROM menu_items;

   

-- Q1: Find average rating per city and cuisine

SELECT 
    city,
    cuisine,
    ROUND(AVG(rating), 2) AS avg_rating
FROM restaurants
GROUP BY city, cuisine
ORDER BY avg_rating DESC;

-- Q2: Identify users who frequently give low ratings (≤ 3)

SELECT 
    user_id,
    COUNT(rating) AS low_rating_count
FROM ratings
WHERE rating <= 3
GROUP BY user_id
ORDER BY low_rating_count DESC
LIMIT 5;

-- Q3: Correlation between delivery time and rating

SELECT 
    ROUND(
        CORR(
            EXTRACT(EPOCH FROM (d.dropped_ts - d.picked_ts)),
            r.rating
        )::NUMERIC,
        4
    ) AS delivery_time_rating_correlation
FROM deliveries d
JOIN ratings r 
    ON d.order_id = r.order_id
WHERE d.picked_ts IS NOT NULL
  AND d.dropped_ts IS NOT NULL
  AND r.rating IS NOT NULL;

-- Q4: Find most common keywords in negative reviews

WITH negative_reviews AS (
    SELECT 
        r.rest_id,
        res.name AS restaurant_name,
        LOWER(r.comment) AS comment
    FROM ratings r
    JOIN restaurants res 
        ON r.rest_id = res.rest_id
    WHERE r.rating <= 3
      AND r.comment IS NOT NULL
),

words AS (
    SELECT 
        rest_id,
        restaurant_name,
        UNNEST(string_to_array(comment, ' ')) AS word
    FROM negative_reviews
)

SELECT 
    restaurant_name,
    word,
    COUNT(*) AS frequency
FROM words
WHERE word NOT IN (
    'the','a','an','and','is','was','for','of','to','in','on','with','it',
    'this','that','very','too','my','your','food','order','restaurant'
)
GROUP BY restaurant_name, word
ORDER BY frequency DESC
LIMIT 15;


--NOTE:->corr(x, y) → built-in PostgreSQL function that returns Pearson correlation coefficient.
--Negative correlation (-0.42) → means as delivery time increases, ratings tend to decrease.
--Positive correlation (+0.3) → means faster deliveries don’t strongly influence ratings; customers may care more about food quality.
--Near 0 → means no clear relationship between speed and rating.)

