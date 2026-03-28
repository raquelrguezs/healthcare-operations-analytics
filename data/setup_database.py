"""
Healthcare Operations Analytics — Data Simulation & Setup Engine
===============================================================
Purpose: Production-Ready SQLite Simulation with Stochastic Variable Noise.

This engine ensures:
1. Reproducibility (via Fixed Seeds)
2. Stochastic realism in costs and readmission logic
3. Full consistency with the relational schema
"""

import sqlite3
import pandas as pd
import numpy as np
import random
import os
from datetime import datetime, timedelta

# Static Seeds for Reproducibility
np.random.seed(42)
random.seed(42)

DB_PATH = os.path.join(os.path.dirname(__file__), "healthcare.db")
SCHEMA_PATH = os.path.join(os.path.dirname(__file__), "schema.sql")

def setup():
    """Build the relational database and seed realistic clinical records."""
    print("=" * 65)
    print("  Healthcare Operations Analytics — Data Engineering Pipeline")
    print("=" * 65)

    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()

    # Step 1: Execute Schema (DDL)
    with open(SCHEMA_PATH, 'r') as f:
        cur.executescript(f.read())
    print("Schema initialization complete.")

    # Step 2: Seed Static Dimensions (Departments)
    meta_depts = [
        (1, "Cardiology",        2550.0, 50),
        (2, "Neurology",         2180.0, 40),
        (3, "Oncology",          3100.0, 60),
        (4, "Orthopedics",       2750.0, 50),
        (5, "Pediatrics",        1480.0, 40),
        (6, "Internal Medicine", 1820.0, 100),
        (7, "Emergency",         2050.0, 80),
        (8, "Pulmonology",       2120.0, 45),
    ]
    cur.executemany("INSERT INTO departments VALUES (?,?,?,?)", meta_depts)

    # Step 3: Seed Dimensions (Patients)
    NUM_PATIENTS = 8500
    cities = ["Dublin", "Cork", "Galway", "Limerick", "Waterford"]
    prob   = [0.4, 0.2, 0.15, 0.15, 0.1]
    
    patients = []
    base_dob = datetime(1945, 1, 1)
    for i in range(1, NUM_PATIENTS + 1):
        patients.append((
            i,
            random.choice(["Male", "Female"]),
            (base_dob + timedelta(days=random.randint(0, 24000))).strftime("%Y-%m-%d"),
            np.random.choice(cities, p=prob)
        ))
    cur.executemany("INSERT INTO patients VALUES (?,?,?,?)", patients)
    print(f"Status: {NUM_PATIENTS} patients initialized.")

    # Step 4: Generate Transaccional Data (Admissions)
    start_date = datetime(2022, 1, 1)
    DAILY_RATE = 825.0
    diagnoses = ["Heart Failure", "Pneumonia", "Stroke", "Joint Replacement", 
                 "Asthma", "Diabetes Management", "Sepsis", "COPD"]
    
    admissions = []
    for i in range(1, 12001):
        dept_id = random.randint(1, 8)
        dept_name = meta_depts[dept_id-1][1]
        
        # Simulated Admission Date
        adm = start_date + timedelta(days=random.randint(0, 725))
        
        # Length of Stay (LOS) Logic with variance per Department
        mu = 7.0 if dept_name == "Cardiology" else 4.2
        sigma = 2.8
        los = max(1, int(np.random.normal(mu, sigma)))
        discharge = adm + timedelta(days=los)

        # Stochastic Readmission Probability Logic
        readm_prob = 0.08 
        if los > 6: readm_prob += 0.05
        if dept_name == "Cardiology": readm_prob += 0.04
        readm_prob += random.uniform(-0.02, 0.02) # Variance Noise
        
        # Cost Logic: Base + LOS-Variable + Diagnosis Complexity Noise
        cost_noise = random.uniform(0.9, 1.15) # Multiplier noise 10-15%
        total_cost = (meta_depts[dept_id-1][2] + (los * DAILY_RATE)) * cost_noise

        admissions.append((
            i,
            random.randint(1, NUM_PATIENTS),
            dept_id,
            adm.strftime("%Y-%m-%d"),
            discharge.strftime("%Y-%m-%d"),
            los,
            random.choice(diagnoses),
            1 if random.random() < readm_prob else 0,
            round(total_cost, 2)
        ))
    
    cur.executemany("INSERT INTO admissions VALUES (?,?,?,?,?,?,?,?,?)", admissions)
    print(f"Status: {len(admissions)} admissions initialized with stochastic factors.")

    conn.commit()
    conn.close()
    print("-" * 65)
    print("Database initialization successful.")

if __name__ == "__main__":
    setup()
