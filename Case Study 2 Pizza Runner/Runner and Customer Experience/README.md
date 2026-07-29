# Case Study 2. Pizza Runner: Runner and Customer Experience

[← Back to main README](../../README.md)

## 1. How many runners signed up for each 1 week period? (weeks start 2021-01-01)

```sql
SELECT 
    DATEDIFF(WEEK, '2021-01-01', runners.registration_date) AS weeks,
    COUNT(runners.runner_id) AS registerations
FROM runners
GROUP BY DATEDIFF(WEEK, '2021-01-01', runners.registration_date)
```

| weeks | registerations |
|---|---|
| 0 | 1 |
| 1 | 2 |
| 2 | 1 |

## 2. Average time in imuntes for each runner to arrive at HQ to pick up the order

```sql
SELECT
    runner_orders.runner_id,
    AVG(DATEDIFF(MINUTE, customer_orders.order_time, runner_orders.pickup_time)) AS avg_pickup_mins
FROM runner_orders
INNER JOIN customer_orders
    ON runner_orders.order_id = customer_orders.order_id
WHERE runner_orders.pickup_time != 'null'
GROUP BY runner_orders.runner_id
```

| runner_id | avg_pickup_mins |
|---|---|
| 1 | 15 |
| 2 | 24 |
| 3 | 10 |

## 3. Is there any relationship between the number of pizzas and how long orders take to prepare?

```sql
WITH prep_time AS(
SELECT 
    customer_orders.order_id,
    COUNT(customer_orders.order_id) AS pizzas_per_order,
    DATEDIFF(MINUTE, customer_orders.order_time, runner_orders.pickup_time) AS preperation_time
FROM customer_orders
INNER JOIN runner_orders
    ON customer_orders.order_id = runner_orders.order_id
WHERE pickup_time != 'null'
GROUP BY customer_orders.order_id, DATEDIFF(MINUTE, customer_orders.order_time, runner_orders.pickup_time)
)

SELECT 
    pizzas_per_order,
    preperation_time
FROM prep_time
ORDER BY pizzas_per_order
```

| pizzas_per_order | preperation_time |
|---|---|
| 1 | 10 |
| 1 | 10 |
| 1 | 10 |
| 1 | 10 |
| 1 | 21 |
| 2 | 16 |
| 2 | 21 |
| 3 | 30 |

## 4. What was the average distance travelled for each customer?

```sql
SELECT 
    customer_orders.customer_id,
    ROUND(AVG(CAST(REPLACE(distance, 'km', '') AS FLOAT)), 2) AS avg_distance_per_customer
FROM runner_orders
INNER JOIN customer_orders
    ON runner_orders.order_id = customer_orders.order_id
WHERE runner_orders.distance != 'null'
GROUP BY customer_orders.customer_id
```

| customer_id | avg_distance_per_customer |
|---|---|
| 101 | 20.0 |
| 102 | 16.73 |
| 103 | 23.4 |
| 104 | 10.0 |
| 105 | 25.0 |

## 5. What was the difference between the longest and shortest delivery time for all orders?

```sql
WITH difference AS(
SELECT
    runner_orders.order_id,
    ROUND(CAST(REPLACE(REPLACE(REPLACE(runner_orders.duration, 'minutes', ''), 'mins', ''), 'minute', '') AS FLOAT), 2) AS clean_duration
FROM runner_orders
WHERE runner_orders.duration != 'null'
)

SELECT 
    MAX(clean_duration) - MIN(clean_duration) AS diff
FROM difference
```

| diff |
|---|
| 30.0 |

## 6. What was the average speed for each runner for each delivery? Any trends?

```sql
WITH distance_duration AS(
SELECT
    runner_orders.order_id,
    runner_orders.runner_id,
    ROUND(CAST(REPLACE(runner_orders.distance,'km', '') AS FLOAT), 2) AS cleaned_distance,
    ROUND((CAST(REPLACE(REPLACE(REPLACE(runner_orders.duration, 'minutes', ''), 'mins', ''), 'minute', '') AS FLOAT) / 60), 2) AS cleaned_duration_in_hours
FROM runner_orders
WHERE runner_orders.distance != 'null' AND runner_orders.duration != 'null'
)

SELECT
    runner_id,
    order_id,
    ROUND(cleaned_distance / cleaned_duration_in_hours, 2) AS speed
FROM distance_duration
```

| runner_id | order_id | speed |
|---|---|---|
| 1 | 1 | 37.74 |
| 1 | 2 | 44.44 |
| 1 | 3 | 40.61 |
| 2 | 4 | 34.93 |
| 3 | 5 | 40.0 |
| 2 | 7 | 59.52 |
| 2 | 8 | 93.6 |
| 1 | 10 | 58.82 |

## 7. What is the successful delivery percentage for each runner?

```sql
WITH orders AS(
SELECT 
    runner_orders.runner_id,
    SUM(CASE WHEN runner_orders.distance != 'null' THEN 1 ELSE 0 END) AS delivered_orders,
    COUNT(runner_orders.order_id) AS total_assigned_orders
FROM runner_orders
GROUP BY runner_orders.runner_id
)

SELECT
    (delivered_orders * 100/ total_assigned_orders) AS delivery_completion_rate_percent
FROM orders
```

| delivery_completion_rate_percent |
|---|
| 100 |
| 75 |
| 50 |
