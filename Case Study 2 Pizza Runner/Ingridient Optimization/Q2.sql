-- What was the most commonly added extra?

SELECT
    pizza_toppings.topping_name,
   COUNT(cleaned_extras.value) AS most_popular_extras
FROM customer_orders
CROSS APPLY string_split(customer_orders.extras, ',') AS cleaned_extras
INNER JOIN pizza_toppings
    ON cleaned_extras.value = pizza_toppings.topping_id
WHERE customer_orders.extras IS NOT NULL 
AND customer_orders.extras != 'null' 
AND customer_orders.extras != ''
GROUP BY pizza_toppings.topping_name

