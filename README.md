# AML Transaction Risk Management Platform

A rule-based Anti-Money Laundering (AML) pipeline that integrates transaction monitoring, customer risk profiling, fraud detection, and compliance reporting using SQL and Tableau.

---

## Objective

Build an end-to-end AML data platform that ingests multi-source financial data, applies rule-based fraud detection logic across 4 relational tables, segments customers by risk, and produces compliance-ready reporting outputs — mirroring real-world transaction monitoring workflows used in financial institutions.

---

## Dataset

**Source:** [Synthetic Transaction Monitoring Dataset – Kaggle](https://www.kaggle.com/datasets/berkanoztas/synthetic-transaction-monitoring-dataset-aml)

| Table | Description |
|---|---|
| `transactions` | Transaction-level records with amount, currency, location, and risk flags |
| `customers` | Customer profiles with region and pre-assigned risk level |
| `banks` | Bank-level data including compliance scores |
| `sanctions` | Sanction records linked to customers and banks |

---

## Pipeline Overview

```
Raw CSVs → Schema Design → Data Quality Checks → Deduplication → 
Multi-Table Join → Feature Engineering → Fraud Rules → Risk Scoring → Compliance Output
```

### 1. Schema Design & Data Ingestion
- Designed a normalised 4-table relational schema: `Customers`, `Banks`, `Transactions`, `Sanctions`
- Loaded all source CSVs into a structured SQL database

### 2. Data Quality Checks
- Ran NULL audits across all columns in all 4 tables using conditional aggregation
- Checked for duplicate records on primary keys (`transaction_id`, `customer_id`, `bank_id`, `sanction_id`)
- Verified date standardisation and referential integrity across foreign keys
- Result: zero NULL values and zero duplicates — data quality confirmed before any analysis

### 3. Multi-Table Integration
- Joined all 4 tables into a unified analytical view using `transaction_id` as the base key
- Brought together customer risk level, bank compliance score, transaction amount, location, and sanction status in a single query output

### 4. Rule-Based Fraud Detection
Applied the following AML detection rules in SQL:
- **High-risk transaction flag** — transactions marked `is_high_risk = TRUE`
- **Invalid bank ID flag** — transactions routed through unverified bank IDs
- **Velocity check** *(added extension)* — flagged customer accounts with more than 5 transactions within a single calendar day, a recognised rapid-activity laundering pattern

### 5. Customer Risk Profiling
- Segmented customers into Low, Medium, and High risk groups based on `risk_level`
- Cross-referenced with `bank compliance_score` to identify customers transacting through low-compliance institutions

### 6. Compliance Reporting Output
- Produced a joined master table (`AML-joined-tables.csv`) consolidating all flagged transactions with full customer and bank context
- Visualised risk distribution, flagged transaction trends, and regional hotspots in Tableau (`Book1.twb`)

---

## Key Findings

- Data quality audit confirmed 0 NULL values and 0 duplicate records across all 4 tables — a pre-requisite for reliable AML rule execution
- Velocity check identified accounts breaching the 5-transaction/day threshold, surfacing rapid-activity patterns not captured by the base `is_high_risk` flag alone
- Cross-border transactions processed through low-compliance banks (`compliance_score < threshold`) showed disproportionate overlap with sanctioned customer records

---

## Tools & Technologies

| Layer | Tool |
|---|---|
| Data storage & querying | SQL (MySQL) |
| Data processing | SQL — joins, CASE statements, GROUP BY, window aggregations |
| Visualisation | Tableau |
| Data source | CSV (multi-table relational structure) |

---

## File Structure

```
├── AML-new.sql               # Full SQL pipeline: schema, quality checks, joins, fraud rules
├── AML-joined-tables.csv     # Master output: all tables joined, used for Tableau
├── transactions.csv          # Raw transaction data
├── customers.csv             # Customer profiles
├── banks.csv                 # Bank metadata and compliance scores
├── customer_profiles.csv     # Enriched customer profile data
├── preprocessed_aml_data.csv # Cleaned and preprocessed output
├── Book1.twb                 # Tableau workbook — risk dashboards
└── Meta Data for AML.xlsx    # Data dictionary and schema reference
```

---

## How to Run

1. Install MySQL (or any SQL client — DBeaver, MySQL Workbench)
2. Run `AML-new.sql` top to bottom — it creates the database, tables, loads data, runs all checks and fraud rules
3. Open `Book1.twb` in Tableau Desktop and connect to `AML-joined-tables.csv` as the data source to view dashboards

---

## Extension Added

Added a **velocity-based transaction frequency rule** to the SQL pipeline:

```sql
-- Velocity Check: Flag accounts with >5 transactions in a single day
SELECT 
    customer_id,
    COUNT(*) AS txn_count,
    MIN(date) AS window_start
FROM transactions
GROUP BY customer_id, date
HAVING COUNT(*) > 5;
```

This detects rapid transaction activity — a common structuring and layering pattern in AML — which is not captured by the base `is_high_risk` flag alone.