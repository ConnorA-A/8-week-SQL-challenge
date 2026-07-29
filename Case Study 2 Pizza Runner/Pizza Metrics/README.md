# Case Study 2. Pizza Runner: Pizza Metrics

[← Back to main README](../../README.md)

## 1. How many pizzas where ordered?

```sql
SELECT COUNT(order_id) AS pizzas_ordered
FROM customer_orders
```

| pizzas_ordered |
|---|
| 14 |

## 2. How many unique customer orders were made?

```sql
SELECT COUNT(DISTINCT order_id)
FROM customer_orders
```

|  |
|---|
| 10 |

## 3. How many successful orders were delivered by each runner?

```sql
SELECT 
    runner_id,
    SUM(CASE
    WHEN cancellation = '' OR cancellation = 'null' OR cancellation  IS     NULL THEN 1
    ELSE 0
    END) AS successful_orders
FROM runner_orders
GROUP BY runner_id
```

| runner_id | successful_orders |
|---|---|
| 1 | 4 |
| 2 | 3 |
| 3 | 1 |

## 4. How many of each type of pizza was delivered?

```sql
SELECT
    pizza_names.pizza_name,
    COUNT(customer_orders.pizza_id) AS total_pizzas
FROM customer_orders
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id
INNER JOIN pizza_names
    ON customer_orders.pizza_id = pizza_names.pizza_id
    WHERE runner_orders.distance != 'null'
GROUP BY pizza_names.pizza_name
```

| pizza_name | total_pizzas |
|---|---|
| Meatlovers | 9 |
| Vegetarian | 3 |

## 5. How many vegeterian and Meatlovers were orederd by each customer?

```sql
SELECT 
    customer_orders.customer_id,
    pizza_names.pizza_name,
    COUNT(pizza_names.pizza_name) AS total_pizzas
FROM customer_orders
INNER JOIN pizza_names
    ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY customer_orders.customer_id, pizza_names.pizza_name
```

| customer_id | pizza_name | total_pizzas |
|---|---|---|
| 101 | Meatlovers | 2 |
| 102 | Meatlovers | 2 |
| 103 | Meatlovers | 3 |
| 104 | Meatlovers | 3 |
| 101 | Vegetarian | 1 |
| 102 | Vegetarian | 1 |
| 103 | Vegetarian | 1 |
| 105 | Vegetarian | 1 |

## 6. What was the maximum number of pizzas delivered in one single order

```sql
WITH pizza_count AS(
    SELECT
        customer_orders.order_id,
        COUNT(customer_orders.pizza_id) AS per_order
    FROM customer_orders
    INNER JOIN runner_orders
        ON customer_orders.order_id = runner_orders.order_id
    WHERE distance != 'null'
    GROUP BY customer_orders.order_id
)

SELECT MAX(per_order) AS max_ordered
FROM pizza_count
```

| max_ordered |
|---|
| 3 |

## 7. For each customer, how many delivered pizzas had at least one change and how many had no changes?

```sql
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
```

| customer_id | min_one_change | no_changes |
|---|---|---|
| 101 | 0 | 3 |
| 102 | 0 | 3 |
| 103 | 4 | 0 |
| 104 | 2 | 1 |
| 105 | 1 | 0 |

## 8. How many pizzas were delivered that had both exclusions and extras?

```sql
SELECT 
    SUM(
        CASE WHEN NOT (customer_orders.exclusions IS NULL OR customer_orders.exclusions = 'null' OR customer_orders.exclusions = ''
        AND
        customer_orders.extras IS NULL OR customer_orders.extras = 'null' OR customer_orders.extras = '')
        THEN 1 ELSE 0
        END) AS exclusions_and_extras
FROM customer_orders
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.distance != 'null'
```

| exclusions_and_extras |
|---|
| 1 |

## 9. What was the total volume of pizzas ordered for each hour of the day?

```sql
SELECT
    DATEPART(HOUR, customer_orders.order_time) AS hour_of_day,
    COUNT(customer_orders.pizza_id) AS volume
FROM customer_orders
GROUP BY DATEPART(HOUR, customer_orders.order_time)
```

| hour_of_day | volume |
|---|---|
| 11 | 1 |
| 13 | 3 |
| 18 | 3 |
| 19 | 1 |
| 21 | 3 |
| 23 | 3 |

## 10. What was the volume of orders for each day of the week?

```sql
SELECT
     DATENAME(WEEKDAY, customer_orders.order_time) AS orders_per_dayofweek,
     COUNT(DISTINCT customer_orders.order_id) AS volume
FROM customer_orders
GROUP BY DATENAME(WEEKDAY, customer_orders.order_time)
```

| orders_per_dayofweek | volume |
|---|---|
| Friday | 1 |
| Saturday | 2 |
| Thursday | 2 |
| Wednesday | 5 |
