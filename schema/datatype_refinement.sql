-- =====================================================
-- RETAIL BUSINESS INTELLIGENCE & CUSTOMER ANALYTICS
-- PHASE 3: SCHEMA REFINEMENT & DATATYPE ENGINEERING
-- =====================================================

-- Objective:
-- Refine imported raw tables into properly structured
-- relational tables by correcting datatypes, enforcing
-- constraints, and improving schema integrity.

USE retail_business_db;

-- =====================================================
-- CUSTOMERS TABLE
-- =====================================================

-- Business Purpose:
-- Stores customer identity and geographic information.

-- Engineering Objective:
-- Review and refine column datatypes to ensure:
-- 1. Proper business representation
-- 2. Storage efficiency
-- 3. Future relational integrity support

DESCRIBE customers;

-- =====================================================
-- CUSTOMERS TABLE DATATYPE REFINEMENT
-- Refine imported generic datatypes into business-aware
-- relational datatypes for schema optimization.
-- =====================================================

ALTER TABLE customers
MODIFY customer_id VARCHAR(50),
MODIFY customer_city VARCHAR(100),
MODIFY customer_state CHAR(2),
MODIFY customer_unique_id VARCHAR(50),
MODIFY customer_zip_code_prefix INT;

DESCRIBE customers;

-- =====================================================
-- SELLERS TABLE DATATYPE REFINEMENT
-- Refine imported generic datatypes into business-aware
-- relational datatypes for schema optimization.
-- =====================================================

DESCRIBE sellers;

ALTER TABLE sellers
MODIFY seller_id VARCHAR(50),
MODIFY seller_city VARCHAR(100),
MODIFY seller_state CHAR(2),
MODIFY seller_zip_code_prefix INT;

DESCRIBE sellers;

-- =====================================================
-- PRODUCTS TABLE DATATYPE REFINEMENT
-- Refine imported generic datatypes into business-aware
-- relational datatypes for schema optimization.
-- =====================================================

DESCRIBE products;

ALTER table products
MODIFY product_id VARCHAR(50),
MODIFY product_category_name VARCHAR(100),
MODIFY product_description_lenght INT,
MODIFY product_name_lenght INT,
MODIFY product_height_cm DECIMAL(10, 2),
MODIFY product_photos_qty INT,
MODIFY product_weight_g INT,
MODIFY product_length_cm DECIMAL(10,2),
MODIFY product_width_cm DECIMAL(10,2);
DESCRIBE products;

-- =====================================================
-- ORDERS TABLE DATATYPE REFINEMENT
-- Refine imported generic datatypes into business-aware
-- relational datatypes for schema optimization.
-- =====================================================

DESCRIBE orders;
ALTER TABLE orders
MODIFY order_id VARCHAR(50),
MODIFY order_status VARCHAR(30),
MODIFY customer_id VARCHAR(50),
MODIFY order_approved_at DATETIME,
MODIFY order_delivered_carrier_date DATETIME,
MODIFY order_delivered_customer_date DATETIME,
MODIFY order_estimated_delivery_date DATETIME,
MODIFY order_purchase_timestamp DATETIME;
DESCRIBE orders;

-- =====================================================
-- PAYMENTS TABLE DATATYPE REFINEMENT
-- Refine imported generic datatypes into business-aware
-- relational datatypes for schema optimization.
-- =====================================================

DESCRIBE payments;

ALTER TABLE payments
MODIFY order_id VARCHAR(50),
MODIFY payment_sequential INT,
MODIFY payment_type VARCHAR(30),
MODIFY payment_installments INT,
MODIFY payment_value DECIMAL(10,2);

DESCRIBE payments;

-- =====================================================
-- REVIEWS TABLE DATATYPE REFINEMENT
-- Refine imported generic datatypes into business-aware
-- relational datatypes for schema optimization.
-- =====================================================

DESCRIBE reviews;

ALTER TABLE reviews
MODIFY review_id VARCHAR(50),
MODIFY order_id VARCHAR(50),
MODIFY review_score INT,
MODIFY review_comment_title VARCHAR(255),
MODIFY review_comment_message TEXT,
MODIFY review_creation_date DATETIME,
MODIFY review_answer_timestamp DATETIME;

DESCRIBE reviews;

-- =====================================================
-- CATEGORY TRANSLATION TABLE DATATYPE REFINEMENT
-- Refine imported generic datatypes into business-aware
-- relational datatypes for schema optimization.
-- =====================================================

DESCRIBE category_translation;

ALTER TABLE category_translation
MODIFY product_category_name VARCHAR(100),
MODIFY product_category_name_english VARCHAR(100);

DESCRIBE category_translation;

-- =====================================================
-- ORDER_ITEMS TABLE DATATYPE REFINEMENT
-- Refine imported generic datatypes into business-aware
-- relational datatypes for schema optimization.
-- =====================================================

DESCRIBE order_items;

ALTER TABLE order_items
MODIFY order_id VARCHAR(50),
MODIFY order_item_id INT,
MODIFY product_id VARCHAR(50),
MODIFY seller_id VARCHAR(50),
MODIFY shipping_limit_date DATETIME,
MODIFY price DECIMAL(10,2),
MODIFY freight_value DECIMAL(10,2);

DESCRIBE order_items;