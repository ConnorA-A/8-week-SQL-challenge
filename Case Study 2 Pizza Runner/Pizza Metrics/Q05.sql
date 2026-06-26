-- How many vegeterian and Meatlovers were orederd by each customer?

SELECT 
    customer_orders.customer_id,
    pizza_names.pizza_name,
    COUNT(pizza_names.pizza_name) AS total_pizzas
FROM customer_orders
INNER JOIN pizza_names
    ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY customer_orders.customer_id, pizza_names.pizza_name


