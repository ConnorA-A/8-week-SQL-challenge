-- What is the number of views and cart adds for each product category?

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
