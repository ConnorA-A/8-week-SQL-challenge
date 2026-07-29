# Case Study 7. Balanced Tree Clothing: Transaction Analysis

[← Back to main README](../../README.md)

## 1. How many unique transactions were there?

```sql
SELECT
    COUNT(DISTINCT txn_id) AS total_unique_transactions
FROM sales
```

| total_unique_transactions |
|---|
| 2500 |

## 2. What is the average unique products purchased in each transaction?

```sql
WITH required_data AS(
SELECT
    txn_id,
    COUNT(DISTINCT prod_id) AS unique_products_per_transaction
FROM sales
GROUP BY txn_id
)

SELECT
    AVG(unique_products_per_transaction) AS average_unique_products_each_transaction
FROM required_data
```

| average_unique_products_each_transaction |
|---|
| 6 |

## 3. What are the 25th, 50th and 75th percentile values for the revenue per transaction (discounts excluded)

```sql
WITH revenue_data AS(
SELECT
    txn_id,
    CAST(ROUND(SUM(qty * price), 2) AS DECIMAL (15, 2)) AS total_revenue
FROM sales
GROUP BY txn_id
)

SELECT TOP 1
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_revenue) OVER () AS twentyfifth_percentile,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_revenue) OVER () AS fifty_percentile,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_revenue) OVER () AS seventyfifth_percentile
FROM revenue_data
```

| twentyfifth_percentile | fifty_percentile | seventyfifth_percentile |
|---|---|---|
| 375.75 | 509.5 | 647.0 |

## 4. What is the average discount value per transaction?

```sql
WITH discounts AS(
SELECT
    txn_id,
    CAST(ROUND(SUM(qty * price * (discount / 100.0)), 2) AS DECIMAL (12, 2)) AS discount_value
FROM sales
GROUP BY txn_id
)

SELECT
    CAST(ROUND(AVG(discount_value), 2) AS DECIMAL (10, 2)) AS average_discount_value_per_transaction
FROM discounts
```

| average_discount_value_per_transaction |
|---|
| 62.49 |

## 5. What is the average percentage split of all transactions for members vs non-members?

```sql
WITH member_vs_non AS(
SELECT
    COUNT(CASE WHEN member = 1 THEN txn_id END) member_sales,
    COUNT(CASE WHEN member = 0 THEN txn_id END) non_member_sales
FROM sales
)

SELECT
    CAST(ROUND(((member_sales * 100.0) / (member_sales + non_member_sales)), 2) AS DECIMAL (15, 2)) AS member_transactions_percent,
    CAST(ROUND(((non_member_sales * 100.0) / (member_sales + non_member_sales)), 2) AS DECIMAL (15, 2)) AS non_member_transactions_percent
FROM member_vs_non
```

| member_transactions_percent | non_member_transactions_percent |
|---|---|
| 60.03 | 39.97 |

## 6. What is the average revenue for member transactions and non-member transactions (discounts excluded)

```sql
WITH revenues AS(
SELECT
    txn_id,
    SUM(CASE WHEN MEMBER = 1 THEN price * qty END) AS member_revenue,
    SUM(CASE WHEN MEMBER = 0 THEN price * qty END) AS non_member_revenue
FROM sales
GROUP BY txn_id
)

SELECT
    AVG(member_revenue) AS average_member_revenues,
    AVG(non_member_revenue) AS average_non_member_revenues
FROM revenues
```

| average_member_revenues | average_non_member_revenues |
|---|---|
| 516 | 515 |
