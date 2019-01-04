/* 1) columns in the survey table */
SELECT * FROM survey limit 10; 


/* 2) survey response funnel */
SELECT question, count(response) AS 'response count' from survey group by 1;


/* Analysis of specific survey questions*/
SELECT question, response, COUNT(user_id) AS chosen 
FROM survey 
WHERE question = '1. What are you looking for?'
GROUP BY 1, 2;

/* colors and styles liked in survey */
SELECT question, response, COUNT(user_id) AS chosen 
FROM survey 
WHERE question IN ('3. Which shapes do you like?', '4. Which colors do you like?')
GROUP BY 1, 2 ORDER BY 1, 3 DESC;


/* 4) list contents of tables quiz, home_try_on, purchase */
SELECT * FROM quiz LIMIT 5;
SELECT * FROM home_try_on LIMIT 5;
SELECT * FROM purchase LIMIT 5;


/* Funnel table from question 5 */
WITH q_to_p AS (
	SELECT quiz.user_id AS q_id, home_try_on.user_id AS h_id, number_of_pairs, purchase.user_id AS p_id from quiz
  LEFT JOIN home_try_on
  ON quiz.user_id = home_try_on.user_id
  LEFT JOIN purchase
  on quiz.user_id = purchase.user_id
),

funnel AS(
SELECT q_id AS 'user_id',
CASE
	WHEN h_id IS NOT NULL THEN 'True'
  ELSE 'False'
END AS 'is_home_try_on',
CASE
	WHEN number_of_pairs IS NULL THEN 'NULL'
  ELSE number_of_pairs
END AS 'number_of_pairs',
CASE
	WHEN p_id IS NOT NULL THEN 'True'
  ELSE 'False'
END AS is_purchase
FROM q_to_p
) 

SELECT * FROM funnel LIMIT 10;


/* raw purchase conversions */
WITH q_to_p AS (
  SELECT quiz.user_id AS q_id, home_try_on.user_id AS h_id, number_of_pairs, purchase.user_id AS p_id from quiz
  LEFT JOIN home_try_on
  ON quiz.user_id = home_try_on.user_id
  LEFT JOIN purchase
  on quiz.user_id = purchase.user_id
),

funnel AS(
  SELECT q_id AS 'user_id',
  CASE
    WHEN h_id IS NOT NULL THEN 1
    ELSE 0
  END AS 'is_home_try_on',
  CASE
    WHEN number_of_pairs IS NULL THEN 'NULL'
    ELSE number_of_pairs
  END AS 'number_of_pairs',
  CASE
    WHEN p_id IS NOT NULL THEN 1
    ELSE 0
  END AS is_purchase
  FROM q_to_p
)

SELECT COUNT(user_id) AS prospects, 
SUM(is_home_try_on) AS 'tried on', 
SUM(is_purchase) AS 'purchased' 
FROM funnel; 


/* ab test results */
WITH q_to_p AS (
  SELECT quiz.user_id AS q_id, home_try_on.user_id AS h_id, number_of_pairs, purchase.user_id AS p_id from quiz
  LEFT JOIN home_try_on
  ON quiz.user_id = home_try_on.user_id
  LEFT JOIN purchase
  on quiz.user_id = purchase.user_id
),

funnel AS(
  SELECT q_id AS 'user_id',
  CASE
    WHEN h_id IS NOT NULL THEN 1
    ELSE 0
  END AS 'is_home_try_on',
  CASE
    WHEN number_of_pairs IS NULL THEN 'NULL'
    ELSE number_of_pairs
  END AS 'number_of_pairs',
  CASE
    WHEN p_id IS NOT NULL THEN 1
    ELSE 0
  END AS is_purchase
  FROM q_to_p
)

SELECT number_of_pairs AS 'pairs sent', 
sum(is_home_try_on) AS 'tried on', 
sum(is_purchase) AS 'purchased'
FROM funnel
WHERE number_of_pairs != 'NULL' 
GROUP BY number_of_pairs;


/* pricing for men and women */
SELECT style, price, COUNT(user_id) AS purchases 
FROM purchase 
GROUP BY 1, 2 
ORDER by 1, 2 ASC; 


/* orders by model and color*/
SELECT model_name, color, 
COUNT(user_id) AS orders FROM purchase 
GROUP BY 1,2 
ORDER BY 3 DESC;

