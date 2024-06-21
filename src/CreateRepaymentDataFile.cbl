IDENTIFICATION DIVISION.
PROGRAM-ID. CreateRepaymentDataFile.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT RepaymentFile ASSIGN TO 'repayments.dat'
        ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  RepaymentFile.
01  RepaymentRecord.
    05 RepaymentID     PIC 9(5).
    05 LoanID          PIC 9(5).
    05 AmountPaid      PIC 9(7)V99.
    05 PaymentDate     PIC 9(8).

WORKING-STORAGE SECTION.
01 WS-End-Flag PIC X VALUE 'N'.

PROCEDURE DIVISION.
    OPEN OUTPUT RepaymentFile.

    PERFORM UNTIL WS-End-Flag = 'Y'
        DISPLAY 'Enter Repayment ID (or type END to finish): '.
        ACCEPT RepaymentRecord.RepaymentID
        IF RepaymentRecord.RepaymentID = 'END'
            MOVE 'Y' TO WS-End-Flag
        ELSE
            DISPLAY 'Enter Loan ID: '.
            ACCEPT RepaymentRecord.LoanID
            DISPLAY 'Enter Amount Paid: '.
            ACCEPT RepaymentRecord.AmountPaid
            DISPLAY 'Enter Payment Date (YYYYMMDD): '.
            ACCEPT RepaymentRecord.PaymentDate
            WRITE RepaymentRecord
        END-IF
    END-PERFORM.

    CLOSE RepaymentFile.
    STOP RUN.
