# sql-banking-system
A SQL-based Banking Management System that simulates real-world banking operations using relational database design, including customers, accounts, and transactions with features like deposits, withdrawals, balance tracking, and transaction history using SQL queries, joins, constraints, and stored procedures.

# 🏦 Mini Banking System – Oracle Live SQL

> A production-style relational banking system built using **Oracle SQL & PL/SQL**, demonstrating real-world database design, transaction management, and procedural programming — fully executable on **Oracle Live SQL (browser-based)**.

---

## 🚀 Overview

This project simulates a real banking backend system with customers, accounts, and transactions. It focuses on **database design principles, integrity constraints, and transaction-safe operations** using PL/SQL stored procedures.

✔ No local installation required  
✔ Runs entirely in Oracle Live SQL  
✔ Designed for DBA + backend interview showcase  

---

## 🎯 Key Objectives

- Design a **normalized (3NF) relational database**
- Implement **secure banking operations**
- Enforce **data integrity using constraints**
- Demonstrate **transaction management (COMMIT/ROLLBACK)**
- Build **reusable PL/SQL stored procedures**

---

## 🧱 System Architecture

Customers  ───▶ Accounts ───▶ Transactions
   (1)           (1 : N)         (Ledger)

- A customer can have multiple accounts  
- Each account can have multiple transactions  
- All financial operations are recorded in a transaction ledger  

---

## 🗄️ Database Schema

### 👤 CUSTOMERS
- customer_id (PK)
- name
- email (UNIQUE)
- phone
- created_at

### 💳 ACCOUNTS
- account_id (PK)
- customer_id (FK → Customers)
- account_type
- balance (CHECK ≥ 0)
- opened_at

### 📊 TRANSACTIONS
- transaction_id (PK)
- account_id (FK → Accounts)
- transaction_type (DEPOSIT / WITHDRAW)
- amount
- transaction_date

---

## ⚙️ Features

✔ Fully normalized relational design (3NF)  
✔ Primary & Foreign key constraints  
✔ Business rule enforcement using CHECK constraints  
✔ Indexing for performance optimization  
✔ Transaction-safe PL/SQL procedures  
✔ Error handling with exception blocks  
✔ Row-level locking for safe concurrency  

---

## 💰 Stored Procedures

### ➕ Deposit Money
- Validates input amount  
- Locks account row  
- Updates balance  
- Inserts transaction record  
- Commits safely  

### ➖ Withdraw Money
- Checks sufficient balance  
- Prevents overdraft  
- Updates balance  
- Logs transaction  
- Rolls back on failure  

---

## 🔄 ER Diagram Explanation

Customers → Accounts → Transactions

1. Customers → Accounts (1:N)
   - One customer can own multiple accounts  

2. Accounts → Transactions (1:N)
   - Each account has multiple transactions  

3. Transactions = Ledger Table
   - Stores all money movements (audit trail)

✔ Ensures normalization  
✔ Maintains referential integrity  
✔ Supports real-world banking systems  

---

## 🚀 How to Run (Oracle Live SQL)

1. Open https://livesql.oracle.com/
2. Create a new worksheet
3. Run in order:

1. sql/banking_schema.sql  
2. sql/sample_data.sql  
3. sql/procedures.sql  
4. sql/queries.sql  

---

## 🧪 Sample Execution

BEGIN
    deposit_money(p_account_id => 101, p_amount => 500);
END;
/

BEGIN
    withdraw_money(p_account_id => 101, p_amount => 200);
END;
/

---

## 📊 Outputs

- Customer account summary  
- Transaction history  
- Updated balances  
- Ledger verification  

---

---
## 🚀 Future Enhancements

- Add triggers for audit logging  
- Convert procedures into PL/SQL packages  
- Expose REST APIs using Oracle ORDS  
- Connect frontend with backend services  

