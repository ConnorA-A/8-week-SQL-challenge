-- What was the difference between the longest and shortest delivery time for all orders?

SELECT
    runner_orders.order_id,
    MAX(runner_orders.duration::NUMERIC) - MIN(runner_orders.duration::NUMERIC)
FROM runner_orders
WHERE runner_orders.distance != 'null'
GROUP BY runner_orders.order_id