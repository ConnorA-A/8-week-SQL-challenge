-- Which product has the most views, cart adds and purchases?

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
),

rnk AS (
SELECT
    combined_data.product,
    DENSE_RANK() OVER (ORDER BY total_views DESC) AS rnk_views,
    DENSE_RANK() OVER (ORDER BY total_cart_adds DESC) AS rnk_cart_adds,
    DENSE_RANK() OVER (ORDER BY purchased DESC) AS rnk_purchases
FROM combined_data
)

SELECT
    combined_data.product AS products,
    CASE WHEN rnk_views = 1 THEN total_views END AS most_viewed,
    CASE WHEN rnk_cart_adds = 1 THEN total_cart_adds END AS most_cart_adds,
    CASE WHEN rnk_purchases = 1 THEN purchased END AS most_purchases
FROM combined_data
JOIN rnk
    ON combined_data.product = rnk.product
WHERE (CASE WHEN rnk_views = 1 THEN total_views END IS NOT NULL) OR 
        (CASE WHEN rnk_cart_adds = 1 THEN total_cart_adds END IS NOT NULL) OR
         (CASE WHEN rnk_purchases = 1 THEN purchased END IS NOT NULL)




