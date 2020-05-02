
SELECT channel,
       AVG(event_count) AS avg_event_count
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day,
       channel,
       COUNT(*) AS event_count
      FROM web_events
      GROUP BY 1,2) sub
GROUP BY 1
ORDER BY 2 DESC




SELECT DATE_TRUNC('day', occurred_at) AS day,
       channel,
       COUNT(*) AS event_count
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC


SELECT *
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day,
             channel,
             COUNT(*) AS event_count
      FROM web_events
      GROUP BY 1,2) sub



SELECT channel,
       AVG(event_count) avg_event_count
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day,
             channel,
             COUNT(*) AS event_count
      FROM web_events
      GROUP BY 1,2) sub
GROUP BY 1
ORDER BY 2 DESC



SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
FROM orders
    




SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders)

SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders)



SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM (SELECT region_name, MAX(total_amt) total_amt
      FROM (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
            FROM sales_reps s
            JOIN accounts a
            ON a.sales_rep_id = s.id
            JOIN orders o
            ON o.account_id = a.id
            JOIN region r
            ON r.id = s.region_id
            GROUP BY 1, 2) t1
      GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
      FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON o.account_id = a.id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY 1,2
      ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;




SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
        SELECT MAX(total_amt)
        FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
                FROM sales_reps s
                JOIN accounts a
                ON a.sales_rep_id = s.id
                JOIN orders o
                ON o.account_id = a.id
                JOIN region r
                ON r.id = s.region_id
                GROUP BY r.name) sub)




SELECT COUNT(*)
FROM (SELECT a.name
        FROM orders o
        JOIN accounts a
        ON o.account_id = a.id
        GROUP BY 1
        HAVING SUM(o.total) > (SELECT total
                                FROM (SELECT a.name act_name, SUM(o.standard_qty) total_std, SUM(o.total) total
                                        FROM accounts a
                                        JOIN orders o
                                        ON o.account_id = a.id
                                        GROUP BY 1
                                        ORDER BY 2 DESC
                                        LIMIT 1) sub1)
                               ) sub2                        








SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id = (SELECT id
                                    FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
                                            FROM orders o
                                            JOIN accounts a
                                            ON a.id = o.account_id
                                            GROUP BY a.id, a.name
                                            ORDER BY 3 DESC
                                            LIMIT 1) sub)
GROUP BY 1, 2
ORDER BY 3 DESC;





SELECT AVG(total_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
        FROM orders o
        JOIN accounts a
        ON a.id = o.account_id
        GROUP BY a.id, a.name
        ORDER BY 3 DESC
        LIMIT 10) sub





SELECT AVG(avg_value)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_value
        FROM orders o
        GROUP BY 1
        HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_spent
                                    FROM orders o)) inner_sub;                           



SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;

WITH events AS (
    SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2)
SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC



WITH table1 AS (
                SELECT *
                FROM web_events),
      table2 AS (
                SELECT *
                FROM accounts)
SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id



SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM (SELECT region_name, MAX(total_amt) total_amt
      FROM (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
            FROM sales_reps s
            JOIN accounts a
            ON a.sales_rep_id = s.id
            JOIN orders o
            ON o.account_id = a.id
            JOIN region r
            ON r.id = s.region_id
            GROUP BY 1, 2) t1
      GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
      FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON o.account_id = a.id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY 1,2
      ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

WITH t1 AS (
            SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
            FROM sales_reps s
            JOIN accounts a
            ON a.sales_rep_id = s.id
            JOIN orders o
            ON o.account_id = a.id
            JOIN region r
            ON r.id = s.region_id
            GROUP BY 1, 2
            ORDER BY 3 DESC),
     t2 AS (
            SELECT region_name, MAX(total_amt) total_amt
            FROM t1
            GROUP BY 1)       
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt



SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
        SELECT MAX(total_amt)
        FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
                FROM sales_reps s
                JOIN accounts a
                ON a.sales_rep_id = s.id
                JOIN orders o
                ON o.account_id = a.id
                JOIN region r
                ON r.id = s.region_id
                GROUP BY r.name) sub)



WITH t1 AS (
            SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
                FROM sales_reps s
                JOIN accounts a
                ON a.sales_rep_id = s.id
                JOIN orders o
                ON o.account_id = a.id
                JOIN region r
                ON r.id = s.region_id
                GROUP BY r.name),
    t2 AS (
            SELECT MAX(total_amt)
            FROM t1)
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT *
                               FROM t2)




SELECT COUNT(*)
FROM (SELECT a.name
        FROM orders o
        JOIN accounts a
        ON o.account_id = a.id
        GROUP BY 1
        HAVING SUM(o.total) > (SELECT total
                                FROM (SELECT a.name act_name, SUM(o.standard_qty) total_std, SUM(o.total) total
                                        FROM accounts a
                                        JOIN orders o
                                        ON o.account_id = a.id
                                        GROUP BY 1
                                        ORDER BY 2 DESC
                                        LIMIT 1) sub1)
                               ) sub2  


WITH t1 AS (
            SELECT a.name act_name, SUM(o.standard_qty) total_std, SUM(o.total) total
            FROM accounts a
            JOIN orders o
            ON o.account_id = a.id
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 1),
    t2 AS (
            SELECT a.name
            FROM orders o
            JOIN accounts a
            ON o.account_id = a.id
            GROUP BY 1
            HAVING SUM(o.total) > (SELECT total
                                   FROM t1)
SELECT COUNT(*)
FROM t2




SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id = (SELECT id
                                    FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
                                            FROM orders o
                                            JOIN accounts a
                                            ON a.id = o.account_id
                                            GROUP BY a.id, a.name
                                            ORDER BY 3 DESC
                                            LIMIT 1) sub)
GROUP BY 1, 2
ORDER BY 3 DESC;

WITH t1 AS (
            SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
            FROM orders o
            JOIN accounts a
            ON a.id = o.account_id
            GROUP BY a.id, a.name
            ORDER BY 3 DESC
            LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id = (SELECT id
                                   FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;



SELECT AVG(total_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
        FROM orders o
        JOIN accounts a
        ON a.id = o.account_id
        GROUP BY a.id, a.name
        ORDER BY 3 DESC
        LIMIT 10) sub

WITH t1 AS (
            SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
            FROM orders o
            JOIN accounts a
            ON a.id = o.account_id
            GROUP BY a.id, a.name
            ORDER BY 3 DESC
            LIMIT 10)
SELECT AVG(total_spent)
FROM t1



SELECT AVG(avg_value)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_value
        FROM orders o
        GROUP BY 1
        HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_spent
                                       FROM orders o)) inner_sub   

WITH t1 AS (
            SELECT AVG(o.total_amt_usd) avg_spent
            FROM orders o
            JOIN accounts a
            ON a.id = o.account_id),
     t2 AS (
            SELECT o.account_id, AVG(o.total_amt_usd) avg_value
            FROM orders o
            GROUP BY 1
            HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1)
SELECT AVG(avg_value)       
FROM t2
    