-- What was the most common exclusions

SELECT
    pizza_toppings.topping_name,
    COUNT(cleaned_exclusions.value) AS exclusion_frequency
FROM customer_orders
CROSS APPLY string_split(customer_orders.exclusions, ',') AS cleaned_exclusions
INNER JOIN pizza_toppings
    ON cleaned_exclusions.value = pizza_toppings.topping_id
WHERE customer_orders.exclusions IS NOT NULL
AND customer_orders.exclusions != 'null'
AND customer_orders.exclusions != ''
GROUP BY pizza_toppings.topping_name