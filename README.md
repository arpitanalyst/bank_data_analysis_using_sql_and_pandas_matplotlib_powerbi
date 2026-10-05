# bank_data_analysis_using_sql_and_pandas_matplotlib_powerbi
This project focuses on analyzing banking transaction and customer data to identify important patterns, trends, and business insights.
# 🏦 Bank Analysis — Data Analytics Project

![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Analysis-150458?logo=pandas)
![NumPy](https://img.shields.io/badge/NumPy-Scientific%20Computing-013243?logo=numpy)
![Matplotlib](https://img.shields.io/badge/Matplotlib-Visualization-11557c)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-orange?logo=jupyter)
![GitHub](https://img.shields.io/badge/GitHub-Repository-black?logo=github)

> **An Exploratory Data Analysis project focused on understanding customer behavior, transaction patterns, financial categories, and credit-related insights using Python.**

---

## 📌 Project Overview

The **Bank Analysis** project analyzes banking and customer-related data to discover meaningful patterns and business insights.

The project follows a complete data analytics workflow:

**Raw Data → Data Cleaning → EDA → KPI Analysis → Visualization → Business Insights**

The analysis is performed using **Python, Pandas, NumPy, Matplotlib, and Jupyter Notebook**.

---

## 🎯 Business Objectives

The main objectives of this project are:

* Analyze customer transaction behavior
* Understand transaction types and categories
* Analyze credit scores
* Identify customer segments
* Study education and financial behavior
* Detect outliers and unusual records
* Understand relationships between numerical variables
* Identify patterns that can support banking decisions
* Convert raw data into actionable business insights

---

## 🛠️ Tech Stack

| Technology          | Purpose                      |
| ------------------- | ---------------------------- |
| 🐍 Python           | Data analysis                |
| 🐼 Pandas           | Data cleaning & manipulation |
| 🔢 NumPy            | Numerical analysis           |
| 📊 Matplotlib       | Data visualization           |
| 📓 Jupyter Notebook | Analysis environment         |
| 🔧 Git              | Version control              |
| 🐙 GitHub           | Project hosting              |

---

# 📂 Project Structure

```text
Bank-Analysis/
│
├── Bank_Analysis.ipynb
├── Bank_Data.csv
├── README.md
├── requirements.txt
│
└── images/
    ├── transaction_analysis.png
    ├── credit_score.png
    ├── customer_analysis.png
    └── charts.png
```

---

# 🔄 Data Analytics Workflow

```text
                ┌───────────────┐
                │   Raw Data    │
                └───────┬───────┘
                        ↓
                ┌───────────────┐
                │ Data Cleaning │
                └───────┬───────┘
                        ↓
                ┌───────────────┐
                │     EDA       │
                └───────┬───────┘
                        ↓
                ┌───────────────┐
                │ KPI Analysis  │
                └───────┬───────┘
                        ↓
                ┌───────────────┐
                │ Visualization │
                └───────┬───────┘
                        ↓
                ┌───────────────┐
                │   Insights    │
                └───────────────┘
```

---

# 🧹 Data Cleaning

The following data-cleaning techniques were performed:

* Checked dataset shape
* Checked data types
* Identified missing/null values
* Handled missing values using appropriate techniques
* Identified duplicate records
* Removed duplicate records where required
* Checked unique values
* Standardized column names
* Checked inconsistent categorical values
* Investigated potential outliers

### Example

```python
df.isnull().sum()
```

```python
df.duplicated().sum()
```

```python
df.drop_duplicates(inplace=True)
```

---

# 📊 KPIs

The following KPIs can be
