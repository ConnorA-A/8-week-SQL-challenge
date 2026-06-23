-- What was the volume of orders for each day of the week?

SELECT
     DATENAME(WEEKDAY, customer_orders.order_time) AS orders_per_dayofweek,
     COUNT(DISTINCT customer_orders.order_id) AS volume
FROM customer_orders
GROUP BY DATENAME(WEEKDAY, customer_orders.order_time)

