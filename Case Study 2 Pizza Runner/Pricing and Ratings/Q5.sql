-- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?


WITH revenue AS(
SELECT  
    SUM(CASE WHEN customer_orders.pizza_id = 1 THEN 12 ELSE 10 END) AS rev
FROM customer_orders
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.distance != 'null'
),
cost AS(
SELECT
    SUM(CAST(REPLACE(runner_orders.distance, 'km', '') AS float)) *0.30 AS paid_to_runners
FROM runner_orders
WHERE distance != 'null'
)
SELECT
    rev - paid_to_runners AS total_profit
FROM revenue, cost