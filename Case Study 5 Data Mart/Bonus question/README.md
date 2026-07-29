# Case Study 5. Data Mart: Bonus Question

[← Back to main README](../../README.md)

## 1. Based on age_band

```sql
WITH before_after AS(
SELECT
    age_band,
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -12, '2020-06-15') AND week_date < '2020-06-15' THEN CAST(sales AS BIGINT) ELSE 0 END) AS before_packaging,
    SUM(CASE WHEN  week_date >= '2020-06-15' AND  week_date < DATEADD(WEEK, 12, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS after_packaging
FROM clean_weekly_sales
GROUP BY age_band
)

SELECT  
    age_band,
    before_packaging,
    after_packaging,
    (after_packaging - before_packaging) AS growth_in_sales,
    CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) AS percentage_growth
FROM before_after
ORDER BY CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) DESC
```

| age_band | before_packaging | after_packaging | growth_in_sales | percentage_growth |
|---|---|---|---|---|
| Young Adults | 801806528 | 794417968 | -7388560 | -.92 |
| Retirees | 2395264515 | 2365714994 | -29549521 | -1.23 |
| Middle Aged | 1164847640 | 1141853348 | -22994292 | -1.97 |
| unknown | 2764354464 | 2671961443 | -92393021 | -3.34 |

## 2. Based on customer_type

```sql
WITH before_after AS(
SELECT
    customer_type,
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -12, '2020-06-15') AND week_date < '2020-06-15' THEN CAST(sales AS BIGINT) ELSE 0 END) AS before_packaging,
    SUM(CASE WHEN  week_date >= '2020-06-15' AND  week_date < DATEADD(WEEK, 12, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS after_packaging
FROM clean_weekly_sales
GROUP BY customer_type
)

SELECT  
    customer_type,
    before_packaging,
    after_packaging,
    (after_packaging - before_packaging) AS growth_in_sales,
    CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) AS percentage_growth
FROM before_after
ORDER BY CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) DESC
```

| customer_type | before_packaging | after_packaging | growth_in_sales | percentage_growth |
|---|---|---|---|---|
| New | 862720419 | 871470664 | 8750245 | 1.01 |
| Existing | 3690116427 | 3606243454 | -83872973 | -2.27 |
| Guest | 2573436301 | 2496233635 | -77202666 | -3.00 |

## 3. Based on demographic

```sql
WITH before_after AS(
SELECT
    demographic,
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -12, '2020-06-15') AND week_date < '2020-06-15' THEN CAST(sales AS BIGINT) ELSE 0 END) AS before_packaging,
    SUM(CASE WHEN  week_date >= '2020-06-15' AND  week_date < DATEADD(WEEK, 12, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS after_packaging
FROM clean_weekly_sales
GROUP BY demographic
)

SELECT  
    demographic,
    before_packaging,
    after_packaging,
    (after_packaging - before_packaging) AS growth_in_sales,
    CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) AS percentage_growth
FROM before_after
ORDER BY CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) DESC
```

| demographic | before_packaging | after_packaging | growth_in_sales | percentage_growth |
|---|---|---|---|---|
| Couples | 2033589643 | 2015977285 | -17612358 | -.87 |
| Families | 2328329040 | 2286009025 | -42320015 | -1.82 |
| unknown | 2764354464 | 2671961443 | -92393021 | -3.34 |

## 4. Based on platform

```sql
WITH before_after AS(
SELECT
    platform,
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -12, '2020-06-15') AND week_date < '2020-06-15' THEN CAST(sales AS BIGINT) ELSE 0 END) AS before_packaging,
    SUM(CASE WHEN  week_date >= '2020-06-15' AND  week_date < DATEADD(WEEK, 12, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS after_packaging
FROM clean_weekly_sales
GROUP BY platform
)

SELECT  
    platform,
    before_packaging,
    after_packaging,
    (after_packaging - before_packaging) AS growth_in_sales,
    CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) AS percentage_growth
FROM before_after
ORDER BY CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) DESC
```

| platform | before_packaging | after_packaging | growth_in_sales | percentage_growth |
|---|---|---|---|---|
| Shopify | 219412034 | 235170474 | 15758440 | 7.18 |
| Retail | 6906861113 | 6738777279 | -168083834 | -2.43 |

## 5. based on region

```sql
WITH before_after AS(
SELECT
    region,
    SUM(CASE WHEN week_date >= DATEADD(WEEK, -12, '2020-06-15') AND week_date < '2020-06-15' THEN CAST(sales AS BIGINT) ELSE 0 END) AS before_packaging,
    SUM(CASE WHEN  week_date >= '2020-06-15' AND  week_date < DATEADD(WEEK, 12, '2020-06-15') THEN CAST(sales AS BIGINT) ELSE 0 END) AS after_packaging
FROM clean_weekly_sales
GROUP BY region
)

SELECT  
    region,
    before_packaging,
    after_packaging,
    (after_packaging - before_packaging) AS growth_in_sales,
    CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) AS percentage_growth
FROM before_after
ORDER BY CAST(ROUND((((after_packaging - before_packaging) * 100.0) / before_packaging), 2) AS DECIMAL (17, 2)) DESC
```

| region | before_packaging | after_packaging | growth_in_sales | percentage_growth |
|---|---|---|---|---|
| EUROPE | 108886567 | 114038959 | 5152392 | 4.73 |
| AFRICA | 1709537105 | 1700390294 | -9146811 | -.54 |
| USA | 677013558 | 666198715 | -10814843 | -1.60 |
| CANADA | 426438454 | 418264441 | -8174013 | -1.92 |
| SOUTH AMERICA | 213036207 | 208452033 | -4584174 | -2.15 |
| OCEANIA | 2354116790 | 2282795690 | -71321100 | -3.03 |
| ASIA | 1637244466 | 1583807621 | -53436845 | -3.26 |
