# 8 Week SQL Challenge

My attempted solutions to Danny Ma's [#8WeekSQLChallenge](https://8weeksqlchallenge.com/): eight case studies, eight fictional businesses and a whole lot of SQL.

---

## About

When I started Case Study 1, the only SQL I had under my belt was the [SQLBolt](https://sqlbolt.com/) tutorial. I could write a `SELECT ... FROM ... WHERE`, group a few rows together and join tables. That was about the limit of it.

Danny's Diner was the first time I had to answer a question rather than just write a query. *"Which item was the most popular for each customer?"* gives you a business problem and leaves you to work out that the answer involves ranking within groups. That was the point where I actually needed CTEs and window functions, rather than just having read about them.

Some questions were just hard. A few took several sittings and one or two I'm still chewing on (noted honestly in the table below). But comparing my Danny's Diner answers to where I ended up on Fresh Segments is the clearest picture I have of how much changed.

---

## Table of Contents

| # | Case Study | Business Problem | Status |
|---|---|---|---|
| 0 | [Schema](./Schema) | `CREATE DATABASE` / `CREATE TABLE` / seed scripts for all eight case studies. Run these first | ✅ |
| 1 | [Danny's Diner](./Case%20Study%201%20Dannys%20Diner) | Customer visits, spend and loyalty programme analysis for a small Japanese restaurant | ✅ Complete |
| 2 | [Pizza Runner](./Case%20Study%202%20Pizza%20Runner) | Delivery metrics, runner performance, ingredient optimisation and pricing for a pizza delivery startup | ✅ Complete |
| 3 | [Foodie-Fi](./Case%20Study%203%20Foodie-Fi) | Subscription plans, churn, trial conversion and upgrade/downgrade behaviour for a streaming service | 🚧 In progress |
| 4 | [Data Bank](./Case%20Study%204%20Data%20Bank) | Customer node distribution, transaction patterns and running balances for a digital bank | 🚧 In progress |
| 5 | [Data Mart](./Case%20Study%205%20Data%20Mart) | Cleaning weekly sales data, then measuring the impact of a sustainable packaging change | ✅ Complete |
| 6 | [Clique Bait](./Case%20Study%206%20CliqueBait) | Digital event analysis, product funnels and ad campaign performance for an online seafood store | ✅ Complete |
| 7 | [Balanced Tree Clothing](./Case%20Study%207%20Balanced%20Tree%20Clothing) | High level sales, product hierarchy and transaction analysis for a clothing retailer | 🚧 In progress |
| 8 | [Fresh Segments](./Case%20Study%208%20Fresh%20Segments) | Interest metrics, data cleansing and segment ranking for a digital marketing agency | 🚧 In progress |

**Status key:** ✅ Complete · 🚧 In progress, some questions still outstanding

---

## Tools Used

**T-SQL** (Microsoft SQL Server). The original challenge is written for PostgreSQL, so the schemas and queries here have been translated across to T-SQL syntax.

---

## Thanks

Thank you to [Danny Ma](https://www.linkedin.com/in/datawithdanny/) for putting the [#8WeekSQLChallenge](https://8weeksqlchallenge.com/) together and making it freely available. It's a well designed set of case studies and it took me from tutorial SQL to something I'd be comfortable using in my finance career.