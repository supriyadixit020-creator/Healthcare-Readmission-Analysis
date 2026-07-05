<div align="center">

# 🏥 Healthcare Patient Readmission Analysis
### *Capstone Project — Predicting Who Comes Back, and Why*

[![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)](.)
[![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=flat-square&logo=microsoft-sql-server&logoColor=white)](.)
[![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat-square&logo=powerbi&logoColor=black)](.)
[![Feature Engineering](https://img.shields.io/badge/Feature_Engineering-8_New_Features-9B59B6?style=flat-square)](.)

`100,241 Patient Encounters` · `130 US Hospitals` · `10 Years of Data` · `8 Engineered Features`

</div>

---

## 🎯 The Clinical Problem

Hospital readmissions cost the US healthcare system over **$26 billion annually**. For diabetic patients specifically, the challenge is acute: complex medication regimens, glucose instability, and multiple comorbidities make post-discharge management genuinely difficult.

This capstone project builds a full analytics pipeline to answer the question every hospital administrator asks:

```
  🔴 Which patients are most likely to return — and what can we do before they leave?
```

---

## 🗂️ The Dataset

| | |
|---|---|
| **Source** | UCI Machine Learning Repository — 130 US Hospitals Dataset (1999–2008) |
| **Raw Records** | 101,766 patient encounters × 50 features |
| **After Cleaning** | 100,241 records × 44 base features |
| **After Engineering** | 100,241 records × 52 features (8 new) |
| **Target Variable** | `readmitted` — NO / >30 days / <30 days |

---

## ⚙️ What Made This Project Different: Feature Engineering

The raw dataset had coded IDs and numeric ranges — not analysis-ready features. Eight new columns were engineered from scratch:

```python
total_visits        = number_outpatient + number_emergency + number_inpatient
visit_category      = binned into: No / Low / Moderate / High Utilization
stay_category       = Short (<4 days) / Medium (4-7 days) / Long (>7 days)
medication_load     = Low (<10 meds) / Medium (10-20) / High (>20)
diagnosis_complexity= derived from number_diagnoses
age_midpoint        = numeric midpoint extracted from age bracket string
readmission_binary  = 0/1 from categorical readmitted column
admission_type      = human-readable via SQL JOIN on IDS_mapping table
```

> The `admission_type` column was created using a **SQL JOIN** between the patient data and a separate IDS mapping table — demonstrating relational data integration, not just single-table analysis.

---

## 🧹 Cleaning Decisions

```python
✓ Removed 1,525 records with '?' in critical diagnostic columns
✓ Dropped weight column (96.9% missing — not recoverable)
✓ Dropped payer_code (39.6% missing — non-critical for this analysis)
✓ Dropped max_glu_serum and A1Cresult (94.7% and 83.3% missing)
✓ Removed 3 records with 'Unknown/Invalid' gender
✓ Dropped columns with near-zero variance (examide, citoglipton)
✓ Verified: 0 remaining nulls, 0 duplicates in final dataset
```

---

## 📊 What the Data Revealed

<div align="center">

| Total Encounters | Readmission Rate | <30-Day Rate | Emergency Readmission |
|:---:|:---:|:---:|:---:|
| **100,241** | **46.31%** | **11.22%** | **47.49%** |

</div>

### The Five Findings That Matter

**1. Emergency admissions dominate both volume and readmission risk**

```
Emergency    ████████████████████████████  47.49% readmission  (27,958 patients)
Urgent       ████████████████████████████  46.43%              (10,942 patients)
Elective     █████████████████████████     40.99%               (9,752 patients)
```

**2. Age alone doesn't tell the whole story**

| Age Group | Readmission Rate |
|---|:---:|
| [80-90) | **48.26%** |
| [70-80) | **48.21%** |
| [60-70) | 46.38% |
| [0-10) | 21.54% ← lowest |

→ Elderly patients are at highest risk, but even younger age groups show rates above 40%.

**3. Prior visit history is the strongest predictor (r = 0.205)**

```
number_diagnoses   ████████████   r = 0.107  (2nd strongest)
total_visits       ████████████████████   r = 0.205  (STRONGEST)
num_medications    ████████   r = 0.043
time_in_hospital   ██████   r = 0.049
age_midpoint       ████   r = 0.024
```

→ A patient's history of healthcare utilization predicts readmission **better than any clinical measurement**.

**4. Insulin dose changes signal instability**

| Insulin Status | Readmission Rate |
|---|:---:|
| 🔴 Down (dose reduced) | **52.88%** |
| 🔴 Up (dose increased) | **51.68%** |
| Steady | 45.42% |
| No insulin | 43.92% |

**5. Long hospital stays don't prevent readmission**

| Stay Duration | Readmission Rate |
|---|:---:|
| Long Stay (>7 days) | **49.66%** |
| Medium Stay (4-7 days) | 48.58% |
| Short Stay (<4 days) | 43.50% |

→ Longer stays correlate with *higher* readmission — likely because they indicate greater disease severity, not because extended stays cause readmissions.

---

## 💡 Strategic Recommendations

| Priority | Action | Target Segment |
|---|---|---|
| 🔴 Immediate | 30-day structured follow-up program | All <30d readmitted patients |
| 🔴 Immediate | Dedicated Emergency Diabetic Care Team | Emergency admissions (47.49% risk) |
| 🟠 High | Elderly-specific discharge protocols | Age 70+ (65% of all patients) |
| 🟠 High | High Utilizer care coordinator program | 5+ prior visits (top 10%) |
| 🟡 Medium | Insulin stabilization protocol pre-discharge | Insulin Up/Down patients |

*Full root-cause analysis and projected impact in [`Healthcare_Business_Recommendations.txt`](./Healthcare_Business_Recommendations.txt)*

---

## 🖥️ Dashboard
!![Healthcare Readmission Dashboard Page 1](Healthcare_Dashboard_Page1.png)
![Healthcare Deep Dive Analysis Page 2](Healthcarer_Dashboard_page2.png)

**Features:** 5 KPI cards · Readmission distribution donut · Age vs readmission stacked bar · Medication load comparison · Admission type breakdown · Hospital stay analysis · Top 10 medical specialties · 4 interactive slicers (Gender, Age, Medication Load, Admission Type)

---

## 🗂️ Repository Contents

```
Healthcare-Readmission-Analysis/
│
├── diabetic_data_original_.csv              raw dataset (101,766 records)
├── IDS_mapping_original_.csv                admission type mapping table
├── healthcare_cleaned_data.csv              cleaned dataset (100,241 × 44)
├── healthcare_feature_engineered_final.csv  final dataset (100,241 × 52)
├── Healthcare_Readmission_Capstone.ipynb    Python EDA + feature engineering
├── Healthcare_sql_analysis.sql              SQL analysis queries
├── Healthcare_Power_BI_dashboard.pbix       Power BI dashboard file
├── Screenshot_2026-07-05_220104.png         dashboard preview
├── Healthcare_Business_Recommendations.txt  insights & strategic recommendations
└── README.md                                you are here
```

---

## 🛠️ Full Skill Stack Demonstrated

`Data Cleaning` `Missing Value Strategy` `Feature Engineering` `Correlation Analysis` `Statistical EDA` `SQL JOINs` `Risk Scoring (CASE WHEN)` `DAX Measures` `Stacked Bar Charts` `Multi-Slicer Dashboard` `Clinical Data Interpretation` `Healthcare Analytics` `Executive Recommendations`

---

## 📁 Portfolio Context

This is the **5th and final project** in a structured data analytics portfolio built to demonstrate end-to-end analytical capability across five industries:

| # | Project | Industry | New Skill Added |
|---|---|---|---|
| 1 | Sales Performance Dashboard | Retail | Excel → SQL → Power BI pipeline |
| 2 | Customer Churn Analysis | Telecom | Python EDA + statistical visualization |
| 3 | HR Attrition Analysis | Human Resources | Advanced SQL (CTEs, Window Functions) |
| 4 | E-Commerce Logistics Analysis | E-Commerce | Multi-table SQL JOINs |
| 5 | **Healthcare Readmission** | **Healthcare** | **Feature Engineering + Correlation Analysis** |

---

## 👩‍💻 About Me

**Supriya Dixit** — Aspiring Data Analyst
Five projects. Five industries. One goal: turning data into decisions.

📧 your.email@example.com &nbsp;|&nbsp; 🔗 [LinkedIn](your-linkedin-url) &nbsp;|&nbsp; 🐙 [GitHub](your-github-url)

---

<div align="center">

⭐ **If this project was useful or interesting, a star means a lot!** ⭐

</div>
