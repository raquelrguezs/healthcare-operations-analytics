/*
===============================================================================
Script Overview: 01_kpi_metrics.sql
Purpose: Compute foundational hospital performance metrics.
Business Questions Answered:
  - What are overall readmission rates and costs?
  - How do different hospital departments compare?
===============================================================================
*/

-- 1. Executive Dashboard KPIs: Hospital-Wide Aggregations
SELECT 
    COUNT(DISTINCT admission_id) AS total_admissions,
    COUNT(DISTINCT patient_id) AS unique_patients_served,
    ROUND(AVG(discharge_date - admission_date), 2) AS avg_length_of_stay_days,
    ROUND(CAST(SUM(readmission_flag) AS REAL) / COUNT(*), 2) AS readmission_rate,
    ROUND(AVG(total_cost), 2) AS avg_cost_per_admission
FROM admissions
WHERE admission_date >= '2022-01-01';


-- 2. Departmental Performance & Cost Variation
-- Identifies which clinical areas drive the highest volume and cost.
SELECT 
    d.department_name,
    COUNT(a.admission_id) AS total_admissions,
    ROUND(AVG(a.discharge_date - a.admission_date), 2) AS department_avg_los,
    
    -- Readmission Rate Calculation
    ROUND(CAST(SUM(a.readmission_flag) AS REAL) / COUNT(*), 2) AS department_readmission_rate,
    SUM(a.total_cost) AS total_department_revenue,
    ROUND(AVG(a.total_cost), 2) AS avg_cost_per_patient
FROM departments d
LEFT JOIN admissions a ON d.department_id = a.department_id
GROUP BY d.department_name
ORDER BY total_admissions DESC;
