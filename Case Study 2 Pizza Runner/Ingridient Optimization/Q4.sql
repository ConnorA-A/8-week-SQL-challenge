-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

WITH prepared AS(
SELECT 
    pizza_names.pizza_name,
    customer_orders.order_id,
    CASE 
        WHEN cleaned_recipe.value IN (SELECT value FROM string_split(customer_orders.extras, ','))
         THEN '2x' + pizza_toppings.topping_name
         ELSE pizza_toppings.topping_name
    END AS extras_display
FROM customer_orders
INNER JOIN pizza_recipes
    ON customer_orders.pizza_id = pizza_recipes.pizza_id
CROSS APPLY string_split(pizza_recipes.toppings, ',') AS cleaned_recipe
INNER JOIN pizza_names
    ON customer_orders.pizza_id = pizza_names.pizza_id
INNER JOIN pizza_toppings
    ON cleaned_recipe.value = pizza_toppings.topping_id
WHERE cleaned_recipe.value NOT IN(
    SELECT value FROM string_split(customer_orders.exclusions, ',')
)
)


SELECT 
    order_id,
    pizza_name,
    STRING_AGG(extras_display, ', ') AS pizza_item
FROM prepared
GROUP BY order_id, pizza_name
