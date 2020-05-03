SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC



SELECT LEFT(UPPER(name), 1) AS first_name, COUNT(*) num_names
FROM accounts
GROUP BY 1
ORDER BY 2 DESC




SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
         CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
      FROM accounts) t1;

WITH t1 AS (
            SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
         CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
            FROM accounts)
SELECT SUM(num) nums, SUM(letter) letters
FROM t1        


WITH t1 AS (
            SELECT name, 
                CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 1 ELSE 0 END AS vowels,
                CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 0 ELSE 1 END AS others
            FROM accounts)
SELECT SUM(vowels) vowels, SUM(others) others
FROM t1



SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts


SELECT LEFT(name, STRPOS(name, ' ') - 1) first_name,
RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps


SELECT first_name, last_name, 
        CONCAT(first_name, ' ', last_name) full_name,
        first_name || ' '|| last_name AS full_name_alt
FROM sales_reps


WITH t1 AS (
            SELECT name, 
            LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_name,
            RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
            FROM accounts)

SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com') email_address
FROM t1


WITH t1 AS (
            SELECT name, 
            LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_name,
            RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
            FROM accounts)

SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com') email_address
FROM t1


WITH t1 AS (
            SELECT name, 
            LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_name,
            RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
            FROM accounts)
SELECT first_name, 
       last_name,
       CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com') email_address,
       CONCAT(LEFT(LOWER(first_name), 1), RIGHT(LOWER(first_name), 1), LEFT(LOWER(last_name), 1), RIGHT(LOWER(last_name), 1), 
              LENGTH(first_name), LENGTH(last_name), REPLACE(UPPER(name), ' ', '')) ini_password
FROM t1



SELECT *
FROM sf_crime_data
LIMIT 10



SELECT date ori_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2)) new_date
FROM sf_crime_data


SELECT date ori_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2)) :: DATE new_date
FROM sf_crime_data


SELECT *,
        COALESCE(primary_poc, 'no POC') AS primary_poc_modified
FROM accounts
WHERE primary_poc IS NULL


SELECT COUNT(primary_poc) AS regular_count,
       COUNT(COALESCE(primary_poc, 'no POC')) AS modified_count
FROM accounts



SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COALESCE(a.id, a.id) AS id_modified, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, 
       COALESCE(o.account_id, a.id) account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, 
       COALESCE(o.account_id, a.id) account_id, o.occurred_at, 
       COALESCE(o.standard_qty, 0) standard_qty, 
       COALESCE(o.gloss_qty,0) gloss_qty, 
       COALESCE(o.poster_qty,0) poster_qty, 
       COALESCE(o.total,0) total, 
       COALESCE(o.standard_amt_usd,0) standard_amt_usd, 
       COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, 
       COALESCE(o.poster_amt_usd,0) poster_amt_usd, 
       COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;



SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;



SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, 
       COALESCE(o.account_id, a.id) account_id, o.occurred_at, 
       COALESCE(o.standard_qty, 0) standard_qty, 
       COALESCE(o.gloss_qty,0) gloss_qty, 
       COALESCE(o.poster_qty,0) poster_qty, 
       COALESCE(o.total,0) total, 
       COALESCE(o.standard_amt_usd,0) standard_amt_usd, 
       COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, 
       COALESCE(o.poster_amt_usd,0) poster_amt_usd, 
       COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;