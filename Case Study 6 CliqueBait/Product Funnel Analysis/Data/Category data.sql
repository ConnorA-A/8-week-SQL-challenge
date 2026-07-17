-- Category required data

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