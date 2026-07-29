# Case Study 8. Fresh Segments: Interest Analysis

[← Back to main README](../../README.md)

## 1. Which interests have been present in all month_year dates in our dataset?

```sql
SELECT
    interest_id,
    COUNT(DISTINCT month_year) AS total_months
FROM interest_metrics
GROUP BY interest_id
HAVING COUNT(DISTINCT month_year) = 14
```

| interest_id | total_months |
|---|---|
| 10008 | 14 |
| 12031 | 14 |
| 5936 | 14 |
| 18619 | 14 |
| 145 | 14 |
| 4943 | 14 |
| 137 | 14 |
| 18783 | 14 |
| 158 | 14 |
| 6267 | 14 |
| 6314 | 14 |
| 6115 | 14 |
| 19631 | 14 |
| 6081 | 14 |
| 5963 | 14 |
| 17318 | 14 |
| 6319 | 14 |
| 6304 | 14 |
| 19338 | 14 |
| 10977 | 14 |

_(showing 20 of 480 rows)_

## 2. Using this same total_months measure - calculate the cumulative percentage of all records starting at 14 months - which total_months value passes the 90% cumulative percentage value?

```sql
WITH cte AS(
SELECT
    interest_id,
    COUNT( DISTINCT month_year) AS total_months
FROM interest_metrics
where interest_id != 'NULL'
GROUP BY interest_id
),

cumulative AS(
SELECT
    total_months,
    COUNT(total_months) AS frequency,
    CAST(ROUND((SUM(COUNT(total_months)) OVER (ORDER BY total_months DESC) * 100.0)/ SUM(COUNT(total_months)) OVER (), 2) AS DECIMAL (15, 2)) AS cumulative_percent
FROM cte
GROUP BY total_months
)

SELECT
    total_months,
    frequency,
    cumulative_percent
FROM cumulative
WHERE cumulative_percent >= 90.0
ORDER BY total_months DESC
```

| total_months | frequency | cumulative_percent |
|---|---|---|
| 6 | 33 | 90.85 |
| 5 | 38 | 94.01 |
| 4 | 32 | 96.67 |
| 3 | 15 | 97.92 |
| 2 | 12 | 98.92 |
| 1 | 13 | 100.00 |

## 3. If we were to remove all interest_id values which are lower than the total_months value we found in the previous question - how many total data points would we be removing?

```sql
WITH deleted_entries AS(
SELECT
    interest_id,
    COUNT( DISTINCT month_year) AS total_months
FROM interest_metrics
WHERE interest_id != 'NULL'
GROUP BY interest_id
HAVING COUNT( DISTINCT month_year) < 6
)

SELECT
    COUNT(interest_id) AS removed_rows
FROM interest_metrics
WHERE interest_id IN (SELECT interest_id FROM deleted_entries)
```

| removed_rows |
|---|
| 400 |

## 4. Does this decision make sense to remove these data points from a business perspective?
Use an example where there are all 14 months present to a removed interest example for your arguments - think about what it means to have less months present from a segment perspective.

```sql
SELECT
    * 
FROM interest_metrics
WHERE (interest_id = 10008) AND (interest_id != 'NULL')
ORDER BY month_year ASC;

SELECT
    * 
FROM interest_metrics
WHERE (interest_id = 133) AND (interest_id != 'NULL')
ORDER BY month_year ASC
```

| _month | _year | month_year | interest_id | composition | index_value | ranking | percentile_ranking |
|---|---|---|---|---|---|---|---|
| 7 | 2018 | 2018-07-01 | 10008 | 9.4600000000000009 | 2.52 | 162 | 77.780000000000001 |
| 8 | 2018 | 2018-08-01 | 10008 | 6.6200000000000001 | 1.8200000000000001 | 72 | 90.609999999999999 |
| 9 | 2018 | 2018-09-01 | 10008 | 5.4500000000000002 | 1.8600000000000001 | 58 | 92.560000000000002 |
| 10 | 2018 | 2018-10-01 | 10008 | 5.9000000000000004 | 2.02 | 62 | 92.769999999999996 |
| 11 | 2018 | 2018-11-01 | 10008 | 5.2400000000000002 | 2.0899999999999999 | 58 | 93.75 |
| 12 | 2018 | 2018-12-01 | 10008 | 5.6500000000000004 | 2.1899999999999999 | 61 | 93.870000000000005 |
| 1 | 2019 | 2019-01-01 | 10008 | 5.25 | 2.1600000000000001 | 40 | 95.890000000000001 |
| 2 | 2019 | 2019-02-01 | 10008 | 6.0999999999999996 | 2.23 | 37 | 96.700000000000003 |
| 3 | 2019 | 2019-03-01 | 10008 | 5.9100000000000001 | 2.2999999999999998 | 31 | 97.269999999999996 |
| 4 | 2019 | 2019-04-01 | 10008 | 4.6600000000000001 | 2.0800000000000001 | 50 | 95.450000000000003 |
| 5 | 2019 | 2019-05-01 | 10008 | 3.8999999999999999 | 2.5699999999999998 | 33 | 96.150000000000006 |
| 6 | 2019 | 2019-06-01 | 10008 | 3.8399999999999999 | 2.8599999999999999 | 32 | 96.120000000000005 |
| 7 | 2019 | 2019-07-01 | 10008 | 4.7699999999999996 | 2.9100000000000001 | 24 | 97.219999999999999 |
| 8 | 2019 | 2019-08-01 | 10008 | 5.1299999999999999 | 2.6400000000000001 | 57 | 95.040000000000006 |

| _month | _year | month_year | interest_id | composition | index_value | ranking | percentile_ranking |
|---|---|---|---|---|---|---|---|
| 7 | 2018 | 2018-07-01 | 133 | 10.91 | 3.4399999999999999 | 46 | 93.689999999999998 |
| 8 | 2018 | 2018-08-01 | 133 | 4.2999999999999998 | 1.45 | 234 | 69.489999999999995 |

## 5. After removing these interests - how many unique interests are there for each month?

```sql
WITH deleted_entries AS(
SELECT
    interest_id,
    COUNT( DISTINCT month_year) AS total_months
FROM interest_metrics
WHERE interest_id != 'NULL'
GROUP BY interest_id
HAVING COUNT( DISTINCT month_year) >= 6
)

SELECT
    month_year,
    COUNT(DISTINCT interest_id) AS unique_interests
FROM interest_metrics
WHERE (interest_id IN (SELECT interest_id FROM deleted_entries)) AND (month_year IS NOT NULL)
GROUP BY month_year
ORDER BY month_year ASC
```

| month_year | unique_interests |
|---|---|
| 2018-07-01 | 709 |
| 2018-08-01 | 752 |
| 2018-09-01 | 774 |
| 2018-10-01 | 853 |
| 2018-11-01 | 925 |
| 2018-12-01 | 986 |
| 2019-01-01 | 966 |
| 2019-02-01 | 1072 |
| 2019-03-01 | 1078 |
| 2019-04-01 | 1035 |
| 2019-05-01 | 827 |
| 2019-06-01 | 804 |
| 2019-07-01 | 836 |
| 2019-08-01 | 1062 |
