-- =====================================================
-- DUPLICATE RECORDS AUDIT
-- Phase 4: Data Cleaning & Validation
--
-- Objective:
-- Identify duplicate records based on each table's
-- business key and relational design.
-- =====================================================

USE retail_business_db;

-- =====================================================
-- CUSTOMERS TABLE
-- Check duplicate customer identifiers.
-- =====================================================

SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Customers table contains no duplicate customer identifiers.
-- Each customer_id uniquely identifies a customer record.
-- No duplicate record issues were identified.

-- =====================================================
-- SELLERS TABLE
-- Check duplicate seller identifiers.
-- =====================================================

SELECT
	seller_id,
    COUNT(*) AS occurrence
FROM sellers
GROUP BY seller_id
HAVING occurrence > 1;

-- Sellers table contains no duplicate seller identifiers.
-- Each seller_id uniquely identifies a seller record.
-- No duplicate record issues were identified.

-- =====================================================
-- PRODUCTS TABLE
-- Check duplicate product identifiers.
-- =====================================================

SELECT
    product_id,
    COUNT(*) AS occurrences
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
-- Products table contains no duplicate product identifiers.
-- Each product_id uniquely identifies a product record.
-- No duplicate record issues were identified.

-- =====================================================
-- ORDERS TABLE
-- Check duplicate order identifiers.
-- =====================================================

SELECT
    order_id,
    COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Orders table contains no duplicate order identifiers.
-- Each order_id uniquely identifies an order transaction.
-- No duplicate record issues were identified.

-- =====================================================
-- PAYMENTS TABLE
-- Check duplicate composite business keys.
-- =====================================================

SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS occurrences
FROM payments
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;

-- Payments table contains no duplicate composite business keys.
-- Each (order_id, payment_sequential) combination uniquely identifies a payment record.
-- No duplicate record issues were identified.

-- =====================================================
-- REVIEWS TABLE
-- Check duplicate composite business keys.
-- =====================================================

SELECT
    review_id,
    order_id,
    COUNT(*) AS occurrences
FROM reviews
GROUP BY
    review_id,
    order_id
HAVING COUNT(*) > 1;

-- Reviews table contains no duplicate composite business keys.
-- Each (review_id, order_id) combination uniquely identifies a review record.
-- No duplicate record issues were identified.

-- =====================================================
-- ORDER ITEMS TABLE
-- Check duplicate composite business keys.
-- =====================================================

SELECT
    order_id,
    order_item_id,
    COUNT(*) AS occurrences
FROM order_items
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;

-- Order items table contains no duplicate composite business keys.
-- Each (order_id, order_item_id) combination uniquely identifies an order line item.
-- No duplicate record issues were identified.