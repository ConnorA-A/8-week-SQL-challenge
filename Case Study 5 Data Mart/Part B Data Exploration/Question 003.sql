-- How many transactions were there for each year in the dataset?

SELECT
    calendar_year,
    SUM(transactions) AS total_transactions_amount
FROM clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year ASC

-- Sales have been increasing YoY with 2020 holding the greatest total transaction amount