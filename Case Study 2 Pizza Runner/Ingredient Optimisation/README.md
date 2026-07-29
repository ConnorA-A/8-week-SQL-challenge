# Case Study 2. Pizza Runner: Ingredient Optimisation

[← Back to main README](../../README.md)

## 1. What are the standard ingridients for each pizza?

```sql
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
```

| pizza_name | toppings |
|---|---|
| Meatlovers | Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami |
| Vegetarian | Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce |

## 2. What was the most commonly added extra?

```sql
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
```

| topping_name | most_popular_extras |
|---|---|
| Bacon | 4 |
| Cheese | 1 |
| Chicken | 1 |

## 3. What was the most common exclusions

```sql
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
```

| topping_name | exclusion_frequency |
|---|---|
| BBQ Sauce | 1 |
| Cheese | 4 |
| Mushrooms | 1 |

## 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

```sql
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
```

| order_id | pizza_name | pizza_item |
|---|---|---|
| 1 | Meatlovers | Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami |
| 2 | Meatlovers | Salami, Pepperoni, Mushrooms, Chicken, Cheese, Beef, BBQ Sauce, Bacon |
| 3 | Meatlovers | Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami |
| 4 | Meatlovers | Salami, Salami, Pepperoni, Pepperoni, Mushrooms, Mushrooms, Chicken, Chicken, Cheese, Cheese, Beef, Beef, BBQ Sauce, BBQ Sauce, Bacon, Bacon |
| 5 | Meatlovers | 2xBacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami |
| 8 | Meatlovers | Salami, Pepperoni, Mushrooms, Chicken, Cheese, Beef, BBQ Sauce, Bacon |
| 9 | Meatlovers | 2xBacon, BBQ Sauce, Beef, Cheese, 2xChicken, Mushrooms, Pepperoni, Salami |
| 10 | Meatlovers | Salami, Salami, Pepperoni, Pepperoni, Mushrooms, Chicken, Chicken, Cheese, 2xCheese, Beef, Beef, BBQ Sauce, BBQ Sauce, Bacon, 2xBacon |
| 3 | Vegetarian | Cheese, Mushrooms, Peppers, Tomatoes, Onions, Tomato Sauce |
| 4 | Vegetarian | Tomato Sauce, Onions, Tomatoes, Peppers, Mushrooms |
| 6 | Vegetarian | Mushrooms, Peppers, Tomatoes, Cheese, Onions, Tomato Sauce |
| 7 | Vegetarian | Tomato Sauce, Onions, Cheese, Tomatoes, Peppers, Mushrooms |
