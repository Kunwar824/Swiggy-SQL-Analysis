-- =====================================================
-- File: 03_rider&delivery_performance.sql
-- Purpose: Analyze rider and delivery performance
-- Author: Kunwar Satyarth Singh
-- =====================================================


--  Section C: Rider & Delivery Performance

   SELECT * FROM orders;
   SELECT * FROM riders;
   SELECT * FROM deliveries;
   SELECT * FROM ratings;
   SELECT * FROM order_items;
   SELECT * FROM menu_items;

-- Q1: Average delivery distance and duration per rider

SELECT 
    rider_id,
    ROUND(AVG(distance_km), 2) AS avg_delivery_distance_km,
    ROUND(
        AVG(EXTRACT(EPOCH FROM (dropped_ts - picked_ts)) / 60),
        2
    ) AS avg_delivery_duration_mins
FROM deliveries
GROUP BY rider_id
ORDER BY avg_delivery_duration_mins;

-- Q2: Top 5 riders by delivery completion rate

SELECT 
    rider_id,
    ROUND(
        SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS completion_rate_percentage
FROM deliveries
GROUP BY rider_id
ORDER BY completion_rate_percentage DESC
LIMIT 5;

-- Q3: Riders whose ratings dropped in last 3 months vs previous 3 months

WITH rider_ratings AS (
    SELECT 
        d.rider_id,
        r.rating,
        r.rating_ts
    FROM deliveries d
    JOIN ratings r 
        ON d.order_id = r.order_id
),

rating_periods AS (
    SELECT 
        rider_id,
        AVG(CASE 
            WHEN rating_ts >= CURRENT_DATE - INTERVAL '3 months' 
            THEN rating 
        END) AS recent_avg_rating,

        AVG(CASE 
            WHEN rating_ts >= CURRENT_DATE - INTERVAL '6 months'
             AND rating_ts < CURRENT_DATE - INTERVAL '3 months'
            THEN rating 
        END) AS previous_avg_rating
    FROM rider_ratings
    GROUP BY rider_id
)

SELECT 
    rider_id,
    ROUND(previous_avg_rating, 2) AS previous_rating,
    ROUND(recent_avg_rating, 2) AS recent_rating,
    ROUND(previous_avg_rating - recent_avg_rating, 2) AS rating_drop
FROM rating_periods
WHERE recent_avg_rating < previous_avg_rating
ORDER BY rating_drop DESC;

-- Q4: Compare city-level avg delivery time with overall average

WITH overall_avg AS (
    SELECT 
        AVG(EXTRACT(EPOCH FROM (dropped_ts - picked_ts))) AS overall_avg_seconds
    FROM deliveries
)

SELECT 
    o.city,
    ROUND(
        AVG(EXTRACT(EPOCH FROM (d.dropped_ts - d.picked_ts))),
        2
    ) AS avg_city_time_seconds,

    ROUND(
        (SELECT overall_avg_seconds FROM overall_avg),
        2
    ) AS overall_avg_time_seconds,

    ROUND(
        AVG(EXTRACT(EPOCH FROM (d.dropped_ts - d.picked_ts)))
        - (SELECT overall_avg_seconds FROM overall_avg),
        2
    ) AS difference_seconds
FROM orders o
JOIN deliveries d 
    ON o.order_id = d.order_id
GROUP BY o.city
ORDER BY difference_seconds DESC;

-- Q5: Ratio of late deliveries to total deliveries by city

SELECT 
    o.city,
    ROUND(
        SUM(
            CASE 
                WHEN EXTRACT(EPOCH FROM (d.dropped_ts - d.picked_ts)) > d.eta_secs 
                THEN 1 ELSE 0 
            END
        ) * 1.0 / COUNT(*),
        3
    ) AS late_delivery_ratio
FROM orders o
JOIN deliveries d 
    ON o.order_id = d.order_id
GROUP BY o.city
ORDER BY late_delivery_ratio DESC;

	  --NOTE:-In SQL, if both numbers in a division are integers,the result is also treated as an integer.
	  --That means:3 / 10 = 0     --  Not 0.3, it truncates to 0
      --SQL doesn’t automatically convert it to a decimal — it just removes the fraction.
      -- So for making integers to float we multiply the one of the integer to 1.0,So that sql should consider decimals also
	