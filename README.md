# Healthcare Operations Analytics: Operational Efficiency & Risk Study

## Overview
Project focused on evaluating hospital operational data to identify potential bottlenecks and departmental performance trends. Using SQL-based analysis and Tableau, this study maps patterns in patient flow and resource utilization within the provided dataset to support data-informed operational reviews.

## Tools & Technologies
- **SQL (SQLite):** Querying, window functions, and cohort analysis.
- **Python:** Data generation and stochastic modeling for realistic distributions.
- **Tableau:** Dashboarding and data visualization.
- **Git/GitHub:** Version control and documentation.

## Business Problem
Healthcare operations encounter constant pressure to optimize patient outcomes while managing rising clinical costs. Readmission rates and prolonged stays are key metrics impacting both operational margins and quality of care. This analysis explores three areas:
1.  **Readmission Variance:** Identification of departments with outlier risk profiles.
2.  **Length of Stay (LOS) Dynamics:** Investigation into factors associated with prolonged hospitalizations.
3.  **Resource Allocation:** Cost mapping across patient cohorts and primary diagnoses.

## Dataset Description
The analysis is based on a relational database modeling a synthetic Electronic Health Record (EHR) environment with approximately 12,000 admissions and 8,500 unique patients spanning 2022-2023.
*   **Schema:** 4 core tables (Admissions, Patients, Departments, Treatments).
*   **Attributes:** Admission/Discharge dates, primary diagnosis, readmission flags, and cost per treatment.
*   **Note:** This analysis is based on a synthetic dataset; results, metrics, and distributions are indicative of operational patterns rather than specific clinical outcomes.

## Dashboard Visualization
<img width="1089" height="627" alt="Captura de pantalla 2026-03-28 a las 14 27 01" src="https://github.com/user-attachments/assets/bcc2aa66-d00e-4f6d-9388-84cd6ed1067c" />

*Tableau dashboard providing a multi-dimensional view of hospital KPIs and correlations between stay duration, readmission risk, and cost-intensive diagnostic clusters.*

## Analytical Approach
The analysis consists of:
- **Data Modeling:** Relational schema including Patients, Departments, Admissions, and Treatments.
- **Data Generation:** Python-based simulation with over 12,000 records incorporating realistic clinical variability.
- **SQL Analysis:** Systematic use of CTEs and rank functions to extract operational insights from raw tables.
- **Visualization:** Translation of SQL outputs into interactive dashboards.

## SQL Analysis
- **[Baseline Metrics](./sql/01_kpi_metrics.sql):** Initial performance benchmarks and hospital-wide KPIs.
- **[Operational Trends](./sql/02_patient_trends.sql):** Time-series analysis and grouping of high-volume diagnoses.
- **[Statistical Distributions](./sql/03_advanced_analytics.sql):** Cost outlier isolation and 30-day readmission cohort analysis.

## Key Visual Insights
- **Cardiology Indicators:** Cardiology exhibits a calculated readmission rate of ~15.5%, significantly above the hospital average (~6.7%).
- **Length of Stay Correlation:** The data suggests an inflection point at the 6-day mark, where the readmission probability jump (~50% relative increase) is observed.
- **Cost vs. Risk Matrix:** Clustering observed among high-cost/high-risk diagnoses (e.g., Diabetes Management, Pneumonia), suggesting priority areas for clinical pathway reviews.
- **Pareto Distribution:** Approximately 5% of admissions account for ~10% of total clinical costs, highlighting resource utilization in complex cases.

## Business Interpretation
- **Operational Efficiency:** The 6-day LOS threshold suggests a potential bottleneck. Pre-emptive case management intervention before Day 5 could be explored to mitigate readmission risks.
- **LOS Threshold Observations:** In this specific dataset, an inflection point is observed at day 6; patients staying 6 days or longer show a calculated ~50% higher readmission risk compared to those discharged earlier.
- **Risk Mitigation:** Cardiology's outlier status indicates an opportunity for post-discharge protocol reviews or targeted monitoring pilots.
- **Cost Optimization:** Cost concentration patterns suggest that focusing standardization on the top 10% of diagnostic clusters could drive operational improvements.

## Methodological Notes
- **Synthetic Dataset:** This project uses a synthetically generated dataset for illustrative purposes. Results are indicative of analytical capabilities rather than specific clinical outcomes.
- **Embedded Correlations:** Patterns have been modeled into the generation logic to simulate realistic healthcare data constraints.
- **Scope:** This analysis focus is on operational metrics and does not account for external social determinants of health (SDoH).
