       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCOUNT-REPORT.
      *>--------------------------------------------------------------
      *> Reads accounts and transactions, applies them, prints report.
      *> Used by the SDD mini hack scenario 3 (legacy modernization).
      *>
      *> accounts.dat record (32 bytes):
      *>   id   PIC 9(4)         cols 1-4
      *>   name PIC X(20)        cols 5-24
      *>   bal  PIC 9(6)V99      cols 25-32  (last 2 = cents)
      *>
      *> transactions.dat record (13 bytes):
      *>   id     PIC 9(4)       cols 1-4
      *>   type   PIC X(1)       col 5  ('D'eposit or 'W'ithdrawal)
      *>   amount PIC 9(6)V99    cols 6-13
      *>--------------------------------------------------------------
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNTS-FILE ASSIGN TO "data/accounts.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TX-FILE ASSIGN TO "data/transactions.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNTS-FILE.
       01  ACCOUNTS-RECORD.
           05 AR-ID         PIC 9(4).
           05 AR-NAME       PIC X(20).
           05 AR-BALANCE    PIC 9(6)V99.

       FD  TX-FILE.
       01  TX-RECORD.
           05 TR-ID         PIC 9(4).
           05 TR-TYPE       PIC X(1).
           05 TR-AMOUNT     PIC 9(6)V99.

       WORKING-STORAGE SECTION.
       77  EOF-FLAG         PIC X VALUE "N".
       77  IDX              PIC 9(3) VALUE 0.
       77  JDX              PIC 9(3) VALUE 0.
       77  N-ACC            PIC 9(3) VALUE 0.
       77  N-TX             PIC 9(3) VALUE 0.
       77  FOUND-IDX        PIC 9(3) VALUE 0.
       77  TMP-ID           PIC 9(4).
       77  TMP-NAME         PIC X(20).
       77  TMP-BAL          PIC 9(6)V99.
       77  ED-AMT           PIC $$$,$$9.99.
       77  ED-BAL           PIC $$$,$$9.99.
       77  TX-LABEL         PIC X(10).

       01  ACCOUNT-TABLE.
           05 ACC-ENTRY OCCURS 100 TIMES.
              10 A-ID      PIC 9(4).
              10 A-NAME    PIC X(20).
              10 A-BAL     PIC 9(6)V99.

       01  TX-TABLE.
           05 TX-ENTRY OCCURS 200 TIMES.
              10 T-ID      PIC 9(4).
              10 T-TYPE    PIC X(1).
              10 T-AMOUNT  PIC 9(6)V99.

       PROCEDURE DIVISION.
       MAIN-PARA.
           PERFORM LOAD-ACCOUNTS
           PERFORM LOAD-TRANSACTIONS
           PERFORM SORT-ACCOUNTS
           PERFORM PRINT-HEADER
           PERFORM APPLY-TRANSACTIONS
           PERFORM PRINT-FOOTER
           PERFORM PRINT-ACCOUNTS
           STOP RUN.

       LOAD-ACCOUNTS.
           OPEN INPUT ACCOUNTS-FILE
           MOVE "N" TO EOF-FLAG
           PERFORM UNTIL EOF-FLAG = "Y"
               READ ACCOUNTS-FILE
                   AT END MOVE "Y" TO EOF-FLAG
                   NOT AT END
                       ADD 1 TO N-ACC
                       MOVE AR-ID      TO A-ID(N-ACC)
                       MOVE AR-NAME    TO A-NAME(N-ACC)
                       MOVE AR-BALANCE TO A-BAL(N-ACC)
               END-READ
           END-PERFORM
           CLOSE ACCOUNTS-FILE.

       LOAD-TRANSACTIONS.
           OPEN INPUT TX-FILE
           MOVE "N" TO EOF-FLAG
           PERFORM UNTIL EOF-FLAG = "Y"
               READ TX-FILE
                   AT END MOVE "Y" TO EOF-FLAG
                   NOT AT END
                       ADD 1 TO N-TX
                       MOVE TR-ID     TO T-ID(N-TX)
                       MOVE TR-TYPE   TO T-TYPE(N-TX)
                       MOVE TR-AMOUNT TO T-AMOUNT(N-TX)
               END-READ
           END-PERFORM
           CLOSE TX-FILE.

       SORT-ACCOUNTS.
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > N-ACC
               PERFORM VARYING JDX FROM 1 BY 1 UNTIL JDX > N-ACC - IDX
                   IF A-ID(JDX) > A-ID(JDX + 1)
                       MOVE A-ID(JDX)     TO TMP-ID
                       MOVE A-NAME(JDX)   TO TMP-NAME
                       MOVE A-BAL(JDX)    TO TMP-BAL
                       MOVE A-ID(JDX + 1)   TO A-ID(JDX)
                       MOVE A-NAME(JDX + 1) TO A-NAME(JDX)
                       MOVE A-BAL(JDX + 1)  TO A-BAL(JDX)
                       MOVE TMP-ID   TO A-ID(JDX + 1)
                       MOVE TMP-NAME TO A-NAME(JDX + 1)
                       MOVE TMP-BAL  TO A-BAL(JDX + 1)
                   END-IF
               END-PERFORM
           END-PERFORM.

       PRINT-HEADER.
           DISPLAY "==========================================="
           DISPLAY "         DAILY ACCOUNT REPORT              "
           DISPLAY "===========================================".

       APPLY-TRANSACTIONS.
           DISPLAY "TRANSACTIONS:"
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > N-TX
               MOVE 0 TO FOUND-IDX
               PERFORM VARYING JDX FROM 1 BY 1 UNTIL JDX > N-ACC
                   IF A-ID(JDX) = T-ID(IDX)
                       MOVE JDX TO FOUND-IDX
                   END-IF
               END-PERFORM
               EVALUATE T-TYPE(IDX)
                   WHEN "D" MOVE "DEPOSIT   " TO TX-LABEL
                   WHEN "W" MOVE "WITHDRAWAL" TO TX-LABEL
                   WHEN OTHER MOVE "UNKNOWN   " TO TX-LABEL
               END-EVALUATE
               MOVE T-AMOUNT(IDX) TO ED-AMT
               IF FOUND-IDX = 0
                   DISPLAY "  ACC " T-ID(IDX) " " TX-LABEL
                       " " ED-AMT " -> REJECTED (unknown account)"
               ELSE
                   IF T-TYPE(IDX) = "D"
                       ADD T-AMOUNT(IDX) TO A-BAL(FOUND-IDX)
                       DISPLAY "  ACC " T-ID(IDX) " " TX-LABEL
                           " " ED-AMT " -> APPLIED"
                   ELSE
                       IF A-BAL(FOUND-IDX) >= T-AMOUNT(IDX)
                           SUBTRACT T-AMOUNT(IDX) FROM A-BAL(FOUND-IDX)
                           DISPLAY "  ACC " T-ID(IDX) " " TX-LABEL
                               " " ED-AMT " -> APPLIED"
                       ELSE
                           DISPLAY "  ACC " T-ID(IDX) " " TX-LABEL
                               " " ED-AMT
                               " -> REJECTED (insufficient funds)"
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.

       PRINT-FOOTER.
           DISPLAY " "
           DISPLAY "FINAL BALANCES:".

       PRINT-ACCOUNTS.
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > N-ACC
               MOVE A-BAL(IDX) TO ED-BAL
               DISPLAY "  " A-ID(IDX) "  " A-NAME(IDX) " " ED-BAL
           END-PERFORM
           DISPLAY "===========================================".
