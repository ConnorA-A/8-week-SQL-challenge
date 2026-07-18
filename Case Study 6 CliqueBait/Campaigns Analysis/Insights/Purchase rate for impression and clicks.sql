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

-- What is the purchase rate for visits with no ad impression, visits with an impression but no click, and visits with both an impression and a click?

SELECT
    CAST(ROUND((SUM(CASE WHEN impression = 0 AND purchase = 1 THEN 1 ELSE 0 END) * 100.0) / SUM(CASE WHEN impression = 0 THEN 1 ELSE 0 END), 2) AS DECIMAL (15, 2)) AS purchase_with_no_impressions_percent,
    CAST(ROUND((SUM(CASE WHEN impression = 1 AND click = 0  AND purchase = 1 THEN 1 ELSE 0 END) * 100.0) / SUM(CASE WHEN impression = 1 AND click = 0 THEN 1 ELSE 0 END), 2) AS DECIMAL (15, 2)) AS purchase_with_impression_no_click,
    CAST(ROUND((SUM(CASE WHEN impression = 1 AND click = 1 AND purchase = 1 THEN 1 ELSE 0 END) * 100.0) / SUM(CASE WHEN impression = 1 AND click = 1 THEN 1 ELSE 0 END), 2) AS DECIMAL (15, 2)) AS purchase_with_impression_and_click
FROM presented_data