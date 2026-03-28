-- Healthcare Operations Analytics — Schema Definition (SQLite Optimized)
-- Purpose: Optimized relational schema with business logic constraints.

DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS admissions;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    department_id   INTEGER PRIMARY KEY,
    department_name TEXT NOT NULL UNIQUE,
    base_cost       REAL CHECK (base_cost >= 0),
    capacity        INTEGER CHECK (capacity > 0)
);

CREATE TABLE patients (
    patient_id      INTEGER PRIMARY KEY,
    gender          TEXT CHECK (gender IN ('Male', 'Female', 'Non-Binary', 'Other')),
    date_of_birth   TEXT NOT NULL, -- ISO8601 Format (YYYY-MM-DD)
    city            TEXT
);

CREATE TABLE admissions (
    admission_id      INTEGER PRIMARY KEY,
    patient_id        INTEGER NOT NULL,
    department_id     INTEGER NOT NULL,
    admission_date    TEXT NOT NULL, -- ISO8601 Format
    discharge_date    TEXT,          -- ISO8601 Format
    length_of_stay    INTEGER CHECK (length_of_stay >= 0),
    primary_diagnosis TEXT NOT NULL,
    readmission_flag  INTEGER DEFAULT 0 CHECK (readmission_flag IN (0, 1)),
    total_cost        REAL CHECK (total_cost >= 0),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE treatments (
    treatment_id    INTEGER PRIMARY KEY,
    admission_id    INTEGER NOT NULL,
    treatment_name  TEXT NOT NULL,
    treatment_date  TEXT NOT NULL, -- ISO8601 Format
    treatment_cost  REAL CHECK (treatment_cost >= 0),
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id)
);

-- Note on SQLite Compatibility: 
-- 1. Date math is performed using JULIANDAY() or STRFTIME() functions.
-- 2. Boolean flags are stored as integers (0/1) with CHECK constraints.
