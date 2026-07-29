# Case Study 6. CliqueBait: Campaigns Analysis

[← Back to main README](../../README.md)

## 1. Campaigns Analysis Table

```sql
WITH required_data AS(
SELECT
    users.user_id,
    events.visit_id,
    MIN(event_time) AS visit_start_time,
    COUNT(CASE WHEN event_type = 1 THEN 1 END) AS page_views,
    COUNT(CASE WHEN event_type = 2 THEN 1 END) AS cart_adds,
    SUM(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS purchase,
    COUNT(CASE WHEN event_type = 4 THEN 1 END) AS impression,
    COUNT(CASE WHEN event_type = 5 THEN 1 END) AS click,
    STRING_AGG(CASE WHEN page_hierarchy.product_id IS NOT NULL AND events.event_type = 2 THEN page_hierarchy.page_name ELSE NULL END, ', ') 
        WITHIN GROUP (ORDER BY events.sequence_number) AS cart_products
FROM users
JOIN events
    ON users.cookie_id = events.cookie_id
JOIN page_hierarchy
    ON events.page_id = page_hierarchy.page_id
GROUP BY users.user_id, events.visit_id

)

SELECT
    user_id,
    visit_id,
    visit_start_time,
    page_views,
    cart_adds,
    purchase,
    campaign_identifier.campaign_name,
    impression,
    click,
    cart_products
FROM required_data
LEFT JOIN campaign_identifier
  ON visit_start_time BETWEEN campaign_identifier.start_date AND campaign_identifier.end_date
ORDER BY user_id ASC
```

| user_id | visit_id | visit_start_time | page_views | cart_adds | purchase | campaign_name | impression | click | cart_products |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 02a5d5 | 2020-02-26 16:57:26.2608710 | 4 | 0 | 0 | Half Off - Treat Your Shellf(ish) | 0 | 0 | NULL |
| 1 | 0826dc | 2020-02-26 05:58:37.9186180 | 1 | 0 | 0 | Half Off - Treat Your Shellf(ish) | 0 | 0 | NULL |
| 1 | 0fc437 | 2020-02-04 17:49:49.6029760 | 10 | 6 | 1 | Half Off - Treat Your Shellf(ish) | 1 | 1 | Tuna, Russian Caviar, Black Truffle, Abalone, Crab, Oyster |
| 1 | 30b94d | 2020-03-15 13:12:54.0239360 | 9 | 7 | 1 | Half Off - Treat Your Shellf(ish) | 1 | 1 | Salmon, Kingfish, Tuna, Russian Caviar, Abalone, Lobster, Crab |
| 1 | 41355d | 2020-03-25 00:11:17.8606550 | 6 | 1 | 0 | Half Off - Treat Your Shellf(ish) | 0 | 0 | Lobster |
| 1 | ccf365 | 2020-02-04 19:16:09.1825460 | 7 | 3 | 1 | Half Off - Treat Your Shellf(ish) | 0 | 0 | Lobster, Crab, Oyster |
| 1 | eaffde | 2020-03-25 20:06:32.3429890 | 10 | 8 | 1 | Half Off - Treat Your Shellf(ish) | 1 | 1 | Salmon, Tuna, Russian Caviar, Black Truffle, Abalone, Lobster, Crab, Oyster |
| 1 | f7c798 | 2020-03-15 02:23:26.3125430 | 9 | 3 | 1 | Half Off - Treat Your Shellf(ish) | 0 | 0 | Russian Caviar, Crab, Oyster |
| 2 | 0635fb | 2020-02-16 06:42:42.7357300 | 9 | 4 | 1 | Half Off - Treat Your Shellf(ish) | 0 | 0 | Salmon, Kingfish, Abalone, Crab |
| 2 | 1f1198 | 2020-02-01 21:51:55.0787750 | 1 | 0 | 0 | Half Off - Treat Your Shellf(ish) | 0 | 0 | NULL |
| 2 | 3b5871 | 2020-01-18 10:16:32.1584750 | 9 | 6 | 1 | 25% Off - Living The Lux Life | 1 | 1 | Salmon, Kingfish, Russian Caviar, Black Truffle, Lobster, Oyster |
| 2 | 49d73d | 2020-02-16 06:21:27.1385320 | 11 | 9 | 1 | Half Off - Treat Your Shellf(ish) | 1 | 1 | Salmon, Kingfish, Tuna, Russian Caviar, Black Truffle, Abalone, Lobster, Crab, Oyster |
| 2 | 910d9a | 2020-02-01 10:40:46.8759680 | 8 | 1 | 0 | Half Off - Treat Your Shellf(ish) | 0 | 0 | Abalone |
| 2 | c5c0ee | 2020-01-18 10:35:22.7653820 | 1 | 0 | 0 | 25% Off - Living The Lux Life | 0 | 0 | NULL |
| 2 | d58cbd | 2020-01-18 23:40:54.7619060 | 8 | 4 | 0 | 25% Off - Living The Lux Life | 0 | 0 | Kingfish, Tuna, Abalone, Crab |
| 2 | e26a84 | 2020-01-18 16:06:40.9072800 | 6 | 2 | 1 | 25% Off - Living The Lux Life | 0 | 0 | Salmon, Oyster |
| 3 | 25502e | 2020-02-21 11:26:15.3533890 | 1 | 0 | 0 | Half Off - Treat Your Shellf(ish) | 0 | 0 | NULL |
| 3 | 76ee84 | 2020-05-28 20:11:54.9974060 | 7 | 3 | 1 | NULL | 0 | 0 | Salmon, Lobster, Crab |
| 3 | 791afc | 2020-04-29 00:37:16.7411180 | 8 | 2 | 1 | NULL | 0 | 0 | Salmon, Oyster |
| 3 | 7e89a0 | 2020-05-28 10:57:51.7498470 | 9 | 6 | 0 | NULL | 1 | 1 | Salmon, Tuna, Russian Caviar, Black Truffle, Lobster, Crab |

_(showing 20 of 3564 rows)_
