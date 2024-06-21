# Loan Management System

## Overview

This project is a COBOL-based Loan Management System designed for banks or government institutions. It handles loan applications, tracks repayments, calculates interest, and generates various reports.

## Setup and Usage

### 1. Compile the COBOL Programs

Use a COBOL compiler (e.g., GnuCOBOL) to compile the COBOL programs.

```sh
cobc -x -o CreateLoanDataFile CreateLoanDataFile.cbl
cobc -x -o CreateRepaymentDataFile CreateRepaymentDataFile.cbl
cobc -x -o LoanManagementSystem LoanManagementSystem.cbl
```

### 2. Initialize Data Files
Run the data file creation programs to initialize the loans.dat and repayments.dat files.

```sh
./CreateLoanDataFile
./CreateRepaymentDataFile
```

### 3. Run the Loan Management System
Execute the main program to start the Loan Management System.

```sh
./LoanManagementSystem
```

## Features
- User Authentication: Secure access to the system.
- Loan Application Management: Add, update, and delete loan applications.
- Repayment Tracking: Record and track loan repayments.
- Interest Calculation: Calculate and update interest on outstanding loans.
- Reporting: Generate detailed reports on loans, repayments, and overdue loans.

## Files
- LoanManagementSystem.cbl: Main program file.
- CreateLoanDataFile.cbl: Program to create the loans.dat file.
- CreateRepaymentDataFile.cbl: Program to create the repayments.dat file.
- users.dat: Binary file for user credentials.
- loans.dat: Binary file for loan records.
- repayments.dat: Binary file for repayment records.
