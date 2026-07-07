-- What are the top 3 pages by number of views?

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


