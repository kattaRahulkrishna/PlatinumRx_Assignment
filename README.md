# PlatinumRx Assignment

This repository contains the solutions for the PlatinumRx Data Analyst assignment, covering Database Management (SQL), Data Manipulation (Spreadsheets), and Programming Logic (Python).

## Folder Structure

- **SQL/**: Contains the database schema creation scripts and the query solutions for both Hotel and Clinic scenarios.
  - `01_Hotel_Schema_Setup.sql`
  - `02_Hotel_Queries.sql`
  - `03_Clinic_Schema_Setup.sql`
  - `04_Clinic_Queries.sql`
- **Spreadsheets/**: Includes the Excel analysis file (`Ticket_Analysis.xlsx`). Note: The necessary worksheet setups and formulas exactly as described in Phase 2 are implemented within the Excel file.
- **Python/**: Contains Python scripts for time conversion and removing duplicates.
  - `01_Time_Converter.py`
  - `02_Remove_Duplicates.py`

## Project Specifics

### SQL Proficiency
- Syntaxes follow standard SQL supported by ANSI/MySQL/Postgres engines. 
- Aggregations and Window Functions (`RANK`, `DENSE_RANK`) were actively utilized to answer complex grouping questions smoothly.
- Time conversions use `EXTRACT(MONTH FROM ...)` based on standard implementations. Depending on the exact SQL engine in use, it could be `MONTH()` or `DATE_PART()` as well.

### Spreadsheet Proficiency
- Spreadsheets are populated using Data samples from the task. 
- Formulas utilized include `VLOOKUP` based index matching to find standard values across sheets. 
- Date isolation calculations were included utilizing `INT()` arithmetic logic. 
- `COUNTIFS` were implemented heavily to build Pivot capabilities natively.

### Python Proficiency
- Basic structural implementations utilizing vanilla features of Python 3 without importing heavy 3rd-party libs.
- Mathematical integer division (`//`) and mod (`%`) were correctly applied for clock time determination.
- Basic character tracing implementation was done instead of set coercions to ensure "loops" condition as requested.

```
