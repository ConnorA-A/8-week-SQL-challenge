# Case Study 6. CliqueBait: Product Funnel Analysis Data

[← Back to main README](../../../README.md)

## 1. Category required data

```sql
WITH required_data AS(
SELECT
    product_category,
    visit_id,
    event_type
FROM page_hierarchy
JOIN events
    ON page_hierarchy.page_id = events.page_id
WHERE event_type != 4 AND event_type != 5
),

cart_add_and_purchase AS(
SELECT
    product_category,
    COUNT(CASE WHEN event_type = 2 THEN event_type END) AS cart_purchase_frequency
FROM required_data
WHERE visit_id IN (
    SELECT visit_id
    FROM required_data
    WHERE event_type = 3
)
GROUP BY product_category
)

SELECT
    cart_add_and_purchase.product_category,
    SUM(CASE WHEN required_data.event_type = 1 THEN 1 ELSE 0 END) AS total_views,
    SUM(CASE WHEN required_data.event_type = 2 THEN 1 ELSE 0 END) AS total_cart_adds,
    (SUM(CASE WHEN required_data.event_type = 2 THEN 1 ELSE 0 END) - cart_add_and_purchase.cart_purchase_frequency) AS abandoned,
    cart_purchase_frequency AS purchased
FROM required_data
JOIN cart_add_and_purchase
    ON required_data.product_category = cart_add_and_purchase.product_category
WHERE required_data.product_category IS NOT NULL
GROUP BY cart_add_and_purchase.product_category, cart_purchase_frequency
ORDER BY product_category ASC
```

| product_category | total_views | total_cart_adds | abandoned | purchased |
|---|---|---|---|---|
| Fish | 4633 | 2789 | 674 | 2115 |
| Luxury | 3032 | 1870 | 466 | 1404 |
| Shellfish | 6204 | 3792 | 894 | 2898 |

## 2. Product required data

```sql
WITH required_data AS(
SELECT
    page_name AS product,
    product_category,
    visit_id,
    event_type
FROM page_hierarchy
JOIN events
    ON page_hierarchy.page_id = events.page_id
WHERE event_type != 4 AND event_type != 5
GROUP BY page_name, visit_id, event_type, product_category
),

cart_add_and_purchase AS(
SELECT
    product,
    COUNT(CASE WHEN event_type = 2 THEN event_type END) AS cart_purchase_frequency
FROM required_data
WHERE visit_id IN (
    SELECT visit_id
    FROM required_data
    WHERE event_type = 3
)
GROUP BY product
)

SELECT
    cart_add_and_purchase.product,
    product_category,
    SUM(CASE WHEN required_data.event_type = 1 THEN 1 ELSE 0 END) AS total_views,
    SUM(CASE WHEN required_data.event_type = 2 THEN 1 ELSE 0 END) AS total_cart_adds,
    (SUM(CASE WHEN required_data.event_type = 2 THEN 1 ELSE 0 END) - cart_add_and_purchase.cart_purchase_frequency) AS abandoned,
    cart_purchase_frequency AS purchased
FROM required_data
JOIN cart_add_and_purchase
    ON required_data.product = cart_add_and_purchase.product
WHERE product_category IS NOT NULL
GROUP BY cart_add_and_purchase.product, product_category, cart_purchase_frequency
ORDER BY product_category ASC
```

| product | product_category | total_views | total_cart_adds | abandoned | purchased |
|---|---|---|---|---|---|
| Salmon | Fish | 1559 | 938 | 227 | 711 |
| Kingfish | Fish | 1559 | 920 | 213 | 707 |
| Tuna | Fish | 1515 | 931 | 234 | 697 |
| Black Truffle | Luxury | 1469 | 924 | 217 | 707 |
| Russian Caviar | Luxury | 1563 | 946 | 249 | 697 |
| Lobster | Shellfish | 1547 | 968 | 214 | 754 |
| Oyster | Shellfish | 1568 | 943 | 217 | 726 |
| Crab | Shellfish | 1564 | 949 | 230 | 719 |
| Abalone | Shellfish | 1525 | 932 | 233 | 699 |
