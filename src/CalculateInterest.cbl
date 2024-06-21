IDENTIFICATION DIVISION.
PROGRAM-ID. CalculateInterest.

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
01 WS-Interest PIC 9(7)V99.
01 WS-TodayDate PIC 9(8).
01 EOF PIC X VALUE 'N'.

PROCEDURE DIVISION USING LoanRecord.
    DISPLAY 'Calculating interest for all loans...'.
    OPEN I-O LoanFile.
    ACCEPT WS-TodayDate FROM DATE YYYYMMDD.
    PERFORM UNTIL EOF = 'Y'
        READ LoanFile INTO LoanRecord
            AT END
                MOVE 'Y' TO EOF
            NOT AT END
                IF LoanRecord.LastInterestCalcDate < WS-TodayDate
                    COMPUTE WS-Interest = LoanRecord.OutstandingBalance * (LoanRecord.InterestRate / 100).
                    ADD WS-Interest TO LoanRecord.OutstandingBalance.
                    MOVE WS-TodayDate TO LoanRecord.LastInterestCalcDate.
                    REWRITE LoanRecord.
                END-IF
    END-PERFORM.
    CLOSE LoanFile.
    DISPLAY 'Interest calculation completed.'.
    STOP RUN.
