CREATE DATABASE olist_ecommerce;

CREATE TABLE customers(
			customer_id	VARCHAR(35),
			customer_unique_id VARCHAR(35),
			customer_zip_code_prefix NUMERIC(10,2),
			customer_city VARCHAR(35),
			customer_state VARCHAR(5)
);

CREATE TABLE geolocation (
		    geolocation_zip_code_prefix VARCHAR(5),
		    geolocation_lat DECIMAL(10,7),
		    geolocation_lng DECIMAL(10,7),
		    geolocation_city TEXT,
		    geolocation_state VARCHAR(2)
);

CREATE TABLE order_items(
			order_id VARCHAR(35),
			order_item_id INTEGER,
			product_id VARCHAR(35),
			seller_id VARCHAR(35),
			shipping_limit_date TIMESTAMP,
			price DECIMAL(7,2),
			freight_value DECIMAL(7,2)
);

CREATE TABLE order_payments (
    order_id VARCHAR(35),
    payment_sequential INTEGER,
    payment_type VARCHAR(20),
    payment_installments INTEGER,
    payment_value DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id VARCHAR(35),
    customer_id VARCHAR(35),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE products (
    product_id VARCHAR(35),
    product_category_name TEXT,
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

CREATE TABLE sellers (
    seller_id VARCHAR(35),
    seller_zip_code_prefix VARCHAR(5),
    seller_city TEXT,
    seller_state VARCHAR(2)
);


CREATE TABLE product_category (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

CREATE TABLE order_reviews (
    review_id VARCHAR(35),
    order_id VARCHAR(35),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

/******************************************************
		Data Validation & Data Understanding
*******************************************************/

/*1. How large is the business? Business problem:Management wants a baseline view of the marketplace.
Calculate:Total orders,Total customers,Total sellers,Total products.*/

SELECT 	COUNT(*) AS total_orders,
		(SELECT COUNT(customer_id) FROM customers)AS total_customers,
		(SELECT COUNT(seller_id) FROM sellers)AS total_sellers,
		(SELECT COUNT(*) FROM products) AS total_products
FROM orders;

/*2. How much revenue did the business generate?Business problem:Finance wants to understand the overall sales generated through orders.
Calculate:Total sales/revenue,Number of orders,Average Order Value (AOV).Decision: Establish the financial baseline.*/

SELECT SUM(price)AS total_sales,
		COUNT(DISTINCT order_id) AS total_orders,
		ROUND(SUM(price)*1.0/COUNT(DISTINCT order_id),2) AS avg_order_value
FROM order_items;
"total_sales"	"total_orders"	"avg_order_value"
13591643.70	98666	137.75

-- 3.How many total records are present in the orders table, and how many unique order_id values exist?
SELECT COUNT(*) AS total_orders,
	   COUNT(DISTINCT order_id ) AS unique_orders
FROM orders;
"total_orders"	"unique_orders"
99441	99441

--4.How many customer records exist, and how many unique customer_id and customer_unique_id values are there?
SELECT COUNT(*) AS total_customers, 
	   COUNT(DISTINCT customer_id) AS unique_customer_ids,
	   COUNT(DISTINCT customer_unique_id) AS customer_unique_ids
FROM customers;

--5.How many product records exist, and is product_id unique?
SELECT COUNT(*) AS total_products,
	   COUNT(DISTINCT product_id)AS unique_ids
FROM products;

--6.How many sellers exist, and is seller_id unique?
SELECT COUNT(*) AS total_sellers,
	   COUNT(DISTINCT seller_id)AS unique_ids
FROM sellers;

--7.How many order-item records exist, and how many unique orders appear in order_items?
SELECT COUNT(*) AS total_order_items,
	   COUNT(DISTINCT order_id)AS unique_ids
FROM order_items;
"total_order_items"	"unique_ids"
112650	98666

--8.How many payment and review records exist, and can an order have multiple payment or review records?
-- multiple payment records?
SELECT COUNT(*)AS payment_records,
	   COUNT(DISTINCT order_id)AS unique_id
FROM order_payments;

-- 8B. Which orders have multiple payment records?
SELECT order_id,
	   	COUNT(*)AS payment_record_count
FROM order_payments
GROUP BY order_id
HAVING COUNT(*)>1
ORDER BY payment_record_count DESC;

-- 8C. How many review records exist, and how many orders have reviews?
SELECT COUNT(*)AS review_records,
	   COUNT(DISTINCT order_id)AS unique_id
FROM order_reviews;

"review_records"	"unique_id"
99224	98673

-- 8D. Can an order have multiple review records?
SELECT order_id,
	   COUNT(*)AS review_records_count
FROM order_reviews
GROUP BY order_id
HAVING COUNT(*)>1
ORDER BY review_records_count DESC;

/******************************************************
		     Executive Business KPIs
*******************************************************/

--9.What is the total number of orders and how are they distributed by order status?
SELECT order_status,COUNT(*)AS no_of_orders
FROM orders
GROUP BY order_status
ORDER BY no_of_orders DESC;

--10.How many unique customers have placed orders?
SELECT 
    COUNT(DISTINCT c.customer_unique_id) AS unique_customers
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;
"unique_customers"
96096

--11.How many unique sellers have fulfilled orders?
SELECT COUNT(DISTINCT oi.seller_id)AS uniqe_sellers
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
WHERE o.order_status='delivered';
"uniqe_sellers"
2970

/******************************************************
			        Sales & Revenue
*******************************************************/

--12.How do order volume and sales value change month by month?
SELECT DATE_TRUNC('month',o.order_purchase_timestamp)AS months,
		  COUNT(DISTINCT o.order_id),
		   SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi
USING (order_id)
GROUP BY months
ORDER BY months ASC;
	
--13. Which product categories generate the highest sales value?
SELECT pc.product_category_name_english AS category,
		 SUM(oi.price)AS sales_value
FROM order_items oi
JOIN products p
ON p.product_id=oi.product_id
JOIN product_category pc
ON p.product_category_name=pc.product_category_name
GROUP BY pc.product_category_name_english
ORDER BY sales_value DESC
LIMIT 1;
"category"	"sales_value"
"health_beauty"	1258681.34
	
--14.Which product categories have high order volume but relatively low sales value?
WITH relative_cte AS(
SELECT pc.product_category_name_english AS category,
		  COUNT(DISTINCT oi.order_id)AS order_volume,
		  SUM(oi.price)AS sales_value
FROM order_items oi
JOIN products p
ON p.product_id=oi.product_id
JOIN product_category pc
ON p.product_category_name=pc.product_category_name
GROUP BY pc.product_category_name_english)
SELECT * FROM relative_cte
WHERE order_volume > (SELECT AVG(order_volume) FROM relative_cte)
  AND sales_value < (SELECT AVG(sales_value) FROM relative_cte)
ORDER BY order_volume DESC;

--15. Which customer states generate the highest sales value and order volume?
SELECT c.customer_state,
	   SUM(oi.price)AS sales_value,
	   COUNT(DISTINCT oi.order_id)AS order_volume
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY c.customer_state
ORDER BY sales_value DESC,order_volume DESC
LIMIT 3;
	
/******************************************************
			      Customer Analysis
*******************************************************/
--16.How many customers placed more than one order?
WITH count_cte AS
(SELECT c.customer_unique_id,COUNT(o.order_id)
FROM customers c
JOIN orders o
USING(customer_id)
GROUP BY c.customer_unique_id	
HAVING COUNT(order_id)>1)
SELECT COUNT(*)AS customers
FROM count_cte;
	
--17.What is the average number of orders per unique customer?
WITH uniq_cte AS(
SELECT c.customer_unique_id,COUNT(o.order_id)AS uni_count
FROM customers c
JOIN orders o
USING(customer_id)
GROUP BY c.customer_unique_id)
	SELECT ROUND(AVG(uni_count),2)AS avg_orders
	FROM uniq_cte;

--18.Which customers generated the highest total order value?
SELECT c.customer_unique_id,
		SUM(oi.price) AS total_order_value
FROM customers c
JOIN orders o
USING(customer_id)
JOIN order_items oi
USING(order_id)
GROUP BY c.customer_unique_id
ORDER BY total_order_value DESC
LIMIT 3;

--19.Which states have the highest number of unique customers, and how does customer concentration compare with 
--sales concentration?
SELECT c.customer_state,
		COUNT(DISTINCT c.customer_unique_id)AS uni_customers,
		ROUND((COUNT(DISTINCT c.customer_unique_id)::numeric
		/ (SELECT COUNT(DISTINCT customer_unique_id) FROM customers) * 100),2) AS cust_concentration,
		SUM(oi.price)AS sales_value,
		ROUND((SUM(oi.price)
		/ (SELECT SUM(price) FROM order_items) * 100),2) AS sales_concentration
FROM customers c
JOIN orders o
USING(customer_id)
JOIN order_items oi
USING(order_id)
GROUP BY customer_state
ORDER BY uni_customers DESC;

/******************************************************
		         Product & Seller Analysis
*******************************************************/

-- 20.Which product categories have the highest number of items sold?
SELECT pc.product_category_name_english AS product_category,
		COUNT(oi.product_id) AS items_sold
FROM product_category pc
JOIN products p
USING(product_category_name)
JOIN order_items oi
USING(product_id)
GROUP BY pc.product_category_name_english
ORDER BY items_sold DESC
LIMIT 3;

-- 21.Which sellers generate the highest sales value and order-item volume?
SELECT s.seller_id,SUM(oi.price)AS sales_value,
		COUNT(oi.order_id) AS order_item_volume
FROM sellers s
JOIN order_items oi
USING(seller_id)
GROUP BY s.seller_id
ORDER BY sales_value DESC,order_item_volume DESC
LIMIT 3;

-- 22.What percentage of total sales is generated by the top 10 sellers?
WITH sales_cte AS(
SELECT s.seller_id,SUM(oi.price)AS sales_value
FROM sellers s
JOIN order_items oi
USING(seller_id)
GROUP BY s.seller_id
ORDER BY sales_value DESC
LIMIT 10)
SELECT ROUND((SUM(sales_value) / (SELECT SUM(price) FROM order_items)* 100),2)AS total_perc
FROM sales_cte;

--23.Which product categories have the highest average selling price?
SELECT pc.product_category_name_english AS product_category,
	   ROUND(AVG(oi.price),2) AS avg_selling_price
FROM product_category pc
JOIN products p
USING(product_category_name)
JOIN order_items oi
USING(product_id)
GROUP BY pc.product_category_name_english
ORDER BY avg_selling_price DESC
LIMIT 3;

--24.What is the average number of days from order purchase to customer delivery ?
SELECT ROUND(AVG(EXTRACT(EPOCH FROM(order_delivered_customer_date - order_purchase_timestamp))/86400),2)AS avg_deliv_time
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
"avg_deliv_time"
12.56

-- (OR)

SELECT AVG(order_delivered_customer_date - order_purchase_timestamp)AS avg_deliv_time
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
"avg_deliv_time"
"12 days 13:24:31.879068"

--25.What percentage of delivered orders arrived after the estimated delivery date?

SELECT (SELECT COUNT(*) FILTER(WHERE order_status ='delivered' 
	  					AND order_delivered_customer_date > order_estimated_delivery_date)
						  FROM orders)/
 (SELECT COUNT(order_status)*1.0
FROM orders
WHERE order_status = 'delivered') * 100 AS percen_delive_orders;


--26. Which customer states have the highest late-delivery rates, considering only states with a meaningful number
--of delivered orders?
SELECT
    c.customer_state,
    COUNT(*) AS delivered_orders,
    COUNT(*) FILTER (
        WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
    ) AS late_orders,
    ROUND(
        COUNT(*) FILTER (
            WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_rate
FROM customers c
JOIN orders o
    USING(customer_id)
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING COUNT(*) >= 500
ORDER BY late_delivery_rate DESC;

--27.Which product categories have the lowest average review scores?
SELECT pc.product_category_name_english AS product_category,
	   ROUND(AVG(r.review_score),2)AS avg_review_score
FROM product_category pc
JOIN products p
USING(product_category_name)
JOIN order_items oi
USING(product_id)
JOIN order_reviews r
USING(order_id)
GROUP BY pc.product_category_name_english
ORDER BY avg_review_score ASC
LIMIT 3;

--28.How does customer review score differ between orders delivered on time and orders delivered late?
SELECT 
    CASE 
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date 
            THEN 'On Time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
            THEN 'Late'
    END AS delivery_status,
    COUNT(*) AS total_reviews,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o
JOIN order_reviews r USING(order_id)
WHERE o.order_status = 'delivered'
GROUP BY delivery_status
ORDER BY avg_review_score DESC;


SELECT * FROM customers;
SELECT * FROM geolocation;
SELECT * FROM order_items;
SELECT * FROM order_payments;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM sellers;
SELECT * FROM product_category;
SELECT * FROM order_reviews;