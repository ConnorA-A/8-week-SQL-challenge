-- Summarise the id values in the fresh_segments.interest_map by its total record count in this table.

SELECT
    id,
    COUNT(id) AS occurrences
FROM interest_map
GROUP BY id
