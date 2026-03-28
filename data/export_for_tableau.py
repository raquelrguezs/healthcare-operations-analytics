"""
Tableau Data Export Engine
==========================
This script executes the project's SQL queries and exports the results 
to the 'reports/tableau_data/' directory for visualization.
"""

import sqlite3
import pandas as pd
import os

# Paths
DB_PATH = os.path.join(os.path.dirname(__file__), "healthcare.db")
OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "..", "reports", "tableau_data")

os.makedirs(OUTPUT_DIR, exist_ok=True)

def export_data():
    conn = sqlite3.connect(DB_PATH)
    
    print("Running SQL queries and exporting to CSV for Tableau...")

    # 1. Main Admissions Data (for granular analysis)
    q_main = """
    SELECT 
        a.admission_id, 
        p.gender, 
        p.city, 
        d.department_name, 
        a.admission_date, 
        a.discharge_date, 
        a.length_of_stay, 
        a.primary_diagnosis, 
        a.readmission_flag, 
        a.total_cost
    FROM admissions a
    JOIN patients p ON a.patient_id = p.patient_id
    JOIN departments d ON a.department_id = d.department_id;
    """
    df_main = pd.read_sql_query(q_main, conn)
    df_main.to_csv(os.path.join(OUTPUT_DIR, "admissions_master.csv"), index=False)
    print("Export complete: admissions_master.csv")

    # 2. Daily Patient Volume & Cost Trend
    q_trends = """
    SELECT 
        admission_date, 
        COUNT(admission_id) as daily_admissions,
        SUM(total_cost) as daily_revenue,
        AVG(length_of_stay) as avg_los
    FROM admissions
    GROUP BY admission_date;
    """
    df_trends = pd.read_sql_query(q_trends, conn)
    df_trends.to_csv(os.path.join(OUTPUT_DIR, "daily_trends.csv"), index=False)
    print("Export complete: daily_trends.csv")

    conn.close()
    print("Status: Reports ready in /reports/tableau_data/")

if __name__ == "__main__":
    if not os.path.exists(DB_PATH):
        print("Error: Database not found. Run setup_database.py first.")
    else:
        export_data()
