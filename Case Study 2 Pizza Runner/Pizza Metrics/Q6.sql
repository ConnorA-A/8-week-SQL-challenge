-- What was the maximum number of pizzas delivered in one single order

WITH pizza_count AS(
    SELECT
        customer_orders.order_id,
        COUNT(customer_orders.pizza_id) AS per_order
    FROM customer_orders
    INNER JOIN runner_orders
        ON customer_orders.order_id = runner_orders.order_id
    WHERE distance != 'null'
    GROUP BY customer_orders.order_id
)

SELECT MAX(per_order) AS max_ordered
FROM pizza_count