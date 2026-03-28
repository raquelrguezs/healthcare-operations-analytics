/*
===============================================================================
Script Overview: 02_patient_trends.sql
Purpose: Analyze trends over time and diagnostic impact on resources.
Business Questions Answered:
  - What is the seasonal trend in patient admissions and cost?
  - Which diagnoses are highest risk for readmission and length of stay?
===============================================================================
*/

-- 1. Monthly Admissions and Cost Trend (Year-over-Year)
-- Useful for capacity planning and identifying seasonal constraints.
SELECT 
    STRFTIME('%Y-%m', admission_date) AS admission_month,
    COUNT(admission_id) AS monthly_admissions,
    SUM(total_cost) AS total_monthly_cost,
    ROUND(AVG(length_of_stay), 2) AS avg_monthly_los
FROM admissions
GROUP BY admission_month
ORDER BY admission_month ASC;


-- 2. Top Diagnoses by Volume & Risk Matrix
-- Highlights the most frequent conditions and flags the ones with concerning readmission risks.
SELECT 
    primary_diagnosis,
    COUNT(admission_id) AS total_cases,
    ROUND(AVG(discharge_date - admission_date), 2) AS avg_los,
    ROUND(AVG(total_cost), 2) AS avg_cost,
    
    -- Calculating Risk Factor (Readmission)
    ROUND(CAST(SUM(readmission_flag) AS REAL) / COUNT(admission_id), 2) AS readmission_risk
FROM admissions
GROUP BY primary_diagnosis
HAVING COUNT(admission_id) > 50
ORDER BY total_cases DESC
LIMIT 15;
