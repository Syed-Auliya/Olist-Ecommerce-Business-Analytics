# Olist E-Commerce Business Analytics
## 📌 Project Overview

This project analyzes the Olist Brazilian E-Commerce marketplace to understand business performance across sales, customers, products, geography, order fulfillment, delivery, and customer experience.

The objective was not simply to build a dashboard, but to follow a practical Data Analyst workflow:

Understand the business → Validate the data → Analyze with SQL → Identify insights → Build a focused Power BI dashboard → Recommend business actions

The analysis focuses on identifying opportunities to improve sales performance, customer retention, category performance, delivery reliability, and customer satisfaction.

## 🎯 Business Objectives

The project addresses five major business areas:

Sales Performance
Understand sales trends, order volume, AOV, and category performance.
Customer Analytics
Analyze customer base, repeat purchasing, retention, and geographic concentration.
Product & Category Performance
Identify high-performing categories and compare sales with order-item volume.
Operational Performance
Evaluate order status and delivery reliability.
Customer Experience
Understand how delivery performance is associated with customer review scores.
🗂️ Dataset

The project uses the Olist Brazilian E-Commerce Public Dataset, containing approximately 100K orders across multiple relational tables.
**Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Main Tables
Table	Purpose
orders	Order lifecycle, timestamps, and status
customers	Customer and geographic information
order_items	Products, sellers, prices, and freight
products	Product attributes and categories
sellers	Seller information
order_payments	Payment information
order_reviews	Customer reviews and ratings
product_category	Product category translation
geolocation	Geographic information

🛠️ Tools & Technologies
PostgreSQL / pgAdmin — SQL analysis and data validation
SQL — business analysis and metric calculation
Microsoft Excel — targeted data-quality validation
Power BI — data modeling, DAX, visualization, and dashboard storytelling
Tool Strategy

## Each tool had a specific role:

Tool	Purpose
Excel	Validate
SQL	Analyze
Power BI	Communicate

This avoided repeating the same analysis across multiple tools.
Data Validation

Before performing business analysis, several data-quality checks were performed.

Examples included:
Key checks included primary-key uniqueness, duplicates, row counts,
customer uniqueness, order/item relationships, multiple payment and
review records, missing order lifecycle dates, product nulls, and status
consistency.

Metric                                 Result

Orders                                 99,441
Unique customers                       96,096
Products                               32,951
Sellers                                 3,095
Order-item records                    112,650
Orders represented in order items      98,666
Delivered orders                       96,478

## SQL Analysis

SQL was used for the main business analysis:

Sales, orders and AOV

Monthly sales trends

Customer retention and orders per customer

Customer and sales concentration

Category and product performance

Seller performance and concentration

Delivery time and late-delivery analysis

Review and customer-experience analysis

## Key Business Metrics

Metric                            Result

Total Orders                  99,441
Unique Customers              96,096
Product Sales                ₹13.59M
Average Order Value          ₹137.75
Repeat Customers               2,997
Repeat Customer Rate           3.12%
Orders per Customer             1.03
Average Review Score        4.09 / 5
Late Delivery Rate             8.11%
Average Delivery Time     12.56 days

Product Sales is the sum of item prices from order_items. It should
not automatically be interpreted as accounting revenue because freight
and other financial components are excluded.

## Key Business Insights

1. Customer retention is weak
Only 2,997 of 96,096 unique customers were repeat customers, giving
a repeat-customer rate of approximately 3.12%.

Business implication: There is significant opportunity to improve
customer retention and reactivation.

2. São Paulo is the dominant market 
São Paulo generated approximately ₹5.2M in product sales and had
around 40K customers, substantially ahead of other states.

Business implication: São Paulo is the most important market to
protect while other high-potential states can be evaluated for
expansion.

3. Health & Beauty is the leading category 
Health & Beauty generated approximately ₹1.26M in product sales.

Business implication: This category deserves attention for seller
availability, pricing, repeat purchases and cross-selling opportunities.

4. Volume does not always equal value 
Some categories generate high order-item volume without proportionally
high sales.

Business implication: Category performance should be evaluated using
sales, volume and average selling price together.

5. Delivery reliability is an important issue 
Approximately 8.11% of delivered orders were late, with average
delivery time of approximately 12.56 days.

Business implication: Late-delivery patterns should be investigated
by state, seller, category and logistics process.

6. Late delivery is associated with lower customer satisfaction 
Average review score was:

Delivery     Average Review

On Time            4.29
Late               2.57

Business implication: Delivery reliability is strongly associated
with customer experience. This is an association, not proof of
causality.

7. Seller concentration is relatively limited 

The top 10 sellers accounted for approximately 13.15% of product
sales.

Business implication: The marketplace is not highly dependent on a
very small seller group, although high-performing sellers should still
be monitored.

Power BI Dashboard

The final dashboard intentionally uses two pages.

## Page 1 --- Executive Overview 
<img width="1292" height="730" alt="image" src="https://github.com/user-attachments/assets/59783030-3fa9-485f-af70-2334a2c53e1e" />




## Page 2 --- Customer & Sales Analytics
<img width="1286" height="727" alt="image" src="https://github.com/user-attachments/assets/e3581b1b-8fe8-4ca9-8ea0-16061dabed31" />




## Analytical Workflow

Business Problem
       ↓
Data Validation
       ↓
Understand Table Grain & Relationships
       ↓
SQL Business Questions
       ↓
Business Insights
       ↓
Power BI Data Model
       ↓
Dashboard Storytelling
       ↓
Business Recommendations

## Tool responsibilities were intentionally separated:

Excel → targeted validation

SQL → business analysis

Power BI → modeling and storytelling

Data Modeling Considerations

The tables have different grains:

orders → one row per order

order_items → one row per product item within an order

order_payments → potentially multiple records per order

order_reviews → review records associated with orders

customers → customer_unique_id represents the actual customer
across orders

Therefore, order-level metrics must avoid double counting. For example,
when analyzing orders from order_items, use distinct order_id rather
than row count.

## Business Recommendations
1. Improve Customer Retention

Develop targeted re-engagement strategies for one-time customers and identify categories with stronger repeat-purchase potential.

2. Improve Delivery Reliability

Prioritize states and sellers with high late-delivery rates.

3. Protect Customer Experience

Monitor delivery performance alongside customer review scores because late delivery is associated with substantially lower ratings.

4. Strengthen High-Performing Categories

Investigate leading categories such as Health & Beauty for pricing, seller availability, customer retention, and cross-selling opportunities.

5. Use Geographic Segmentation

Treat major states as distinct markets because customer and sales concentration varies considerably across geography.
Skills Demonstrated

## Business problem framing

Data quality validation

SQL analysis

Table-grain and relationship understanding

Business KPI development

Customer analytics

E-commerce analytics

Power BI data modeling

DAX measures

Dashboard storytelling

Insight-to-action thinking

Suggested Repository Structure

## Olist-Ecommerce-Business-Analytics/
├── README.md
├── sql/
│   └── business_analysis.sql
├── powerbi/
│   └── Olist_Ecommerce_Business_Analytics.pbix
└── screenshots/
    ├── executive-overview.png
    └── customer-sales-analytics.png

## Author

Syed Auliya Mohiddin

Aspiring Data Analyst | SQL | Power BI | Excel | Python
