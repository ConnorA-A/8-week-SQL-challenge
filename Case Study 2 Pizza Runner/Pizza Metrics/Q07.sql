-- For each customer, how many delivered pizzas had at least one change and how many had no changes?

SELECT 
    customer_orders.customer_id,
    SUM(
        CASE WHEN NOT((customer_orders.exclusions IS NULL OR customer_orders.exclusions = '' OR  customer_orders.exclusions = 'null' )
        AND
        (customer_orders.extras IS NULL OR customer_orders.extras = 'null' OR customer_orders.extras = ''))
        THEN 1 ELSE 0
        END) AS min_one_change,
    SUM(
        CASE WHEN (customer_orders.exclusions IS NULL OR customer_orders.exclusions = 'null' OR customer_orders.exclusions = '')
        AND
        (customer_orders.extras is NULL OR customer_orders.extras = 'null' OR customer_orders.extras = '') 
        THEN 1 ELSE 0
        END) AS no_changes
FROM customer_orders
GROUP BY customer_orders.customer_id