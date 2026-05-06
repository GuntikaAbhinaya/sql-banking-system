/*====================================================================
   DATABASE DESIGN – SCHEMA
====================================================================*/

/* Drop existing objects (optional reset) */
DROP TABLE transactions CASCADE CONSTRAINTS;
DROP TABLE accounts    CASCADE CONSTRAINTS;
DROP TABLE customers   CASCADE CONSTRAINTS;
DROP SEQUENCE seq_customer_id;
DROP SEQUENCE seq_account_id;
DROP SEQUENCE seq_transaction_id;

/* Sequences for surrogate primary keys */
CREATE SEQUENCE seq_customer_id   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_account_id    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_transaction_id START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

/* Customers table */
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name        VARCHAR2(100) NOT NULL,
    email       VARCHAR2(150) NOT NULL UNIQUE,
    phone       VARCHAR2(20)  NOT NULL,
    created_at  DATE DEFAULT SYSDATE
);

/* Accounts table */
CREATE TABLE accounts (
    account_id   NUMBER PRIMARY KEY,
    customer_id  NUMBER NOT NULL,
    account_type VARCHAR2(30) CHECK (account_type IN ('SAVINGS','CHECKING')) NOT NULL,
    balance      NUMBER(15,2) DEFAULT 0 CONSTRAINT chk_balance_nonneg CHECK (balance >= 0),
    opened_at    DATE DEFAULT SYSDATE,
    CONSTRAINT fk_accounts_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

/* Transactions table */
CREATE TABLE transactions (
    transaction_id   NUMBER PRIMARY KEY,
    account_id       NUMBER NOT NULL,
    transaction_type VARCHAR2(20) CHECK (transaction_type IN ('DEPOSIT','WITHDRAW')) NOT NULL,
    amount           NUMBER(15,2) NOT NULL,
    transaction_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_tx_account FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE
);

/* Indexes for performance */
CREATE INDEX idx_accounts_customer ON accounts(customer_id);
CREATE INDEX idx_tx_account_date    ON transactions(account_id, transaction_date);

/* Comments for documentation */
COMMENT ON TABLE customers IS 'Stores core client information.';
COMMENT ON COLUMN customers.email IS 'Unique email address, useful as natural identifier.';
COMMENT ON TABLE accounts IS 'Bank accounts linked to customers; balance never negative.';
COMMENT ON TABLE transactions IS 'Immutable ledger of deposits and withdrawals.';
