-- What was the total volume of pizzas ordered for each hour of the day?

SELECT
    DATEPART(HOUR, customer_orders.order_time) AS hour_of_day,
    COUNT(customer_orders.pizza_id) AS volume
FROM customer_orders
GROUP BY DATEPART(HOUR, customer_orders.order_time)