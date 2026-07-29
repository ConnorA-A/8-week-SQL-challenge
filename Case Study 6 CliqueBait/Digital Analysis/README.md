# Case Study 6. CliqueBait: Digital Analysis

[← Back to main README](../../README.md)

## 1. How many users are there?

```sql
SELECT
    COUNT (DISTINCT user_id) AS total_users
FROM users
```

| total_users |
|---|
| 500 |

## 2. How many cookies does each user have on average?

```sql
WITH cookies_per_user AS (
SELECT
    user_id,
    COUNT(cookie_id) * 1.0 AS cookies_held
FROM users
GROUP BY user_id
)

SELECT
    CAST(ROUND(AVG(cookies_held), 2) AS DECIMAL (10, 2)) AS average_cookies
FROM cookies_per_user
```

| average_cookies |
|---|
| 3.56 |

## 3. What is the unique number of visits by all users per month?

```sql
SELECT
    MONTH(event_time) AS months,
    COUNT(DISTINCT visit_id) AS unique_visits
FROM events
GROUP BY MONTH(event_time)
ORDER BY MONTH(event_time) ASC
```

| months | unique_visits |
|---|---|
| 1 | 876 |
| 2 | 1488 |
| 3 | 916 |
| 4 | 248 |
| 5 | 36 |

## 4. What is the number of events for each event type?

```sql
SELECT
    event_name,
    events.event_type,
    COUNT(*) AS total_events
FROM events
JOIN event_identifier 
ON events.event_type = event_identifier.event_type
GROUP BY event_name, events.event_type
```

| event_name | event_type | total_events |
|---|---|---|
| Page View | 1 | 20928 |
| Add to Cart | 2 | 8451 |
| Purchase | 3 | 1777 |
| Ad Impression | 4 | 876 |
| Ad Click | 5 | 702 |

## 5. What is the percentage of visits which have a purchase event?

```sql
WITH numbers_required AS(
SELECT
    COUNT(CASE WHEN event_type = 3 THEN visit_id END) AS purchases,
    COUNT(DISTINCT visit_id) AS total_visits
FROM events
)

SELECT
    CAST(ROUND(((purchases * 100.0) / total_visits), 2) AS DECIMAL (15, 2)) AS percent_visits_w_purchase
FROM numbers_required
```

| percent_visits_w_purchase |
|---|
| 49.86 |

## 6. What is the percentage of visits which view the checkout page but do not have a purchase event?

```sql
WITH difference AS(
SELECT
    COUNT(CASE WHEN page_id = 12 THEN visit_id END) AS visited_checkout,
    COUNT(CASE WHEN event_type = 3 THEN visit_id END) AS purchases
FROM events
)

SELECT
    visited_checkout,
    purchases,
    CAST(ROUND(100 - ((purchases * 100.0) / visited_checkout), 2) AS DECIMAL (15, 2)) AS view_checkout_no_purchase_percent
FROM difference
```

| visited_checkout | purchases | view_checkout_no_purchase_percent |
|---|---|---|
| 2103 | 1777 | 15.50 |

## 7. What are the top 3 pages by number of views?

```sql
WITH page_visits AS(
SELECT
    page_name,
    COUNT (*) AS total_page_visits
FROM events    
JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
    GROUP BY page_name
),

page_ranking AS(
SELECT
    page_name,
    total_page_visits,
    DENSE_RANK() over (ORDER BY total_page_visits DESC) AS rnk
FROM page_visits
)

SELECT
    page_name,
    total_page_visits
FROM page_ranking
WHERE rnk <= 3
```

| page_name | total_page_visits |
|---|---|
| All Products | 4752 |
| Lobster | 2515 |
| Crab | 2513 |

## 8. What is the number of views and cart adds for each product category?

```sql
WITH views_and_cart_adds AS(
SELECT
    events.event_type,
    product_category
FROM events
JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
WHERE (event_type = 1 OR event_type = 2) AND product_id IS NOT NULL
)

SELECT
    product_category,
    COUNT(CASE WHEN event_type = 1 THEN event_type END) AS total_page_views,
    COUNT(CASE WHEN event_type = 2 THEN event_type END) AS total_cart_adds
FROM views_and_cart_adds
GROUP BY product_category
ORDER BY total_page_views DESC
```

| product_category | total_page_views | total_cart_adds |
|---|---|---|
| Shellfish | 6204 | 3792 |
| Fish | 4633 | 2789 |
| Luxury | 3032 | 1870 |

## 9. What are the top 3 products by purchases?

```sql
WITH required_data AS (
SELECT
    page_name AS products,
    event_type,
    visit_id
FROM events
JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
WHERE (event_type = 2) OR (event_type = 3)
),

added_to_cart AS(
SELECT
    products,
    COUNT(CASE WHEN event_type = 2 THEN event_type END) AS added_to_cart_frequency
FROM required_data
WHERE visit_id IN (
    SELECT visit_id
    FROM required_data
    WHERE event_type = 3
)
GROUP BY products
),

purchases_frequency AS(
SELECT
    products,
    added_to_cart_frequency,
    DENSE_RANK() OVER (ORDER BY added_to_cart_frequency DESC) AS rnk
FROM added_to_cart
)

SELECT
    products,
    added_to_cart_frequency AS purchases
FROM purchases_frequency
WHERE rnk <= 3
```

| products | purchases |
|---|---|
| Lobster | 754 |
| Oyster | 726 |
| Crab | 719 |
