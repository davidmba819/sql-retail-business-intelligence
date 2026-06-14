-- =====================================================
-- MISSING VALUES AUDIT
-- Phase 4: Data Cleaning & Validation
--
-- Objective:
-- Identify missing values across all tables and
-- assess potential data quality issues.
-- =====================================================

USE retail_business_db;

-- =====================================================
-- CUSTOMERS TABLE
-- Check missing values across all customer attributes.
-- =====================================================

SELECT
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(customer_unique_id IS NULL) AS missing_customer_unique_id,
    SUM(customer_zip_code_prefix IS NULL) AS missing_zip_code_prefix,
    SUM(customer_city IS NULL) AS missing_customer_city,
    SUM(customer_state IS NULL) AS missing_customer_state
FROM customers;

-- Customers table contains no missing values across all attributes.
-- The table demonstrates complete customer identification and location information.
-- No data quality concerns were identified.

-- =====================================================
-- SELLERS TABLE
-- Check missing values across all seller attributes.
-- =====================================================

SELECT
    SUM(seller_id IS NULL) AS missing_seller_id,
    SUM(seller_zip_code_prefix IS NULL) AS missing_zip_code_prefix,
    SUM(seller_city IS NULL) AS missing_seller_city,
    SUM(seller_state IS NULL) AS missing_seller_state
FROM sellers;

-- Sellers table contains no missing values across all attributes.
-- The table demonstrates complete seller identification and location information.
-- No data quality concerns were identified.

-- =====================================================
-- PRODUCTS TABLE
-- Check missing values across all product attributes.
-- =====================================================

SELECT
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(product_category_name IS NULL) AS missing_product_category_name,
    SUM(product_name_lenght IS NULL) AS missing_product_name_length,
    SUM(product_description_lenght IS NULL) AS missing_product_description_length,
    SUM(product_photos_qty IS NULL) AS missing_product_photos_qty,
    SUM(product_weight_g IS NULL) AS missing_product_weight_g,
    SUM(product_length_cm IS NULL) AS missing_product_length_cm,
    SUM(product_height_cm IS NULL) AS missing_product_height_cm,
    SUM(product_width_cm IS NULL) AS missing_product_width_cm
FROM products;

-- Products table contains missing values in product metadata attributes.
-- 610 products are missing category and descriptive information.
-- 2 products are missing physical measurement attributes.
-- Missing values appear systematic rather than random and should be investigated.

-- =====================================================
-- ORDERS TABLE
-- Check missing values across all order attributes.
-- =====================================================

SELECT
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(order_status IS NULL) AS missing_order_status,
    SUM(order_purchase_timestamp IS NULL) AS missing_purchase_timestamp,
    SUM(order_approved_at IS NULL) AS missing_order_approved_at,
    SUM(order_delivered_carrier_date IS NULL) AS missing_delivered_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS missing_delivered_customer_date,
    SUM(order_estimated_delivery_date IS NULL) AS missing_estimated_delivery_date
FROM orders;

-- Orders table contains missing values in fulfillment lifecycle attributes.
-- 160 orders lack approval timestamps.
-- 1,783 orders lack carrier handoff dates.
-- 2,965 orders lack customer delivery dates.
-- Missing values were identified in order processing and delivery-related fields.

-- =====================================================
-- PAYMENTS TABLE
-- Check missing values across all payment attributes.
-- =====================================================

SELECT
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(payment_sequential IS NULL) AS missing_payment_sequential,
    SUM(payment_type IS NULL) AS missing_payment_type,
    SUM(payment_installments IS NULL) AS missing_payment_installments,
    SUM(payment_value IS NULL) AS missing_payment_value
FROM payments;

-- Payments table contains no missing values across all payment attributes.
-- Payment records are complete and suitable for financial analysis.
-- No missing value issues were identified.

-- =====================================================
-- REVIEWS TABLE
-- Check missing values across all review attributes.
-- =====================================================

SELECT
    SUM(review_id IS NULL) AS missing_review_id,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(review_score IS NULL) AS missing_review_score,
    SUM(review_comment_title IS NULL) AS missing_review_comment_title,
    SUM(review_comment_message IS NULL) AS missing_review_comment_message,
    SUM(review_creation_date IS NULL) AS missing_review_creation_date,
    SUM(review_answer_timestamp IS NULL) AS missing_review_answer_timestamp
FROM reviews;

-- Reviews table contains missing values in optional text feedback attributes.
-- 87,656 reviews lack a review title.
-- 58,247 reviews lack a review comment message.
-- All review identifiers, review scores, and review timestamps are complete.
-- Missing values were identified in customer-provided textual feedback fields.
-- Further investigation is required to determine whether these missing values represent normal customer behavior or a data collection issue.

-- =====================================================
-- ORDER ITEMS TABLE
-- Check missing values across all order item attributes.
-- =====================================================

SELECT
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(order_item_id IS NULL) AS missing_order_item_id,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(seller_id IS NULL) AS missing_seller_id,
    SUM(shipping_limit_date IS NULL) AS missing_shipping_limit_date,
    SUM(price IS NULL) AS missing_price,
    SUM(freight_value IS NULL) AS missing_freight_value
FROM order_items;

-- Order items table contains no missing values across all attributes.
-- Product references, seller references, shipping information, and monetary values are complete.
-- No missing value issues were identified.

-- =====================================================
-- CATEGORY TRANSLATION TABLE
-- Check missing values across all translation attributes.
-- =====================================================

SELECT
    SUM(product_category_name IS NULL) AS missing_product_category_name,
    SUM(product_category_name_english IS NULL) AS missing_product_category_name_english
FROM category_translation;

-- Category translation table contains no missing values across all attributes.
-- Product category mappings are complete.
-- No missing value issues were identified.