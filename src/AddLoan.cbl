IDENTIFICATION DIVISION.
PROGRAM-ID. AddLoan.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT LoanFile ASSIGN TO 'loans.dat'
        ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  LoanFile.
01  LoanRecord.
    05 LoanID              PIC 9(5).
    05 BorrowerName        PIC X(30).
    05 LoanAmount          PIC 9(7)V99.
    05 InterestRate        PIC 9(2)V99.
    05 LoanTerm            PIC 9(3).
    05 OutstandingBalance  PIC 9(7)V99.
    05 LastInterestCalcDate PIC 9(8).

WORKING-STORAGE SECTION.
01 WS-End-Flag PIC X VALUE 'N'.

PROCEDURE DIVISION USING LoanRecord.
    OPEN OUTPUT LoanFile.

    DISPLAY 'Enter Loan ID: '.
    ACCEPT LoanRecord.LoanID.
    PERFORM UNTIL LoanRecord.LoanID NUMERIC
        DISPLAY 'Invalid input. Enter numeric Loan ID: '.
        ACCEPT LoanRecord.LoanID
    END-PERFORM.

    DISPLAY 'Enter Borrower Name: '.
    ACCEPT LoanRecord.BorrowerName.

    DISPLAY 'Enter Loan Amount: '.
    ACCEPT LoanRecord.LoanAmount.
    PERFORM UNTIL LoanRecord.LoanAmount NUMERIC
        DISPLAY 'Invalid input. Enter numeric Loan Amount: '.
        ACCEPT LoanRecord.LoanAmount
    END-PERFORM.

    DISPLAY 'Enter Interest Rate (e.g., 5.25): '.
    ACCEPT LoanRecord.InterestRate.
    PERFORM UNTIL LoanRecord.InterestRate NUMERIC
        DISPLAY 'Invalid input. Enter numeric Interest Rate: '.
        ACCEPT LoanRecord.InterestRate
    END-PERFORM.

    DISPLAY 'Enter Loan Term (in months): '.
    ACCEPT LoanRecord.LoanTerm.
    PERFORM UNTIL LoanRecord.LoanTerm NUMERIC
        DISPLAY 'Invalid input. Enter numeric Loan Term: '.
        ACCEPT LoanRecord.LoanTerm
    END-PERFORM.

    MOVE LoanRecord.LoanAmount TO LoanRecord.OutstandingBalance.
    ACCEPT LoanRecord.LastInterestCalcDate FROM DATE YYYYMMDD.
    WRITE LoanRecord.

    DISPLAY 'Loan added successfully.'.

    CLOSE LoanFile.
    STOP RUN.
