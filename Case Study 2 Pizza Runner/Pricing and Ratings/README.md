# Case Study 2. Pizza Runner: Pricing and Ratings

[← Back to main README](../../README.md)

## 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

```sql
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
```

| total_money_made |
|---|
| 138 |

## 2. Q2

```sql
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
```

| total_made |
|---|
| 142 |

## 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

```sql
DROP TABLE IF EXISTS customer_thoughts
CREATE TABLE customer_thoughts (
    "order_id" INTEGER,
    "runner_id" INTEGER,
    "rating"  INTEGER CHECK (rating BETWEEN 1 AND 5),
    "rating_time" DATETIME,
    "comments" VARCHAR(500)
);

INSERT INTO customer_thoughts
    (order_id, runner_id, rating, rating_time, comments)
VALUES
    (1, 1, 3, '2021-01-01 20:05:42', 'Delivery took a long time and the pizza was cold'),
    (2, 1, 4, '2021-01-01 21:07:55', 'Delivery was quicker than expected and the driver was very polite'),
    (3, 1, 5, '2021-01-03 01:30:12', 'Exceptional service!'),
    (4, 2, 2, '2021-01-04 14:59:01', 'Delivery took a very long time!'),
    (5, 3, NULL, NULL, NULL)
```

| order_id | runner_id | rating | rating_time | comments |
|---|---|---|---|---|
| 1 | 1 | 3 | 2021-01-01 20:05:42.000 | Delivery took a long time and the pizza was cold |
| 2 | 1 | 4 | 2021-01-01 21:07:55.000 | Delivery was quicker than expected and the driver was very polite |
| 3 | 1 | 5 | 2021-01-03 01:30:12.000 | Exceptional service! |
| 4 | 2 | 2 | 2021-01-04 14:59:01.000 | Delivery took a very long time! |
| 5 | 3 | NULL | NULL | NULL |

## 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?

```sql
WITH total_pizzas AS (
SELECT 
    customer_orders.order_id,
     COUNT(customer_orders.pizza_id) AS pizzas_counted
FROM customer_orders   
GROUP BY customer_orders.order_id
)

SELECT
    customer_orders.order_id,
    customer_orders.customer_id,
    runner_orders.runner_id,
    customer_thoughts.rating,
    customer_orders.order_time,
    runner_orders.pickup_time,
    DATEDIFF(minute, customer_orders.order_time, runner_orders.pickup_time) AS minutes_between_order_and_pickup,
    ROUND((CAST(REPLACE(REPLACE(REPLACE(runner_orders.duration, 'mins', ''), 'minute', ''), 's', '') AS FLOAT) / 60), 2) AS delivery_hours,
    CAST(REPLACE(runner_orders.distance, 'km', '') AS FLOAT) AS distance_travelled,
    ROUND(CAST(REPLACE(runner_orders.distance, 'km', '') AS FLOAT) / ROUND((CAST(REPLACE(REPLACE(REPLACE(runner_orders.duration, 'mins', ''), 'minute', ''), 's', '') AS FLOAT) / 60), 2), 2) AS average_speed,
    total_pizzas.pizzas_counted
    
FROM customer_orders
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id
LEFT JOIN customer_thoughts
    ON customer_orders.order_id = customer_thoughts.order_id
INNER JOIN total_pizzas
    ON customer_orders.order_id = total_pizzas.order_id
WHERE runner_orders.distance != 'null'
GROUP BY 
    customer_orders.order_id,
    customer_orders.customer_id,
    runner_orders.runner_id,
    customer_thoughts.rating,
    customer_orders.order_time,
    runner_orders.pickup_time,
    DATEDIFF(minute, customer_orders.order_time, runner_orders.pickup_time),
    ROUND((CAST(REPLACE(REPLACE(REPLACE(runner_orders.duration, 'mins', ''), 'minute', ''), 's', '') AS FLOAT) / 60), 2),
    CAST(REPLACE(runner_orders.distance, 'km', '') AS FLOAT),
    total_pizzas.pizzas_counted
```

| order_id | customer_id | runner_id | rating | order_time | pickup_time | minutes_between_order_and_pickup | delivery_hours | distance_travelled | average_speed | pizzas_counted |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 101 | 1 | 3 | 2020-01-01 18:05:02.000 | 2020-01-01 18:15:34 | 10 | 0.53 | 20.0 | 37.74 | 1 |
| 2 | 101 | 1 | 4 | 2020-01-01 19:00:52.000 | 2020-01-01 19:10:54 | 10 | 0.45 | 20.0 | 44.44 | 1 |
| 3 | 102 | 1 | 5 | 2020-01-02 23:51:23.000 | 2020-01-03 00:12:37 | 21 | 0.33 | 13.4 | 40.61 | 2 |
| 4 | 103 | 2 | 2 | 2020-01-04 13:23:46.000 | 2020-01-04 13:53:03 | 30 | 0.67 | 23.4 | 34.93 | 3 |
| 5 | 104 | 3 | NULL | 2020-01-08 21:00:29.000 | 2020-01-08 21:10:57 | 10 | 0.25 | 10.0 | 40.0 | 1 |
| 7 | 105 | 2 | NULL | 2020-01-08 21:20:29.000 | 2020-01-08 21:30:45 | 10 | 0.42 | 25.0 | 59.52 | 1 |
| 8 | 102 | 2 | NULL | 2020-01-09 23:54:33.000 | 2020-01-10 00:15:02 | 21 | 0.25 | 23.4 | 93.6 | 1 |
| 10 | 104 | 1 | NULL | 2020-01-11 18:34:49.000 | 2020-01-11 18:50:20 | 16 | 0.17 | 10.0 | 58.82 | 2 |

## 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```sql
WITH revenue AS(
SELECT  
    SUM(CASE WHEN customer_orders.pizza_id = 1 THEN 12 ELSE 10 END) AS rev
FROM customer_orders
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.distance != 'null'
),
cost AS(
SELECT
    SUM(CAST(REPLACE(runner_orders.distance, 'km', '') AS float)) *0.30 AS paid_to_runners
FROM runner_orders
WHERE distance != 'null'
)
SELECT
    rev - paid_to_runners AS total_profit
FROM revenue, cost
```

| total_profit |
|---|
| 94.44 |
