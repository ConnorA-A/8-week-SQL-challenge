-- What is the unique number of visits by all users per month?

SELECT
    MONTH(event_time) AS months,
    COUNT(DISTINCT visit_id) AS unique_visits
FROM events
GROUP BY MONTH(event_time)
ORDER BY MONTH(event_time) ASC