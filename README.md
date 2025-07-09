# Pharmacy Sales Management System – Oracle SQL

This project implements a relational database system for managing pharmacy operations using Oracle SQL and PL/SQL. It captures the core entities and relationships in a pharmacy ecosystem and provides robust procedures for data handling and reporting.

## Overview

The system models the real-world workflow of pharmacies, including doctors, patients, pharmaceutical companies, drugs, prescriptions, and contracts. It supports data insertion, updates, deletions, and retrieval through well-structured PL/SQL procedures.

## Features

- Normalized schema design with referential integrity
- Table creation with appropriate constraints
- PL/SQL procedures for:
  - Insertion, update, and deletion across entities
  - Generating custom reports (e.g., patient prescriptions, stock status)
- Cursor-based output using `DBMS_OUTPUT`
- Sample data included for testing and demonstration

## File

- `pharmacy_sales.sql`  
  Contains all DDL and DML statements:
  - Table and constraint definitions  
  - PL/SQL procedure creation  
  - Sample data for testing  

## Entities Modeled

- **Doctor**: Physician details and specialties  
- **Patient**: Demographic and medical associations  
- **Pharma_Company**: Drug manufacturers  
- **Pharmacy**: Outlets selling pharmaceutical products  
- **Drug**: Trade names and compositions  
- **Prescription**: Drug orders issued by doctors  
- **Pharmacy_Drug**: Inventory and pricing at each pharmacy  
- **Contract**: Agreements between pharmacies and companies  

## Setup Instructions

1. Ensure Oracle Database (e.g., XE 21c) is installed and running.
2. Connect to the database container (e.g., `XEPDB1`) using SQL*Plus or Oracle SQL Developer.
3. Run `pharmacy_sales.sql` in order:
   - Session/container setup  
   - Table and constraint creation  
   - Procedure definitions  
   - Sample data insertion  

## Stored Procedures

Includes procedures for:

- **Insertions**: `addDoctor`, `addPatient`, `addPharmacy`, `addCompany`, `addDrug`, `addPrescription`, `addContract`
- **Updates**: Update address, phone number, experience, formulas, etc.
- **Deletions**: Record removal from all major tables
- **Reports**:
  - Prescription history by patient and date range
  - Prescription on a given date
  - Dr
