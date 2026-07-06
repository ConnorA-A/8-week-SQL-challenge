-- How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?

-- 4 week period

WITH before_after AS (
SELECT
    calendar_year,
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -4, DATEADD(YEAR, -2, '2020-06-15'))  AND week_date < DATEADD(YEAR, -2, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS four_week_before_2018,
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -4, DATEADD(YEAR, -1, '2020-06-15'))  AND week_date < DATEADD(YEAR, -1, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS four_week_before_2019,
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -4, DATEADD(YEAR, 0, '2020-06-15'))  AND week_date < DATEADD(YEAR, 0, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS four_week_before_2020,
    SUM(CASE WHEN week_date >= DATEADD(YEAR, -2, '2020-06-15') AND week_date < DATEADD(WEEK, 4, DATEADD(YEAR, -2, '2020-06-15')) THEN CAST(sales AS BIGINT) ELSE 0 END) AS four_weeks_after_2018,
    SUM(CASE WHEN week_date >= DATEADD(YEAR, -1, '2020-06-15') AND week_date < DATEADD(WEEK, 4, DATEADD(YEAR, -1, '2020-06-15')) THEN CAST(sales AS BIGINT) ELSE 0 END) AS four_weeks_after_2019,
    SUM(CASE WHEN week_date >= DATEADD(YEAR, 0, '2020-06-15') AND week_date < DATEADD(WEEK, 4, DATEADD(YEAR, 0, '2020-06-15')) THEN CAST(sales AS BIGINT) ELSE 0 END) AS four_weeks_after_2020
FROM clean_weekly_sales
GROUP BY calendar_year
),

cleaned_columns AS(
SELECT
    calendar_year,
    (four_week_before_2018 + four_week_before_2019 + four_week_before_2020) AS four_weeks_before,
    (four_weeks_after_2018 + four_weeks_after_2019 + four_weeks_after_2020) AS four_weeks_after
FROM before_after
)

SELECT
    calendar_year,
    four_weeks_before,
    four_weeks_after,
    (four_weeks_after - four_weeks_before) AS sales_difference,
    CAST(ROUND((((four_weeks_after - four_weeks_before) * 100.0) / four_weeks_before), 2) AS DECIMAL (20, 2)) AS sales_percentage_change
FROM cleaned_columns
ORDER BY calendar_year DESC

-- 2020 represents the largest sales drop between the 4 week periods.
-- However, sales have been declining from 2018-2019