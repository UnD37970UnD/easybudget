-- Drop tables if they exist to start with a clean slate
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS wallets;
DROP TABLE IF EXISTS users;

-- 1. Create the 'users' table
-- This table has no dependencies.
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    preferences JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Create the 'wallets' table
-- This table depends on 'users'.
CREATE TABLE wallets (
    wallet_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(3) NOT NULL DEFAULT 'USD',
    type VARCHAR(50),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_user
        FOREIGN KEY(user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- 3. Create the 'transactions' table
-- This table depends on 'wallets'.
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    wallet_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    amount NUMERIC(12, 2) NOT NULL,
    type VARCHAR(50) NOT NULL, -- e.g., 'income' or 'expense'
    category VARCHAR(100),
    transaction_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_wallet
        FOREIGN KEY(wallet_id)
        REFERENCES wallets(wallet_id)
        ON DELETE CASCADE
);

-- Add indexes for better query performance on foreign keys
CREATE INDEX idx_wallets_user_id ON wallets(user_id);
CREATE INDEX idx_transactions_wallet_id ON transactions(wallet_id);