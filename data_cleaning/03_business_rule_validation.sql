-- ==================================================
-- INVESTIGATION 1
-- MISSING DELIVERY-RELATED DATES BY ORDER STATUS
--
-- Objective:
-- Determine whether missing fulfillment dates are
-- associated with specific order statuses.
-- ==================================================
USE retail_business_db;

SELECT
    order_status,
    COUNT(*) AS orders_count
FROM orders
WHERE order_approved_at IS NULL
GROUP BY order_status
ORDER BY orders_count DESC;

-- Missing approval timestamps are concentrated in canceled orders (141 records).
-- A small number of created orders (5 records) also lack approval timestamps.
-- 14 delivered orders have no approval timestamp and require further investigation.
-- Additional validation is needed before determining whether corrective action is required.

SELECT
    order_status,
    COUNT(*) AS orders_count
FROM orders
WHERE order_delivered_carrier_date IS NULL
GROUP BY order_status
ORDER BY orders_count DESC;

-- Missing carrier handoff dates were identified across multiple order statuses.
-- The highest concentrations occur in unavailable (609), canceled (550),
-- invoiced (314), and processing (301) orders.
-- Only 2 delivered orders are missing carrier handoff dates.
-- Further validation is required before determining whether corrective action is necessary.

SELECT
    order_status,
    COUNT(*) AS orders_count
FROM orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status
ORDER BY orders_count DESC;

-- Missing customer delivery dates were identified across multiple order statuses.
-- The highest concentrations occur in shipped (1,107), canceled (619),
-- unavailable (609), invoiced (314), and processing (301) orders.
-- 8 delivered orders are missing customer delivery dates and should be flagged for further review.
-- Additional investigation is required before any corrective action is taken.

-- ==================================================
-- ORDERS TABLE INVESTIGATION SUMMARY
--
-- Missing fulfillment-related dates were investigated
-- using order_status classifications.
--
-- Most missing values occur in orders that were
-- canceled, unavailable, invoiced, processing,
-- created, or shipped.
--
-- These records will be retained pending further
-- business rule evaluation because they may represent
-- legitimate operational states rather than data
-- quality errors.
--
-- A small number of delivered orders contain missing
-- fulfillment dates and have been flagged for
-- additional review.
-- ==================================================

-- ==================================================
-- REVIEWS TABLE
-- REVIEW COMMENT INVESTIGATION
--
-- Objective:
-- Determine whether missing review comments are
-- associated with specific review score patterns.
-- ==================================================

SELECT
    review_score,
    COUNT(*) AS reviews_without_title
FROM reviews
WHERE review_comment_title IS NULL
GROUP BY review_score
ORDER BY review_score;

-- Review titles are missing across all review score categories.
-- The highest concentration occurs among 5-star reviews (50,670 records).
-- Customers appear to provide ratings without necessarily supplying review titles.
-- Missing review titles may reflect optional user input rather than data quality issues.
-- Further investigation of review comment messages is required.

SELECT
    SUM(review_comment_title IS NULL) AS missing_titles,
    SUM(review_comment_message IS NULL) AS missing_comments,
    SUM(review_comment_title IS NULL AND review_comment_message IS NULL) AS missing_both
FROM reviews;

-- ==================================================
-- REVIEWS TABLE INVESTIGATION SUMMARY
--
-- 87,656 reviews contain missing titles.
-- 58,247 reviews contain missing comments.
-- 56,518 reviews contain both title and comment missing.
--
-- Review scores remain fully populated for these records.
--
-- Findings suggest that customers frequently submit
-- ratings without providing written feedback.
--
-- Missing review titles and comments are likely
-- attributable to optional user input rather than
-- data quality issues.
--
-- No data cleaning action is recommended at this stage.
-- ==================================================

-- ==================================================
-- PRODUCTS TABLE
-- Investigate products with missing metadata attributes.
-- ==================================================

SELECT
    COUNT(*) AS products_missing_all_metadata
FROM products
WHERE product_category_name IS NULL
    AND product_name_lenght IS NULL
    AND product_description_lenght IS NULL
    AND product_photos_qty IS NULL;
    
-- ==================================================
-- PRODUCTS TABLE
-- Missing Product Metadata Investigation
-- ==================================================

-- All 610 products with missing category names also
-- have missing product name length, description length,
-- and photo count attributes.

-- Missing metadata is concentrated in the same set of
-- product records rather than being randomly distributed.

-- These records will be retained pending further
-- investigation of their role in order transactions.

-- ==================================================
-- PRODUCTS TABLE
-- Missing Physical Dimensions Investigation
-- ==================================================

SELECT
    product_id,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM products
WHERE product_weight_g IS NULL
   OR product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;
   
SELECT
    product_id
FROM products
WHERE product_weight_g IS NULL
  AND product_length_cm IS NULL
  AND product_height_cm IS NULL
  AND product_width_cm IS NULL;
  
-- Two products are missing all physical dimension attributes
-- (weight, length, height, and width).

-- Missing dimensional data is concentrated in the same
-- two product records rather than distributed across
-- multiple products.

-- These records will be retained pending further
-- business evaluation.

-- ==================================================
-- PAYMENTS TABLE
-- Validation 1: Payment value must be greater than zero.
-- ==================================================

SELECT *
FROM payments
WHERE payment_value <= 0;
  
SELECT
    payment_type,
    COUNT(*) AS records,
    MIN(payment_value) AS min_value,
    MAX(payment_value) AS max_value
FROM payments
WHERE payment_value <= 0
GROUP BY payment_type;

DELETE FROM payments
WHERE payment_value = 0;

-- Validation Result:
-- 9 payment records have payment_value = 0.
-- These records occur only in voucher (6) and not_defined (3) payment types.
-- No zero-value payments were identified in standard payment methods.
-- Records will be retained pending further business context.

-- Validation 2
-- Payment installments must be greater than zero.

SELECT*
FROM payments
WHERE payment_installments <= 0;

-- PAYMENTS TABLE
-- Validation 2 Investigation
-- Distribution of installment counts

SELECT
    payment_installments,
    COUNT(*) AS records_count
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;

-- ============================================
-- PAYMENTS TABLE
-- Validation 3: Payment sequence must be >= 1
-- ============================================

SELECT *
FROM payments
WHERE payment_sequential < 1;

DELETE FROM payments
WHERE payment_value = 0;

-- Validation Result:
-- Business rule requires payment_value > 0.
-- 9 records were identified with payment_value = 0.
-- These records belonged to voucher and not_defined payment types.
-- The issue affected less than 0.02% of payment records.
-- Decision:
-- Records removed because they violate payment value business rules
-- and do not contribute meaningful transaction value.

-- ============================================
-- ORDERS TABLE
-- Validation 1: Purchase timestamp must exist
-- ============================================

SELECT *
FROM orders
WHERE order_purchase_timestamp IS NULL;

-- Validation Passed:
-- All orders contain purchase timestamps.
-- No violations identified.

-- ============================================
-- ORDERS TABLE
-- Validation 2: Approval must occur after purchase
-- ============================================

SELECT *
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_approved_at < order_purchase_timestamp;
  
  -- ============================================
-- ORDERS TABLE
-- Validation 3: Carrier handoff after approval
-- ============================================

SELECT *
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at;
  
  SELECT
    COUNT(*) AS violations,
    MIN(TIMESTAMPDIFF(HOUR,
        order_delivered_carrier_date,
        order_approved_at)) AS min_hours_gap,
    MAX(TIMESTAMPDIFF(HOUR,
        order_delivered_carrier_date,
        order_approved_at)) AS max_hours_gap,
    AVG(TIMESTAMPDIFF(HOUR,
        order_delivered_carrier_date,
        order_approved_at)) AS avg_hours_gap
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at;
  
 SELECT
    CASE
        WHEN TIMESTAMPDIFF(HOUR,
             order_delivered_carrier_date,
             order_approved_at) <= 1
             THEN '0-1 Hours'

        WHEN TIMESTAMPDIFF(HOUR,
             order_delivered_carrier_date,
             order_approved_at) > 1
         AND TIMESTAMPDIFF(HOUR,
             order_delivered_carrier_date,
             order_approved_at) <= 24
             THEN '1-24 Hours'

        WHEN TIMESTAMPDIFF(HOUR,
             order_delivered_carrier_date,
             order_approved_at) > 24
         AND TIMESTAMPDIFF(HOUR,
             order_delivered_carrier_date,
             order_approved_at) <= 168
             THEN '1-7 Days'

        ELSE 'More Than 7 Days'
    END AS gap_category,

    COUNT(*) AS records_count

FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
GROUP BY gap_category;

-- Validation Result:
-- 1,359 orders have carrier pickup timestamps earlier than approval timestamps.

-- Distribution:
-- 0-1 Hours: 435 records
-- 1-24 Hours: 519 records
-- 1-7 Days: 391 records
-- More Than 7 Days: 14 records

-- Decision:
-- Records retained.
-- The violations may reflect operational timestamp recording delays
-- rather than invalid order transactions.
-- No records were removed.

-- ==================================================
-- ORDERS TABLE
-- Validation 4: Customer delivery must occur after carrier pickup
-- ==================================================

SELECT *
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;
  
  SELECT
    COUNT(*) AS violations,
    MIN(TIMESTAMPDIFF(HOUR,
        order_delivered_customer_date,
        order_delivered_carrier_date)) AS min_hours_gap,
    MAX(TIMESTAMPDIFF(HOUR,
        order_delivered_customer_date,
        order_delivered_carrier_date)) AS max_hours_gap,
    AVG(TIMESTAMPDIFF(HOUR,
        order_delivered_customer_date,
        order_delivered_carrier_date)) AS avg_hours_gap
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;
  
-- Validation Result:
-- 23 orders violate delivery sequence rules.
-- Related records:
--   50 order_items
--   26 payments
--   23 reviews
--
-- Decision:
-- Retain records to preserve referential integrity.
-- Exclude from analytical queries and reporting.

CREATE VIEW valid_orders AS
SELECT *
FROM orders
WHERE NOT (
    order_delivered_carrier_date IS NOT NULL
    AND order_delivered_customer_date IS NOT NULL
    AND order_delivered_customer_date < order_delivered_carrier_date
);

-- 23 orders violate delivery sequence rules.
-- Records retained for referential integrity.
-- Analytical queries should use valid_orders view.


-- ==========================================
-- ORDERS TABLE
-- Validation 5: Estimated delivery date must
-- occur after purchase date
-- ==========================================

SELECT *
FROM orders
WHERE order_estimated_delivery_date <= order_purchase_timestamp;

-- No order has an estimated delivery date earlier than its purchase date.

-- ==========================================
-- ORDERS TABLE
-- Validation 6: Delivered orders must have
-- a customer delivery date
-- ==========================================

SELECT *
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

-- ==========================================
-- Investigation:
-- Do these orders have carrier handoff dates?
-- ==========================================

SELECT
    COUNT(*) AS affected_orders,
    SUM(order_delivered_carrier_date IS NOT NULL) AS has_carrier_date,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;
  
-- =====================================================
-- ORDERS TABLE
-- Valid Orders Analytical View
-- =====================================================
-- Purpose:
-- Create a clean analytical view of orders that excludes
-- records failing critical order lifecycle business rules.
--
-- Excluded Records:
--
-- 1. Orders where customer delivery occurred before
--    carrier handoff (physically impossible sequence).
--
-- 2. Orders marked as 'delivered' but missing
--    customer delivery timestamps.
--
-- Decision:
-- Invalid records are retained in the source table
-- to preserve referential integrity with order_items,
-- payments, and reviews.
--
-- Analytical queries should use valid_orders instead
-- of the raw orders table.
-- =====================================================  
  
  CREATE OR REPLACE VIEW valid_orders AS
SELECT *
FROM orders
WHERE NOT (

    -- Invalid Group 1
    (
        order_delivered_carrier_date IS NOT NULL
        AND order_delivered_customer_date IS NOT NULL
        AND order_delivered_customer_date < order_delivered_carrier_date
    )

    OR

    -- Invalid Group 2
    (
        order_status = 'delivered'
        AND order_delivered_customer_date IS NULL
    )

);

-- =====================================================
-- GROUP 3: PRODUCTS TABLE
-- Business Rule Validation
-- =====================================================
--
-- Validation 1: Positive Product Dimensions
-- Validation 2: Positive Product Weight
-- Validation 3: Non-Negative Product Photo Quantity
--
-- =====================================================

-- =====================================================
-- PRODUCTS TABLE
-- Validation 1: Positive Product Dimensions
-- =====================================================

SELECT *
FROM products
WHERE product_length_cm <= 0
   OR product_height_cm <= 0
   OR product_width_cm <= 0;
   
-- Validation Passed:
-- No products contain zero or negative dimensions.
-- All recorded product dimensions are physically valid.

-- =====================================================
-- PRODUCTS TABLE
-- Validation 2: Positive Product Weight
-- =====================================================

SELECT *
FROM products
WHERE product_weight_g <= 0;

-- =====================================================
-- PRODUCTS TABLE
-- Validation 3: Non-Negative Product Photo Quantity
-- =====================================================

SELECT *
FROM products
WHERE product_photos_qty < 0;

-- Validation Result:
-- 4 products have product_weight_g = 0.
-- Product dimensions are valid.
-- No evidence of physically impossible records.
-- Records retained in source table.
-- Weight-based analyses should exclude product_weight_g = 0 records.

-- =====================================================
-- GROUP 4: REVIEWS TABLE
-- =====================================================

-- Validation 1: Review Score Range Validation
-- Validation 2: Review Timeline Validation