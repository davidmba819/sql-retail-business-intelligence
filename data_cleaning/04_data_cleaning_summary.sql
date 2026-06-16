-- =====================================================
-- RETAIL BUSINESS INTELLIGENCE & CUSTOMER ANALYTICS SYSTEM
-- DATA CLEANING SUMMARY REPORT
-- =====================================================

-- Purpose:
-- Summarize all data quality checks, validation results,
-- cleaning decisions, and analytical exclusions performed
-- during the Data Cleaning phase.

-- =====================================================
-- SECTION 1: MISSING VALUE AUDIT
-- =====================================================

-- Missing values were audited across all project tables.
-- Missingness patterns were investigated and documented.
-- No critical primary key fields contained missing values.
-- Missing values were retained where they represented
-- legitimate business scenarios.

-- =====================================================
-- SECTION 2: DUPLICATE AUDIT
-- =====================================================

-- Duplicate checks were performed across all tables.
-- No duplicate primary keys were identified.
-- No duplicate records required removal.

-- =====================================================
-- SECTION 3: BUSINESS RULE VALIDATION
-- =====================================================

-- PAYMENTS TABLE

-- Validation 1: Payment Value > 0
-- 9 records contained payment_value = 0.
-- Records removed because zero-value payments do not
-- represent meaningful financial transactions.

-- Validation 2: Payment Installments >= 1
-- Validation passed.

-- Validation 3: Payment Sequence >= 1
-- Validation passed.

-- ORDERS TABLE

-- Validation 1: Purchase Timestamp Exists
-- Validation passed.

-- Validation 2: Approval After Purchase
-- Validation passed.

-- Validation 3: Carrier Handoff After Approval
-- 1,359 records violated delivery sequence rules.
-- Records retained due to referential dependencies.
-- Excluded through valid_orders view.

-- Validation 4: Customer Delivery After Carrier Handoff
-- 23 records violated delivery sequence rules.
-- Records retained due to referential dependencies.
-- Excluded through valid_orders view.

-- Validation 5: Estimated Delivery After Purchase
-- Validation passed.

-- Validation 6: Delivered Orders Have Delivery Timestamp
-- 8 delivered orders missing customer delivery timestamps.
-- Records retained due to referential dependencies.
-- Excluded through valid_orders view.

-- PRODUCTS TABLE

-- Validation 1: Positive Product Dimensions
-- Validation passed.

-- Validation 2: Positive Product Weight
-- 4 products contain product_weight_g = 0.
-- Records retained.
-- Exclude from weight-based analyses when necessary.

-- Validation 3: Non-Negative Product Photo Quantity
-- Validation passed.

-- REVIEWS TABLE

-- Validation 1: Review Score Range Validation
-- Validation passed.

-- Validation 2: Review Timeline Validation
-- Validation passed.

-- ORDER_ITEMS TABLE

-- Validation 1: Positive Price Validation
-- Validation passed.

-- Validation 2: Non-Negative Freight Validation
-- Validation passed.

-- Validation 3: Shipping Timeline Validation
-- Validation passed.

-- =====================================================
-- SECTION 4: ANALYTICAL VIEWS CREATED
-- =====================================================

-- valid_orders
-- Created to exclude orders that fail business-rule
-- validations while preserving referential integrity.

