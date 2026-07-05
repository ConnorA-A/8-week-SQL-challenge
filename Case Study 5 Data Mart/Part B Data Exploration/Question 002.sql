-- What range of week numbers are missing from the dataset

SELECT
    DISTINCT(week_number) AS week_numbers_used
FROM clean_weekly_sales
WHERE week_number BETWEEN 1 AND 53
ORDER BY week_number ASC

-- The range of week numbers missing is 1 - 12 AND 37 - 52
-- The range 13 - 36 is contained in the data