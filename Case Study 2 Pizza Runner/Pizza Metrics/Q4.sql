-- How many of each type of pizza was delivered?

SELECT
    pizza_names.pizza_name,
    COUNT(customer_orders.pizza_id) AS total_pizzas
FROM customer_orders
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id
INNER JOIN pizza_names
    ON customer_orders.pizza_id = pizza_names.pizza_id
    WHERE runner_orders.distance != 'null'
GROUP BY pizza_names.pizza_name