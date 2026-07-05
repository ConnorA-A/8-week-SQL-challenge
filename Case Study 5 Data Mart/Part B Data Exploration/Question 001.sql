-- What day of the week is used for each week_date?

SELECT
    DISTINCT DATENAME(WEEKDAY, week_date) as day_week_date
FROM clean_weekly_sales

-- The day of the week used for week_date is Monday
