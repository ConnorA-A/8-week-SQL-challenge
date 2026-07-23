-- What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where interest_id = 21246 
--  in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.


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
WHERE interest_id != 'NULL' AND interest_id = '21246'

