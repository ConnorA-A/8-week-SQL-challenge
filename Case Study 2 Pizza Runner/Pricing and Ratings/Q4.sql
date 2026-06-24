-- Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?

WITH total_pizzas AS (
SELECT 
    customer_orders.order_id,
     COUNT(customer_orders.pizza_id) AS pizzas_counted
FROM customer_orders   
GROUP BY customer_orders.order_id
)

SELECT
    customer_orders.order_id,
    customer_orders.customer_id,
    runner_orders.runner_id,
    customer_thoughts.rating,
    customer_orders.order_time,
    runner_orders.pickup_time,
    DATEDIFF(minute, customer_orders.order_time, runner_orders.pickup_time) AS minutes_between_order_and_pickup,
    ROUND((CAST(REPLACE(REPLACE(REPLACE(runner_orders.duration, 'mins', ''), 'minute', ''), 's', '') AS FLOAT) / 60), 2) AS delivery_hours,
    CAST(REPLACE(runner_orders.distance, 'km', '') AS FLOAT) AS distance_travelled,
    ROUND(CAST(REPLACE(runner_orders.distance, 'km', '') AS FLOAT) / ROUND((CAST(REPLACE(REPLACE(REPLACE(runner_orders.duration, 'mins', ''), 'minute', ''), 's', '') AS FLOAT) / 60), 2), 2) AS average_speed,
    total_pizzas.pizzas_counted
    
FROM customer_orders
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id
LEFT JOIN customer_thoughts
    ON customer_orders.order_id = customer_thoughts.order_id
INNER JOIN total_pizzas
    ON customer_orders.order_id = total_pizzas.order_id
WHERE runner_orders.distance != 'null'
GROUP BY 
    customer_orders.order_id,
    customer_orders.customer_id,
    runner_orders.runner_id,
    customer_thoughts.rating,
    customer_orders.order_time,
    runner_orders.pickup_time,
    DATEDIFF(minute, customer_orders.order_time, runner_orders.pickup_time),
    ROUND((CAST(REPLACE(REPLACE(REPLACE(runner_orders.duration, 'mins', ''), 'minute', ''), 's', '') AS FLOAT) / 60), 2),
    CAST(REPLACE(runner_orders.distance, 'km', '') AS FLOAT),
    total_pizzas.pizzas_counted


