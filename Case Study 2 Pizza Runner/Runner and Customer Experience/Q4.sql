-- What was the average distance travelled for each customer?

SELECT 
    customer_orders.customer_id,
    ROUND(AVG(CAST(REPLACE(distance, 'km', '') AS FLOAT)), 2) AS avg_distance_per_customer
FROM runner_orders
INNER JOIN customer_orders
    ON runner_orders.order_id = customer_orders.order_id
WHERE runner_orders.distance != 'null'
GROUP BY customer_orders.customer_id