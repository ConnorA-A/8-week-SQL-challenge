-- How many pizzas were delivered that had both exclusions and extras?

SELECT 
    SUM(
        CASE WHEN NOT (customer_orders.exclusions IS NULL OR customer_orders.exclusions = 'null' OR customer_orders.exclusions = ''
        AND
        customer_orders.extras IS NULL OR customer_orders.extras = 'null' OR customer_orders.extras = '')
        THEN 1 ELSE 0
        END) AS exclusions_and_extras
FROM customer_orders
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.distance != 'null'