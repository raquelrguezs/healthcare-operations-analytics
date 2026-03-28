/*
===============================================================================
Script Overview: 03_advanced_analytics.sql
Purpose: Surface advanced insights using Window Functions, CTEs, and Cohorts.
Business Questions Answered:
  - How are readmissions trending across specific monthly patient cohorts?
  - Who are the cost outliers within each clinical department?
  - Does length of stay correlate with exponential cost increases?
===============================================================================
*/

-- 1. Readmission Cohort Analysis (30-day Readmissions by Admission Month Cohort)
-- Tracks the effectiveness of care over time based on when the patient was admitted.
WITH MonthlyCohorts AS (
    SELECT 
        patient_id,
        admission_id,
        STRFTIME('%Y-%m', admission_date) AS cohort_month,
        readmission_flag
    FROM admissions
)
SELECT 
    cohort_month,
    COUNT(DISTINCT patient_id) AS total_patients,
    SUM(readmission_flag) AS readmissions,
    ROUND(CAST(SUM(readmission_flag) AS REAL) / COUNT(*), 2) AS rate
FROM MonthlyCohorts
GROUP BY cohort_month;


-- 2. Identifying Cost Outliers Using Window Functions (The "5% Rule")
-- Ranks patients by cost within their department to isolate the most resource-intensive 5% cases.
WITH PatientCostRankings AS (
    SELECT 
        a.department_id,
        d.department_name,
        a.patient_id,
        a.primary_diagnosis,
        a.total_cost,
        (a.discharge_date - a.admission_date) AS length_of_stay,
        PERCENT_RANK() OVER(PARTITION BY a.department_id ORDER BY a.total_cost) AS cost_percentile
    FROM admissions a
    JOIN departments d ON a.department_id = d.department_id
)
SELECT 
    department_name,
    patient_id,
    primary_diagnosis,
    length_of_stay,
    total_cost
FROM PatientCostRankings
WHERE cost_percentile >= 0.95
ORDER BY department_name, total_cost DESC;


-- 3. Length of Stay (LOS) vs Cost Smoothing Algorithm
-- Calculates a rolling average of cost for the preceding 20 patients in a department 
-- to smooth out single-patient variance and understand localized trends.
SELECT 
    a.admission_id,
    d.department_name,
    a.primary_diagnosis,
    (a.discharge_date - a.admission_date) AS length_of_stay,
    a.total_cost,
    
    -- Rolling Average Window Function
    ROUND(
        AVG(a.total_cost) OVER(
            PARTITION BY a.department_id 
            ORDER BY a.admission_date 
            ROWS BETWEEN 20 PRECEDING AND CURRENT ROW
        ), 
    2) AS rolling_avg_cost_trend
FROM admissions a
JOIN departments d ON a.department_id = d.department_id
WHERE (a.discharge_date - a.admission_date) IS NOT NULL
ORDER BY d.department_name, a.admission_date;
