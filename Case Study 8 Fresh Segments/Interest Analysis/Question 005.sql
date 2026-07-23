-- After removing these interests - how many unique interests are there for each month?


WITH deleted_entries AS(
SELECT
    interest_id,
    COUNT( DISTINCT month_year) AS total_months
FROM interest_metrics
WHERE interest_id != 'NULL'
GROUP BY interest_id
HAVING COUNT( DISTINCT month_year) >= 6
)

SELECT
    month_year,
    COUNT(DISTINCT interest_id) AS unique_interests
FROM interest_metrics
WHERE (interest_id IN (SELECT interest_id FROM deleted_entries)) AND (month_year IS NOT NULL)
GROUP BY month_year
ORDER BY month_year ASC