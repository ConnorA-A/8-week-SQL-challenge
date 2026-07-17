-- Which product was most likely to be abandoned?

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
),

combined_data AS(
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
)

SELECT TOP 1
    combined_data.product,
    CAST(ROUND(((abandoned * 100.0) / total_cart_adds), 2) AS DECIMAL (15, 2)) AS cart_adds_abandoned_percent
FROM combined_data
ORDER BY CAST(ROUND(((abandoned * 100.0) / total_cart_adds), 2) AS DECIMAL (15, 2)) DESC