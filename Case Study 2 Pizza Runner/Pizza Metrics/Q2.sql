-- How many unique customer orders were made?

SELECT COUNT(DISTINCT order_id)
FROM customer_orders
