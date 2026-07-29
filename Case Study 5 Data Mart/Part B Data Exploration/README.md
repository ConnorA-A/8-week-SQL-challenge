# Case Study 5. Data Mart: Part B Data Exploration

[← Back to main README](../../README.md)

## 1. What day of the week is used for each week_date?

```sql
SELECT
    DISTINCT DATENAME(WEEKDAY, week_date) as day_week_date
FROM clean_weekly_sales
```

| day_week_date |
|---|
| Monday |

## 2. What range of week numbers are missing from the dataset

```sql
SELECT
    DISTINCT(week_number) AS week_numbers_used
FROM clean_weekly_sales
WHERE week_number BETWEEN 1 AND 53
ORDER BY week_number ASC
```

| week_numbers_used |
|---|
| 13 |
| 14 |
| 15 |
| 16 |
| 17 |
| 18 |
| 19 |
| 20 |
| 21 |
| 22 |
| 23 |
| 24 |
| 25 |
| 26 |
| 27 |
| 28 |
| 29 |
| 30 |
| 31 |
| 32 |

_(showing 20 of 24 rows)_

## 3. How many transactions were there for each year in the dataset?

```sql
SELECT
    calendar_year,
    SUM(transactions) AS total_transactions_amount
FROM clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year ASC
```

| calendar_year | total_transactions_amount |
|---|---|
| 2018 | 346406460 |
| 2019 | 365639285 |
| 2020 | 375813651 |

## 4. What is the total sales for each region for each month?

```sql
SELECT
    month_number,
    region,
    SUM(CAST(sales AS BIGINT)) AS total_regional_sales
FROM clean_weekly_sales
GROUP BY month_number, region
ORDER BY month_number, region ASC
```

| month_number | region | total_regional_sales |
|---|---|---|
| 3 | AFRICA | 567767480 |
| 3 | ASIA | 529770793 |
| 3 | CANADA | 144634329 |
| 3 | EUROPE | 35337093 |
| 3 | OCEANIA | 783282888 |
| 3 | SOUTH AMERICA | 71023109 |
| 3 | USA | 225353043 |
| 4 | AFRICA | 1911783504 |
| 4 | ASIA | 1804628707 |
| 4 | CANADA | 484552594 |
| 4 | EUROPE | 127334255 |
| 4 | OCEANIA | 2599767620 |
| 4 | SOUTH AMERICA | 238451531 |
| 4 | USA | 759786323 |
| 5 | AFRICA | 1647244738 |
| 5 | ASIA | 1526285399 |
| 5 | CANADA | 412378365 |
| 5 | EUROPE | 109338389 |
| 5 | OCEANIA | 2215657304 |
| 5 | SOUTH AMERICA | 201391809 |

_(showing 20 of 49 rows)_

## 5. What is the total count (value) of transactions for each platform

```sql
SELECT
    platform,
    SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY platform
ORDER BY platform ASC
```

| platform | total_transactions |
|---|---|
| Retail | 1081934227 |
| Shopify | 5925169 |

## 6. What is the percentage of sales for Retail vs Shopify for each month?

```sql
WITH platform_monthly_sales AS (
SELECT
    month_number,
    SUM(CASE WHEN platform = 'Shopify' THEN CAST(sales AS BIGINT) ELSE 0 END) AS total_shopify_sales,
    SUM(CASE WHEN platform = 'Retail' THEN CAST(sales AS BIGINT) ELSE 0 END) AS total_retail_sales
FROM clean_weekly_sales
GROUP BY month_number
)

SELECT
    platform_monthly_sales.month_number,
    CAST(ROUND((total_shopify_sales * 100.0 / (total_shopify_sales + total_retail_sales)), 2) AS DECIMAL (15, 2)) AS shopify_sales_percentage,
    CAST(ROUND((total_retail_sales *100.0 / (total_shopify_sales + total_retail_sales)), 2) AS DECIMAL (15, 2)) AS retail_sales_percentage
FROM platform_monthly_sales
ORDER BY month_number ASC
```

| month_number | shopify_sales_percentage | retail_sales_percentage |
|---|---|---|
| 3 | 2.46 | 97.54 |
| 4 | 2.41 | 97.59 |
| 5 | 2.70 | 97.30 |
| 6 | 2.73 | 97.27 |
| 7 | 2.71 | 97.29 |
| 8 | 2.92 | 97.08 |
| 9 | 2.62 | 97.38 |

## 7. What is the percentage of sales by demographic for each year in the dataset?

```sql
WITH demographic_sales AS(
SELECT
    calendar_year,
    SUM(CASE WHEN demographic = 'Couples' THEN CAST(sales AS BIGINT) ELSE 0 END) AS couples_sales,
    SUM(CASE WHEN demographic = 'Families' THEN CAST(sales AS BIGINT) ELSE 0 END) AS families_sales,
    SUM(CASE WHEN demographic = 'unknown' THEN CAST(sales AS BIGINT) ELSE 0 END) AS unknown_sales
FROM clean_weekly_sales
GROUP BY calendar_year
)

SELECT
    demographic_sales.calendar_year,
    CAST(ROUND(couples_sales * 100.0 / (couples_sales + families_sales + unknown_sales), 2) AS DECIMAL (15, 2)) AS couples_percentage,
    CAST(ROUND(families_sales * 100.0 / (couples_sales + families_sales + unknown_sales), 2) AS DECIMAL (15, 2)) AS families_percentage,
    CAST(ROUND(unknown_sales * 100.0 / (couples_sales + families_sales + unknown_sales), 2) AS DECIMAL (15, 2)) AS unknown_percentage
FROM demographic_sales
ORDER BY calendar_year ASC
```

| calendar_year | couples_percentage | families_percentage | unknown_percentage |
|---|---|---|---|
| 2018 | 26.38 | 31.99 | 41.63 |
| 2019 | 27.28 | 32.47 | 40.25 |
| 2020 | 28.72 | 32.73 | 38.55 |

## 8. Which age_band and demographic values contribute the most to Retail sales?

```sql
SELECT
    age_band,
    demographic,
    SUM(CAST(sales AS BIGINT)) AS total_sales
FROM clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY SUM(CAST(sales AS BIGINT)) DESC
```

| age_band | demographic | total_sales |
|---|---|---|
| unknown | unknown | 16067285533 |
| Retirees | Families | 6634686916 |
| Retirees | Couples | 6370580014 |
| Middle Aged | Families | 4354091554 |
| Young Adults | Couples | 2602922797 |
| Middle Aged | Couples | 1854160330 |
| Young Adults | Families | 1770889293 |

## 9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?

```sql
SELECT
    calendar_year,
    platform,
    CAST(ROUND(SUM(CAST(sales AS DECIMAL (12, 2))) / SUM(transactions), 2) AS DECIMAL (12, 2)) AS average_transaction_size,
    CAST(ROUND(AVG(avg_transaction), 2) AS DECIMAL (12, 2)) AS incorrect_average
FROM clean_weekly_sales
GROUP BY calendar_year, platform
ORDER BY calendar_year, platform ASC
```

| calendar_year | platform | average_transaction_size | incorrect_average |
|---|---|---|---|
| 2018 | Retail | 36.56 | 42.91 |
| 2018 | Shopify | 192.48 | 188.28 |
| 2019 | Retail | 36.83 | 41.97 |
| 2019 | Shopify | 183.36 | 177.56 |
| 2020 | Retail | 36.56 | 40.64 |
| 2020 | Shopify | 179.03 | 174.87 |
