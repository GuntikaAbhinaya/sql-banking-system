# sql-banking-system
A SQL-based Banking Management System that simulates real-world banking operations using relational database design, including customers, accounts, and transactions with features like deposits, withdrawals, balance tracking, and transaction history using SQL queries, joins, constraints, and stored procedures.


# Mini Banking System – Oracle Live SQL

## 1. Project Overview
A compact, production‑style banking core built entirely with **Oracle SQL/PLSQL**. The whole solution runs in **Oracle Live SQL** (browser‑only) – no local Oracle installation, Docker, or cloud services required. It demonstrates solid relational modeling, constraints, indexes, transaction‑safe stored procedures, and a static HTML/CSS/JS UI for portfolio showcase.

## 2. Problem Statement
Employers expect junior DB developers to:
- Design a normalized schema (3 NF) for customers, accounts, and a ledger.
- Enforce business rules (e.g., no negative balance).
- Write reusable PL/SQL procedures with proper `COMMIT/ROLLBACK` semantics.

This project satisfies those expectations while staying small enough for a fresh graduate to explain clearly.

## 3. System Architecture
```
+-----------------+      +-------------------+
|   Customers     |<-----|    Accounts       |
| (PK:customer_id)|      | (PK:account_id)   |
+-----------------+      | (FK:customer_id)  |
                         +-------------------+
                                 |
                                 v
                         +-------------------+
                         |  Transactions     |
                         | (PK:transaction_id) |
                         | (FK:account_id)   |
                         +-------------------+
```
All tables reside in a single Oracle schema. Stored procedures act as the "service layer".

## 4. Database Schema Explanation
| Table | Columns | Key/Constraint | Reason |
|-------|---------|----------------|--------|
| **CUSTOMERS** | `customer_id`, `name`, `email`, `phone`, `created_at` | PK, `email` UNIQUE, NOT NULLs | Guarantees each person is unique; email is a natural login candidate. |
| **ACCOUNTS** | `account_id`, `customer_id`, `account_type`, `balance`, `opened_at` | PK, FK → CUSTOMERS, CHECK (`balance >= 0`), CHECK (`account_type` enum) | Enforces one‑to‑many relationship + business rule that balance never goes negative. |
| **TRANSACTIONS** | `transaction_id`, `account_id`, `transaction_type`, `amount`, `transaction_date` | PK, FK → ACCOUNTS, CHECK (`transaction_type` enum) | Immutable ledger; every monetary movement is recorded. |

**Indexes**: `idx_accounts_customer` (fast lookup of accounts per customer) and `idx_tx_account_date` (fast transaction‑history queries).

## 5. Stored Procedures
### `deposit_money(p_account_id, p_amount)`
1. Validate `p_amount > 0`.
2. `SELECT … FOR UPDATE` – row‑level lock.
3. Compute new balance, update `ACCOUNTS`.
4. Insert a `DEPOSIT` row into `TRANSACTIONS`.
5. `COMMIT`; on any error `ROLLBACK` and re‑raise.

### `withdraw_money(p_account_id, p_amount)`
Same flow, plus:
- Verify sufficient funds; raise `-20003` if not.
- Update balance and insert a `WITHDRAW` row.

Both procedures showcase **transaction control**, **exception handling**, and **row‑level locking**.

## 6. Execution Guide (Oracle Live SQL)
1. Open https://livesql.oracle.com/ and create a new worksheet.

2. Copy‑paste the files **in order** (run each block separately):
   1. `schema.sql` – creates tables, sequences, constraints, indexes.
   2. `sample_data.sql` – inserts demo customers, accounts, transactions.
   3. `procedures.sql` – defines `deposit_money` and `withdraw_money`.
   4. `queries.sql` – run the sample SELECTs.
3. Test the procedures, e.g.:
```sql
BEGIN
    deposit_money(p_account_id => 101, p_amount => 250);
END;
/

BEGIN
    withdraw_money(p_account_id => 101, p_amount => 1000);
END;
/
```
4. Observe the updated balances with the aggregate query from `queries.sql`.

All statements are idempotent; the script begins by dropping existing objects.

## 7. Expected Outputs (replace placeholders with screenshots from Live SQL)
- **Customer total balances** table.
- **Transaction history** for a specific account.
- **Procedure success messages** (`PL/SQL procedure successfully completed`).

## 8. Interview Talking Points
| Topic | Key Points |
|-------|------------|
| Normalization | 3NF – no repeating groups, all non‑key attributes depend on the whole PK. |
| Constraints | PK/FK enforce referential integrity; `CHECK` enforces business rule. |
| Indexes | Show performance benefit for look‑ups (`WHERE customer_id = ?`). |
| Procedures | Row‑level locking, atomic transaction, user‑friendly error handling. |
| Live SQL | No installation required – perfect for quick POCs. |
| Front‑end Demo | Static UI demonstrates UI‑to‑DB thinking; could be wired to an API later. |

## 9. Resume Bullet (copy‑paste)
```
Mini Banking System (Oracle Live SQL) – Designed a fully‑normalized relational model (Customers, Accounts, Transactions) with PK/FK constraints, CHECK constraints, and indexes. Implemented PL/SQL stored procedures for deposit/withdrawal with transaction control, exception handling, and row‑level locking. Created sample data, aggregate reports, and a static HTML/CSS/JS demo for portfolio showcase. Built entirely in browser‑based Oracle Live SQL (no local installation required).
```

## 10. Next Steps (optional extensions)
1. Add an `AFTER UPDATE` trigger to auto‑log balance changes.
2. Package procedures into a PL/SQL **package** for easier management.
3. Expose the procedures via Oracle ORDS REST services (out‑of‑scope for this demo).

---
**All files are ready in the project folder.** Open `index.html` in a browser to see the UI demo.
