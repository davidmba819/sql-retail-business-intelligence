USE retail_business_db;

-- =====================================================
-- CUSTOMERS TABLE CONSTRAINT ENGINEERING
-- Validate candidate primary key before constraint creation.
-- =====================================================

SHOW CREATE TABLE customers;

SHOW INDEX FROM customers;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM customers;

SELECT
    COUNT(*) AS null_customer_ids
FROM customers
WHERE customer_id IS NULL;

-- =====================================================
-- CUSTOMERS PRIMARY KEY ENFORCEMENT
-- customer_id is unique and non-null.
-- =====================================================

ALTER TABLE customers
MODIFY customer_id VARCHAR(50) NOT NULL;

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

SHOW INDEX FROM customers;

-- =====================================================
-- SELLERS TABLE CONSTRAINT ENGINEERING
-- Validate candidate primary key before constraint creation.
-- =====================================================

SHOW CREATE TABLE sellers;

SHOW INDEX FROM sellers;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_seller_ids
FROM sellers;

SELECT
    COUNT(*) AS null_seller_ids
FROM sellers
WHERE seller_id IS NULL;

-- =====================================================
-- SELLERS PRIMARY KEY ENFORCEMENT
-- seller_id is unique and non-null.
-- =====================================================

ALTER TABLE sellers
MODIFY seller_id VARCHAR(50) NOT NULL;

ALTER TABLE sellers
ADD PRIMARY KEY (seller_id);

SHOW INDEX FROM sellers;

-- =====================================================
-- PRODUCTS TABLE CONSTRAINT ENGINEERING
-- Validate candidate primary key before constraint creation.
-- =====================================================

SHOW CREATE TABLE products;

SHOW INDEX FROM products;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM products;

SELECT
    COUNT(*) AS null_product_ids
FROM products
WHERE product_id IS NULL;

-- =====================================================
-- PRODUCTS PRIMARY KEY ENFORCEMENT
-- product_id is unique and non-null.
-- =====================================================

ALTER TABLE products
MODIFY product_id VARCHAR(50) NOT NULL;

ALTER TABLE products
ADD PRIMARY KEY (product_id);

SHOW INDEX FROM products;

-- =====================================================
-- ORDERS TABLE CONSTRAINT ENGINEERING
-- Validate candidate primary key before constraint creation.
-- =====================================================

SHOW CREATE TABLE orders;

SHOW INDEX FROM orders;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM orders;

SELECT
    COUNT(*) AS null_order_ids
FROM orders
WHERE order_id IS NULL;

-- =====================================================
-- ORDERS PRIMARY KEY ENFORCEMENT
-- order_id is unique and non-null.
-- =====================================================

ALTER TABLE orders
MODIFY order_id VARCHAR(50) NOT NULL;

ALTER TABLE orders
ADD PRIMARY KEY (order_id);

SHOW INDEX FROM orders;

-- =====================================================
-- CATEGORY_TRANSLATION TABLE CONSTRAINT ENGINEERING
-- Validate candidate primary key before constraint creation.
-- =====================================================

SHOW CREATE TABLE category_translation;

SHOW INDEX FROM category_translation;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_category_name) AS unique_categories
FROM category_translation;

SELECT
    COUNT(*) AS null_categories
FROM category_translation
WHERE product_category_name IS NULL;

ALTER TABLE category_translation
MODIFY product_category_name VARCHAR(100) NOT NULL;

ALTER TABLE category_translation
ADD PRIMARY KEY (product_category_name);

SHOW INDEX FROM category_translation;

-- =====================================================
-- PAYMENTS TABLE CONSTRAINT ENGINEERING
-- Validate composite primary key candidate.
-- =====================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(order_id,'-',payment_sequential))
        AS unique_payment_rows
FROM payments;

SELECT COUNT(*) AS null_order_ids
FROM payments
WHERE order_id IS NULL;

SELECT COUNT(*) AS null_payment_sequence
FROM payments
WHERE payment_sequential IS NULL;

ALTER TABLE payments
MODIFY order_id VARCHAR(50) NOT NULL,
MODIFY payment_sequential INT NOT NULL;

ALTER TABLE payments
ADD PRIMARY KEY (order_id, payment_sequential);

SHOW INDEX FROM payments;

-- =====================================================
-- ORDER_ITEMS TABLE CONSTRAINT ENGINEERING
-- Validate composite primary key candidate.
-- =====================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(order_id, '-', order_item_id))
        AS unique_order_items
FROM order_items;

SELECT COUNT(*) AS null_order_ids
FROM order_items
WHERE order_id IS NULL;

SELECT COUNT(*) AS null_order_item_ids
FROM order_items
WHERE order_item_id IS NULL;

DESCRIBE order_items;

-- =====================================================
-- ORDER_ITEMS PRIMARY KEY ENFORCEMENT
-- (order_id, order_item_id) uniquely identifies an item
-- within an order.
-- =====================================================

ALTER TABLE order_items
MODIFY order_id VARCHAR(50) NOT NULL,
MODIFY order_item_id INT NOT NULL;

ALTER TABLE order_items
ADD PRIMARY KEY (order_id, order_item_id);

SHOW INDEX FROM order_items;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(review_id, '-', order_id))
        AS unique_review_order_pairs
FROM reviews;

SELECT COUNT(*) AS null_review_ids
FROM reviews
WHERE review_id IS NULL;

SELECT COUNT(*) AS null_order_ids
FROM reviews
WHERE order_id IS NULL;

-- =====================================================
-- REVIEWS PRIMARY KEY ENFORCEMENT
-- (review_id, order_id) uniquely identifies a review.
-- =====================================================

ALTER TABLE reviews
MODIFY review_id VARCHAR(50) NOT NULL,
MODIFY order_id VARCHAR(50) NOT NULL;

ALTER TABLE reviews
ADD PRIMARY KEY (review_id, order_id);

SHOW INDEX FROM reviews;

-- =====================================================
-- FOREIGN KEY VALIDATION
-- =====================================================

-- =====================================================
-- FOREIGN KEY VALIDATION
-- orders.customer_id -> customers.customer_id
-- =====================================================

SELECT COUNT(*) AS orphan_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- =====================================================
-- payments.order_id -> orders.order_id
-- =====================================================

SELECT COUNT(*) AS orphan_payments
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;



-- =====================================================
-- reviews.order_id -> orders.order_id
-- =====================================================

SELECT COUNT(*) AS orphan_reviews
FROM reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- =====================================================
-- order_items.order_id -> orders.order_id
-- =====================================================

SELECT COUNT(*) AS orphan_order_items
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- =====================================================
-- order_items.product_id -> products.product_id
-- =====================================================

SELECT COUNT(*) AS orphan_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- =====================================================
-- order_items.seller_id -> sellers.seller_id
-- =====================================================

SELECT COUNT(*) AS orphan_sellers
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- =====================================================
-- FOREIGN KEY ENFORCEMENT
-- =====================================================

-- =====================================================
-- orders.customer_id -> customers.customer_id
-- =====================================================

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

-- =====================================================
-- payments.order_id -> orders.order_id
-- =====================================================

ALTER TABLE payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- =====================================================
-- reviews.order_id -> orders.order_id
-- =====================================================

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- =====================================================
-- order_items.order_id -> orders.order_id
-- =====================================================

ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- =====================================================
-- order_items.product_id -> products.product_id
-- =====================================================

ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);

-- =====================================================
-- order_items.seller_id -> sellers.seller_id
-- =====================================================

ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'retail_business_db'
AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;