# 🚀 Swiggy Food Delivery SQL Analytics Project

### *End-to-End Business Analysis using PostgreSQL | Data Analytics | KPI Engineering*

---

## 📌 Project Overview

This project simulates a **real-world Swiggy food delivery ecosystem** and performs **end-to-end SQL-based data analysis** across users, restaurants, orders, deliveries, and ratings.

The goal is to extract **business-critical insights**, optimize operations, and design **data models ready for BI dashboards**.

---

## 🎯 Business Objectives

* 📈 Identify **high-value customers and revenue drivers**
* 🍽️ Analyze **restaurant performance and customer satisfaction**
* 🚴 Evaluate **delivery efficiency and rider performance**
* 💰 Measure **GMV, revenue trends, and promo effectiveness**
* 🧍 Track **user behavior, retention, and churn**
* 🧹 Ensure **data quality and integrity checks**

---

## 🗂️ Dataset Architecture

| Table           | Description                                        |
| --------------- | -------------------------------------------------- |
| **users**       | Customer details, demographics, and signup data    |
| **restaurants** | Restaurant metadata, cuisine, ratings              |
| **orders**      | Core transaction data (revenue, platform, payment) |
| **order_items** | Item-level order details                           |
| **menu_items**  | Menu catalog                                       |
| **deliveries**  | Delivery time, distance, rider performance         |
| **riders**      | Delivery partner details                           |
| **ratings**     | Customer reviews and feedback                      |

---

## 🧠 Key SQL Concepts Used

* 🔹 Complex **JOINs (multi-table analysis)**
* 🔹 **CTEs (WITH clause)** for modular queries
* 🔹 **Window Functions** (`RANK`, `LAG`)
* 🔹 **CASE WHEN** for business logic
* 🔹 **Date & Time Functions** (`EXTRACT`, `TO_CHAR`)
* 🔹 **Aggregation & Grouping**
* 🔹 **Data Cleaning & Validation Queries**
* 🔹 **Correlation Analysis (`CORR`)**
* 🔹 **Text Processing (Keyword Extraction)**

---

## 📊 Key Business Analysis

### 👤 User Analytics

* Top 10 high-value customers
* Repeat purchase rate
* Churn rate (inactive users > 90 days)
* Premium vs Non-premium AOV

---

### 🍽️ Restaurant Analytics

* Top revenue-generating restaurants
* High sales but low-rated restaurants (business anomaly detection)
* Top cuisines by rating
* Repeat customer analysis

---

### 🚴 Delivery & Rider Analytics

* Average delivery time and distance per rider
* Rider completion rate
* Late delivery ratio (SLA performance)
* Delivery efficiency (time per km)
* Rider rating trend analysis

---

### 💰 Business & Revenue Insights

* Monthly revenue trend
* GMV (Gross Merchandise Value) analysis
* Promo code impact (usage % + discount)
* Payment method performance

---

### ⭐ Customer Experience Analytics

* Users giving frequent low ratings
* Correlation between delivery time & ratings
* Keyword extraction from negative reviews

---

### 🧹 Data Quality & Integrity

* Missing / invalid data detection
* Referential integrity checks
* Order amount mismatch validation

---

## 📈 Sample Insights

* 📉 ~20% users became inactive after 90 days → retention needed
* 💸 Promo codes used in ~18–25% of orders
* 🚴 Faster deliveries strongly correlated with higher ratings
* 🍕 Certain low-rated restaurants still generated high revenue
* 🏙️ Metro cities showed better delivery efficiency

---

## 🧮 KPIs Calculated

* 💰 Gross Merchandise Value (GMV)
* 📦 Total Orders & Revenue
* 🧍 Churn Rate (%)
* 🔁 Repeat Purchase Rate
* 🚴 Delivery Efficiency
* ⏱️ Avg Delivery Time
* ⭐ Avg Rating
* 💸 Promo Code Usage (%)

---

## ⚙️ Tools & Technologies

* **Database:** PostgreSQL
* **IDE:** pgAdmin / DBeaver
* **Version Control:** Git & GitHub
* **Future Scope:** Power BI / Tableau

---

## 🚀 Advanced Features

* ✔️ Modular query design using CTEs
* ✔️ Time-based analysis (monthly, daily trends)
* ✔️ Business KPI computation
* ✔️ Text analysis using SQL (keyword extraction)
* ✔️ Data validation layer (audit queries)

---

## 📂 Project Structure

```

├── 📄 00_create_tables.sql
├── 📄 01_user_analysis.sql
├── 📄 02_restaurant_analysis.sql
├── 📄 03_delivery_analysis.sql
├── 📄 04_business_analysis.sql
├── 📄 05_rating_analysis.sql
├── 📄 06_data_quality.sql
└── 📄 README.md
```

---

## 🧭 Future Enhancements

* 📊 Build Power BI Dashboard
* 🤖 Add ML forecasting (Python)
* ⚡ Optimize queries using indexing
* 🧠 Implement cohort & retention analysis

---

## 💼 Author

**Satyarth**
💻 SQL Developer | 📊 Data Analyst | 🏋️ Fitness Enthusiast

---

## 🌟 Project Highlights

✔️ End-to-end SQL project
✔️ Real-world business use cases
✔️ Advanced analytics queries
✔️ Interview-ready portfolio project

---

## 📌 Final Note

This project demonstrates the ability to:

* Transform raw data into actionable insights
* Solve real business problems using SQL
* Build scalable and clean data models

---

⭐ *If you found this project useful, consider giving it a star!*
