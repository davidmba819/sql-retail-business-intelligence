# Retail Business Intelligence & Customer Analytics System

## Project Overview

Retail businesses generate large volumes of transactional data every day. However, raw data alone does not provide actionable insights. This project focuses on transforming retail transaction data into business intelligence that supports decision-making across sales performance, customer behavior, product performance, and operational efficiency.

Using SQL and relational database design principles, the project builds a structured analytical workflow that moves from raw data ingestion and validation to business-focused analytics and insights generation.

---

## Business Problem

Retail companies need visibility into:

- Revenue performance over time
- Customer purchasing behavior
- Product category performance
- Order fulfillment efficiency
- Delivery delays and operational bottlenecks

Without a structured analytics system, identifying trends, inefficiencies, and growth opportunities becomes difficult.

---

## Project Objectives

The project aims to answer the following business questions:

### Sales Performance
- How much revenue is generated over time?
- How do order volumes change across months and years?

### Product Performance
- Which product categories generate the most revenue?
- Which categories receive the highest order volumes?
- Which categories generate the highest average revenue per order?

### Customer Behavior
- How many products does the average customer purchase?
- How much does the average customer spend?
- What is the relationship between customer order frequency and spending?

### Order Fulfillment & Delivery
- Which stage of the order lifecycle takes the longest?
- What percentage of total fulfillment time is spent in each stage?
- Do delayed deliveries experience longer shipping times?
- Which months record the highest late-delivery rates?

---

## Dataset Overview

The project uses the Olist E-commerce Dataset.

### Core Tables

| Table | Description |
|---------|-------------|
| customers | Customer information |
| orders | Order lifecycle information |
| order_items | Products purchased within each order |
| order_payments | Payment information |
| order_reviews | Customer reviews |
| products | Product information |
| sellers | Seller information |
| product_category_translation | Product category translations |

---

## Database Design

The database was designed using a relational structure.

### Key Relationships

- One customer can place multiple orders.
- One order can contain multiple products.
- One order can have multiple payment records.
- One order can receive customer reviews.
- Products belong to categories.
- Sellers supply products included in orders.

The database design ensures referential integrity and supports efficient analytical querying.

---

## Project Workflow

### Phase 1: Business Understanding

Defined project objectives, business requirements, and analytical goals.

### Phase 2: Data Understanding & Relational Modeling

Explored all tables, identified relationships, primary keys, foreign keys, and business processes represented by the data.

### Phase 3: Database Setup & Schema Engineering

Created the database structure, defined relationships, and implemented database constraints.

### Phase 4: Data Cleaning & Validation

Performed data quality checks and business rule validation, including:

- Missing value assessment
- Duplicate detection
- Invalid records identification
- Referential integrity checks
- Order lifecycle validation

### Phase 5: Foundational Analytics

Generated baseline business metrics including:

- Revenue analysis
- Order volume analysis
- Product category analysis
- Delivery performance analysis

### Phase 6: Advanced SQL Analytics

Performed deeper analytical investigations focused on:

#### Product Concentration Analysis

- Top-performing product categories by revenue
- Product category order volume analysis
- Highest average revenue per order by category

#### Customer Purchase Behavior Analysis

- Average products purchased per customer
- Average customer spending
- Customer order frequency versus spending behavior

#### Order Lifecycle Analysis

- Average approval time
- Average shipping time
- Average delivery time
- Stage contribution to fulfillment time
- Shipping time comparison between delayed and on-time orders
- Monthly late-delivery rate analysis

---

## Key Business Findings

### Revenue Growth

Revenue increased significantly across the available years, with 2018 generating the highest revenue.

### Product Performance

A small number of product categories contributed a disproportionate share of revenue and order volume, indicating product concentration.

### Customer Purchasing Behavior

Most customers made relatively few purchases, while a smaller segment generated significantly higher spending.

### Order Fulfillment Bottleneck

The delivery stage from carrier to customer represented the largest portion of the order lifecycle.

Average lifecycle times:

| Stage | Average Hours |
|---------|-------------:|
| Approval | 9.92 |
| Shipping | 66.66 |
| Delivery | 223.51 |

### Delayed Deliveries

Delayed orders spent substantially longer in the shipping stage.

| Delivery Status | Average Shipping Time (Hours) |
|---------|-------------:|
| On Time | 61.31 |
| Delayed | 127.18 |

Delayed deliveries required approximately twice the shipping time of on-time deliveries.

### Late Delivery Trends

March 2018 recorded the highest meaningful late-delivery rate among high-volume months, suggesting potential logistics or capacity constraints during that period.

---

## Business Recommendations

### Improve Last-Mile Delivery Operations

Since the delivery stage accounts for the majority of fulfillment time, operational improvements should prioritize carrier-to-customer delivery efficiency.

### Monitor Shipping Delays

Shipping delays are strongly associated with late deliveries. Monitoring shipping performance can help reduce customer dissatisfaction.

### Focus on High-Performing Product Categories

High-performing categories should receive priority in inventory planning, marketing, and sales strategies.

### Identify High-Value Customers

Customer spending patterns suggest opportunities for loyalty programs and targeted retention strategies.

### Establish Delivery Performance Monitoring

Monthly delivery metrics should be tracked to identify emerging logistics issues before they impact customer experience.

---

## SQL Skills Demonstrated

This project demonstrates practical SQL skills including:

- Database Design
- Relational Modeling
- Data Cleaning
- Data Validation
- Business Rule Validation
- INNER JOIN
- LEFT JOIN
- Common Table Expressions (CTEs)
- Aggregate Functions
- CASE Statements
- Date Functions
- TIMESTAMPDIFF
- GROUP BY
- ORDER BY
- Revenue Analysis
- Customer Analytics
- Product Analytics
- Operational Analytics
- Business Insight Generation

---

## Project Structure

```text
sql-retail-business-intelligence/
│
├── analysis/
│   ├── 05_foundation_analytics.sql
│   └── 06_advanced_sql_analytics.sql
│
├── data/
│   └── raw/
│
├── data_cleaning/
│   ├── 03_business_rule_validation.sql
│   └── 04_data_cleaning_validation.sql
│
├── schema/
│   ├── schema_design.sql
│   └── database_constraints.sql
|
├── script/
|   |___ load_data.py
|
├── README.md
│
└── .gitignore
```

---

## Conclusion

This project was built to strengthen my SQL skills by applying them to real business problems. Beyond learning SQL syntax, the project helped me understand how to translate business questions into analytical investigations and use data to generate meaningful insights.

Through database design, data validation, sales analysis, customer behavior analysis, product performance analysis, and delivery analytics, I gained practical experience using SQL as a tool for business decision-making. The project also improved my understanding of relational databases, analytical thinking, and how data can be used to solve business problems.
