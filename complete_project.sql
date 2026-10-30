-- =====================================================================
-- COMPLETE BANKING ANALYSIS PROJECT (ALL-IN-ONE SCRIPT)
-- Database: MySQL 8.0+
-- Tables: 1. customer, 2. accounts, 3. transaction, 4. loan
-- Author: Data Analytics & Engineering
-- =====================================================================

CREATE DATABASE IF NOT EXISTS banking_db;
USE banking_db;

-- ---------------------------------------------------------------------
-- 1. DROP EXISTING OBJECTS
-- ---------------------------------------------------------------------
DROP VIEW IF EXISTS vw_customer_360;
DROP VIEW IF EXISTS vw_branch_performance;
DROP PROCEDURE IF EXISTS sp_get_customer_portfolio;

DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS loan;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customer;

-- ---------------------------------------------------------------------
-- 2. CREATE SCHEMAS
-- ---------------------------------------------------------------------
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    credit_score INT CHECK (credit_score BETWEEN 300 AND 900),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_type ENUM('Savings', 'Current', 'Fixed Deposit', 'Salary') NOT NULL,
    balance DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    status ENUM('Active', 'Dormant', 'Frozen', 'Closed') DEFAULT 'Active',
    branch_code VARCHAR(10) NOT NULL,
    opened_date DATE NOT NULL,
    CONSTRAINT fk_accounts_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES customer(customer_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT chk_positive_balance 
        CHECK (balance >= 0.00)
) ENGINE=InnoDB;

CREATE TABLE transaction (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type ENUM('Deposit', 'Withdrawal', 'Transfer_In', 'Transfer_Out', 'EMI_Payment') NOT NULL,
    amount DECIMAL(15, 2) NOT NULL CHECK (amount > 0),
    transaction_date DATETIME NOT NULL,
    channel ENUM('ATM', 'NetBanking', 'UPI', 'Branch', 'AutoDebit') NOT NULL,
    status ENUM('Success', 'Pending', 'Failed') DEFAULT 'Success',
    description VARCHAR(255),
    CONSTRAINT fk_transaction_account 
        FOREIGN KEY (account_id) 
        REFERENCES accounts(account_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE loan (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    loan_type ENUM('Home', 'Personal', 'Auto', 'Education', 'Business') NOT NULL,
    loan_amount DECIMAL(15, 2) NOT NULL CHECK (loan_amount > 0),
    interest_rate DECIMAL(5, 2) NOT NULL,
    term_months INT NOT NULL CHECK (term_months > 0),
    monthly_emi DECIMAL(15, 2) NOT NULL,
    start_date DATE NOT NULL,
    loan_status ENUM('Approved', 'Disbursed', 'In Progress', 'Fully Paid', 'Defaulted') DEFAULT 'Disbursed',
    CONSTRAINT fk_loan_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES customer(customer_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Indexes for performance
CREATE INDEX idx_customer_city ON customer(city);
CREATE INDEX idx_accounts_type ON accounts(account_type);
CREATE INDEX idx_accounts_customer ON accounts(customer_id);
CREATE INDEX idx_transaction_date ON transaction(transaction_date);
CREATE INDEX idx_loan_status ON loan(loan_status);

-- ---------------------------------------------------------------------
-- 3. INSERT SAMPLE DATA
-- ---------------------------------------------------------------------
INSERT INTO customer (customer_id, first_name, last_name, email, phone_number, date_of_birth, gender, city, state, credit_score, created_at)
VALUES
(1, 'Aarav', 'Sharma', 'aarav.sharma@example.com', '9876543210', '1988-04-12', 'Male', 'Mumbai', 'Maharashtra', 780, '2021-01-15 10:30:00'),
(2, 'Priya', 'Verma', 'priya.verma@example.com', '9876543211', '1993-08-25', 'Female', 'Delhi', 'Delhi', 810, '2021-03-20 11:15:00'),
(3, 'Rohan', 'Mehta', 'rohan.mehta@example.com', '9876543212', '1982-11-05', 'Male', 'Ahmedabad', 'Gujarat', 640, '2021-05-10 14:00:00'),
(4, 'Ananya', 'Iyer', 'ananya.iyer@example.com', '9876543213', '1996-02-18', 'Female', 'Bengaluru', 'Karnataka', 745, '2021-07-22 09:45:00'),
(5, 'Vikram', 'Singh', 'vikram.singh@example.com', '9876543214', '1975-06-30', 'Male', 'Jaipur', 'Rajasthan', 590, '2021-09-05 16:20:00'),
(6, 'Neha', 'Patel', 'neha.patel@example.com', '9876543215', '1990-12-14', 'Female', 'Surat', 'Gujarat', 720, '2022-01-12 10:00:00'),
(7, 'Amit', 'Kumar', 'amit.kumar@example.com', '9876543216', '1985-09-08', 'Male', 'Patna', 'Bihar', 670, '2022-03-18 12:30:00'),
(8, 'Sneha', 'Reddy', 'sneha.reddy@example.com', '9876543217', '1995-05-21', 'Female', 'Hyderabad', 'Telangana', 830, '2022-06-25 15:10:00'),
(9, 'Rahul', 'Nair', 'rahul.nair@example.com', '9876543218', '1989-07-19', 'Male', 'Kochi', 'Kerala', 760, '2022-08-30 11:40:00'),
(10, 'Pooja', 'Das', 'pooja.das@example.com', '9876543219', '1992-10-02', 'Female', 'Kolkata', 'West Bengal', 610, '2022-11-14 13:50:00'),
(11, 'Kunal', 'Joshi', 'kunal.joshi@example.com', '9876543220', '1979-03-11', 'Male', 'Pune', 'Maharashtra', 795, '2023-01-10 10:20:00'),
(12, 'Divya', 'Chawla', 'divya.chawla@example.com', '9876543221', '1998-01-29', 'Female', 'Chandigarh', 'Punjab', 710, '2023-04-05 14:15:00'),
(13, 'Suresh', 'Gupta', 'suresh.gupta@example.com', '9876543222', '1968-12-03', 'Male', 'Lucknow', 'Uttar Pradesh', 540, '2023-06-19 16:45:00'),
(14, 'Tanvi', 'Deshmukh', 'tanvi.deshmukh@example.com', '9876543223', '1994-04-17', 'Female', 'Nagpur', 'Maharashtra', 775, '2023-09-01 11:00:00'),
(15, 'Manish', 'Tiwari', 'manish.tiwari@example.com', '9876543224', '1987-08-09', 'Male', 'Bhopal', 'Madhya Pradesh', 690, '2023-11-20 15:30:00');

INSERT INTO accounts (account_id, customer_id, account_type, balance, status, branch_code, opened_date)
VALUES
(101, 1, 'Savings', 125000.50, 'Active', 'BR001', '2021-01-16'),
(102, 1, 'Fixed Deposit', 500000.00, 'Active', 'BR001', '2021-06-10'),
(103, 2, 'Salary', 95400.00, 'Active', 'BR002', '2021-03-21'),
(104, 2, 'Savings', 420000.00, 'Active', 'BR002', '2021-08-15'),
(105, 3, 'Current', 45000.75, 'Active', 'BR003', '2021-05-12'),
(106, 4, 'Savings', 215000.00, 'Active', 'BR004', '2021-07-25'),
(107, 5, 'Savings', 12000.00, 'Dormant', 'BR005', '2021-09-10'),
(108, 6, 'Savings', 88500.25, 'Active', 'BR003', '2022-01-15'),
(109, 6, 'Fixed Deposit', 300000.00, 'Active', 'BR003', '2022-04-01'),
(110, 7, 'Salary', 34500.00, 'Active', 'BR006', '2022-03-20'),
(111, 8, 'Savings', 650000.00, 'Active', 'BR007', '2022-06-28'),
(112, 8, 'Current', 180000.00, 'Active', 'BR007', '2022-09-15'),
(113, 9, 'Savings', 74000.00, 'Active', 'BR008', '2022-09-02'),
(114, 10, 'Savings', 8500.00, 'Frozen', 'BR009', '2022-11-18'),
(115, 11, 'Savings', 310000.00, 'Active', 'BR001', '2023-01-12'),
(116, 11, 'Fixed Deposit', 800000.00, 'Active', 'BR001', '2023-03-01'),
(117, 12, 'Salary', 52000.00, 'Active', 'BR010', '2023-04-08'),
(118, 13, 'Current', 1500.00, 'Dormant', 'BR011', '2023-06-22'),
(119, 14, 'Savings', 145000.00, 'Active', 'BR001', '2023-09-05'),
(120, 15, 'Savings', 67500.00, 'Active', 'BR012', '2023-11-22');

INSERT INTO loan (loan_id, customer_id, loan_type, loan_amount, interest_rate, term_months, monthly_emi, start_date, loan_status)
VALUES
(201, 1, 'Home', 4500000.00, 8.40, 240, 38780.00, '2021-08-01', 'In Progress'),
(202, 2, 'Auto', 800000.00, 9.10, 60, 16650.00, '2022-02-15', 'In Progress'),
(203, 3, 'Business', 1500000.00, 12.50, 48, 39880.00, '2021-10-10', 'Defaulted'),
(204, 4, 'Education', 1200000.00, 7.80, 84, 18600.00, '2022-04-20', 'In Progress'),
(205, 5, 'Personal', 300000.00, 14.00, 36, 10250.00, '2021-11-05', 'Defaulted'),
(206, 6, 'Personal', 250000.00, 13.50, 24, 11950.00, '2022-05-10', 'Fully Paid'),
(207, 7, 'Auto', 650000.00, 9.25, 60, 13580.00, '2022-07-01', 'In Progress'),
(208, 8, 'Home', 6000000.00, 8.25, 240, 51100.00, '2023-01-15', 'In Progress'),
(209, 9, 'Personal', 400000.00, 13.00, 36, 13480.00, '2023-03-10', 'In Progress'),
(210, 11, 'Business', 2000000.00, 11.75, 60, 44250.00, '2023-05-20', 'In Progress'),
(211, 13, 'Personal', 200000.00, 14.50, 24, 9650.00, '2023-08-10', 'Defaulted'),
(212, 14, 'Education', 900000.00, 8.00, 60, 18250.00, '2023-10-01', 'In Progress');

INSERT INTO transaction (transaction_id, account_id, transaction_type, amount, transaction_date, channel, status, description)
VALUES
(1, 101, 'Deposit', 50000.00, '2024-01-05 10:15:00', 'NetBanking', 'Success', 'Salary Credit from employer'),
(2, 101, 'Withdrawal', 10000.00, '2024-01-08 14:22:00', 'ATM', 'Success', 'Cash withdrawal at ATM Mumbai'),
(3, 101, 'Transfer_Out', 38780.00, '2024-01-10 09:00:00', 'AutoDebit', 'Success', 'Home Loan EMI AutoDebit'),
(4, 101, 'Deposit', 75000.00, '2024-02-01 11:30:00', 'NetBanking', 'Success', 'Consulting fees deposit'),
(5, 101, 'Transfer_Out', 15000.00, '2024-02-14 18:45:00', 'UPI', 'Success', 'Family maintenance transfer'),
(6, 103, 'Deposit', 95400.00, '2024-01-01 08:00:00', 'NetBanking', 'Success', 'Monthly Salary Credit'),
(7, 103, 'Transfer_Out', 16650.00, '2024-01-05 10:00:00', 'AutoDebit', 'Success', 'Auto Loan EMI debit'),
(8, 103, 'Withdrawal', 5000.00, '2024-01-12 16:30:00', 'ATM', 'Success', 'ATM withdrawal Delhi'),
(9, 104, 'Deposit', 100000.00, '2024-02-10 12:10:00', 'Branch', 'Success', 'High value cash deposit'),
(10, 104, 'Transfer_In', 25000.00, '2024-02-18 15:40:00', 'UPI', 'Success', 'Stock dividend payout'),
(11, 105, 'Deposit', 120000.00, '2024-01-15 11:00:00', 'NetBanking', 'Success', 'Client invoice payment'),
(12, 105, 'Withdrawal', 40000.00, '2024-01-18 13:20:00', 'Branch', 'Success', 'Vendor cash payout'),
(13, 105, 'Transfer_Out', 39880.00, '2024-01-20 10:00:00', 'AutoDebit', 'Failed', 'Business Loan EMI bounced - Low funds'),
(14, 105, 'Deposit', 30000.00, '2024-02-05 14:50:00', 'UPI', 'Success', 'Client payment receipt'),
(15, 106, 'Deposit', 65000.00, '2024-01-03 09:30:00', 'NetBanking', 'Success', 'Software project milestone'),
(16, 106, 'Transfer_Out', 18600.00, '2024-01-10 09:15:00', 'AutoDebit', 'Success', 'Education Loan EMI debit'),
(17, 106, 'Transfer_Out', 2500.00, '2024-01-22 20:10:00', 'UPI', 'Success', 'Utility bill payment'),
(18, 106, 'Deposit', 45000.00, '2024-02-02 10:05:00', 'NetBanking', 'Success', 'Monthly stipend credit'),
(19, 107, 'Transfer_Out', 10250.00, '2024-01-05 09:00:00', 'AutoDebit', 'Failed', 'Personal Loan EMI bounced - Insufficient balance'),
(20, 107, 'Withdrawal', 2000.00, '2024-01-28 17:15:00', 'ATM', 'Failed', 'Transaction declined account dormant'),
(21, 108, 'Deposit', 40000.00, '2024-01-07 10:45:00', 'NetBanking', 'Success', 'Consultancy fee credit'),
(22, 108, 'Withdrawal', 8000.00, '2024-01-16 12:00:00', 'ATM', 'Success', 'Cash withdrawal Surat'),
(23, 108, 'Transfer_Out', 5500.00, '2024-02-04 19:25:00', 'UPI', 'Success', 'Online shopping payment'),
(24, 110, 'Deposit', 34500.00, '2024-01-01 08:30:00', 'NetBanking', 'Success', 'Govt employee salary credit'),
(25, 110, 'Transfer_Out', 13580.00, '2024-01-07 10:00:00', 'AutoDebit', 'Success', 'Auto Loan EMI debit'),
(26, 110, 'Withdrawal', 10000.00, '2024-01-15 11:20:00', 'Branch', 'Success', 'Counter cash withdrawal'),
(27, 111, 'Deposit', 350000.00, '2024-01-02 11:15:00', 'NetBanking', 'Success', 'Real estate investment return'),
(28, 111, 'Transfer_Out', 51100.00, '2024-01-15 09:00:00', 'AutoDebit', 'Success', 'Luxury Home Loan EMI'),
(29, 112, 'Deposit', 200000.00, '2024-01-20 14:00:00', 'NetBanking', 'Success', 'Business revenue deposit'),
(30, 112, 'Transfer_Out', 75000.00, '2024-01-25 16:30:00', 'NetBanking', 'Success', 'Vendor supply payment'),
(31, 111, 'Transfer_Out', 50000.00, '2024-02-12 18:00:00', 'UPI', 'Success', 'Investment into mutual funds'),
(32, 113, 'Deposit', 60000.00, '2024-01-04 10:10:00', 'NetBanking', 'Success', 'Salary credit'),
(33, 113, 'Transfer_Out', 13480.00, '2024-01-10 09:30:00', 'AutoDebit', 'Success', 'Personal Loan EMI'),
(34, 113, 'Withdrawal', 15000.00, '2024-01-26 15:45:00', 'ATM', 'Success', 'ATM cash withdrawal Kochi'),
(35, 114, 'Transfer_In', 20000.00, '2024-01-11 12:00:00', 'UPI', 'Failed', 'Account status is frozen'),
(36, 115, 'Deposit', 180000.00, '2024-01-06 13:25:00', 'NetBanking', 'Success', 'Contractual payout credit'),
(37, 115, 'Transfer_Out', 44250.00, '2024-01-20 09:00:00', 'AutoDebit', 'Success', 'Business Loan EMI debit'),
(38, 115, 'Withdrawal', 25000.00, '2024-02-08 11:40:00', 'ATM', 'Success', 'ATM withdrawal Pune'),
(39, 117, 'Deposit', 52000.00, '2024-01-01 07:30:00', 'NetBanking', 'Success', 'Monthly salary credit'),
(40, 117, 'Withdrawal', 12000.00, '2024-01-14 17:00:00', 'ATM', 'Success', 'Personal shopping withdrawal'),
(41, 118, 'Transfer_Out', 9650.00, '2024-01-10 09:00:00', 'AutoDebit', 'Failed', 'Personal Loan EMI bounced - Insufficient balance'),
(42, 119, 'Deposit', 80000.00, '2024-01-03 12:00:00', 'NetBanking', 'Success', 'Client deposit'),
(43, 119, 'Transfer_Out', 18250.00, '2024-01-08 10:00:00', 'AutoDebit', 'Success', 'Education Loan EMI payment'),
(44, 120, 'Deposit', 45000.00, '2024-01-05 14:10:00', 'NetBanking', 'Success', 'Freelance payment'),
(45, 120, 'Withdrawal', 7000.00, '2024-01-19 16:30:00', 'ATM', 'Success', 'Weekend cash withdrawal');

-- ---------------------------------------------------------------------
-- 4. CREATE VIEWS
-- ---------------------------------------------------------------------
CREATE VIEW vw_customer_360 AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    c.state,
    c.credit_score,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    COALESCE(SUM(a.balance), 0.00) AS total_account_balance,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    COALESCE(SUM(CASE WHEN l.loan_status IN ('Disbursed', 'In Progress', 'Defaulted') THEN l.loan_amount ELSE 0 END), 0.00) AS total_active_debt,
    CASE 
        WHEN COALESCE(SUM(a.balance), 0) >= 1000000 THEN 'Platinum / HNI'
        WHEN COALESCE(SUM(a.balance), 0) >= 250000 THEN 'Gold'
        WHEN COALESCE(SUM(a.balance), 0) >= 50000 THEN 'Silver'
        ELSE 'Standard'
    END AS customer_tier
FROM customer c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN loan l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, c.state, c.credit_score;

-- ---------------------------------------------------------------------
-- 5. QUICK VERIFICATION QUERIES
-- ---------------------------------------------------------------------
SELECT '--- TABLE COUNTS ---' AS check_summary;
SELECT 
    (SELECT COUNT(*) FROM customer) AS total_customers,
    (SELECT COUNT(*) FROM accounts) AS total_accounts,
    (SELECT COUNT(*) FROM transaction) AS total_transactions,
    (SELECT COUNT(*) FROM loan) AS total_loans;

SELECT '--- TOP CUSTOMER 360 PROFILES ---' AS check_summary;
SELECT * FROM vw_customer_360 ORDER BY total_account_balance DESC LIMIT 5;
