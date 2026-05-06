-- =====================================================
-- File: 00_create_tables.sql
-- Purpose: Define Swiggy relational schema with constraints
-- Author: Kunwar Satyarth Singh
-- =====================================================


-- USERS TABLE
DROP TABLE users;
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
	phone_number VARCHAR(10),
    city VARCHAR(50),
    gender VARCHAR(10),
    birth_year INT,
    signup_ts TIMESTAMP,
    is_premium BOOLEAN
);

-- RESTAURANTS TABLE
CREATE TABLE restaurants (
    rest_id SERIAL PRIMARY KEY,
    name VARCHAR(150),
    city VARCHAR(50),
    cuisine VARCHAR(50),
    rating DECIMAL(2,1),
    opentime TIME,
    closetime TIME,
    lat DECIMAL(10,6),
    lon DECIMAL(10,6),
	contact_number VARCHAR(10)
);
DROP TABLE restaurants;
-- MENU ITEMS TABLE
CREATE TABLE menu_items (
    item_id SERIAL PRIMARY KEY,
    rest_id INT REFERENCES restaurants(rest_id) ON DELETE CASCADE,
    name VARCHAR(150),
    category VARCHAR(50),
    price DECIMAL(10,2),
    is_veg BOOLEAN
);



-- RIDERS TABLE
CREATE TABLE riders (
    rider_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
	phone_number VARCHAR(10),
    city VARCHAR(50),
    vehicle_type VARCHAR(20),
    rating DECIMAL(2,1)
);


-- ORDERS TABLE
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    rest_id INT REFERENCES restaurants(rest_id) ON DELETE CASCADE,
    order_ts TIMESTAMP,
    dispatch_ts TIMESTAMP,
    delivered_ts TIMESTAMP,
    status VARCHAR(20),
    total_amount DECIMAL(10,2),
    promo_code VARCHAR(20),
    payment_method VARCHAR(20),
    platform VARCHAR(20),
    city VARCHAR(50)
);


-- ORDER ITEMS TABLE
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    item_id INT REFERENCES  menu_items(item_id) ON DELETE CASCADE,
    qty INT,
    item_price DECIMAL(10,2)
);


-- DELIVERIES TABLE
CREATE TABLE deliveries (
    delivery_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    rider_id INT REFERENCES riders(rider_id) ON DELETE CASCADE,
    picked_ts TIMESTAMP,
    dropped_ts TIMESTAMP,
    distance_km DECIMAL(5,2),
    eta_secs INT,
    status VARCHAR(20)
);


-- RATINGS TABLE
CREATE TABLE ratings (
    rating_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    user_id INT REFERENCES  users(user_id) ON DELETE CASCADE,
	 rest_id INT REFERENCES  restaurants(rest_id) ON DELETE CASCADE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    rating_ts TIMESTAMP,
    comment VARCHAR(200)
);


