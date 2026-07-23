-- What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?

SELECT
    month_year,
    COUNT(*) AS count_of_records
FROM interest_metrics
GROUP BY month_year
ORDER BY month_year ASC