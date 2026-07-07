-- What is the percentage of visits which view the checkout page but do not have a purchase event?

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