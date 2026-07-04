-- Data cleaning steps

-- convert the week_date to a DATE format

SELECT 
    week_date,
    CONVERT(DATE, week_date, 3) AS week_date_converted,
    DATEPART(WEEK, CONVERT(DATE, week_date, 3)) AS week_number,
    DATEPART(MONTH, CONVERT(DATE, week_date, 3)) AS month_number
FROM weekly_sales


