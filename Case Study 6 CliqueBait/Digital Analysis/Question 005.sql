-- What is the percentage of visits which have a purchase event?

WITH numbers_required AS(
SELECT
    COUNT(CASE WHEN event_type = 3 THEN visit_id END) AS purchases,
    COUNT(DISTINCT visit_id) AS total_visits
FROM events
)

SELECT
    CAST(ROUND(((purchases * 100.0) / total_visits), 2) AS DECIMAL (15, 2)) AS percent_visits_w_purchase
FROM numbers_required
