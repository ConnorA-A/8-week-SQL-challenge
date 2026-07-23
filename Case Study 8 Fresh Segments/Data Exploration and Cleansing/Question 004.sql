-- How many interest_id values exist in the interest_metrics table but not in the interest_map table? What about the other way around?

SELECT
    COUNT (DISTINCT interest_id) AS metrics_ids_not_in_map
FROM interest_metrics
WHERE interest_id != 'NULL'
AND NOT EXISTS (SELECT id FROM interest_map WHERE interest_map.id = CAST(interest_metrics.interest_id AS INT))
;

SELECT
    COUNT(DISTINCT id) AS map_ids_not_in_metrics
FROM interest_map
WHERE NOT EXISTS (SELECT interest_id FROM interest_metrics WHERE CAST(interest_metrics.interest_id AS INT) = interest_map.id 
AND interest_metrics.interest_id != 'NULL')