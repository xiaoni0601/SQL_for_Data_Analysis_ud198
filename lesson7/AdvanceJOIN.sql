SELECT column_name(s)
FROM Tabel_A
INNER JOIN Tabel_B ON Tabel_A.column_name = Tabel_B.column_name;



SELECT column_name(s)
FROM Tabel_A
LEFT JOIN Tabel_B ON Tabel_A.column_name = Tabel_B.column_name;


SELECT column_name(s)
FROM Tabel_A
RIGHT JOIN Tabel_B ON Tabel_A.column_name = Tabel_B.column_name;



SELECT column_name(s)
FROM Tabel_A
FULL OUTER JOIN Tabel_B ON Tabel_A.column_name = Tabel_B.column_name;


SELECT column_name(s)
FROM Tabel_A
FULL OUTER JOIN with WHERE A.Key IS NULL OR B.Key IS NULL



SELECT  a.*, s.*
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id




SELECT *
FROM accounts
FULL OUTER JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
WHERE accounts.sales_rep_id IS NULL OR sales_reps.id IS NULL


SELECT *
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
    (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders)
ORDER BY occurred_at


SELECT o.id,
       o.occurred_at AS order_date,
       events.*
FROM orders
LEFT JOIN web_events_full events ON 
events.account_id = o.account_id
AND events.occurred_at < o.occurred_at
WHERE DATE_TRUNC('month', occurred_at) = 
    (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders)
ORDER BY occurred_at



SELECT accounts.name account_name, 
       accounts.primary_poc poc_name, 
       sales_reps.name sales_rep_name
FROM accounts
LEFT JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
AND accounts.primary_poc < sales_reps.name



SELECT o1.id AS o1_id, 
       o1.account_id AS o1_account_id, 
       o1.occurred_at AS o1_occurred_at,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at
FROM orders o1
LEFT JOIN orders o2
ON o1.account_id = o2.account_id
AND o2.occurred_at > o1.occurred_at
AND o2_occurred_at <= o1_occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at





SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w1.channel AS w1_channel,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at,
       w2.channel AS w2_channel
  FROM web_events w1
 LEFT JOIN web_events w2
   ON w1.account_id = w2.account_id
  AND w1.occurred_at > w2.occurred_at
  AND w1.occurred_at <= w2.occurred_at + INTERVAL '1 day'
ORDER BY w1.account_id, w2.occurred_at




SELECT *
FROM accounts

UNION ALL

SELECT *
FROM accounts



SELECT *
FROM accounts
WHERE name = 'Walmart'

UNION ALL

SELECT *
FROM accounts
WHERE name = 'Disney'




WITH double_accounts AS (
                          SELECT *
                          FROM accounts

                          UNION ALL

                          SELECT *
                          FROM accounts)


SELECT name, COUNT(*) name_account
FROM double_accounts
GROUP BY name
ORDER BY 2 DESC



WITH sub AS (
            SELECT account_id, 
                    COUNT(*) AS web_events
            FROM web_events_full events
            GROUP BY account_id)
SELECT a.name, sub.web_events
FROM sub
JOIN accounts a
ON a.id = sub.account_id
ORDER BY 2 DESC


EXPLAIN
SELECT *
FROM web_events_full
WHERE occurred_at >= '2016-01-01'
AND occurred_at < '2017-07-01'




SELECT DATE_TRUNC('day', o.occurred_at) AS date,
       COUNT(DISTINCT a.sales_rep_id) AS active_sales_reps,
       COUNT(DISTINCT o.id) AS orders,
       COUNT(DISTINCT we.id) AS web_visits
FROM accounts a
JOIN orders o
ON o.account_id = a.id
JOIN web_events_full we
ON DATE_TRUNC('day', we.occurred_at) = DATE_TRUNC('day', o.occurred_at)
GROUP BY 1
ORDER BY 1 DESC






SELECT DATE_TRUNC('day', o.occurred_at) AS date,
       COUNT(DISTINCT a.sales_rep_id) AS active_sales_reps,
       COUNT(DISTINCT o.id) AS orders
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1

SELECT DATE_TRUNC('day', o.occurred_at) AS date,
       COUNT(DISTINCT we.id) AS web_visits
FROM web_events_full we
GROUP BY 1 



SELECT COALESCE(orders.date, web_events.date) AS date,
       orders.active_sales_reps,
       orders.orders,
       web_events.web_visits
FROM (
SELECT DATE_TRUNC('day', o.occurred_at) AS date,
       COUNT(DISTINCT a.sales_rep_id) AS active_sales_reps,
       COUNT(DISTINCT o.id) AS orders
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
) orders

FULL JOIN

(
SELECT DATE_TRUNC('day', o.occurred_at) AS date,
       COUNT(DISTINCT we.id) AS web_visits
FROM web_events_full we
GROUP BY 1 
) web_events

ON orders.date = web_events.date
ORDER BY 1 DESC