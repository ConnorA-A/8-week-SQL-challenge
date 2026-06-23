-- Average time in imuntes for each runner to arrive at HQ to pick up the order

SELECT
    runner_orders.runner_id,
    AVG(DATEDIFF(MINUTE, customer_orders.order_time, runner_orders.pickup_time)) AS avg_pickup_mins
FROM runner_orders
INNER JOIN customer_orders
    ON runner_orders.order_id = customer_orders.order_id
WHERE runner_orders.pickup_time != 'null'
GROUP BY runner_orders.runner_id