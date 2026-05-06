/*====================================================================
   STORED PROCEDURES – DEPOSIT & WITHDRAW
====================================================================*/

/* Deposit Procedure */
CREATE OR REPLACE PROCEDURE deposit_money (
    p_account_id IN NUMBER,
    p_amount     IN NUMBER
) IS
    v_new_balance NUMBER;
BEGIN
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Deposit amount must be positive.');
    END IF;

    SELECT balance + p_amount
    INTO   v_new_balance
    FROM   accounts
    WHERE  account_id = p_account_id
    FOR UPDATE;

    UPDATE accounts
    SET    balance = v_new_balance
    WHERE  account_id = p_account_id;

    INSERT INTO transactions (transaction_id, account_id, transaction_type, amount)
    VALUES (seq_transaction_id.NEXTVAL, p_account_id, 'DEPOSIT', p_amount);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END deposit_money;
/

/* Withdraw Procedure */
CREATE OR REPLACE PROCEDURE withdraw_money (
    p_account_id IN NUMBER,
    p_amount     IN NUMBER
) IS
    v_current_balance NUMBER;
    v_new_balance     NUMBER;
BEGIN
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Withdrawal amount must be positive.');
    END IF;

    SELECT balance
    INTO   v_current_balance
    FROM   accounts
    WHERE  account_id = p_account_id
    FOR UPDATE;

    IF v_current_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20003,
            'Insufficient funds. Available: '||v_current_balance);
    END IF;

    v_new_balance := v_current_balance - p_amount;

    UPDATE accounts
    SET    balance = v_new_balance
    WHERE  account_id = p_account_id;

    INSERT INTO transactions (transaction_id, account_id, transaction_type, amount)
    VALUES (seq_transaction_id.NEXTVAL, p_account_id, 'WITHDRAW', p_amount);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END withdraw_money;
/
