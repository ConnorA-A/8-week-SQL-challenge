-- What are the standard ingridients for each pizza?

SELECT 
    pizza_names.pizza_name,
    STRING_AGG(pizza_toppings.topping_name, ', ') AS toppings
FROM pizza_recipes
CROSS APPLY string_split(pizza_recipes.toppings, ',') AS clean_toppings
INNER JOIN pizza_toppings
    ON clean_toppings.value = pizza_toppings.topping_id
INNER JOIN pizza_names
    ON pizza_recipes.pizza_id = pizza_names.pizza_id
GROUP BY pizza_names.pizza_name


