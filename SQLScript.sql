 /* Order and Sales Analysis */
/*a.Order Status Summary*/
SELECT order_status, COUNT(*) AS total_orders
FROM customer_orders
GROUP BY order_status;
/*b.Monthly Revenue Trends*/
 SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(order_amount) AS total_revenue
FROM customer_orders
WHERE order_status = 'delivered'
GROUP BY month
ORDER BY month;
/*c. Top Revenue Generating Orders*/
SELECT order_id, order_amount
FROM customer_orders
ORDER BY order_amount DESC
LIMIT 10;

/*Customer Analysis*/
/* a. Repeat Customers*/
SELECT customer_id, COUNT(*) AS total_orders
FROM customer_orders
GROUP BY customer_id
HAVING total_orders > 1;
/*b. First-Time vs Returning Orders*/
SELECT 
    CASE 
        WHEN order_count = 1 THEN 'First-Time'
        ELSE 'Returning'
    END AS customer_type,
    COUNT(*) AS num_customers
FROM (
    SELECT customer_id, COUNT(*) AS order_count
    FROM customer_orders
    GROUP BY customer_id
) AS sub
GROUP BY customer_type;
/* c. Orders Per Customer Over Time*/
SELECT 
    customer_id,
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS orders_per_month
FROM customer_orders
GROUP BY customer_id, month
ORDER BY customer_id, month;

/*Payment Status Analysis*/
/* a. Payment Success vs Failure*/
SELECT payment_status, COUNT(*) AS total_payments
FROM payments
GROUP BY payment_status;
/* b. Payment Method Breakdown*/
SELECT payment_method, COUNT(*) AS count
FROM payments
GROUP BY payment_method;
/* c. Failed Payments Analysis*/
SELECT payment_method, COUNT(*) AS failed_count
FROM payments
WHERE payment_status = 'Failed'
GROUP BY payment_method;

/*Order Details Report (Join Both Tables)*/
SELECT 
    co.order_id,
    co.customer_id,
    co.order_date,
    co.order_amount,
    co.order_status,
    p.payment_date,
    p.payment_amount,
    p.payment_method,
    p.payment_status
FROM customer_orders co
LEFT JOIN payments p ON co.order_id = p.order_id;

/*Customer Retention Analysis (for BI Tool like Power BI or Tableau)*/
WITH customer_first_order AS (
    SELECT 
        customer_id, 
        MIN(DATE_FORMAT(order_date, '%Y-%m')) AS cohort_month
    FROM customer_orders
    GROUP BY customer_id
)
SELECT 
    cfo.cohort_month,
    DATE_FORMAT(co.order_date, '%Y-%m') AS order_month,
    co.customer_id
FROM customer_orders co
JOIN customer_first_order cfo ON co.customer_id = cfo.customer_id;

WITH customer_first_order AS (
    SELECT 
        customer_id, 
        MIN(DATE_FORMAT(order_date, '%Y-%m')) AS cohort_month
    FROM customer_orders
    GROUP BY customer_id
)
SELECT 
    cfo.customer_id,
    cfo.cohort_month,
    DATE_FORMAT(co.order_date, '%Y-%m') AS order_month
FROM customer_orders co
JOIN customer_first_order cfo ON co.customer_id = cfo.customer_id;

 
