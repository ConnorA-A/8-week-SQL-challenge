-- Which age_band and demographic values contribute the most to Retail sales?

SELECT
    age_band,
    demographic,
    SUM(CAST(sales AS BIGINT)) AS total_sales
FROM clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY SUM(CAST(sales AS BIGINT)) DESC

-- data mart can't determine the largest contributor of sales as unknown demographic and unknown age_band hold the highest sales amount