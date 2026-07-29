# Case Study 7. Balanced Tree Clothing: Product Analysis

[← Back to main README](../../README.md)

## 1. What are the top 3 products by total revenue before discount?

```sql
SELECT TOP 3
    product_name,
    SUM(sales.price * qty) AS revenue_before_discount
FROM product_details
JOIN sales 
    ON product_details.product_id = sales.prod_id
GROUP BY product_name
ORDER BY SUM(sales.price * qty) DESC
```

| product_name | revenue_before_discount |
|---|---|
| Blue Polo Shirt - Mens | 217683 |
| Grey Fashion Jacket - Womens | 209304 |
| White Tee Shirt - Mens | 152000 |

## 2. What is the total quantity, revenue and discount for each segment?

```sql
SELECT
    segment_name,
    SUM(qty) AS total_quantity,
    SUM((sales.price * qty)) AS total_revenue,
    CAST(ROUND(SUM((qty * sales.price * (discount / 100.0))), 2) AS DECIMAL (15, 2)) AS total_discount
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
group by segment_name
```

| segment_name | total_quantity | total_revenue | total_discount |
|---|---|---|---|
| Jacket | 11385 | 366983 | 44277.46 |
| Jeans | 11349 | 208350 | 25343.97 |
| Shirt | 11265 | 406143 | 49594.27 |
| Socks | 11217 | 307977 | 37013.44 |

## 3. What is the top selling product for each segment? (quantity sold)

```sql
WITH ranking AS(
SELECT
    segment_name,
    product_name,
    SUM(qty) AS total_quantity,
    DENSE_RANK () OVER (PARTITION BY segment_name ORDER BY SUM(qty) DESC) AS rnk
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY product_name, segment_name
)

SELECT
    segment_name, 
    product_name, 
    total_quantity, 
    rnk
FROM ranking
WHERE rnk = 1
ORDER BY total_quantity DESC
```

| segment_name | product_name | total_quantity | rnk |
|---|---|---|---|
| Jacket | Grey Fashion Jacket - Womens | 3876 | 1 |
| Jeans | Navy Oversized Jeans - Womens | 3856 | 1 |
| Shirt | Blue Polo Shirt - Mens | 3819 | 1 |
| Socks | Navy Solid Socks - Mens | 3792 | 1 |

## 4. What is the total quantity, revenue and discount for each category?

```sql
SELECT
    category_name,
    SUM(qty) AS total_quantity,
    SUM(sales.price * qty) AS total_revenue,
    CAST(ROUND(SUM(qty * sales.price * (discount / 100.0)), 2) AS DECIMAL (15, 2)) AS total_discount
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY category_name
```

| category_name | total_quantity | total_revenue | total_discount |
|---|---|---|---|
| Mens | 22482 | 714120 | 86607.71 |
| Womens | 22734 | 575333 | 69621.43 |

## 5. What is the top selling product for each category? (in quantity)

```sql
WITH ranking AS (
SELECT
    category_name,
    product_name,
    SUM(qty) AS total_quantity,
    DENSE_RANK () OVER (PARTITION BY category_name ORDER BY SUM(qty) DESC) AS rnk
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY category_name, product_name
)

SELECT
    category_name,
    product_name,
    total_quantity,
    rnk
FROM ranking
WHERE rnk = 1
ORDER BY total_quantity DESC
```

| category_name | product_name | total_quantity | rnk |
|---|---|---|---|
| Womens | Grey Fashion Jacket - Womens | 3876 | 1 |
| Mens | Blue Polo Shirt - Mens | 3819 | 1 |

## 6. What is the percentage split of revenue by product for each segment?

```sql
WITH revenues AS(
SELECT
    segment_name,
    product_name,
    SUM((qty * sales.price)) AS total_revenue
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY segment_name, product_name
)

SELECT
    segment_name,
    product_name,
    CAST(ROUND(((total_revenue * 100.0)/ SUM(total_revenue) OVER (PARTITION BY segment_name)), 2) AS DECIMAL (15, 2)) AS percentage_split_per_segment
FROM revenues
```

| segment_name | product_name | percentage_split_per_segment |
|---|---|---|
| Jacket | Grey Fashion Jacket - Womens | 57.03 |
| Jacket | Indigo Rain Jacket - Womens | 19.45 |
| Jacket | Khaki Suit Jacket - Womens | 23.51 |
| Jeans | Black Straight Jeans - Womens | 58.15 |
| Jeans | Cream Relaxed Jeans - Womens | 17.79 |
| Jeans | Navy Oversized Jeans - Womens | 24.06 |
| Shirt | Blue Polo Shirt - Mens | 53.60 |
| Shirt | Teal Button Up Shirt - Mens | 8.98 |
| Shirt | White Tee Shirt - Mens | 37.43 |
| Socks | Navy Solid Socks - Mens | 44.33 |
| Socks | Pink Fluro Polkadot Socks - Mens | 35.50 |
| Socks | White Striped Socks - Mens | 20.18 |

## 7. What is the percentage split of revenue by segment for each category?

```sql
WITH segregated AS(
SELECT
    category_name,
    segment_name,
    SUM(sales.price * qty) AS revenue
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY category_name, segment_name
)

SELECT
    category_name,
    segment_name,
    CAST(ROUND(((revenue * 100.0) / SUM(revenue) OVER (PARTITION BY category_name)), 2) AS DECIMAL (15, 2)) AS percentage_split_of_revenue
FROM segregated
```

| category_name | segment_name | percentage_split_of_revenue |
|---|---|---|
| Mens | Shirt | 56.87 |
| Mens | Socks | 43.13 |
| Womens | Jacket | 63.79 |
| Womens | Jeans | 36.21 |

## 8. What is the percentage split of total revenue by category?

```sql
WITH revenues AS (
SELECT
    category_name,
    SUM(qty * sales.price) AS revenue
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY category_name
)

SELECT
    category_name,
    CAST(ROUND(((revenue * 100.0)) / SUM(revenue) OVER (), 2) AS DECIMAL (15, 2)) AS percent_split
FROM revenues
```

| category_name | percent_split |
|---|---|
| Mens | 55.38 |
| Womens | 44.62 |

## 9. What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)

```sql
SELECT
    product_name,
    CAST(ROUND(((COUNT(DISTINCT txn_id) * 100.0) / (SELECT COUNT(DISTINCT txn_id) FROM sales)), 2) AS DECIMAL (15, 2)) AS penetration_percent
FROM product_details
JOIN sales
    ON product_details.product_id = sales.prod_id
GROUP BY product_name
ORDER BY CAST(ROUND(((COUNT(DISTINCT txn_id) * 100.0) / (SELECT COUNT(DISTINCT txn_id) FROM sales)), 2) AS DECIMAL (15, 2)) DESC
```

| product_name | penetration_percent |
|---|---|
| Navy Solid Socks - Mens | 51.24 |
| Grey Fashion Jacket - Womens | 51.00 |
| Navy Oversized Jeans - Womens | 50.96 |
| White Tee Shirt - Mens | 50.72 |
| Blue Polo Shirt - Mens | 50.72 |
| Pink Fluro Polkadot Socks - Mens | 50.32 |
| Indigo Rain Jacket - Womens | 50.00 |
| Khaki Suit Jacket - Womens | 49.88 |
| Black Straight Jeans - Womens | 49.84 |
| Cream Relaxed Jeans - Womens | 49.72 |
| White Striped Socks - Mens | 49.72 |
| Teal Button Up Shirt - Mens | 49.68 |
