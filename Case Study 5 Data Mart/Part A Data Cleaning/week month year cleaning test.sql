-- week month year testing


SELECT 
    week_date,
    CONVERT(DATE, week_date, 3) AS week_date_converted,
    DATEPART(WEEK, CONVERT(DATE, week_date, 3)) AS week_number,
    DATEPART(MONTH, CONVERT(DATE, week_date, 3)) AS month_number,
    DATEPART(YEAR, CONVERT(DATE, week_date, 3)) AS calander_year
FROM weekly_sales


