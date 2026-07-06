
-- Before and After Analysis part 2

WITH before_after AS(
SELECT
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -12, '2020-06-15') AND week_date < '2020-06-15' THEN CAST(sales AS BIGINT) ELSE 0 END) AS before_packaging,
    SUM(CASE WHEN  week_date >= '2020-06-15' AND  week_date < DATEADD(WEEK, 12, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS after_packaging
FROM clean_weekly_sales
)

SELECT  
    before_packaging,
    after_packaging,
    (after_packaging - before_packaging) AS growth_in_sales,
    CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) AS percentage_growth
FROM before_after

-- Sales have fallen by 2.14% in the 12 weeks after the packaging change