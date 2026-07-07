-- What are the top 3 products by purchases?

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