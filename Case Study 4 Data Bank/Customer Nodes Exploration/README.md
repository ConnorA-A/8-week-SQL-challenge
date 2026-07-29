# Case Study 4. Data Bank: Customer Nodes Exploration

[← Back to main README](../../README.md)

## 1. How many unique nodes are there on the Data Bank system?

```sql
SELECT COUNT(DISTINCT node_id) AS distinct_nodes
FROM customer_nodes 
```

| distinct_nodes |
|---|
| 5 |

## 2. What is the number of nodes per region?

```sql
SELECT
    regions.region_name,
    COUNT(DISTINCT customer_nodes.node_id) AS node_ids_per_region
FROM regions
INNER JOIN customer_nodes
    ON regions.region_id = customer_nodes.region_id
GROUP BY regions.region_name
```

| region_name | node_ids_per_region |
|---|---|
| Africa | 5 |
| America | 5 |
| Asia | 5 |
| Australia | 5 |
| Europe | 5 |

## 3. How many customers are allocated to each region?

```sql
SELECT
    COUNT(DISTINCT customer_nodes.customer_id) AS customers_per_region,
    regions.region_name
FROM customer_nodes
INNER JOIN regions
    ON customer_nodes.region_id = regions.region_id
GROUP BY regions.region_name
```

| customers_per_region | region_name |
|---|---|
| 102 | Africa |
| 105 | America |
| 95 | Asia |
| 110 | Australia |
| 88 | Europe |

## 4. How many days on average are customers reallocated to a different node?

```sql
SELECT 
    AVG((DATEDIFF(day, customer_nodes.start_date, customer_nodes.end_date))) AS average_days_between
FROM customer_nodes
WHERE customer_nodes.end_date != '9999-12-31'
```

| average_days_between |
|---|
| 14 |

## 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

```sql
WITH days_between AS(
SELECT 
    DATEDIFF(day, customer_nodes.start_date, customer_nodes.end_date) AS days_difference,
    regions.region_name
FROM customer_nodes
INNER JOIN regions
    ON customer_nodes.region_id = regions.region_id
WHERE customer_nodes.end_date != '9999-12-31'
)

SELECT
    DISTINCT region_name,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_difference) OVER (PARTITION BY region_name) AS median_days,
    PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY days_difference) OVER (PARTITION BY region_name) AS eighty_percentile_days,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY days_difference) OVER (PARTITION BY region_name) AS nintyfive_percentile_days
FROM days_between
```

| region_name | median_days | eighty_percentile_days | nintyfive_percentile_days |
|---|---|---|---|
| Europe | 15.0 | 24.0 | 28.0 |
| Australia | 15.0 | 23.0 | 28.0 |
| Africa | 15.0 | 24.0 | 28.0 |
| Asia | 15.0 | 23.0 | 28.0 |
| America | 15.0 | 23.0 | 28.0 |
