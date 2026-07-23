-- Using this same total_months measure - calculate the cumulative percentage of all records starting at 14 months - which total_months value passes the 90% cumulative percentage value?

WITH cte AS(
SELECT
    interest_id,
    COUNT( DISTINCT month_year) AS total_months
FROM interest_metrics
where interest_id != 'NULL'
GROUP BY interest_id
),

cumulative AS(
SELECT
    total_months,
    COUNT(total_months) AS frequency,
    CAST(ROUND((SUM(COUNT(total_months)) OVER (ORDER BY total_months DESC) * 100.0)/ SUM(COUNT(total_months)) OVER (), 2) AS DECIMAL (15, 2)) AS cumulative_percent
FROM cte
GROUP BY total_months
)

SELECT
    total_months,
    frequency,
    cumulative_percent
FROM cumulative
WHERE cumulative_percent >= 90.0
ORDER BY total_months DESC