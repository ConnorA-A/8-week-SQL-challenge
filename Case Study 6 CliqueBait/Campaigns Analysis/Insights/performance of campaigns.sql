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

-- Campaign-level comparison: which of the three campaigns has the best purchase rate / most page views / most cart adds, so you can say "Campaign X outperformed Campaign Y"

SELECT
    campaign_name,
    CAST(ROUND(((SUM(CASE WHEN purchase = 1 THEN 1 END) * 100.0) / COUNT(purchase)), 2) AS DECIMAL (15, 2)) AS purchase_rate,
    SUM(page_views) AS total_page_views,
    SUM(cart_adds) AS total_cart_adds
FROM presented_data
WHERE campaign_name IS NOT NULL
GROUP BY campaign_name