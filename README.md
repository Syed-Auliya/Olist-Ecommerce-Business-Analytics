## Olist E-Commerce Business Analytics

### Project Overview

This project analyzes the Olist Brazilian e-commerce marketplace to
understand sales, customers, products, sellers, delivery operations, and
customer experience.

The goal was to go beyond dashboard creation by combining data
validation, SQL business analysis, data modeling, and Power BI
storytelling.

Tools are the means. Business reasoning is the product.

Business Problem

The business needs a consolidated view of:

Sales and order performance

Customer retention

Product and category performance

Geographic concentration

Delivery reliability

Customer satisfaction

Areas requiring business attention

Dataset

Main tables:

orders

customers

order_items

order_payments

order_reviews

products

sellers

product_category

Data Validation

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

SQL Analysis

SQL was used for the main business analysis:

Sales, orders and AOV

Monthly sales trends

Customer retention and orders per customer

Customer and sales concentration

Category and product performance

Seller performance and concentration

Delivery time and late-delivery analysis

Review and customer-experience analysis

Key Business Metrics

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

Key Business Insights

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
<img width="1201" height="672" alt="image" src="https://github.com/user-attachments/assets/00efefb6-7692-4c47-a63d-7918af7571f2" />



## Page 2 --- Customer & Sales Analytics
<img width="1200" height="681" alt="Screenshot 2026-10-04 111920" src="https://github.com/user-attachments/assets/972d8abb-7e80-4742-bae7-6335cc58b448" />


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

Tool responsibilities were intentionally separated:

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

Improve customer retention through reactivation, personalized
offers and post-purchase engagement.

Reduce late deliveries and investigate high-risk states, sellers
and categories.

Monitor geographic performance, especially the dominant São
Paulo market and states with high delivery delays.

Evaluate categories using multiple dimensions: Sales + Volume +
Average Price + Customer Experience.

Monitor seller performance for availability, delivery
reliability and customer satisfaction.

Skills Demonstrated

Business problem framing

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
