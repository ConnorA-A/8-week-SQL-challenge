-- Data cleaning
WITH cleaned_table AS(
SELECT
    CONVERT(DATE, week_date, 3) AS week_date,
    DATEPART(WEEK, CONVERT(DATE, week_date, 3)) AS week_number,
    DATEPART(MONTH, CONVERT(DATE, week_date, 3)) AS month_number,
    DATEPART(YEAR, CONVERT(DATE, week_date, 3)) AS calendar_year,
    region,
    platform,
    REPLACE(segment, 'null', 'unknown') AS segment,
    SUBSTRING(segment, 2) AS segment_numbers,
    SUBSTRING(segment, 1, 1) AS demographics,
    customer_type,
    transactions,
    sales,
    CAST(ROUND((sales * 1.0/ transactions), 2) AS DECIMAL(15, 2)) AS avg_transaction
FROM weekly_sales
)


SELECT
    cleaned_table.week_date,
    cleaned_table.week_number,
    cleaned_table.month_number,
    cleaned_table.calendar_year,
    cleaned_table.region,
    cleaned_table.platform,
    cleaned_table.segment,
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
    END AS demographic,
    cleaned_table.customer_type,
    cleaned_table.transactions,
    cleaned_table.sales,
    cleaned_table.avg_transaction
    INTO clean_weekly_sales
FROM cleaned_table