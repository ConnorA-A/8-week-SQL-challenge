# Case Study 7. Balanced Tree Clothing: High Level Sales Analysis

[← Back to main README](../../README.md)

## 1. What was the total quantity sold for all products?

```sql
SELECT
    SUM(qty) AS total_quantity_sold
FROM sales
```

| total_quantity_sold |
|---|
| 45216 |

## 2. What is the total generated revenue for all products before discounts?

```sql
SELECT
    SUM(qty * price) AS total_revenue
FROM sales
```

| total_revenue |
|---|
| 1289453 |

## 3. What was the total discount amount for all products?

```sql
SELECT
    CAST(ROUND(SUM((qty * price * (discount / 100.0))), 2) AS DECIMAL (12, 2)) AS total_discount_amount
FROM sales
```

| total_discount_amount |
|---|
| 156229.14 |
