-- Which interests have been present in all month_year dates in our dataset?

SELECT
    interest_id,
    COUNT(DISTINCT month_year) AS total_months
FROM interest_metrics
GROUP BY interest_id
HAVING COUNT(DISTINCT month_year) = 14