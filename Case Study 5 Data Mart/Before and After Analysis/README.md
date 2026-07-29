# Case Study 5. Data Mart: Before and After Analysis

[← Back to main README](../../README.md)

## 1. Before and After Analysis part 1

```sql
WITH before_after AS(
SELECT
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -4, '2020-06-15') AND week_date < '2020-06-15' THEN CAST(sales AS BIGINT) ELSE 0 END) AS before_packaging,
    SUM(CASE WHEN  week_date >= '2020-06-15' AND  week_date < DATEADD(WEEK, 4, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS after_packaging
FROM clean_weekly_sales
)

SELECT  
    before_packaging,
    after_packaging,
    (after_packaging - before_packaging) AS growth_in_sales,
    CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) AS percentage_growth
FROM before_after
```

| before_packaging | after_packaging | growth_in_sales | percentage_growth |
|---|---|---|---|
| 2345878357 | 2318994169 | -26884188 | -1.15 |

## 2. Before and After Analysis part 2

```sql
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
```

| before_packaging | after_packaging | growth_in_sales | percentage_growth |
|---|---|---|---|
| 7126273147 | 6973947753 | -152325394 | -2.14 |

## 3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
4 week period

```sql
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
```

| calendar_year | four_weeks_before | four_weeks_after | sales_difference | sales_percentage_change |
|---|---|---|---|---|
| 2020 | 2345878357 | 2318994169 | -26884188 | -1.15 |
| 2019 | 2249989796 | 2252326390 | 2336594 | .10 |
| 2018 | 2125140809 | 2129242914 | 4102105 | .19 |

## 4. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
12 week period

```sql
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
```

| calendar_year | twelve_weeks_before | twelve_weeks_after | sales_difference | sales_percentage_change |
|---|---|---|---|---|
| 2020 | 7126273147 | 6973947753 | -152325394 | -2.14 |
| 2019 | 6883386397 | 6862646103 | -20740294 | -.30 |
| 2018 | 6396562317 | 6500818510 | 104256193 | 1.63 |
