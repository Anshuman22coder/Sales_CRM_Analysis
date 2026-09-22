```markdown
# 📊 Sales Pipeline & Win-Loss Performance Analysis (SQL & Power BI)

An end-to-end data analytics project evaluating B2B sales pipeline conversion dynamics, sales team efficiency, quarterly trajectory, and product-line win rates across 8,800+ sales pipeline opportunities from October 2016 to December 2017[cite: 2].

---

## 📌 Project Overview
* **Objective:** Analyze deal conversion rates, evaluate sales manager and individual representative performance benchmarks, assess product portfolio win vs. loss distribution, and uncover quarterly engagement velocity[cite: 2].
* **Tech Stack:** Microsoft SQL Server (T-SQL), Power BI, Power Query (M), DAX[cite: 2, 3].
* **Key Metrics:** Overall Win Rate, Sales Team Win Rate, Agent Conversion %, Product Win/Loss Rates, Quarter-over-Quarter Deal Velocity[cite: 2].

---

## 📈 Key Metrics Summary
| Metric | Value | Business Interpretation |
| :--- | :--- | :--- |
| **Overall Deal Win Rate** | **48.16%** | Baseline conversion rate across all pipeline opportunities[cite: 2] |
| **Top Performing Team** | **52.07%** | Led by Rocco Neubert (691 won out of 1,327 pitched opportunities)[cite: 2] |
| **Lowest Converting Team** | **45.72%** | Managed by Melvin Marxen (882 won out of 1,929 pitched opportunities)[cite: 2] |
| **Top Converting Sales Agent** | **65.40%** | Reed Clapper (155 won out of 237 pitched opportunities)[cite: 2] |
| **Lowest Converting Sales Agent** | **40.84%** | Lajuana Vencill (127 won out of 311 pitched opportunities)[cite: 2] |
| **Highest Volume Product** | **GTX Basic** | 1,866 total deals with a 49.04% win rate[cite: 2] |
| **Underperforming Product** | **GTK 500** | Only 40 deals pitched; lowest conversion at 37.50% (62.50% loss rate)[cite: 2] |
| **Peak Sales Velocity Month** | **February 2017** | Recorded highest conversion volume with 1,385 won deals[cite: 2] |

---

## 🔍 Key SQL Queries & Logic

### 1. Overall Pipeline Win Rate
```sql
SELECT
    CAST(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales_pipeline)
        AS DECIMAL(4,2)
    ) AS won_no
FROM sales_pipeline 
WHERE deal_stage = 'Won';

```

### 2. Team Performance & Manager Benchmarking

```sql
SELECT 
    T.manager AS TEAM,
    COUNT(CASE WHEN S.deal_stage = 'Won' THEN 1 END) AS won_deals,
    COUNT(*) AS total_team_deals,
    CAST(
        COUNT(CASE WHEN S.deal_stage = 'Won' THEN 1 END) * 100.0 / COUNT(*) 
        AS DECIMAL(5,2)
    ) AS win_rate_percentage
FROM sales_pipeline S
JOIN sales_teams T 
    ON S.sales_agent = T.sales_agent
GROUP BY T.manager
ORDER BY win_rate_percentage DESC;

```

### 3. Sales Agent Conversion Distribution

```sql
SELECT 
    sales_agent,
    COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS won_cnt,
    COUNT(opportunity_id) AS total_cnt,
    CAST(
        COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) * 100.0 / COUNT(*) 
        AS DECIMAL(6,2)
    ) AS win_rate_percentage
FROM sales_pipeline
GROUP BY sales_agent 
ORDER BY win_rate_percentage ASC;

```

### 4. Product Portfolio Win vs. Loss Analysis

```sql
SELECT 
    product,
    COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS won_cnt,
    COUNT(CASE WHEN deal_stage <> 'Won' THEN 1 END) AS not_won_cnt,
    COUNT(opportunity_id) AS total_cnt,
    CAST(COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(6,2)) AS win_rate_percentage,
    CAST(COUNT(CASE WHEN deal_stage <> 'Won' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(6,2)) AS not_win_rate_percentage
FROM sales_pipeline                                     
GROUP BY product 
ORDER BY product;

```

### 5. Quarter-over-Quarter Pipeline Dynamics

```sql
SELECT 
    CONCAT(YEAR(engage_date), '-Q', DATEPART(QUARTER, engage_date)) AS engage_quarter,
    COUNT(*) AS WON
FROM sales_pipeline 
WHERE deal_stage = 'Won'
  AND engage_date IS NOT NULL
GROUP BY 
    CONCAT(YEAR(engage_date), '-Q', DATEPART(QUARTER, engage_date)),
    YEAR(engage_date),
    DATEPART(QUARTER, engage_date)
ORDER BY 
    YEAR(engage_date),
    DATEPART(QUARTER, engage_date);

```

---

## 💡 Business Findings & Insights

1. **Sales Leadership Disparity:**
* Conversion varies by **6.35%** across sales teams. Rocco Neubert’s team leads company-wide conversion at **52.07%**, whereas Melvin Marxen’s team handled the greatest deal volume (1,929 deals) but closed at **45.72%**. This indicates reps in higher volume territories face qualification bottlenecks.




2. **Rep Efficiency Spread:**
* A significant spread exists across individual sales agents, spanning from **65.40%** (Reed Clapper) down to **40.84%** (Lajuana Vencill). Top-quartile closers like Reed Clapper and Garret Kinder (>60%) establish standard practices for company-wide enablement.




3. **Product Line Viability:**
* The flagship **GTX series** consistently delivers between **47.22% and 49.48%** win rates. Meanwhile, **GTK 500** struggles with low pitch volume (40 deals) and a **62.50% loss rate**, highlighting a candidate for pricing adjustments or product retirement.




4. **Seasonal Engagement Spike:**
* Pipeline deal wins peaked sharply in **February 2017 (1,385 wins)** before settling into a consistent cadence between Q2 and Q3, guiding future marketing spend and pipeline ramp periods.





---

## 🖥️ Power BI Data Modeling & Visuals

### Data Model Architecture

* Joined `sales_pipeline` with `sales_teams` via `sales_agent` to enable team hierarchy filtering.


* Resolved chronological sorting in time-series visuals using an integer sort-by-column key (`YYYYMM`):
```dax
YearMonth_Key = YEAR(sales_pipeline[engage_date]) * 100 + MONTH(sales_pipeline[engage_date])

```



### Key DAX Measures

* **Total Won Deals:**
```dax
TotalWon = 
CALCULATE(
    COUNTROWS(sales_pipeline),
    sales_pipeline[deal_stage] = "Won"
)

```


* **Total Pipeline Opportunities:**
```dax
TotalAllDeals = 
CALCULATE(
    COUNTROWS(sales_pipeline),
    ALL(sales_pipeline[deal_stage])
)

```


* **Win Rate %:**
```dax
Won_Rate_% = 
DIVIDE([TotalWon], [TotalAllDeals], 0)

```



---

### Dashboard Previews

#### Page 1: Sales Performance & KPI Overview

*Deal conversion rates, manager benchmark table, and product win vs. loss distributions.*
![Home page](<Dashboards\Dashboard1.png>)

---

#### Page 2: Pipeline Velocity & Time Intelligence

*Quarter-over-quarter deal progress, monthly engagement volume, and sales rep rankings.*
![Main KPIs page](<Dashboards\Dashboard2.png>)
---

## 🚀 How to Run Locally

1. Clone the repository:
```bash
git clone https://github.com/Anshuman22coder/Sales_CRM_Analysis.git

```


2. Open and execute the SQL scripts in Microsoft SQL Server Management Studio (SSMS) against your database.


3. Open `SALES_REPORT.pbix` in Power BI Desktop to explore the interactive visual reports.



```

```