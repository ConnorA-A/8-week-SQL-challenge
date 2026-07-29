# Case Study 8. Fresh Segments: Data Exploration and Cleansing

[← Back to main README](../../README.md)

## 1. Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month

```sql
ALTER TABLE interest_metrics
ALTER COLUMN month_year VARCHAR(10);

UPDATE interest_metrics
SET month_year = CASE WHEN month_year = 'NULL' THEN NULL
ELSE CONVERT(VARCHAR, CONVERT(DATE, '01' + '-' + month_year, 103), 23)
END;

ALTER TABLE interest_metrics 
ALTER COLUMN month_year DATE
```

| month_year |
|---|
| NULL |
| 2018-07-01 |
| 2018-08-01 |
| 2018-09-01 |
| 2018-10-01 |
| 2018-11-01 |
| 2018-12-01 |
| 2019-01-01 |
| 2019-02-01 |
| 2019-03-01 |
| 2019-04-01 |
| 2019-05-01 |
| 2019-06-01 |
| 2019-07-01 |
| 2019-08-01 |

## 2. What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?

```sql
SELECT
    month_year,
    COUNT(*) AS count_of_records
FROM interest_metrics
GROUP BY month_year
ORDER BY month_year ASC
```

| month_year | count_of_records |
|---|---|
| NULL | 1194 |
| 2018-07-01 | 729 |
| 2018-08-01 | 767 |
| 2018-09-01 | 780 |
| 2018-10-01 | 857 |
| 2018-11-01 | 928 |
| 2018-12-01 | 995 |
| 2019-01-01 | 973 |
| 2019-02-01 | 1121 |
| 2019-03-01 | 1136 |
| 2019-04-01 | 1099 |
| 2019-05-01 | 857 |
| 2019-06-01 | 824 |
| 2019-07-01 | 864 |
| 2019-08-01 | 1149 |

## 3. What do you think we should do with these null values in the fresh_segments.interest_metrics

Keep them in the table as its still a large chunk of data. They can be excluded when necessary with a WHERE OR CASE statement.

## 4. How many interest_id values exist in the interest_metrics table but not in the interest_map table? What about the other way around?

```sql
SELECT
    COUNT (DISTINCT interest_id) AS metrics_ids_not_in_map
FROM interest_metrics
WHERE interest_id != 'NULL'
AND NOT EXISTS (SELECT id FROM interest_map WHERE interest_map.id = CAST(interest_metrics.interest_id AS INT))
;

SELECT
    COUNT(DISTINCT id) AS map_ids_not_in_metrics
FROM interest_map
WHERE NOT EXISTS (SELECT interest_id FROM interest_metrics WHERE CAST(interest_metrics.interest_id AS INT) = interest_map.id 
AND interest_metrics.interest_id != 'NULL')
```

| metrics_ids_not_in_map |
|---|
| 0 |

| map_ids_not_in_metrics |
|---|
| 7 |

## 5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table.

```sql
SELECT
    id,
    COUNT(id) AS occurrences
FROM interest_map
GROUP BY id
```

| id | occurrences |
|---|---|
| 1 | 1 |
| 2 | 1 |
| 3 | 1 |
| 4 | 1 |
| 5 | 1 |
| 6 | 1 |
| 7 | 1 |
| 8 | 1 |
| 12 | 1 |
| 13 | 1 |
| 14 | 1 |
| 15 | 1 |
| 16 | 1 |
| 17 | 1 |
| 18 | 1 |
| 19 | 1 |
| 20 | 1 |
| 21 | 1 |
| 22 | 1 |
| 23 | 1 |

_(showing 20 of 1209 rows)_

## 6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where interest_id = 21246
in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.

```sql
SELECT
    _month,
    _year,
    month_year,
    interest_id,
    composition,
    index_value, 
    ranking, 
    percentile_ranking,
    interest_name,
    interest_summary,
    created_at,
    last_modified
FROM interest_metrics
LEFT JOIN interest_map
    ON interest_metrics.interest_id = interest_map.id
WHERE interest_id != 'NULL' AND interest_id = '21246'
```

| _month | _year | month_year | interest_id | composition | index_value | ranking | percentile_ranking | interest_name | interest_summary | created_at | last_modified |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 7 | 2018 | 2018-07-01 | 21246 | 2.2599999999999998 | 0.65000000000000002 | 722 | 0.95999999999999996 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04.000 | 2018-06-11 17:50:04.000 |
| 8 | 2018 | 2018-08-01 | 21246 | 2.1299999999999999 | 0.58999999999999997 | 765 | 0.26000000000000001 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04.000 | 2018-06-11 17:50:04.000 |
| 9 | 2018 | 2018-09-01 | 21246 | 2.0600000000000001 | 0.60999999999999999 | 774 | 0.77000000000000002 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04.000 | 2018-06-11 17:50:04.000 |
| 10 | 2018 | 2018-10-01 | 21246 | 1.74 | 0.57999999999999996 | 855 | 0.23000000000000001 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04.000 | 2018-06-11 17:50:04.000 |
| 11 | 2018 | 2018-11-01 | 21246 | 2.25 | 0.78000000000000003 | 908 | 2.1600000000000001 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04.000 | 2018-06-11 17:50:04.000 |
| 12 | 2018 | 2018-12-01 | 21246 | 1.97 | 0.69999999999999996 | 983 | 1.21 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04.000 | 2018-06-11 17:50:04.000 |
| 1 | 2019 | 2019-01-01 | 21246 | 2.0499999999999998 | 0.76000000000000001 | 954 | 1.95 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04.000 | 2018-06-11 17:50:04.000 |
| 2 | 2019 | 2019-02-01 | 21246 | 1.8400000000000001 | 0.68000000000000005 | 1109 | 1.0700000000000001 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04.000 | 2018-06-11 17:50:04.000 |
| 3 | 2019 | 2019-03-01 | 21246 | 1.75 | 0.67000000000000004 | 1123 | 1.1399999999999999 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04.000 | 2018-06-11 17:50:04.000 |
| 4 | 2019 | 2019-04-01 | 21246 | 1.5800000000000001 | 0.63 | 1092 | 0.64000000000000001 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04.000 | 2018-06-11 17:50:04.000 |
| NULL | NULL | NULL | 21246 | 1.6100000000000001 | 0.68000000000000005 | 1191 | 0.25 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04.000 | 2018-06-11 17:50:04.000 |

## 7. Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? Do you think these values are valid and why?

```sql
SELECT
    _month,
    _year,
    month_year,
    interest_id,
    composition,
    index_value, 
    ranking, 
    percentile_ranking,
    interest_name,
    interest_summary,
    created_at,
    last_modified
FROM interest_metrics
LEFT JOIN interest_map
    ON interest_metrics.interest_id = interest_map.id
WHERE interest_id != 'NULL' AND month_year < created_at
```

| _month | _year | month_year | interest_id | composition | index_value | ranking | percentile_ranking | interest_name | interest_summary | created_at | last_modified |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 7 | 2018 | 2018-07-01 | 32704 | 8.0399999999999991 | 2.27 | 225 | 69.140000000000001 | Major Airline Customers | People visiting sites for major airline brands to plan and view travel itinerary. | 2018-07-06 14:35:04.000 | 2018-07-06 14:35:04.000 |
| 7 | 2018 | 2018-07-01 | 33191 | 3.9900000000000002 | 2.1099999999999999 | 283 | 61.18 | Online Shoppers | People who spend money online | 2018-07-17 10:40:03.000 | 2018-07-17 10:46:58.000 |
| 7 | 2018 | 2018-07-01 | 32703 | 5.5300000000000002 | 1.8 | 375 | 48.560000000000002 | School Supply Shoppers | Consumers shopping for classroom supplies for K-12 students. | 2018-07-06 14:35:04.000 | 2018-07-06 14:35:04.000 |
| 7 | 2018 | 2018-07-01 | 32701 | 4.2300000000000004 | 1.4099999999999999 | 483 | 33.740000000000002 | Womens Equality Advocates | People visiting sites advocating for womens equal rights. | 2018-07-06 14:35:03.000 | 2018-07-06 14:35:03.000 |
| 7 | 2018 | 2018-07-01 | 32705 | 4.3799999999999999 | 1.3400000000000001 | 505 | 30.73 | Certified Events Professionals | Professionals reading industry news and researching products and services for event management. | 2018-07-06 14:35:04.000 | 2018-07-06 14:35:04.000 |
| 7 | 2018 | 2018-07-01 | 32702 | 3.5600000000000001 | 1.1799999999999999 | 580 | 20.440000000000001 | Romantics | People reading about romance and researching ideas for planning romantic moments. | 2018-07-06 14:35:04.000 | 2018-07-06 14:35:04.000 |
| 8 | 2018 | 2018-08-01 | 34465 | 3.3399999999999999 | 2.3399999999999999 | 12 | 98.439999999999998 | Toronto Blue Jays Fans | People reading news about the Toronto Blue Jays and watching games. These consumers are more likely to spend money on team gear. | 2018-08-15 18:00:04.000 | 2018-08-15 18:00:04.000 |
| 8 | 2018 | 2018-08-01 | 34463 | 3.0600000000000001 | 2.1000000000000001 | 36 | 95.310000000000002 | Boston Red Sox Fans | People reading news about the Boston Red Sox and watching games. These consumers are more likely to spend money on team gear. | 2018-08-15 18:00:04.000 | 2018-08-15 18:00:04.000 |
| 8 | 2018 | 2018-08-01 | 34464 | 3.0 | 1.9099999999999999 | 57 | 92.569999999999993 | New York Yankees Fans | People reading news about the New York Yankees and watching games. These consumers are more likely to spend money on team gear. | 2018-08-15 18:00:04.000 | 2018-08-15 18:00:04.000 |
| 8 | 2018 | 2018-08-01 | 33959 | 2.54 | 1.8600000000000001 | 67 | 91.260000000000005 | Boston Bruins Fans | People reading news about the Boston Bruins and watching games. These consumers are more likely to spend money on team gear. | 2018-08-02 16:05:03.000 | 2018-08-02 16:05:03.000 |
| 8 | 2018 | 2018-08-01 | 34469 | 4.54 | 1.8400000000000001 | 68 | 91.129999999999995 | Jazz Festival Enthusiasts | People researching and planning to attend jazz music festivals. | 2018-08-15 18:00:04.000 | 2018-08-15 18:00:04.000 |
| 8 | 2018 | 2018-08-01 | 33971 | 4.9199999999999999 | 1.8100000000000001 | 74 | 90.349999999999994 | Sun Protection Shoppers | Consumers comparing brands and shopping for sun protection products. | 2018-08-02 16:05:05.000 | 2018-08-02 16:05:05.000 |
| 8 | 2018 | 2018-08-01 | 34462 | 2.73 | 1.73 | 97 | 87.349999999999994 | Baltimore Orioles Fans | People reading news about the Baltimore Orioles and watching games. These consumers are more likely to spend money on team gear. | 2018-08-15 18:00:03.000 | 2018-08-15 18:00:03.000 |
| 8 | 2018 | 2018-08-01 | 34082 | 3.4500000000000002 | 1.7 | 107 | 86.049999999999997 | New England Patriots Fans | People reading news about the New England Patriots and watching games. These consumers are more likely to spend money on team gear. | 2018-08-07 17:10:04.000 | 2018-08-07 17:10:04.000 |
| 8 | 2018 | 2018-08-01 | 34574 | 2.9900000000000002 | 1.6899999999999999 | 111 | 85.530000000000001 | F1 Racing Enthusiasts | People visiting websites and reading articles about F1 racing. | 2018-08-17 10:50:03.000 | 2018-08-17 10:50:03.000 |
| 8 | 2018 | 2018-08-01 | 33960 | 2.6800000000000002 | 1.6699999999999999 | 118 | 84.620000000000005 | Chicago Blackhawks Fans | People reading news about the Chicago Blackhawks and watching games. These consumers are more likely to spend money on team gear. | 2018-08-02 16:05:03.000 | 2018-08-02 16:05:03.000 |
| 8 | 2018 | 2018-08-01 | 33967 | 2.8500000000000001 | 1.6299999999999999 | 131 | 82.920000000000002 | New York Rangers Fans | People reading news about the New York Rangers and watching games. These consumers are more likely to spend money on team gear. | 2018-08-02 16:05:04.000 | 2018-08-02 16:05:04.000 |
| 8 | 2018 | 2018-08-01 | 34461 | 3.3100000000000001 | 1.53 | 176 | 77.049999999999997 | Jazz Music Fans | People reading about jazz music and musicians. | 2018-08-15 18:00:03.000 | 2018-08-15 18:00:03.000 |
| 8 | 2018 | 2018-08-01 | 34466 | 2.4100000000000001 | 1.52 | 182 | 76.269999999999996 | Detroit Tigers Fans | People reading news about the Detroit Tigers and watching games. These consumers are more likely to spend money on team gear. | 2018-08-15 18:00:04.000 | 2018-08-15 18:00:04.000 |
| 8 | 2018 | 2018-08-01 | 33963 | 2.3799999999999999 | 1.52 | 182 | 76.269999999999996 | Denver Broncos Fans | People reading news about the Denver Broncos and watching games. These consumers are more likely to spend money on team gear. | 2018-08-02 16:05:04.000 | 2018-08-02 16:05:04.000 |

_(showing 20 of 188 rows)_
