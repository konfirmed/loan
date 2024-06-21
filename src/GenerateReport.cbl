IDENTIFICATION DIVISION.
PROGRAM-ID. GenerateReport.

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
01 WS-Choice PIC 9.
01 EOF       PIC X VALUE 'N'.
01 WS-BorrowerName PIC X(30).

PROCEDURE DIVISION USING WS-Choice.
    EVALUATE WS-Choice
        WHEN 1
            PERFORM REPORT-ALL-LOANS
        WHEN 2
            PERFORM REPORT-SPECIFIC-BORROWER
        WHEN 3
            PERFORM REPORT-OVERDUE-LOANS
        WHEN OTHER
            DISPLAY 'Invalid choice, please try again.'
    END-EVALUATE.

    STOP RUN.

REPORT-ALL-LOANS.
    DISPLAY 'Generating report for all loans...'.
    OPEN INPUT LoanFile.
    PERFORM UNTIL EOF = 'Y'
        READ LoanFile INTO LoanRecord
            AT END
                MOVE 'Y' TO EOF
            NOT AT END
                DISPLAY 'Loan ID: ' LoanRecord.LoanID
                DISPLAY 'Borrower Name: ' LoanRecord.BorrowerName
                DISPLAY 'Outstanding Balance: ' LoanRecord.OutstandingBalance
    END-PERFORM.
    CLOSE LoanFile.
    DISPLAY 'Report generation completed.'.
    .

REPORT-SPECIFIC-BORROWER.
    DISPLAY 'Enter Borrower Name: '.
    ACCEPT WS-BorrowerName.
    DISPLAY 'Generating report for ' WS-BorrowerName '...'.
    OPEN INPUT LoanFile.
    PERFORM UNTIL EOF = 'Y'
        READ LoanFile INTO LoanRecord
            AT END
                MOVE 'Y' TO EOF
            NOT AT END
                IF LoanRecord.BorrowerName = WS-BorrowerName
                    DISPLAY 'Loan ID: ' LoanRecord.LoanID
                    DISPLAY 'Outstanding Balance: ' LoanRecord.OutstandingBalance
                END-IF
    END-PERFORM.
    CLOSE LoanFile.
    DISPLAY 'Report generation completed.'.
    .

REPORT-OVERDUE-LOANS.
    DISPLAY 'Generating report for overdue loans...'.
    OPEN INPUT LoanFile.
    ACCEPT WS-TodayDate FROM DATE YYYYMMDD.
    PERFORM UNTIL EOF = 'Y'
        READ LoanFile INTO LoanRecord
            AT END
                MOVE 'Y' TO EOF
            NOT AT END
                IF LoanRecord.LastInterestCalcDate < WS-TodayDate - LoanRecord.LoanTerm
                    DISPLAY 'Loan ID: ' LoanRecord.LoanID
                    DISPLAY 'Borrower Name: ' LoanRecord.BorrowerName
                    DISPLAY 'Outstanding Balance: ' LoanRecord.OutstandingBalance
                END-IF
    END-PERFORM.
    CLOSE LoanFile.
    DISPLAY 'Report generation completed.'.
    .
