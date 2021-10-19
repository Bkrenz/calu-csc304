      ******************************************************************
      * CIS/CSC - 304 - COBOL
      * Assignment 2
      * 
      * Authors: ROBERT KRENCY
      * 
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASSIGNMENT2.
       AUTHOR. 'KRENCY, ROBINSON, MORRIS, MORRISON'.


       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       
       FILE-CONTROL.

           SELECT INPUT-FILE ASSIGN TO 'INPUT.TXT'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT VALID-RECORDS-FILE ASSIGN TO 'GOOD.TXT'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT INVALID-RECORDS-FILE ASSIGN TO 'BAD.TXT'
               ORGANIZATION IS LINE SEQUENTIAL.



       DATA DIVISION.
       FILE SECTION.

      * INPUT RECORD FILE INFORMATION
       FD INPUT-FILE 
           RECORD CONTAINS 67 CHARACTERS
           DATA RECORD IS INPUT-RECORD.
       01 INPUT-RECORD.
           05  SALE-LOCATION       PIC X(11).
           05  BRANCH              PIC 9(4). 
           05  SALESPERSON         PIC X(10).
           05  CUSTOMER-NAME       PIC X(10). 
           05  SALE-DATE.
               06 SALE-MONTH       PIC 99.
               06 SALE-DAY         PIC 99.
               06 SALE-YEAR        PIC 99.
           05  SALE-AMOUNT         PIC 9(6). 
           05  COMMISSION-RATE     PIC 9(3).
           05  CAR-MODEL           PIC X(13).
           05  CAR-YEAR            PIC 9(4).
      
      * GOOD RECORD OUTPUT INFORMATION
       FD VALID-RECORDS-FILE
           RECORD CONTAINS 100 CHARACTERS
           DATA RECORD IS GOOD-PRINT-LINE.
       01 GOOD-PRINT-LINE PIC X(150) VALUE SPACES.

      * BAD RECORD OUTPUT INFORMATION
       FD INVALID-RECORDS-FILE
           RECORD CONTAINS 112 CHARACTERS
           DATA RECORD IS BAD-PRINT-LINE.
       01 BAD-PRINT-LINE PIC X(150) VALUE SPACES.



       WORKING-STORAGE SECTION.

      * DATA-REMAINS-SWITCH: KEEP TRACK OF DATA LEFT IN INPUT
       01 DATA-REMAINS-SWITCH PIC X(2) VALUES SPACES.

      * VALID-RECORD-SWITCH: USED WHEN VALIDATING A RECORD
       01 VALID-RECORD-SWITCH PIC X(7) VALUE 'ERROR'.

      * MISSING-DATA-SWITCH
       01 MISSING-DATA-SWITCH PIC X VALUE 'F'.

      * VALID-DATE-FLAG
       01 VALID-DATE-FLAG PIC X VALUE 'T'.

      * INVALID-DAY-SWITCH
       01 INVALID-DAY-SWITCH  PIC X VALUE 'F'.

      * VALID-DATES DATA
       01 DAYS-IN-MONTH PIC 99.
           88 31-DAYS VALUES 1,3,5,7,8,10,12.
           88 30-DAYS VALUES 4,6,9,11.
           88 28-DAYS VALUES 2.

      * INVALID DATA RECORD
       01 INVALID-RECORD.
           05 ERROR-MESSAGE PIC X(40) VALUE SPACES.
           05 FILLER        PIC X(5)  VALUE SPACES.
           05 RECORD-DATA   PIC X(90) VALUE SPACES.

      * ERROR MESSAGES
       01 ERR-MISSING-DATA  PIC X(40) VALUE 
           'INCOMING RECORD MISSING DATA'.
       01 ERR-INVALID-DAY   PIC X(40) VALUE 'INVALID DAY'.
       01 ERR-INVALID-MONTH PIC X(40) VALUE 'INVALID MONTH'.
       01 ERR-INVALID-COMMISSION   PIC X(40) VALUE
           'INVALID COMMISSION RATE'.
       01 ERR-INVALID-CAR-YEAR     PIC X(40) VALUE
           'INVALID CAR YEAR'.


       PROCEDURE DIVISION.

      ******************************************************************
      *
      *    PREPARE-REPORTS
      *
      *    Entry point of the program. 
      *
      ******************************************************************
       PREPARE-REPORTS.
           
      *    OPEN THE FILES
           OPEN INPUT INPUT-FILE
                OUTPUT VALID-RECORDS-FILE
                OUTPUT INVALID-RECORDS-FILE.

      *    READ THE FIRST DATA RECORD IN FROM INPUT-FILE
           READ INPUT-FILE
                AT END
                    MOVE 'NO' TO DATA-REMAINS-SWITCH
           END-READ.

      *    WRITE THE FILE HEADINGS FOR THE ERROR REPORT
           PERFORM WRITE-FILE-HEADINGS.

      *    LOOP THROUGH VALIDATING RECORDS UNTIL END OF FILE
           PERFORM VALIDATE-DATA
               UNTIL DATA-REMAINS-SWITCH = 'NO'.

      *    CLOSE THE FILES
           CLOSE INPUT-FILE
                 VALID-RECORDS-FILE
                 INVALID-RECORDS-FILE.

      *    EXIT THE PROGRAM
           STOP RUN.


      ******************************************************************
      *
      *    VALIDATE-DATA
      *
      *    Validates that the input records are correct by the following
      *      - Must contain data in specified fields
      *      - Numeric fields must contain numeric data
      *      - Dates must be valid
      *      - Commission Rate must be between 0-100
      *      - Car Year is between 1930-1965
      *
      ******************************************************************
       VALIDATE-DATA.

      *    CLEAR DATA IN THE INVALID RECORD OUTPUT 
           MOVE 'T' TO VALID-RECORD-SWITCH.

      *    PERFORM THE VARIOUS VALIDATION CHECKS
           PERFORM CHECK-FOR-MISSING-DATA.
           PERFORM VALIDATE-NUMERIC-DATA.
           PERFORM VALIDATE-SALES-DATE.
           PERFORM VALIDATE-COMMISSION-RATE.
           PERFORM VALIDATE-CAR-YEAR.

      *    IF THE RECORD IS INVALID, OUTPUT A BLANK LINE TO BAD.TXT
           IF VALID-RECORD-SWITCH = 'F' THEN
               MOVE SPACES TO ERROR-MESSAGE
               MOVE SPACES TO RECORD-DATA
               MOVE INVALID-RECORD TO BAD-PRINT-LINE
               WRITE BAD-PRINT-LINE.

      *    IF THE RECORD IS STILL VALID, OUTPUT AS GOOD RECORD
           IF VALID-RECORD-SWITCH = 'T' THEN
               MOVE INPUT-RECORD TO GOOD-PRINT-LINE
               WRITE GOOD-PRINT-LINE.

      *    READ THE NEXT DATA RECORD IN FROM INPUT-FILE
           READ INPUT-FILE
                AT END
                    MOVE 'NO' TO DATA-REMAINS-SWITCH
           END-READ.


      ******************************************************************
      *
      *    CHECK-FOR-MISSING-DATA
      *
      *    Validates that the input record has data in each required
      *      field:
      *        Location, Branch, Salesperson, Customer, Sale Amount,
      *        Commission Rate, Model Year
      *
      ******************************************************************
       CHECK-FOR-MISSING-DATA.
           MOVE 'F' TO MISSING-DATA-SWITCH.

           IF SALE-LOCATION OF INPUT-RECORD = SPACES 
               MOVE 'T' TO MISSING-DATA-SWITCH.

           IF BRANCH OF INPUT-RECORD = SPACES
               MOVE 'T' TO MISSING-DATA-SWITCH.

           IF SALESPERSON OF INPUT-RECORD = SPACES
               MOVE 'T' TO MISSING-DATA-SWITCH.

           IF CUSTOMER-NAME OF INPUT-RECORD = SPACES
               MOVE 'T' TO MISSING-DATA-SWITCH.

           IF SALE-AMOUNT OF INPUT-RECORD = SPACES 
               MOVE 'T' TO MISSING-DATA-SWITCH.

           IF COMMISSION-RATE OF INPUT-RECORD = SPACES
               MOVE 'T' TO MISSING-DATA-SWITCH.

           IF CAR-YEAR OF INPUT-RECORD = SPACES
               MOVE 'T' TO MISSING-DATA-SWITCH.

           IF MISSING-DATA-SWITCH = 'T' THEN
               MOVE ERR-MISSING-DATA TO ERROR-MESSAGE
               MOVE INPUT-RECORD TO RECORD-DATA OF INVALID-RECORD 
               MOVE INVALID-RECORD TO BAD-PRINT-LINE
               WRITE BAD-PRINT-LINE
               MOVE 'F' TO VALID-RECORD-SWITCH.


      ******************************************************************
      *
      *    VALIDATE-NUMERIC-DATA
      *
      *    Validates that the input record contains numeric data in
      *      the required numeric fields:
      *        Branch, Sale Date, Sale Amount, Commission Rate
      *
      ******************************************************************
       VALIDATE-NUMERIC-DATA.


      ******************************************************************
      *
      *    VALIDATE-SALES-DATA
      *
      *    Validates that the input record has a valid sales date.
      *
      ******************************************************************
       VALIDATE-SALES-DATE.
           MOVE 'T' TO VALID-DATE-FLAG.

           IF SALE-MONTH > 12 OR SALE-MONTH < 1
               MOVE 'F' TO VALID-DATE-FLAG.

           IF VALID-DATE-FLAG = 'F' THEN
               MOVE ERR-INVALID-MONTH TO ERROR-MESSAGE
               MOVE INPUT-RECORD TO RECORD-DATA
               MOVE INVALID-RECORD TO BAD-PRINT-LINE
               WRITE BAD-PRINT-LINE
               MOVE 'F' TO VALID-RECORD-SWITCH.

           IF VALID-DATE-FLAG = 'T' THEN
                PERFORM CHECK-DAYS-IN-MONTH.



      ******************************************************************
      *
      *    CHECK-DAYS-IN-MONTH
      *
      *    Checks that the day of the date is a legal value for the
      *      corresponding month, ie February can't have a 30th Day.
      *    
      ******************************************************************
       CHECK-DAYS-IN-MONTH.

           MOVE SALE-MONTH TO DAYS-IN-MONTH.
           MOVE 'F' TO INVALID-DAY-SWITCH.

           IF 31-DAYS THEN
               IF SALE-DAY > 31 OR SALE-DAY < 1 THEN
                   MOVE 'T' TO INVALID-DAY-SWITCH.
                   
           IF 30-DAYS THEN
               IF SALE-DAY > 30 OR SALE-DAY < 1 THEN
                   MOVE 'T' TO INVALID-DAY-SWITCH.
                   
           IF 28-DAYS THEN
               IF SALE-DAY > 28 OR SALE-DAY < 1 THEN
                   MOVE 'T' TO INVALID-DAY-SWITCH.

           IF INVALID-DAY-SWITCH = 'T'
               MOVE ERR-INVALID-DAY TO ERROR-MESSAGE
               MOVE INPUT-RECORD TO RECORD-DATA
               MOVE INVALID-RECORD TO BAD-PRINT-LINE
               WRITE BAD-PRINT-LINE
               MOVE 'F' TO VALID-RECORD-SWITCH.
           

      ******************************************************************
      *
      *    VALIDATE-COMMISSION-RATE
      *
      *    Validates that the input commission rate is between 0-100.
      *
      ******************************************************************
       VALIDATE-COMMISSION-RATE.
           IF COMMISSION-RATE > 100 OR COMMISSION-RATE < 0 THEN
                MOVE ERR-INVALID-COMMISSION TO ERROR-MESSAGE
                MOVE INPUT-RECORD TO RECORD-DATA
                MOVE INVALID-RECORD TO BAD-PRINT-LINE
                WRITE BAD-PRINT-LINE
                MOVE 'F' TO VALID-RECORD-SWITCH.

      ******************************************************************
      *
      *    VALIDATE-CAR-YEAR
      *
      *    Validates that the input record has a Car Year between 30-95.
      *
      ******************************************************************
       VALIDATE-CAR-YEAR.
           IF CAR-YEAR > 1995 OR CAR-YEAR < 1930 THEN
               MOVE ERR-INVALID-CAR-YEAR TO ERROR-MESSAGE
               MOVE INPUT-RECORD TO RECORD-DATA
               MOVE INVALID-RECORD TO BAD-PRINT-LINE
               WRITE BAD-PRINT-LINE
               MOVE 'F' TO VALID-RECORD-SWITCH.


      ******************************************************************
      *
      *    WRITE-FILE-HEADINGS
      *
      *    Writes out the column headings to the error report.
      *
      ******************************************************************
       WRITE-FILE-HEADINGS.


       END PROGRAM ASSIGNMENT2.