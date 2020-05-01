SELECT COUNT(*)
FROM accounts

SELECT COUNT(accounts.id)
FROM accounts



SELECT SUM(poster_qty) AS total_poster_sales,
	   SUM(standard_qty) AS total_standard_sales,
       SUM(total_amt_usd) AS total_dollar_sales,
	   SUM(standard_amt_usd + gloss_amt_usd) AS standard_gloss
FROM orders

SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

SELECT SUM(standard_amt_usd) / SUM(standard_qty) AS standard_price_per_unit
FROM orders



SELECT MIN(occurred_at)
FROM orders

SELECT occurred_at
FROM orders
ORDER BY occurred_at 
LIMIT 1;



SELECT MAX(occurred_at)
FROM web_events;

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;


SELECT AVG(standard_qty) mean_standard,
	   AVG(gloss_qty) mean_gloss,
	   AVG(poster_qty) mean_poster,
	   AVG(standard_amt_usd) mean_standard_usd,
	   AVG(gloss_amt_usd) mean_gloss_usd,
	   AVG(poster_amt_usd) mean_poster_usd
FROM orders

SELECT *
FROM (SELECT total_amt_usd
	  FROM orders
	  ORDER BY total_amt_usd
	  LIMIT 3457) Table1
ORDER BY total_amt_usd DESC
LIMIT 2;


SELECT account_id, 
	   SUM(standard_qty) AS standard_sum,
	   SUM(gloss_qty) AS gloss_sum,
	   SUM(poster_qty) AS poster_sum
FROM orders
GROUP BY account_id
ORDER BY account_id

SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;

SELECT a.name, SUM(o.total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name

SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1


SELECT channel,
       COUNT(channel) AS channel_sum
FROM web_events
GROUP BY channel;


SELECT a.primary_poc, w.occurred_at
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

SELECT a.name, o.total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o.total_amt_usd
LIMIT 1;

SELECT a.name, MIN(o.total_amt_usd) smallest_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_usd

SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;

SELECT a.name, 
	   AVG(o.standard_qty) AS standard_avg, 		   
	   AVG(o.gloss_qty) AS gloss_avg,
       AVG(o.poster_qty) AS poster_avg
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name


SELECT a.name, 
	   AVG(o.standard_amt_usd) AS standard_avg, 		   
	   AVG(o.gloss_amt_usd) AS gloss_avg,
       AVG(o.poster_amt_usd) AS poster_avg
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name


SELECT s.name, w.channel, COUNT(w.channel) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;

SELECT r.name, w.channel, COUNT(w.channel) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN region r 
ON r.id = s.region_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;


SELECT DISTINCT id, name
FROM accounts;

SELECT DISTINCT id, name
FROM sales_reps


SELECT s.id, s.name, COUNT(*) AS num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;

SELECT a.id, a.name, COUNT(*) AS num_orders
FROM accounts a 
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders


SELECT a.id, a.name, COUNT(*) AS num_orders
FROM accounts a 
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders DESC
LIMIT 1;


SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent 
FROM accounts a 
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent


SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent 
FROM accounts a 
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent


SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent 
FROM accounts a 
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent 
FROM accounts a 
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1


SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a 
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel


SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a 
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING w.channel = 'facebook'
ORDER BY use_of_channel DESC
LIMIT 1


SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;



SELECT DATE_PART('year', occurred_at) order_year,  SUM(total_amt_usd) total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


SELECT DATE_PART('month', occurred_at) order_month,  SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1


SELECT DATE_PART('year', occurred_at) order_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


SELECT DATE_PART('month', occurred_at) order_month,  COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
GROUP BY 1
ORDER BY 2 DESC;


SELECT DATE_TRUNC('month', o.occurred_at) order_date,  SUM(o.gloss_amt_usd) total_gloss
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


SELECT account_id, total_amt_usd,
CASE WHEN total_amt_usd > 3000 THEN 'Large'
ELSE 'Small' END AS order_level
FROM orders


SELECT CASE WHEN total >= 2000 THEN 'At least 2000'
WHEN total > 1000 AND total < 2000 THEN 'BETWEEN 1000 and 2000'
ELSE 'Less than 1000' END AS order_category,
COUNT(total) AS order_count
FROM orders
GROUP BY 1


SELECT a.name, SUM(o.total_amt_usd) total_spent, 
CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top'
WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd) < 200000 THEN ' middle'
ELSE 'low' END AS custom_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC



SELECT a.name, SUM(o.total_amt_usd) total_spent, 
CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top'
WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd) < 200000 THEN ' middle'
ELSE 'low' END AS custom_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01'
GROUP BY 1
ORDER BY 2 DESC


SELECT s.name, COUNT(*) AS order_num, 
	CASE WHEN COUNT(*) > 200 THEN 'top'
	ELSE 'not' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC



SELECT s.name, SUM(o.total_amt_usd) total_spent, COUNT(*) AS order_num, 
	CASE WHEN COUNT(*) > 200  OR SUM(o.total_amt_usd) > 750000 THEN 'top'
	WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 50000 THEN 'middle'
	ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC