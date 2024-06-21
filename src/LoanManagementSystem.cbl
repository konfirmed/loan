IDENTIFICATION DIVISION.
PROGRAM-ID. LoanManagementSystem.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT UserFile ASSIGN TO 'users.dat'
        ORGANIZATION IS LINE SEQUENTIAL.
    SELECT LoanFile ASSIGN TO 'loans.dat'
        ORGANIZATION IS LINE SEQUENTIAL.
    SELECT RepaymentFile ASSIGN TO 'repayments.dat'
        ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  UserFile.
01  UserRecord.
    05 UserID           PIC X(20).
    05 UserPassword     PIC X(20).

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
01 WS-Choice          PIC 9.
01 WS-LoanID          PIC 9(5).
01 WS-RepaymentID     PIC 9(5).
01 WS-AmountPaid      PIC 9(7)V99.
01 WS-Interest        PIC 9(7)V99.
01 WS-OutstandingBalance PIC 9(7)V99.
01 WS-UserID          PIC X(20).
01 WS-UserPassword    PIC X(20).
01 WS-Authenticated   PIC X VALUE 'N'.
01 WS-TodayDate       PIC 9(8).
01 WS-BorrowerName    PIC X(30).
01 EOF                PIC X VALUE 'N'.

PROCEDURE DIVISION.
    PERFORM UNTIL WS-Authenticated = 'Y'
        DISPLAY 'Enter User ID: '.
        ACCEPT WS-UserID.
        DISPLAY 'Enter Password: '.
        ACCEPT WS-UserPassword.
        PERFORM AUTHENTICATE-USER
    END-PERFORM.

    PERFORM UNTIL WS-Choice = 6
        DISPLAY '========================================'.
        DISPLAY '        Loan Management System         '.
        DISPLAY '========================================'.
        DISPLAY '1. Add Loan'.
        DISPLAY '2. Update Loan'.
        DISPLAY '3. Record Repayment'.
        DISPLAY '4. Generate Report'.
        DISPLAY '5. Calculate Interest'.
        DISPLAY '6. Exit'.
        DISPLAY '========================================'.
        DISPLAY 'Please enter your choice (1-6): '.
        ACCEPT WS-Choice

        EVALUATE WS-Choice
            WHEN 1
                CALL 'AddLoan' USING LoanRecord
            WHEN 2
                CALL 'UpdateLoan' USING LoanRecord
            WHEN 3
                CALL 'RecordRepayment' USING RepaymentRecord
            WHEN 4
                CALL 'GenerateReport' USING WS-Choice
            WHEN 5
                CALL 'CalculateInterest' USING LoanRecord
            WHEN 6
                DISPLAY 'Exiting system...'
            WHEN OTHER
                DISPLAY 'Invalid choice, please try again.'
        END-EVALUATE
    END-PERFORM.

    STOP RUN.

AUTHENTICATE-USER.
    OPEN INPUT UserFile.
    READ UserFile INTO UserRecord
        AT END
            DISPLAY 'Invalid User ID or Password.'
        NOT AT END
            IF UserRecord.UserID = WS-UserID AND UserRecord.UserPassword = WS-UserPassword
                MOVE 'Y' TO WS-Authenticated
                DISPLAY 'Login successful.'
            ELSE
                DISPLAY 'Invalid User ID or Password.'
            END-IF
    END-READ.
    CLOSE UserFile.
    .
