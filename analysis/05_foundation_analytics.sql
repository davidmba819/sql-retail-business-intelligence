-- =====================================================
-- PHASE 5: FOUNDATION ANALYTICS
-- =====================================================
--
-- Purpose:
-- Explore key business metrics and operational
-- performance using the cleaned retail dataset.
--
-- This phase focuses on descriptive analytics to
-- understand orders, customers, products, sales,
-- delivery performance, and customer reviews.
--
-- All analyses are performed using validated and
-- cleaned data from previous phases.
--
-- =====================================================

-- =====================================================
-- SECTION A: BUSINESS OVERVIEW
-- =====================================================
--
-- Objective:
-- Understand the overall scale and performance of
-- the business through orders, customers, revenue,
-- and order status metrics.

-- =====================================================
-- A1: TOTAL ORDERS
-- =====================================================
-- How many valid orders exist in the dataset?
--
-- =====================================================

USE retail_business_db;
SELECT
	COUNT(*) AS total_orders
FROM valid_orders;

-- Finding:
-- The cleaned dataset contains 99,410 valid orders.

-- =====================================================
-- A2: TOTAL CUSTOMERS
-- =====================================================
--
-- Business Question:
-- How many unique customers placed orders?
--

SELECT 
	COUNT(DISTINCT c.customer_unique_id) AS total_unique_customers
FROM valid_orders o
LEFT JOIN customers c
ON c.customer_id = o.customer_id;

SELECT 
	c.customer_unique_id,
	COUNT(o.order_id) AS total_orders_per_customers
FROM valid_orders o
LEFT JOIN customers c
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY COUNT(o.order_id) DESC;

-- Finding:
-- 96,068 unique customers placed 99,410 valid orders.
-- The dataset contains repeat customers, indicating some customers
-- made more than one purchase.


-- =====================================================
-- A3: TOTAL PRODUCT REVENUE
-- =====================================================

-- Business Question:
-- What is the total product revenue generated from all valid orders?

SELECT 
	SUM(oi.price) AS total_product_revenue
FROM valid_orders vo
LEFT JOIN order_items oi
ON oi.order_id = vo.order_id;

-- Finding:
-- Valid orders generated total product revenue of 13,586,635.78.
-- Revenue is calculated from product prices only and excludes freight charges.

-- =====================================================
-- A4: AVERAGE ORDER VALUE (AOV)
-- =====================================================

-- Business Question:
-- What is the average revenue generated per valid order?

SELECT 
	(SUM(oi.price) / COUNT(DISTINCT vo.order_id)) AS AOV
FROM valid_orders vo
LEFT JOIN order_items oi
ON oi.order_id = vo.order_id;

-- Finding:
-- Average Order Value (AOV) was 136.67 per valid order.
-- On average, each completed order generated 136.67 in product revenue.

-- =====================================================
-- A5: AVERAGE PRODUCTS PER ORDER
-- =====================================================

-- Business Question:
-- How many products are purchased on average in each valid order?

SELECT 
	(COUNT(oi.order_item_id) / COUNT(DISTINCT oi.order_id)) AS average_order_per_order,
    COUNT(oi.order_item_id) AS total_order_items,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM valid_orders vo
LEFT JOIN order_items oi
ON oi.order_id = vo.order_id;

-- Finding:
-- Customers purchased an average of 1.14 products per order.
-- Most orders contained a single product, with relatively few multi-item purchases.

-- =====================================================
-- A6: TOTAL FREIGHT REVENUE
-- =====================================================

-- Business Question:
-- How much freight (shipping) revenue was collected from valid orders?

SELECT 
	SUM(oi.freight_value) AS total_freight_revenue
FROM valid_orders vo
LEFT JOIN order_items oi
ON oi.order_id = vo.order_id;

-- Finding:
-- Valid orders generated total freight revenue of 2,251,001.83.
-- Freight charges represented an additional source of revenue beyond product sales.

-- =====================================================
-- A7: TOTAL REVENUE
-- =====================================================

-- Business Question:
-- What was the total revenue generated from valid orders,
-- including product sales and freight charges?

SELECT 
	(SUM(oi.freight_value) + SUM(oi.price)) AS total_revenue
FROM valid_orders vo
LEFT JOIN order_items oi
ON oi.order_id = vo.order_id;

-- Finding:
-- Total revenue generated from valid orders was 15,837,637.61.
-- Product sales contributed 13.59M, while freight charges contributed 2.25M.

-- =====================================================
-- A8: ORDER STATUS DISTRIBUTION
-- =====================================================

-- Business Question:
-- What proportion of orders fall into each order status?

SELECT 
	order_status,
	COUNT(DISTINCT order_id) AS Total_orders
FROM valid_orders
GROUP BY order_status
ORDER BY Total_orders DESC;

-- Finding:
-- Delivered orders dominated the dataset with 96,447 orders.
-- Cancelled, unavailable, shipped, and other statuses represented a small share of total orders.

-- =====================================================
-- SECTION B: CUSTOMER ANALYTICS
-- =====================================================
--
-- Objective:
-- Understand customer purchasing behavior and customer value.

-- =====================================================
-- B1: REPEAT VS ONE-TIME CUSTOMERS
-- =====================================================

-- Business Question:
-- How many customers placed only one order,
-- and how many customers placed multiple orders?
 
SELECT
	COUNT(customer_unique_id) AS total_one_time_customers
FROM(
	SELECT 
		c.customer_unique_id,
		COUNT(DISTINCT vo.order_id) AS orders_per_customer
	 FROM valid_orders vo
	 LEFT JOIN customers c
	 ON vo.customer_id = c.customer_id
	GROUP BY c.customer_unique_id
)t
WHERE orders_per_customer = 1;

SELECT
	COUNT(customer_unique_id) AS total_repeated_customers
FROM(
	SELECT 
		c.customer_unique_id,
		COUNT(DISTINCT vo.order_id) AS orders_per_customer
	 FROM valid_orders vo
	 LEFT JOIN customers c
	 ON vo.customer_id = c.customer_id
	GROUP BY c.customer_unique_id
)t
WHERE orders_per_customer >1;

-- Finding:
-- 93,074 customers placed exactly one order.
-- 2,994 customers placed multiple orders.
-- The customer base is dominated by one-time buyers.

-- =====================================================
-- B3: TOP CUSTOMERS BY NUMBER OF ORDERS
-- =====================================================

-- Business Question:
-- Which customers placed the highest number of orders?
SELECT
	c.customer_unique_id,
    COUNT(DISTINCT vo.order_id) AS order_per_customer
FROM valid_orders vo
LEFT JOIN customers c
ON vo.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY order_per_customer DESC
LIMIT 10;
-- Finding:
-- The most active customer placed 17 orders.
-- Most high-frequency customers placed between 6 and 9 orders.
-- Customer purchases appear broadly distributed rather than concentrated among a few buyers.

-- =====================================================
-- B4: TOP CUSTOMERS BY REVENUE
-- =====================================================

-- Business Question:
-- Which customers generated the highest revenue?
SELECT 
	c.customer_unique_id,
    (SUM(oi.price) + SUM(oi.freight_value)) AS total_revenue_per_customer
FROM valid_orders vo
LEFT JOIN customers c
ON c.customer_id = vo.customer_id
LEFT JOIN order_items oi
ON oi.order_id = vo.order_id
GROUP BY c.customer_unique_id
ORDER BY total_revenue_per_customer DESC;

-- Finding:
-- Revenue is concentrated among a small group of high-value customers.
-- The highest-spending customer generated 13,664.08 in total revenue.

-- =====================================================
-- SECTION C: PRODUCT ANALYTICS
-- =====================================================

-- This section analyzes product sales performance,
-- revenue contribution, and product popularity.

-- =====================================================
-- C1: TOTAL UNIQUE PRODUCTS SOLD
-- =====================================================

-- Business Question:
-- How many unique products were sold in valid orders?

SELECT
	COUNT(DISTINCT oi.product_id) AS total_unique_product
FROM valid_orders vo
LEFT JOIN order_items oi
ON oi.order_id = vo.order_id;
-- Finding:
-- A total of 32,937 unique products were sold in valid orders.
-- The product catalog is highly diverse, with thousands of distinct products purchased.

-- =====================================================
-- C2: TOP SELLING PRODUCTS
-- =====================================================

-- Business Question:
-- Which products were purchased most frequently?
SELECT
	oi.product_id,
	p.product_category_name,
    COUNT(oi.order_item_id) AS total_order_per_product
FROM valid_orders vo
INNER JOIN order_items oi
ON oi.order_id = vo.order_id
LEFT JOIN products p
ON p.product_id = oi.product_id
WHERE oi.product_id IS NOT NULL
GROUP BY p.product_category_name, oi.product_id
ORDER BY total_order_per_product DESC;

-- Finding:
-- The most purchased product was ordered 527 times.
-- Top-selling products were concentrated in categories such as
-- home decor, bed & bath, and garden tools.

-- =====================================================
-- C3: HIGHEST REVENUE PRODUCTS
-- =====================================================

-- Business Question:
-- Which products generated the highest revenue?

SELECT
	oi.product_id,
	p.product_category_name,
    (SUM(oi.price) + SUM(oi.freight_value)) AS total_revenue_per_product
FROM valid_orders vo
INNER JOIN order_items oi
ON oi.order_id = vo.order_id
INNER JOIN products p
ON p.product_id = oi.product_id
WHERE oi.product_id IS NOT NULL
GROUP BY p.product_category_name, oi.product_id
ORDER BY total_revenue_per_product DESC
LIMIT 10;

-- Finding:
-- The highest revenue-generating product generated 67,606.10 in total revenue.
-- Products from the Beauty & Health (beleza_saude) category dominated the top revenue rankings.
-- High revenue was concentrated among a relatively small number of products.

-- =====================================================
-- C4: PRODUCT CATEGORY DISTRIBUTION
-- =====================================================

-- Business Question:
-- Which product categories were purchased most frequently?
-- =====================================================
-- C4: PRODUCT CATEGORY DISTRIBUTION
-- =====================================================

-- Business Question:
-- Which product categories were purchased most frequently?

SELECT
    p.product_category_name,
    COUNT(oi.order_item_id) AS total_products_sold
FROM valid_orders vo
INNER JOIN order_items oi
    ON vo.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY total_products_sold DESC
LIMIT 10;

-- Finding:
-- The most frequently purchased category was cama_mesa_banho with 11,111 products sold.
-- Beauty & Health (beleza_saude) and Sports & Leisure (esporte_lazer) were also among the most purchased categories.
-- Customer demand was concentrated in household, lifestyle, and personal care product categories.	