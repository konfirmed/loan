IDENTIFICATION DIVISION.
PROGRAM-ID. UserAuthentication.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT UserFile ASSIGN TO 'users.dat'
        ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  UserFile.
01  UserRecord.
    05 UserID           PIC X(20).
    05 UserPassword     PIC X(20).

WORKING-STORAGE SECTION.
01 WS-UserID        PIC X(20).
01 WS-UserPassword  PIC X(20).
01 WS-Authenticated PIC X VALUE 'N'.

PROCEDURE DIVISION.
    OPEN INPUT UserFile.

    DISPLAY 'Enter User ID: '.
    ACCEPT WS-UserID.
    DISPLAY 'Enter Password: '.
    ACCEPT WS-UserPassword.

    PERFORM UNTIL WS-Authenticated = 'Y' OR AT END
        READ UserFile INTO UserRecord
            AT END
                DISPLAY 'Invalid User ID or Password.'
                MOVE 'Y' TO AT END
            NOT AT END
                IF UserRecord.UserID = WS-UserID AND UserRecord.UserPassword = WS-UserPassword
                    MOVE 'Y' TO WS-Authenticated
                    DISPLAY 'Login successful.'
                END-IF
    END-PERFORM.

    CLOSE UserFile.
    IF WS-Authenticated = 'N'
        DISPLAY 'Login failed. Exiting program.'
        STOP RUN
    END-IF.

    EXIT PROGRAM.
