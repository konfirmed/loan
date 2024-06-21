IDENTIFICATION DIVISION.
PROGRAM-ID. CreateLoanDataFile.

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

PROCEDURE DIVISION.
    OPEN OUTPUT LoanFile.

    PERFORM UNTIL WS-End-Flag = 'Y'
        DISPLAY 'Enter Loan ID (or type END to finish): '.
        ACCEPT LoanRecord.LoanID
        IF LoanRecord.LoanID = 'END'
            MOVE 'Y' TO WS-End-Flag
        ELSE
            DISPLAY 'Enter Borrower Name: '.
            ACCEPT LoanRecord.BorrowerName
            DISPLAY 'Enter Loan Amount: '.
            ACCEPT LoanRecord.LoanAmount
            DISPLAY 'Enter Interest Rate (e.g., 5.25): '.
            ACCEPT LoanRecord.InterestRate
            DISPLAY 'Enter Loan Term (in months): '.
            ACCEPT LoanRecord.LoanTerm
            MOVE LoanRecord.LoanAmount TO LoanRecord.OutstandingBalance
            ACCEPT LoanRecord.LastInterestCalcDate FROM DATE YYYYMMDD
            WRITE LoanRecord
        END-IF
    END-PERFORM.

    CLOSE LoanFile.
    STOP RUN.
