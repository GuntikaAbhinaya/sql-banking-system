/*====================================================================
   CORE QUERIES – Joins, Aggregates, Transaction History
====================================================================*/

/* 1. Customer total balances (INNER JOIN + SUM) */
SELECT c.customer_id,
       c.name,
       c.email,
       SUM(a.balance) AS total_balance
FROM   customers c
JOIN   accounts a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.name, c.email
ORDER BY total_balance DESC;

/* 2. Transaction history for a given account (bind variable) */
SELECT t.transaction_id,
       t.transaction_type,
       t.amount,
       TO_CHAR(t.transaction_date, 'YYYY-MM-DD HH24:MI') AS when_it_happened
FROM   transactions t
WHERE  t.account_id = :p_account_id   -- replace with actual account_id when executing
ORDER BY t.transaction_date DESC;

/* 3. Number of accounts per customer */
SELECT c.name,
       COUNT(a.account_id) AS num_accounts
FROM   customers c
LEFT JOIN accounts a ON a.customer_id = c.customer_id
GROUP BY c.name
ORDER BY num_accounts DESC;
