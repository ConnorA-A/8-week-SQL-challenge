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

-- Which products appear most often in the cart_products list among visits that resulted in a purchase?

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