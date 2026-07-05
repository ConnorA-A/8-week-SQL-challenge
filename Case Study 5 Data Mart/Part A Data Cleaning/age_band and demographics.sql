-- age_band and demographics

WITH seperated AS(
SELECT
    REPLACE(segment, 'null', 'unknown') AS segment,
    SUBSTRING(segment, 2) AS segment_numbers,
    SUBSTRING(segment, 1, 1) AS demographics
FROM weekly_sales
)

SELECT
    seperated.segment,
    CASE 
        WHEN segment_numbers = 'ull' THEN 'unknown'
        WHEN segment_numbers = 1 THEN 'Young Adults'
        WHEN segment_numbers = 2 THEN 'Middle Aged'
        WHEN segment_numbers = 3 OR segment_numbers = 4 THEN 'Retirees'
    END AS age_band,
    CASE 
        WHEN demographics = 'n' THEN 'unknown'
        WHEN demographics = 'C' THEN 'Couples'
        WHEN demographics = 'F' THEN 'Families'
    END AS demographic
FROM seperated
