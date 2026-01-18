# SQL Data Cleaning & Exploratory Data Analysis  
## Global Company Layoffs During the COVID-19 Era

**Role Focus:** Data Analyst | Financial Analyst | Finance Operations | SQL  
**Tools:** MySQL Workbench (CTEs, Window Functions), CSV  
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
9. [Recommendations Based on EDA Analyis](#recommendations-based-on-eda-analyis)
10. [Skills Demonstrated](#skills-demonstrated)

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

 <img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/83770e47-e0cb-4782-8819-c104af2027fa" />
 
- A screenshot showing staging table creation and `ROW_NUMBER()` logic

---

### 5.2 Duplicate Detection

Duplicates were identified using a **CTE with window functions**, partitioning by:
- Company | Location | Industry | Date | Layoff metrics

Records with `ROW_NUMBER() > 1` were flagged as duplicates.

Manual validation queries were run for companies such as:
- Casper | Cazoo | Hibob | Wildlife Studios | Yahoo  

This ensured only **true duplicates** were targeted.

 <img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/e9763f75-2df5-413b-b0cd-d6c5a0f9be0d" />

- CTE output highlighting duplicate rows

---

### 5.3 Duplicate Removal

A second staging table (`layoffs_staging2`) was created with a permanent row number column.  
Duplicates were deleted safely using conditional logic.

**Post-deletion validation** confirmed:
- Duplicates removed
- Original data integrity preserved

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/fadcf7b9-b073-4030-9d7a-b0c80c61c801" />
- DELETE statement and post-cleaning table output print Code

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

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/dbe656ad-5f56-427f-b7b7-46ec177f2a8e" />
- TRIM, UPDATE, and ALTER TABLE statements

---

### 5.5 Handling Missing Values

Example: **Airbnb Industry Completion**

Some Airbnb records had missing industry values.  
These were populated using:
- Existing Airbnb records
- Same geographic locations

This approach preserved accuracy without introducing assumptions.

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/bc58546f-80a4-4942-bb09-96db46ee36a6" />
- UPDATE statements handling missing industries

---

### 5.6 Removing Non-Analytical Records

Rows where **both**:
- `total_laid_off`
- `percentage_laid_off`

were NULL or blank were removed.

**Reason:**  
Such rows do not contribute to meaningful layoff analysis.

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/f93e0756-6200-45eb-92eb-523195d68c50" />
- DELETE logic for removing unusable rows

---

## Final Clean Dataset

After completing all cleaning steps, the dataset was fully standardized, deduplicated, and ready for analysis.

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/c58cffa5-4e93-4411-a28a-df0cd9b21a80" />
- Final cleaned table preview

---

## Exploratory Data Analysis (EDA)

### 7.1 Timeframe Analysis

The earliest and latest layoff dates were identified to confirm the pandemic coverage period.

**Insight:**  
The dataset spans the core COVID-19 disruption period, including lockdowns, recovery phases, and post-pandemic restructuring.

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/36e78251-3cce-4795-9b23-949d893184fe" />
- MIN(date) / MAX(date) output

---

### 7.2 Maximum Layoffs & 100% Layoff Events

Analysis identified:
- Companies with the highest total layoffs
- Companies that laid off **100% of their workforce**

**COVID-19 Context:**  
Many 100% layoff cases occurred in early-stage or travel-dependent businesses during lockdowns.

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/d9189eb0-3942-453b-906a-b0cdd20dbfce" />
- Max layoffs and percentage layoffs output (1 reps 100%)

---

### 7.3 Funding vs Layoffs

Companies with 100% layoffs were analyzed against funds raised.

**Key Insight:**  
High funding levels did not guarantee survival during the pandemic.

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/c79cb117-df19-4d9e-9daf-57343abb7278" />
- Funds raised vs layoffs output

---

### 7.4 Company-Level Analysis

Top companies by total layoffs were identified.

**Interpretation:**  
Larger firms executed mass layoffs as cost-control measures during economic uncertainty.

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/7ea00282-6f9c-4856-8707-f268c7463131" />
- Company aggregation output

---

### 7.5 Industry-Level Analysis

- Top 5 hardest-hit industries
- Bottom 5 least-affected industries

**COVID-19 Insight:**  
Travel, consumer tech, and crypto-related sectors were heavily impacted, while defensive industries showed resilience.

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/9b05946b-f5f8-467b-beda-88532d60014b" />
- Industry aggregation output

---

### 7.6 Country-Level Analysis

Countries were ranked by total layoffs:
- Most affected
- Least affected
- Mid-tier impact countries

**Interpretation:**  
Layoff severity reflected lockdown policies, economic structure, and labor market flexibility.

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/43e0365a-9769-4878-8c78-431f8eac3577" />
- Country-level aggregation output

---

### 7.7 Yearly & Monthly Layoff Trends

- Layoffs per year
- Monthly layoffs
- Rolling cumulative layoffs using CTEs

**Key Observation:**  
Sharp spikes align with major COVID-19 waves and lockdown announcements.

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/b07208b9-77d9-4026-b612-46b9f0c33ff7" />
- Rolling sum

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/a62f25be-f20e-4968-9458-c2fc49d268ae" />
- CTE output

---

### 7.8 Company Stage Analysis

Layoffs were analyzed by funding stage.

**Insight:**  
- Early-stage companies showed higher vulnerability
- Late-stage firms used layoffs as strategic restructuring

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/562bb534-2a70-4871-b357-cb3188198df0" />
- Stage vs layoffs output

---

## 8. Key Insights & COVID-19 Context

* **Sectoral Vulnerability:** Layoffs were highly concentrated in the **Consumer (45,182)** and **Retail (43,613)** industries. High-profile tech giants in the **United States** bore the brunt of the volume, led by **Amazon (18,150)** and **Google (12,000)**.
* **Capital vs. Crisis Resilience:** Data reveals that massive funding did not guarantee workforce stability. Despite a **$12.9B funding pool** in 2022, **Twitter** executed a layoff of **3,700 staff**, the highest single-event total for that period.
* **Stage-Specific Risk:** Early-stage and late-growth companies faced disproportionate pressure. **Series H** companies saw **7,244** layoffs, while **Private Equity-backed firms** were also heavily impacted with **7,957** staff reductions.
* **Crisis Acceleration (Rolling Metrics):** Utilizing SQL rolling totals, the analysis shows a stark escalation:
    * **March 2020:** 9,628 total layoffs.
    * **December 2020:** 80,998 total layoffs (**741% spike** from early-pandemic levels).
    * **June 2021:** 91,421 total layoffs, reflecting the long-tail impact as companies scaled down or ceased operations permanently.
* **Technical Validation:** Demonstrated that a structured SQL lifecycle—from multi-layer staging to advanced EDA—is sufficient for enterprise-level crisis analytics.

---

## 9. Strategic Recommendations based on EDA Analysis

* **Industry Diversification:** Organizations and investors should diversify portfolios across sectors to mitigate the impact of industry-specific shocks, such as those seen in **Consumer and Retail**.
* **Beyond Capital Reserves:** Well-funded firms must strengthen crisis-response planning; this analysis proves that high liquidity alone is not a sufficient shield against pandemic-scale workforce disruption.
* **Resilience Frameworks for Growth-Stage Firms:** Early-stage and **Series H** companies require robust workforce sustainability frameworks to navigate the higher risk profile inherent in the growth pyramid.
* **Proactive Workforce Monitoring:** Implement the developed **SQL-driven analytics pipeline** for continuous monitoring of rolling metrics to anticipate crisis escalation and trigger proactive workforce adjustments.
* **Scenario-Based Planning:** Use the identified rolling layoff patterns to build predictive models for future economic downturns, allowing for more strategic scenario planning.

---
## Skills Demonstrated

- Advanced SQL (CTEs, Window Functions)
- Data cleaning and validation
- Analytical problem-solving
- Business interpretation of data
- Time-series and aggregate analysis
- COVID-19 economic impact analysis
