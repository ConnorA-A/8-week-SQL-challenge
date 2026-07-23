-- Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? Do you think these values are valid and why?

SELECT
    _month,
    _year,
    month_year,
    interest_id,
    composition,
    index_value, 
    ranking, 
    percentile_ranking,
    interest_name,
    interest_summary,
    created_at,
    last_modified
FROM interest_metrics
LEFT JOIN interest_map
    ON interest_metrics.interest_id = interest_map.id
WHERE interest_id != 'NULL' AND month_year < created_at