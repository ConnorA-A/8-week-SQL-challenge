# Case Study 6. CliqueBait: Campaigns Analysis Insights

[← Back to main README](../../../README.md)

## 1. % of ad clicks that translated into purchases

```sql
WITH required_data AS(
SELECT
    users.user_id,
    events.visit_id,
    MIN(event_time) AS visit_start_time,
    COUNT(CASE WHEN event_type = 1 THEN 1 END) AS page_views,
    COUNT(CASE WHEN event_type = 2 THEN 1 END) AS cart_adds,
    SUM(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS purchase,
    COUNT(CASE WHEN event_type = 4 THEN 1 END) AS impression,
    COUNT(CASE WHEN event_type = 5 THEN 1 END) AS click,
    STRING_AGG(CASE WHEN page_hierarchy.product_id IS NOT NULL AND events.event_type = 2 THEN page_hierarchy.page_name ELSE NULL END, ', ') 
        WITHIN GROUP (ORDER BY events.sequence_number) AS cart_products
FROM users
JOIN events
    ON users.cookie_id = events.cookie_id
JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
GROUP BY users.user_id, events.visit_id
),

presented_data AS(
SELECT
    user_id,
    visit_id,
    visit_start_time,
    page_views,
    cart_adds,
    purchase,
    campaign_identifier.campaign_name,
    impression,
    click,
    cart_products
FROM required_data
LEFT JOIN campaign_identifier
  ON visit_start_time BETWEEN campaign_identifier.start_date AND campaign_identifier.end_date
)

SELECT
    CAST(ROUND(((SUM(CASE WHEN click > 0 THEN purchase ELSE 0 END) * 100.0) / SUM(click)), 2) AS DECIMAL (15, 2)) AS clicks_to_purchases_percent
FROM presented_data
```

| clicks_to_purchases_percent |
|---|
| 88.89 |

## 2. What is the purchase rate for visits with no ad impression, visits with an impression but no click, and visits with both an impression and a click?

```sql
WITH required_data AS(
SELECT
    users.user_id,
    events.visit_id,
    MIN(event_time) AS visit_start_time,
    COUNT(CASE WHEN event_type = 1 THEN 1 END) AS page_views,
    COUNT(CASE WHEN event_type = 2 THEN 1 END) AS cart_adds,
    SUM(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS purchase,
    COUNT(CASE WHEN event_type = 4 THEN 1 END) AS impression,
    COUNT(CASE WHEN event_type = 5 THEN 1 END) AS click,
    STRING_AGG(CASE WHEN page_hierarchy.product_id IS NOT NULL AND events.event_type = 2 THEN page_hierarchy.page_name ELSE NULL END, ', ') 
        WITHIN GROUP (ORDER BY events.sequence_number) AS cart_products
FROM users
JOIN events
    ON users.cookie_id = events.cookie_id
JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
GROUP BY users.user_id, events.visit_id
),

presented_data AS(
SELECT
    user_id,
    visit_id,
    visit_start_time,
    page_views,
    cart_adds,
    purchase,
    campaign_identifier.campaign_name,
    impression,
    click,
    cart_products
FROM required_data
LEFT JOIN campaign_identifier
  ON visit_start_time BETWEEN campaign_identifier.start_date AND campaign_identifier.end_date
)

SELECT
    CAST(ROUND((SUM(CASE WHEN impression = 0 AND purchase = 1 THEN 1 ELSE 0 END) * 100.0) / SUM(CASE WHEN impression = 0 THEN 1 ELSE 0 END), 2) AS DECIMAL (15, 2)) AS purchase_with_no_impressions_percent,
    CAST(ROUND((SUM(CASE WHEN impression = 1 AND click = 0  AND purchase = 1 THEN 1 ELSE 0 END) * 100.0) / SUM(CASE WHEN impression = 1 AND click = 0 THEN 1 ELSE 0 END), 2) AS DECIMAL (15, 2)) AS purchase_with_impression_no_click,
    CAST(ROUND((SUM(CASE WHEN impression = 1 AND click = 1 AND purchase = 1 THEN 1 ELSE 0 END) * 100.0) / SUM(CASE WHEN impression = 1 AND click = 1 THEN 1 ELSE 0 END), 2) AS DECIMAL (15, 2)) AS purchase_with_impression_and_click
FROM presented_data
```

| purchase_with_no_impressions_percent | purchase_with_impression_no_click | purchase_with_impression_and_click |
|---|---|---|
| 38.69 | 64.94 | 88.89 |

## 3. Of visits that added at least one product to cart, what percentage went on to purchase?

```sql
WITH required_data AS(
SELECT
    users.user_id,
    events.visit_id,
    MIN(event_time) AS visit_start_time,
    COUNT(CASE WHEN event_type = 1 THEN 1 END) AS page_views,
    COUNT(CASE WHEN event_type = 2 THEN 1 END) AS cart_adds,
    SUM(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS purchase,
    COUNT(CASE WHEN event_type = 4 THEN 1 END) AS impression,
    COUNT(CASE WHEN event_type = 5 THEN 1 END) AS click,
    STRING_AGG(CASE WHEN page_hierarchy.product_id IS NOT NULL AND events.event_type = 2 THEN page_hierarchy.page_name ELSE NULL END, ', ') 
        WITHIN GROUP (ORDER BY events.sequence_number) AS cart_products
FROM users
JOIN events
    ON users.cookie_id = events.cookie_id
JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
GROUP BY users.user_id, events.visit_id
),

presented_data AS(
SELECT
    user_id,
    visit_id,
    visit_start_time,
    page_views,
    cart_adds,
    purchase,
    campaign_identifier.campaign_name,
    impression,
    click,
    cart_products
FROM required_data
LEFT JOIN campaign_identifier
  ON visit_start_time BETWEEN campaign_identifier.start_date AND campaign_identifier.end_date
)

SELECT
    CAST(ROUND((SUM(CASE WHEN cart_adds >= 1  AND purchase = 1 THEN 1 ELSE 0 END) * 100.0) / SUM(CASE WHEN cart_adds >= 1 THEN 1 ELSE 0 END), 2) AS DECIMAL (15, 2)) AS cart_to_purchase_percent
FROM presented_data
```

| cart_to_purchase_percent |
|---|
| 70.80 |

## 4. Which products appear most often in the cart_products list among visits that resulted in a purchase?

```sql
WITH required_data AS(
SELECT
    users.user_id,
    events.visit_id,
    MIN(event_time) AS visit_start_time,
    COUNT(CASE WHEN event_type = 1 THEN 1 END) AS page_views,
    COUNT(CASE WHEN event_type = 2 THEN 1 END) AS cart_adds,
    SUM(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS purchase,
    COUNT(CASE WHEN event_type = 4 THEN 1 END) AS impression,
    COUNT(CASE WHEN event_type = 5 THEN 1 END) AS click,
    STRING_AGG(CASE WHEN page_hierarchy.product_id IS NOT NULL AND events.event_type = 2 THEN page_hierarchy.page_name ELSE NULL END, ', ') 
        WITHIN GROUP (ORDER BY events.sequence_number) AS cart_products
FROM users
JOIN events
    ON users.cookie_id = events.cookie_id
JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
GROUP BY users.user_id, events.visit_id
),

presented_data AS(
SELECT
    user_id,
    visit_id,
    visit_start_time,
    page_views,
    cart_adds,
    purchase,
    campaign_identifier.campaign_name,
    impression,
    click,
    cart_products
FROM required_data
LEFT JOIN campaign_identifier
  ON visit_start_time BETWEEN campaign_identifier.start_date AND campaign_identifier.end_date
),

split_products AS(
SELECT
    visit_id,
    purchase,
    TRIM(unlisted_products.value) AS products
FROM presented_data
CROSS APPLY STRING_SPLIT(cart_products, ',') AS unlisted_products
)

SELECT
    products,
    COUNT(CASE WHEN purchase = 1 THEN products END) AS appearance_products_with_purchase
FROM split_products
GROUP BY products
ORDER BY COUNT(CASE WHEN purchase = 1 THEN products END) DESC
```

| products | appearance_products_with_purchase |
|---|---|
| Lobster | 754 |
| Oyster | 726 |
| Crab | 719 |
| Salmon | 711 |
| Kingfish | 707 |
| Black Truffle | 707 |
| Abalone | 699 |
| Tuna | 697 |
| Russian Caviar | 697 |

## 5. Campaign-level comparison: which of the three campaigns has the best purchase rate / most page views / most cart adds, so you can say "Campaign X outperformed Campaign Y"

```sql
WITH required_data AS(
SELECT
    users.user_id,
    events.visit_id,
    MIN(event_time) AS visit_start_time,
    COUNT(CASE WHEN event_type = 1 THEN 1 END) AS page_views,
    COUNT(CASE WHEN event_type = 2 THEN 1 END) AS cart_adds,
    SUM(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS purchase,
    COUNT(CASE WHEN event_type = 4 THEN 1 END) AS impression,
    COUNT(CASE WHEN event_type = 5 THEN 1 END) AS click,
    STRING_AGG(CASE WHEN page_hierarchy.product_id IS NOT NULL AND events.event_type = 2 THEN page_hierarchy.page_name ELSE NULL END, ', ') 
        WITHIN GROUP (ORDER BY events.sequence_number) AS cart_products
FROM users
JOIN events
    ON users.cookie_id = events.cookie_id
JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
GROUP BY users.user_id, events.visit_id
),

presented_data AS(
SELECT
    user_id,
    visit_id,
    visit_start_time,
    page_views,
    cart_adds,
    purchase,
    campaign_identifier.campaign_name,
    impression,
    click,
    cart_products
FROM required_data
LEFT JOIN campaign_identifier
  ON visit_start_time BETWEEN campaign_identifier.start_date AND campaign_identifier.end_date
)

SELECT
    campaign_name,
    CAST(ROUND(((SUM(CASE WHEN purchase = 1 THEN 1 END) * 100.0) / COUNT(purchase)), 2) AS DECIMAL (15, 2)) AS purchase_rate,
    SUM(page_views) AS total_page_views,
    SUM(cart_adds) AS total_cart_adds
FROM presented_data
WHERE campaign_name IS NOT NULL
GROUP BY campaign_name
```

| campaign_name | purchase_rate | total_page_views | total_cart_adds |
|---|---|---|---|
| 25% Off - Living The Lux Life | 50.00 | 2434 | 991 |
| Half Off - Treat Your Shellf(ish) | 49.41 | 13897 | 5592 |
| BOGOF - Fishing For Compliments | 48.85 | 1536 | 625 |
