SELECT
    SUM(CASE WHEN customer_orders.pizza_id = 1 Then 12 ELSE 10 END)
    + (SELECT COUNT(cleaned_extras.value)
    FROM customer_orders
    INNER JOIN runner_orders 
        ON customer_orders.order_id = runner_orders.order_id
        CROSS APPLY string_split(customer_orders.extras, ',') AS cleaned_extras
        WHERE runner_orders.distance != 'null'
        AND customer_orders.extras != 'null'
        AND customer_orders.extras != ''
        AND customer_orders.extras IS NOT NULL) AS total_made

FROM customer_orders 
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id 
WHERE runner_orders.distance != 'null'     