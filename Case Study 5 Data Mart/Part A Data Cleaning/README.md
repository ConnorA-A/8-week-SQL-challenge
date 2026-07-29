# Case Study 5. Data Mart: Part A Data Cleaning

[← Back to main README](../../README.md)

## 1. week month year testing

```sql
SELECT 
    week_date,
    CONVERT(DATE, week_date, 3) AS week_date_converted,
    DATEPART(WEEK, CONVERT(DATE, week_date, 3)) AS week_number,
    DATEPART(MONTH, CONVERT(DATE, week_date, 3)) AS month_number,
    DATEPART(YEAR, CONVERT(DATE, week_date, 3)) AS calander_year
FROM weekly_sales
```

| week_date | week_date_converted | week_number | month_number | calander_year |
|---|---|---|---|---|
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |
| 31/8/20 | 2020-08-31 | 36 | 8 | 2020 |

_(showing 20 of 17117 rows)_

## 2. average test

```sql
SELECT
    sales,
    transactions,
    CAST(ROUND((sales * 1.0/ transactions), 2) AS DECIMAL(15, 2)) AS avg_transaction
FROM weekly_sales
```

| sales | transactions | avg_transaction |
|---|---|---|
| 3656163 | 120631 | 30.31 |
| 996575 | 31574 | 31.56 |
| 16509610 | 529151 | 31.20 |
| 141942 | 4517 | 31.42 |
| 1758388 | 58046 | 30.29 |
| 243878 | 1336 | 182.54 |
| 519502 | 2514 | 206.64 |
| 371417 | 2158 | 172.11 |
| 49557 | 318 | 155.84 |
| 3888162 | 111032 | 35.02 |
| 260773 | 1398 | 186.53 |
| 882690 | 4661 | 189.38 |
| 38762 | 1029 | 37.67 |
| 917 | 6 | 152.83 |
| 35215 | 115 | 306.22 |
| 30371770 | 551905 | 55.03 |
| 374327 | 1969 | 190.11 |
| 5185233 | 97604 | 53.13 |
| 2980673 | 111219 | 26.80 |
| 463738 | 11820 | 39.23 |

_(showing 20 of 17117 rows)_

## 3. age_band and demographics

```sql
WITH seperated AS(
SELECT
    REPLACE(segment, 'null', 'unknown') AS segment,
    SUBSTRING(segment, 2) AS segment_numbers,
    SUBSTRING(segment, 1, 1) AS demographics
FROM weekly_sales
)

SELECT
    seperated.segment,
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
    END AS demographic
FROM seperated
```

| segment | age_band | demographic |
|---|---|---|
| C3 | Retirees | Couples |
| F1 | Young Adults | Families |
| unknown | unknown | unknown |
| C1 | Young Adults | Couples |
| C2 | Middle Aged | Couples |
| F2 | Middle Aged | Families |
| F3 | Retirees | Families |
| F1 | Young Adults | Families |
| F2 | Middle Aged | Families |
| C3 | Retirees | Couples |
| F1 | Young Adults | Families |
| C2 | Middle Aged | Couples |
| C2 | Middle Aged | Couples |
| C4 | Retirees | Couples |
| F3 | Retirees | Families |
| F3 | Retirees | Families |
| C3 | Retirees | Couples |
| F1 | Young Adults | Families |
| C2 | Middle Aged | Couples |
| F1 | Young Adults | Families |

_(showing 20 of 17117 rows)_

## 4. Data cleaning

```sql
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
```

| week_date | week_number | month_number | calendar_year | region | platform | segment | age_band | demographic | customer_type | transactions | sales | avg_transaction |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2020-08-31 | 36 | 8 | 2020 | ASIA | Retail | C3 | Retirees | Couples | New | 120631 | 3656163 | 30.31 |
| 2020-08-31 | 36 | 8 | 2020 | ASIA | Retail | F1 | Young Adults | Families | New | 31574 | 996575 | 31.56 |
| 2020-08-31 | 36 | 8 | 2020 | USA | Retail | unknown | unknown | unknown | Guest | 529151 | 16509610 | 31.20 |
| 2020-08-31 | 36 | 8 | 2020 | EUROPE | Retail | C1 | Young Adults | Couples | New | 4517 | 141942 | 31.42 |
| 2020-08-31 | 36 | 8 | 2020 | AFRICA | Retail | C2 | Middle Aged | Couples | New | 58046 | 1758388 | 30.29 |
| 2020-08-31 | 36 | 8 | 2020 | CANADA | Shopify | F2 | Middle Aged | Families | Existing | 1336 | 243878 | 182.54 |
| 2020-08-31 | 36 | 8 | 2020 | AFRICA | Shopify | F3 | Retirees | Families | Existing | 2514 | 519502 | 206.64 |
| 2020-08-31 | 36 | 8 | 2020 | ASIA | Shopify | F1 | Young Adults | Families | Existing | 2158 | 371417 | 172.11 |
| 2020-08-31 | 36 | 8 | 2020 | AFRICA | Shopify | F2 | Middle Aged | Families | New | 318 | 49557 | 155.84 |
| 2020-08-31 | 36 | 8 | 2020 | AFRICA | Retail | C3 | Retirees | Couples | New | 111032 | 3888162 | 35.02 |
| 2020-08-31 | 36 | 8 | 2020 | USA | Shopify | F1 | Young Adults | Families | Existing | 1398 | 260773 | 186.53 |
| 2020-08-31 | 36 | 8 | 2020 | OCEANIA | Shopify | C2 | Middle Aged | Couples | Existing | 4661 | 882690 | 189.38 |
| 2020-08-31 | 36 | 8 | 2020 | SOUTH AMERICA | Retail | C2 | Middle Aged | Couples | Existing | 1029 | 38762 | 37.67 |
| 2020-08-31 | 36 | 8 | 2020 | SOUTH AMERICA | Shopify | C4 | Retirees | Couples | New | 6 | 917 | 152.83 |
| 2020-08-31 | 36 | 8 | 2020 | EUROPE | Shopify | F3 | Retirees | Families | Existing | 115 | 35215 | 306.22 |
| 2020-08-31 | 36 | 8 | 2020 | OCEANIA | Retail | F3 | Retirees | Families | Existing | 551905 | 30371770 | 55.03 |
| 2020-08-31 | 36 | 8 | 2020 | ASIA | Shopify | C3 | Retirees | Couples | Existing | 1969 | 374327 | 190.11 |
| 2020-08-31 | 36 | 8 | 2020 | AFRICA | Retail | F1 | Young Adults | Families | Existing | 97604 | 5185233 | 53.13 |
| 2020-08-31 | 36 | 8 | 2020 | OCEANIA | Retail | C2 | Middle Aged | Couples | New | 111219 | 2980673 | 26.80 |
| 2020-08-31 | 36 | 8 | 2020 | USA | Retail | F1 | Young Adults | Families | New | 11820 | 463738 | 39.23 |

_(showing 20 of 17117 rows)_
