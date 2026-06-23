-- Is there any relationship between the number of pizzas and how long orders take to prepare?

WITH prep_time AS(
SELECT 
    customer_orders.order_id,
    COUNT(customer_orders.order_id) AS pizzas_per_order,
    DATEDIFF(MINUTE, customer_orders.order_time, runner_orders.pickup_time) AS preperation_time
FROM customer_orders
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id
WHERE pickup_time != 'null'
GROUP BY customer_orders.order_id, DATEDIFF(MINUTE, customer_orders.order_time, runner_orders.pickup_time)
)

SELECT 
    pizzas_per_order,
    preperation_time
FROM prep_time
ORDER BY pizzas_per_order