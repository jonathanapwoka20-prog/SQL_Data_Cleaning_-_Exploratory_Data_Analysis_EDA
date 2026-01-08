# SQL Data Cleaning & Exploratory Data Analysis  
## Global Company Layoffs During the COVID-19 Era

**Author:** Jonathan Apwoka  
**Role Focus:** Data Analyst | Financial Analyst | Finance Operations | SQL  
**Tools:** SQL (CTEs, Window Functions), CSV  
**Data Source:** Kaggle  

---

## 📌 Table of Contents
1. [Project Overview](#project-overview)
2. [Dataset Description](#dataset-description)
3. [Project Objectives](#project-objectives)
4. [Data Cleaning Strategy](#data-cleaning-strategy)
5. [Step-by-Step Data Cleaning Process](#step-by-step-data-cleaning-process)
    - 5.1 [Staging Tables & Row Identification](#51-staging-tables--row-identification)
    - 5.2 [Duplicate Detection](#52-duplicate-detection)
    - 5.3 [Duplicate Removal](#53-duplicate-removal)
    - 5.4 [Data Standardization](#54-data-standardization)
    - 5.5 [Handling Missing Values](#55-handling-missing-values)
    - 5.6 [Removing Non-Analytical Records](#56-removing-non-analytical-records)
6. [Final Clean Dataset](#final-clean-dataset)
7. [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
    - 7.1 [Timeframe Analysis](#71-timeframe-analysis)
    - 7.2 [Maximum Layoffs & 100% Layoff Events](#72-maximum-layoffs--100-layoff-events)
    - 7.3 [Funding vs Layoffs](#73-funding-vs-layoffs)
    - 7.4 [Company-Level Analysis](#74-company-level-analysis)
    - 7.5 [Industry-Level Analysis](#75-industry-level-analysis)
    - 7.6 [Country-Level Analysis](#76-country-level-analysis)
    - 7.7 [Yearly & Monthly Layoff Trends](#77-yearly--monthly-layoff-trends)
    - 7.8 [Company Stage Analysis](#78-company-stage-analysis)
8. [Key Insights & COVID-19 Context](#key-insights--covid-19-context)
9. [Skills Demonstrated](#skills-demonstrated)
10. [How to Reproduce This Project](#how-to-reproduce-this-project)

---

## Project Overview

This project demonstrates a **complete SQL-based data cleaning and exploratory analysis workflow** using a real-world dataset on company layoffs during the COVID-19 pandemic.

The primary objective was to transform a **raw, inconsistent CSV dataset** into a **clean, analysis-ready table**, then extract insights that explain how layoffs evolved across:
- Time
- Industries
- Countries
- Company funding stages
- Company size and funding levels

The project emphasizes **best practices used in real analytics environments**, including staging tables, validation queries, CTEs, and business-driven interpretation of results.

---

## Dataset Description

- **Source:** Kaggle.com  
- **File:** `layoffs.csv`  
- **Granularity:** Company-level layoff events  
- **Time Period:** COVID-19 era  

### Key Columns
| Column | Description |
|------|------------|
| company | Company name |
| location | City or region |
| industry | Industry classification |
| total_laid_off | Number of employees laid off |
| percentage_laid_off | Percentage of workforce laid off |
| date | Layoff announcement date |
| stage | Company funding stage |
| country | Country |
| funds_raised_millions | Total funding raised (USD millions) |

---

## Project Objectives

- Clean and standardize raw layoff data using SQL
- Identify and remove duplicate records
- Handle missing and inconsistent values logically
- Prepare a reliable dataset for analysis
- Perform exploratory analysis aligned with real-world COVID-19 events
- Translate SQL outputs into business and economic insights

---

## Data Cleaning Strategy

All transformations were performed **directly in SQL**, following these principles:

- Never modify raw data directly
- Use **staging tables** for traceability
- Validate results at every step
- Prioritize analytical integrity over aggressive data removal

---

## Step-by-Step Data Cleaning Process

### 5.1 Staging Tables & Row Identification

The raw dataset did not include a unique identifier.  
To ensure row-level traceability, a **staging table** was created and a **row number surrogate key** was introduced.

**Why this matters:**
- Enables safe duplicate detection
- Prevents accidental deletion of valid records
- Mirrors production-grade SQL workflows

📸 *Recommended Screenshot:*  
- PDF section showing staging table creation and `ROW_NUMBER()` logic

---

### 5.2 Duplicate Detection

Duplicates were identified using a **CTE with window functions**, partitioning by:
- Company
- Location
- Industry
- Date
- Layoff metrics

Records with `ROW_NUMBER() > 1` were flagged as duplicates.

Manual validation queries were run for companies such as:
- Casper  
- Cazoo  
- Hibob  
- Wildlife Studios  
- Yahoo  

This ensured only **true duplicates** were targeted.

📸 *Recommended Screenshot:*  
- CTE output highlighting duplicate rows

---

### 5.3 Duplicate Removal

A second staging table (`layoffs_staging2`) was created with a permanent row number column.  
Duplicates were deleted safely using conditional logic.

**Post-deletion validation** confirmed:
- Duplicates removed
- Original data integrity preserved

📸 *Recommended Screenshot:*  
- DELETE statement and post-cleaning table output

---

### 5.4 Data Standardization

The following standardization steps were applied:

- Trimmed whitespace from text fields
- Standardized capitalization
- Converted dates to proper DATE format
- Extracted numeric values from text where necessary
- Updated column data types for analysis

**Why this matters:**  
Ensures accurate grouping, filtering, and time-series analysis.

📸 *Recommended Screenshot:*  
- TRIM, UPDATE, and ALTER TABLE statements

---

### 5.5 Handling Missing Values

Example: **Airbnb Industry Completion**

Some Airbnb records had missing industry values.  
These were populated using:
- Existing Airbnb records
- Same geographic locations

This approach preserved accuracy without introducing assumptions.

📸 *Recommended Screenshot:*  
- UPDATE statements handling missing industries

---

### 5.6 Removing Non-Analytical Records

Rows where **both**:
- `total_laid_off`
- `percentage_laid_off`

were NULL or blank were removed.

**Reason:**  
Such rows do not contribute to meaningful layoff analysis.

📸 *Recommended Screenshot:*  
- DELETE logic for removing unusable rows

---

## Final Clean Dataset

After completing all cleaning steps, the dataset was fully standardized, deduplicated, and ready for analysis.

📸 *Recommended Screenshot:*  
- Final cleaned table preview

---

## Exploratory Data Analysis (EDA)

### 7.1 Timeframe Analysis

The earliest and latest layoff dates were identified to confirm the pandemic coverage period.

**Insight:**  
The dataset spans the core COVID-19 disruption period, including lockdowns, recovery phases, and post-pandemic restructuring.

📸 *Recommended Screenshot:*  
- MIN(date) / MAX(date) output

---

### 7.2 Maximum Layoffs & 100% Layoff Events

Analysis identified:
- Companies with the highest total layoffs
- Companies that laid off **100% of their workforce**

**COVID-19 Context:**  
Many 100% layoff cases occurred in early-stage or travel-dependent businesses during lockdowns.

📸 *Recommended Screenshot:*  
- Max layoffs and percentage layoffs output

---

### 7.3 Funding vs Layoffs

Companies with 100% layoffs were analyzed against funds raised.

**Key Insight:**  
High funding levels did not guarantee survival during the pandemic.

📸 *Recommended Screenshot:*  
- Funds raised vs layoffs output

---

### 7.4 Company-Level Analysis

Top companies by total layoffs were identified.

**Interpretation:**  
Larger firms executed mass layoffs as cost-control measures during economic uncertainty.

📸 *Recommended Screenshot:*  
- Company aggregation output

---

### 7.5 Industry-Level Analysis

- Top 5 hardest-hit industries
- Bottom 5 least-affected industries

**COVID-19 Insight:**  
Travel, consumer tech, and crypto-related sectors were heavily impacted, while defensive industries showed resilience.

📸 *Recommended Screenshot:*  
- Industry aggregation output

---

### 7.6 Country-Level Analysis

Countries were ranked by total layoffs:
- Most affected
- Least affected
- Mid-tier impact countries

**Interpretation:**  
Layoff severity reflected lockdown policies, economic structure, and labor market flexibility.

📸 *Recommended Screenshot:*  
- Country-level aggregation output

---

### 7.7 Yearly & Monthly Layoff Trends

- Layoffs per year
- Monthly layoffs
- Rolling cumulative layoffs using CTEs

**Key Observation:**  
Sharp spikes align with major COVID-19 waves and lockdown announcements.

📸 *Recommended Screenshot:*  
- Rolling sum CTE output

---

### 7.8 Company Stage Analysis

Layoffs were analyzed by funding stage.

**Insight:**  
- Early-stage companies showed higher vulnerability
- Late-stage firms used layoffs as strategic restructuring

📸 *Recommended Screenshot:*  
- Stage vs layoffs output

---

## Key Insights & COVID-19 Context

- Layoffs were uneven across industries and regions
- Funding size did not eliminate pandemic risk
- Early-stage companies were disproportionately affected
- Rolling metrics reveal clear crisis progression patterns
- SQL is sufficient for full lifecycle analytics when structured correctly

---

## Skills Demonstrated

- Advanced SQL (CTEs, Window Functions)
- Data cleaning and validation
- Analytical problem-solving
- Business interpretation of data
- Time-series and aggregate analysis
- COVID-19 economic impact analysis

---

## How to Reproduce This Project

1. Download `layoffs.csv` from Kaggle
2. Load the dataset into a SQL environment
3. Follow the staging → cleaning → EDA workflow
4. Reference screenshots for validation at each step

---

**This project is designed to be transparent, reproducible, and interview-ready.**
