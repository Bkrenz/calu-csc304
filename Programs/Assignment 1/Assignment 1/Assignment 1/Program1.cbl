       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASSIGNMENT1.
       AUTHOR. 'KRENCY-KRESS-PADILLA'.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTOMER-FILE ASSIGN TO 'INPUT.TXT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT VALID-RECORDS ASSIGN TO 'GOOD.TXT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT INVALID-RECORDS ASSIGN TO 'BAD.TXT'
               ORGANIZATION IS LINE SEQUENTIAL.


       DATA DIVISION.
       FILE SECTION.

      * CUSTOMER FILE INFORMATION
       FD CUSTOMER-FILE
           RECORD CONTAINS 70 CHARACTERS
           DATA RECORD IS CUSTOMER.
       01 CUSTOMER.
         03 FIRST-NAME PIC X(12).
         03 LAST-NAME PIC X(12).
         03 STREET-ADDRESS PIC X(15).
         03 CITY PIC X(13).
         03 STATE PIC X(2).
         03 ACCOUNT-NUMBER PIC 9(6).
         03 PREV-METER-READING PIC 9(5).
         03 CURR-METER-READING PIC 9(5).

      * GOOD RECORD OUTPUT INFORMATION
       FD VALID-RECORDS
           RECORD CONTAINS 50 CHARACTERS
           DATA RECORD IS GOOD-PRINT-LINE.
       01 GOOD-PRINT-LINE PIC X(85) VALUE SPACES.

      * BAD RECORD OUTPUT INFORMATION
       FD INVALID-RECORDS
           RECORD CONTAINS 16 CHARACTERS
           DATA RECORD IS BAD-PRINT-LINE.
       01 BAD-PRINT-LINE PIC X(70).

       WORKING-STORAGE SECTION.

      * DATA-REMAINS-SWITCH: KEEP TRACK OF DATA LEFT IN INPUT
       01 DATA-REMAINS-SWITCH PIC X(2) VALUES SPACES.

      * VALID-RECORD-SWITCH: USED WHEN VALIDATING A RECORD
       01 VALID-RECORD-SWITCH PIC 9(1) VALUE ZERO.

       01 VALID-RECORD.
         03 LAST-NAME PIC X(12).
         03 FILLER PIC X(5) VALUE SPACES.
         03 FIRST-NAME PIC X(12).
         03 FILLER PIC X(5) VALUE SPACES.
         03 ACCOUNT-NUMBER PIC 9(6).
         03 FILLER PIC X(14) VALUE SPACES.
         03 STREET-ADDRESS PIC X(15).
         03 FILLER PIC X(5) VALUE SPACES.
         03 UNITS-USED PIC 9(5).

       01 GOOD-HEADING.
         03 FILLER         PIC X(12)    VALUE 'LAST NAME'.
         03 FILLER         PIC X(5)     VALUE SPACES.
         03 FILLER         PIC X(12)    VALUE 'FIRST NAME'.
         03 FILLER         PIC X(5)     VALUE SPACES.
         03 FILLER         PIC X(15)    VALUE 'ACCOUNT NUMBER'.
         03 FILLER         PIC X(5)     VALUE SPACES.
         03 FILLER         PIC X(15)    VALUE 'STREET ADDRESS'.
         03 FILLER         PIC X(5)     VALUE SPACES.
         03 FILLER         PIC X(10)     VALUE 'UNITS USED'.

       01 INVALID-RECORD.
         03 ACCOUNT-NUMBER PIC 9(6).
         03 FILLER PIC X(15) VALUE SPACES.
         03 CURR-READING PIC 9(5).
         03 FILLER PIC X(16).
         03 PREV-READING PIC 9(5).
         03 FILLER PIC X(29).

       01 BAD-HEADING.
         03 FILLER PIC X(16) VALUE 'ACCOUNT NUMBER  '.
         03 FILLER PIC X(5) VALUE SPACES.
         03 FILLER PIC X(16) VALUE 'CURRENT READING '.
         03 FILLER PIC X(5) VALUE SPACES.
         03 FILLER PIC X(16) VALUE 'PREVIOUS READING'.
         03 FILLER PIC X(12) VALUE SPACES.

       PROCEDURE DIVISION.

      ******************************************************************
      *
      *    PREPARE REPORTS
      *
      *    THIS FUNCTION IS THE MAIN ENTRY POINT. IT HANDLES FILE OPEN/
      *    CLOSE OPERATIONS AND DELEGATES TO PROCESS-RECORDS.
      *
      ******************************************************************
      
       PREPARE-REPORTS.
      *    OPEN THE FILES TO USE
           OPEN INPUT CUSTOMER-FILE
             OUTPUT VALID-RECORDS
             OUTPUT INVALID-RECORDS.

      *    READ THE FIRST DATA RECORD, TO ENSURE THE FILE CONTAINS DATA
           READ CUSTOMER-FILE
               AT END
                   MOVE 'NO' TO DATA-REMAINS-SWITCH
           END-READ.

      *    WRITE THE HEADINGS TO THE OUTPUT FILES
           PERFORM WRITE-HEADING-LINES.

      *    PROCESS RECORDS UNTIL THERE ARE NO MORE AVAILABLE IN INPUT
           PERFORM PROCESS-RECORDS
             UNTIL DATA-REMAINS-SWITCH = 'NO'.

      *    CLOSE FILES
           CLOSE CUSTOMER-FILE
             VALID-RECORDS
             INVALID-RECORDS.

      *    EXIT PROGRAM
           STOP RUN.



      ******************************************************************
      *
      *    WRITE HEADLING LINES
      *
      *    WRITE LINE HEADINGS TO OUTPUT FILES.
      *
      ******************************************************************
       WRITE-HEADING-LINES.
           MOVE BAD-HEADING TO BAD-PRINT-LINE.
           WRITE BAD-PRINT-LINE.

           MOVE GOOD-HEADING TO GOOD-PRINT-LINE.
           WRITE GOOD-PRINT-LINE.



      ******************************************************************
      *
      *    PROCESS-RECORDS
      *
      *    THIS FUNCTION IS THE CONTROL FOR DETERMINING HOW TO PROCESS
      *    THE GIVEN RECORD.
      *
      ******************************************************************
       PROCESS-RECORDS.
      *    VALIDATE THE CURRENT RECORD FIRST
           PERFORM VALIDATE-RECORD

      *    IF IT IS VALID (VALID-RECORD-SWITCH = 0), PROCESS AS
      *        VALID-RECORD
           IF VALID-RECORD-SWITCH IS ZERO THEN
               PERFORM PROCESS-VALID-RECORD.

      *    IF IT IS INVALID (VALID-RECORD-SWITCH > 0),
      *        PROCESS AS INVALID-RECORD
           IF VALID-RECORD-SWITCH IS POSITIVE THEN
               PERFORM PROCESS-INVALID-RECORD.

      *    READ THE NEXT RECORD IN, IF ONE DOES NOT EXIST, SET
      *    SET DATA REMAINS SWITCH TO 'NO'
           READ CUSTOMER-FILE
               AT END
                   MOVE 'NO' TO DATA-REMAINS-SWITCH
           END-READ.



      ******************************************************************
      *
      *    VALIDATE-RECORD
      *
      *    THIS VALIDATES AN INPUT RECORD.
      *        A VALID RECORD IS DEFINED BY HAVING NUMERIC VALUES IN  
      *            EACH OF THE FIELDS 'ACCOUNT NUMBER', 'PREVIOUS
      *            METER READING', AND 'CURRENT METER READING'.
      *
      *        AN INVALID FIELD IS DEFINED BY HAVING NON-NUMERIC VALUES
      *            IN ANY OF THOSE THREE FIELDS.
      *
      *    VALID-RECORD-SWITCH WILL BE ZERO WITH A VALID INPUT RECORD,
      *    AND GREATER THAN ZERO WITH AN INVALID RECORD.
      *
      ******************************************************************
       VALIDATE-RECORD.
      
      *    SET VALID-RECORD-SWITCH TO ZERO.
           MOVE ZERO TO VALID-RECORD-SWITCH.

      *    IF ACCOUNT-NUMBER CONTAINS NON-NUMERIC VALUES
      *        INCREMENT VALID-RECORD-SWITCH BY ONE.
           IF ACCOUNT-NUMBER OF CUSTOMER IS NOT NUMERIC
               ADD 1 TO VALID-RECORD-SWITCH.

      *    IF CURRENT-READING CONTAINS NON-NUMERIC VALUES
      *        INCREMENT VALID-RECORD-SWITCH BY ONE.
           IF PREV-METER-READING IS NOT NUMERIC
               ADD 1 TO VALID-RECORD-SWITCH.

      *    IF PREVIOUS READING CONTAINS NON-NUMERIC VALUES
      *        INCREMENT VALID-RECORD-SWITCH BY ONE.
           IF CURR-METER-READING IS NOT NUMERIC
               ADD 1 TO VALID-RECORD-SWITCH.

      ******************************************************************
      *
      *    PROCESS-INVALID-RECORD
      *
      *    THIS FUNCTIONS HANDLES MOVING DATA TO THE INVALID-RECORD 
      *    RECORD
      *    AND WRITING IT TO FILE.
      *
      ******************************************************************
       PROCESS-INVALID-RECORD.
      *    MOVE DATA INTO THE INVALID-RECORD RECORD
           MOVE ACCOUNT-NUMBER OF CUSTOMER TO ACCOUNT-NUMBER OF
             INVALID-RECORD.
           MOVE PREV-METER-READING TO PREV-READING.
           MOVE CURR-METER-READING TO CURR-READING.

      *    WRITE DATA TO OUTPUT FILE
           MOVE INVALID-RECORD TO BAD-PRINT-LINE.
           WRITE BAD-PRINT-LINE.




      ******************************************************************
      *
      *    PROCESS-VALID-RECORD
      *
      *    THIS MOVES DATA INTO THE VALID-RECORD RECORD AND WRITES IT
      *    TO THE OUTPUT FILE
      *
      ******************************************************************
       PROCESS-VALID-RECORD.
      *    MOVE DATA INTO THE VALID-RECORD MODEL
           MOVE FIRST-NAME OF CUSTOMER TO FIRST-NAME OF VALID-RECORD.
           MOVE LAST-NAME OF CUSTOMER TO LAST-NAME OF VALID-RECORD.
           MOVE ACCOUNT-NUMBER OF CUSTOMER TO ACCOUNT-NUMBER OF
             VALID-RECORD.
           MOVE STREET-ADDRESS OF CUSTOMER TO STREET-ADDRESS OF
             VALID-RECORD.
           MOVE CURR-METER-READING TO UNITS-USED.

      *    WRITE THE DATA TO OUTPUT FILE
           MOVE VALID-RECORD TO GOOD-PRINT-LINE.
           WRITE GOOD-PRINT-LINE.



       END PROGRAM ASSIGNMENT1.