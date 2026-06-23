-- What is the successful delivery percentage for each runner?

WITH orders AS(
SELECT 
    runner_orders.runner_id,
    SUM(CASE WHEN runner_orders.distance != 'null' THEN 1 ELSE 0 END) AS delivered_orders,
    COUNT(runner_orders.order_id) AS total_assigned_orders
FROM runner_orders
GROUP BY runner_orders.runner_id
)

SELECT
    (delivered_orders * 100/ total_assigned_orders) AS delivery_completion_rate_percent
FROM orders