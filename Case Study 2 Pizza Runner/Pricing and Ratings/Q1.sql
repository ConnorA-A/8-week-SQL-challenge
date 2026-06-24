-- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

WITH money_per_order AS(
SELECT 
    customer_orders.order_id,
    SUM(CASE 
    WHEN customer_orders.pizza_id = 1 THEN 12
    WHEN customer_orders.pizza_id = 2 THEN 10
    END) AS money_per_order
FROM customer_orders
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.distance != 'null'
GROUP BY customer_orders.order_id
)

SELECT 
   SUM(money_per_order) AS total_money_made
FROM money_per_order