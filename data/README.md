# Data Architecture & Engineering Documentation

## Overview
This directory contains the core data assets for the Healthcare Operations Analytics project. It follows an Analytics Engineering approach, focusing on relational integrity, stochastic realism, and cross-engine compatibility (SQLite/PostgreSQL).

## Data Schema (ERD Logic)
The database follows a star-like relational schema:
- **`patients`**: Master data for patient demographics.
- **`departments`**: Strategic lookup for hospital wings and cost structures.
- **`admissions`**: Central fact table capturing patient encounters.
- **`treatments`**: Granular transactional table linked to admissions.

### Entity Relationship
- `patients 1:N admissions`
- `departments 1:N admissions`
- `admissions 1:N treatments`

## Engineering Assumptions & Generator Logic
The synthetic dataset is generated via `setup_database.py` using a stochastic simulation model:

1. **Length of Stay (LOS):** Modeled using a Normal Distribution with departmental variance. Cardiology has a higher mean LOS (7.0 days) compared to other wings (4.2 days).
2. **Cost Derivation:** 
   `Total Cost = (Base Departmental Cost + (LOS * Daily Rate)) * Stochastic Noise`.
   A noise factor of 0.9 to 1.15 is applied to simulate the complexity variance found in real clinical environments.
3. **Readmission Flag:** Calculated based on a 8% base-rate adjusted for clinical triggers (LOS > 6 days, Cardiology specialty) and random clinical variance.

## Technical Constraints (SQLite Compatibility)
To ensure portability, the analytical layer utilizes:
- **ISO8601 Strings:** All dates are stored as `YYYY-MM-DD` strings.
- **Integer Flags:** Boolean values (Readmission) are stored as 0/1.
- **Standard Casting:** Using `CAST(X AS REAL)` instead of engine-specific shorthands (e.g., `::numeric`).
- **Standard Date Math:** Using `JULIANDAY()` or `STRFTIME()` instead of Postgres' `DATE_TRUNC`.

## Limitations
- **Synthetic Distribution:** While clinical patterns (e.g., Q4 respiratory surges) are simulated, they do not account for external social determinants of health (SDoH).
- **Concurrency:** As a SQLite implementation, it is optimized for local analytical workloads, not high-concurrency production EHR write-loads.
