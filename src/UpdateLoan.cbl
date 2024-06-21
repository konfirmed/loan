IDENTIFICATION DIVISION.
PROGRAM-ID. UpdateLoan.

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
01 WS-LoanID PIC 9(5).

PROCEDURE DIVISION USING LoanRecord.
    DISPLAY 'Enter Loan ID to update: '.
    ACCEPT WS-LoanID.

    OPEN I-O LoanFile.
    READ LoanFile INTO LoanRecord
        KEY IS WS-LoanID
        INVALID KEY
            DISPLAY 'Loan not found.'
            CLOSE LoanFile
            STOP RUN
        NOT INVALID KEY
            DISPLAY 'Enter new Loan Amount: '.
            ACCEPT LoanRecord.LoanAmount.
            PERFORM UNTIL LoanRecord.LoanAmount NUMERIC
                DISPLAY 'Invalid input. Enter numeric Loan Amount: '.
                ACCEPT LoanRecord.LoanAmount
            END-PERFORM.

            DISPLAY 'Enter new Interest Rate (e.g., 5.25): '.
            ACCEPT LoanRecord.InterestRate.
            PERFORM UNTIL LoanRecord.InterestRate NUMERIC
                DISPLAY 'Invalid input. Enter numeric Interest Rate: '.
                ACCEPT LoanRecord.InterestRate
            END-PERFORM.

            DISPLAY 'Enter new Loan Term (in months): '.
            ACCEPT LoanRecord.LoanTerm.
            PERFORM UNTIL LoanRecord.LoanTerm NUMERIC
                DISPLAY 'Invalid input. Enter numeric Loan Term: '.
                ACCEPT LoanRecord.LoanTerm
            END-PERFORM.

            MOVE LoanRecord.LoanAmount TO LoanRecord.OutstandingBalance.
            REWRITE LoanRecord.

            DISPLAY 'Loan updated successfully.'
    END-READ.

    CLOSE LoanFile.
    STOP RUN.
