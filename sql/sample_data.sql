/*====================================================================
   SAMPLE DATA – INSERT CUSTOMERS, ACCOUNTS, TRANSACTIONS
====================================================================*/

/* Insert three customers */
INSERT INTO customers (customer_id, name, email, phone)
VALUES (seq_customer_id.NEXTVAL, 'Alice Johnson',  'alice.johnson@example.com',  '555-0101');

INSERT INTO customers (customer_id, name, email, phone)
VALUES (seq_customer_id.NEXTVAL, 'Bob Martinez',   'bob.martinez@example.com',   '555-0102');

INSERT INTO customers (customer_id, name, email, phone)
VALUES (seq_customer_id.NEXTVAL, 'Carol Singh',    'carol.singh@example.com',    '555-0103');

/* Insert accounts – one per customer, plus an extra for Bob */
INSERT INTO accounts (account_id, customer_id, account_type, balance)
VALUES (seq_account_id.NEXTVAL,
        (SELECT customer_id FROM customers WHERE email='alice.johnson@example.com'),
        'SAVINGS', 1500);

INSERT INTO accounts (account_id, customer_id, account_type, balance)
VALUES (seq_account_id.NEXTVAL,
        (SELECT customer_id FROM customers WHERE email='bob.martinez@example.com'),
        'CHECKING', 2500);

INSERT INTO accounts (account_id, customer_id, account_type, balance)
VALUES (seq_account_id.NEXTVAL,
        (SELECT customer_id FROM customers WHERE email='bob.martinez@example.com'),
        'SAVINGS', 800);

INSERT INTO accounts (account_id, customer_id, account_type, balance)
VALUES (seq_account_id.NEXTVAL,
        (SELECT customer_id FROM customers WHERE email='carol.singh@example.com'),
        'CHECKING', 1200);

/* Insert sample transaction rows */
DECLARE
    v_acc_id NUMBER;
BEGIN
    -- Alice deposits 500
    SELECT account_id INTO v_acc_id FROM accounts
    WHERE customer_id = (SELECT customer_id FROM customers WHERE email='alice.johnson@example.com')
      AND account_type='SAVINGS';
    INSERT INTO transactions (transaction_id, account_id, transaction_type, amount)
    VALUES (seq_transaction_id.NEXTVAL, v_acc_id, 'DEPOSIT', 500);

    -- Bob withdraws 200 from checking
    SELECT account_id INTO v_acc_id FROM accounts
    WHERE customer_id = (SELECT customer_id FROM customers WHERE email='bob.martinez@example.com')
      AND account_type='CHECKING';
    INSERT INTO transactions (transaction_id, account_id, transaction_type, amount)
    VALUES (seq_transaction_id.NEXTVAL, v_acc_id, 'WITHDRAW', 200);

    -- Carol deposits 300
    SELECT account_id INTO v_acc_id FROM accounts
    WHERE customer_id = (SELECT customer_id FROM customers WHERE email='carol.singh@example.com')
      AND account_type='CHECKING';
    INSERT INTO transactions (transaction_id, account_id, transaction_type, amount)
    VALUES (seq_transaction_id.NEXTVAL, v_acc_id, 'DEPOSIT', 300);
END;
/
COMMIT;
