-- AML Master Project
drop database master_project;
create database master_project;
use master_project;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(100),
    region VARCHAR(50),
    risk_level VARCHAR(10)
);

select * from customers;

CREATE TABLE Banks (
    bank_id INT PRIMARY KEY,
    name VARCHAR(100),
    region VARCHAR(50),
    compliance_score FLOAT
);

select * from banks;

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    bank_id INT,
    amount DECIMAL(15,2),
    currency VARCHAR(10),
    date DATE,
    location VARCHAR(100),
    is_high_risk BOOLEAN,
    is_valid_bank_id BOOLEAN
);

select * from transactions;

CREATE TABLE Sanctions (
    sanction_id INT PRIMARY KEY,
    bank_id INT,
    customer_id INT,
    sanction_date DATE,
    reason VARCHAR(200),
    is_valid_bank_id BOOLEAN
);

select * from sanctions;

-- 1. Use SQL queries to check for NULL values in each column

-- check null values in customers table
select 
    'customers' as table_name,
    count(*) as total_rows,
    sum(case when customer_id is null then 1 else 0 end) as null_customer_id,
    sum(case when name is null then 1 else 0 end) as null_name,
    sum(case when email is null then 1 else 0 end) as null_email,
    sum(case when phone is null then 1 else 0 end) as null_phone,
    sum(case when region is null then 1 else 0 end) as null_region,
    sum(case when risk_level is null then 1 else 0 end) as null_risk_level
from customers;

-- check null values in banks table
select 
    'banks' as table_name,
    count(*) as total_rows,
    sum(case when bank_id is null then 1 else 0 end) as null_bank_id,
    sum(case when name is null then 1 else 0 end) as null_name,
    sum(case when region is null then 1 else 0 end) as null_region,
    sum(case when compliance_score is null then 1 else 0 end) as null_compliance_score
from banks;

-- check null values in transactions table
select 
    'transactions' as table_name,
    count(*) as total_rows,
    sum(case when transaction_id is null then 1 else 0 end) as null_transaction_id,
    sum(case when customer_id is null then 1 else 0 end) as null_customer_id,
    sum(case when bank_id is null then 1 else 0 end) as null_bank_id,
    sum(case when amount is null then 1 else 0 end) as null_amount,
    sum(case when currency is null then 1 else 0 end) as null_currency,
    sum(case when date is null then 1 else 0 end) as null_date,
    sum(case when location is null then 1 else 0 end) as null_location,
    sum(case when is_high_risk is null then 1 else 0 end) as null_is_high_risk,
    sum(case when is_valid_bank_id is null then 1 else 0 end) as null_is_valid_bank_id
from transactions;

-- check null values in sanctions table
select 
    'sanctions' as table_name,
    count(*) as total_rows,
    sum(case when sanction_id is null then 1 else 0 end) as null_sanction_id,
    sum(case when bank_id is null then 1 else 0 end) as null_bank_id,
    sum(case when customer_id is null then 1 else 0 end) as null_customer_id,
    sum(case when sanction_date is null then 1 else 0 end) as null_sanction_date,
    sum(case when reason is null then 1 else 0 end) as null_reason,
    sum(case when is_valid_bank_id is null then 1 else 0 end) as null_is_valid_bank_id
from sanctions;

-- No null values on any tables

-- 2.	Run a query to find and remove duplicate rows based on transaction ID or customer ID

-- Find duplicate rows based on transaction_id
select 
    transaction_id,
    count(*) as duplicate_count
from 
    transactions
group by 
    transaction_id
having 
    count(*) > 1;

-- Find duplicate rows based on customer_id
select 
    customer_id,
    count(*) as duplicate_count
from 
    customers
group by 
    customer_id
having 
    count(*) > 1;

-- Find duplicate rows based on bank_id
select 
    bank_id,
    count(*) as duplicate_count
from 
    banks
group by 
    bank_id
having 
    count(*) > 1;

-- Find duplicate rows based on customer_id
select 
    sanction_id,
    count(*) as duplicate_count
from 
    sanctions
group by 
    sanction_id
having 
    count(*) > 1;



-- No duplicate values

-- Dates are already standardized so no need to do it again

-- Joining all tables
select 
    t.transaction_id,
    t.customer_id,
    c.name as customer_name,
    c.email as customer_email,
    c.phone as customer_phone,
    c.region as customer_region,
    c.risk_level as customer_risk_level,
    t.bank_id,
    b.name as bank_name,
    b.region as bank_region,
    b.compliance_score as bank_compliance_score,
    t.amount,
    t.currency,
    t.date as transaction_date,
    t.location as transaction_location,
    t.is_high_risk,
    t.is_valid_bank_id
from 
    transactions t
join 
    customers c on t.customer_id = c.customer_id
join 
    banks b on t.bank_id = b.bank_id;

------------------------------------------------

 