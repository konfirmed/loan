IDENTIFICATION DIVISION.
PROGRAM-ID. RecordRepayment.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT LoanFile ASSIGN TO 'loans.dat'
        ORGANIZATION IS LINE SEQUENTIAL.
    SELECT RepaymentFile ASSIGN TO 'repayments.dat'
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

FD  RepaymentFile.
01  RepaymentRecord.
    05 RepaymentID         PIC 9(5).
    05 LoanID              PIC 9(5).
    05 AmountPaid          PIC 9(7)V99.
    05 PaymentDate         PIC 9(8).

WORKING-STORAGE SECTION.
01 WS-LoanID PIC 9(5).

PROCEDURE DIVISION USING RepaymentRecord.
    DISPLAY 'Enter Loan ID for repayment: '.
    ACCEPT WS-LoanID.

    OPEN I-O LoanFile.
    READ LoanFile INTO LoanRecord
        KEY IS WS-LoanID
        INVALID KEY
            DISPLAY 'Loan not found.'
            CLOSE LoanFile
            STOP RUN
        NOT INVALID KEY
            DISPLAY 'Enter Repayment ID: '.
            ACCEPT RepaymentRecord.RepaymentID.
            DISPLAY 'Enter Amount Paid: '.
            ACCEPT RepaymentRecord.AmountPaid.
            PERFORM UNTIL RepaymentRecord.AmountPaid NUMERIC
                DISPLAY 'Invalid input. Enter numeric Amount Paid: '.
                ACCEPT RepaymentRecord.AmountPaid
            END-PERFORM.

            DISPLAY 'Enter Payment Date (YYYYMMDD): '.
            ACCEPT RepaymentRecord.PaymentDate.
            MOVE WS-LoanID TO RepaymentRecord.LoanID.

            OPEN OUTPUT RepaymentFile.
            WRITE RepaymentRecord.
            CLOSE RepaymentFile.

            SUBTRACT RepaymentRecord.AmountPaid FROM LoanRecord.OutstandingBalance.
            REWRITE LoanRecord.

            DISPLAY 'Repayment recorded successfully.'
    END-READ.

    CLOSE LoanFile.
    STOP RUN.
