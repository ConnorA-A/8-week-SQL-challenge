-- If we were to remove all interest_id values which are lower than the total_months value we found in the previous question - how many total data points would we be removing?


WITH deleted_entries AS(
SELECT
    interest_id,
    COUNT( DISTINCT month_year) AS total_months
FROM interest_metrics
WHERE interest_id != 'NULL'
GROUP BY interest_id
HAVING COUNT( DISTINCT month_year) < 6
)

SELECT
    COUNT(interest_id) AS removed_rows
FROM interest_metrics
WHERE interest_id IN (SELECT interest_id FROM deleted_entries)