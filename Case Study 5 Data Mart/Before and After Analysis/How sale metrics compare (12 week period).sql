-- How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?

-- 12 week period

WITH before_after AS (
SELECT
    calendar_year,
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -12, DATEADD(YEAR, -2, '2020-06-15'))  AND week_date < DATEADD(YEAR, -2, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS twelve_week_before_2018,
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -12, DATEADD(YEAR, -1, '2020-06-15'))  AND week_date < DATEADD(YEAR, -1, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS twelve_week_before_2019,
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -12, DATEADD(YEAR, 0, '2020-06-15'))  AND week_date < DATEADD(YEAR, 0, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS twelve_week_before_2020,
    SUM(CASE WHEN week_date >= DATEADD(YEAR, -2, '2020-06-15') AND week_date < DATEADD(WEEK, 12, DATEADD(YEAR, -2, '2020-06-15')) THEN CAST(sales AS BIGINT) ELSE 0 END) AS twelve_weeks_after_2018,
    SUM(CASE WHEN week_date >= DATEADD(YEAR, -1, '2020-06-15') AND week_date < DATEADD(WEEK, 12, DATEADD(YEAR, -1, '2020-06-15')) THEN CAST(sales AS BIGINT) ELSE 0 END) AS twelve_weeks_after_2019,
    SUM(CASE WHEN week_date >= DATEADD(YEAR, 0, '2020-06-15') AND week_date < DATEADD(WEEK, 12, DATEADD(YEAR, 0, '2020-06-15')) THEN CAST(sales AS BIGINT) ELSE 0 END) AS twelve_weeks_after_2020
FROM clean_weekly_sales
GROUP BY calendar_year
),

cleaned_columns AS(
SELECT
    calendar_year,
    (twelve_week_before_2018 + twelve_week_before_2019 + twelve_week_before_2020) AS twelve_weeks_before,
    (twelve_weeks_after_2018 + twelve_weeks_after_2019 + twelve_weeks_after_2020) AS twelve_weeks_after
FROM before_after
)

SELECT
    calendar_year,
    twelve_weeks_before,
    twelve_weeks_after,
    (twelve_weeks_after - twelve_weeks_before) AS sales_difference,
    CAST(ROUND((((twelve_weeks_after - twelve_weeks_before) * 100.0) / twelve_weeks_before), 2) AS DECIMAL (20, 2)) AS sales_percentage_change
FROM cleaned_columns
ORDER BY calendar_year DESC

-- Similar to the 4 week period, 2020 faces a sales decline, but 2019 also does this time round
