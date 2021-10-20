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
                   88 VALID-MONTH VALUES 1 THRU 12.
               06 SALE-DAY         PIC 99.
               06 SALE-YEAR        PIC 99.
           05  SALE-AMOUNT         PIC 9(6). 
           05  COMMISSION-RATE     PIC 9(3).
               88 VALID-COMM-RATE VALUES 0 THRU 100.
           05  CAR-MODEL           PIC X(13).
           05  CAR-YEAR            PIC 9(4).
               88 VALID-CAR-YEAR VALUES 1930 THRU 1995.
      
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
       
      * INVALID DATA RECORD
       01 INVALID-RECORD.
           05 ERROR-MESSAGE PIC X(40) VALUE 'ERROR MESSAGE'.
           05 FILLER        PIC X(5)  VALUE SPACES.
           05 RECORD-DATA   PIC X(90) VALUE 'RECORD DATA'.

      * DATA-REMAINS-SWITCH: KEEP TRACK OF DATA LEFT IN INPUT
       01 DATA-REMAINS-SWITCH PIC X(2) VALUES SPACES.

      * VALID-RECORD-SWITCH: USED WHEN VALIDATING A RECORD
       01 VALID-RECORD-SWITCH PIC X(7) VALUE 'ERROR'.

      * DATA VALIDATION FLAGS
       01 DVF-MISSING-DATA      PIC X VALUE 'F'.
       01 DVF-NONNUMERIC-DATA   PIC X VALUE 'F'.
       01 DVF-INVALID-MONTH     PIC X VALUE 'F'.
       01 DVF-INVALID-DAY       PIC X VALUE 'F'.
       01 DVF-INVALID-COMM-RATE PIC X VALUE 'F'.
       01 DVF-INVALID-CAR-YEAR  PIC X VALUE 'F'.
       01 DVF-INVALID-RECORD    PIC X VALUE 'F'.

      * VALID-DATES DATA
       01 DAYS-IN-MONTH PIC 99.
           88 31-DAYS VALUES 1,3,5,7,8,10,12.
           88 30-DAYS VALUES 4,6,9,11.
           88 28-DAYS VALUES 2.


      * ERROR MESSAGES
       01 ERR-MISSING-DATA                  PIC X(40) 
           VALUE 'INCOMING RECORD MISSING DATA'.
       01 ERR-NONNUMERIC-DATA               PIC X(40)
           VALUE 'NON-NUMERIC DATA'.
       01 ERR-INVALID-DAY                   PIC X(40) 
           VALUE 'INVALID DAY'.
       01 ERR-INVALID-MONTH                 PIC X(40) 
           VALUE 'INVALID MONTH'.
       01 ERR-INVALID-COMMISSION            PIC X(40) 
           VALUE 'INVALID COMMISSION RATE'.
       01 ERR-INVALID-CAR-YEAR              PIC X(40) 
           VALUE 'INVALID CAR YEAR'.


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

      *    RESET DATA FLAGS 
           MOVE 'F' TO DVF-INVALID-RECORD.
           MOVE 'F' TO DVF-MISSING-DATA.
           MOVE 'F' TO DVF-NONNUMERIC-DATA.
           MOVE 'F' TO DVF-INVALID-MONTH.
           MOVE 'F' TO DVF-INVALID-DAY.
           MOVE 'F' TO DVF-INVALID-COMM-RATE.
           MOVE 'F' TO DVF-INVALID-CAR-YEAR.

      *    PERFORM THE VARIOUS VALIDATION CHECKS
           PERFORM CHECK-FOR-MISSING-DATA.
           PERFORM VALIDATE-NUMERIC-DATA.
           PERFORM VALIDATE-SALES-DATE.
           PERFORM VALIDATE-COMMISSION-RATE.
           PERFORM VALIDATE-CAR-YEAR.

      *    CHECK IF RECORD IS VALID
           IF DVF-MISSING-DATA = 'T' OR
                DVF-NONNUMERIC-DATA = 'T' OR
                DVF-INVALID-MONTH = 'T' OR
                DVF-INVALID-DAY = 'T' OR
                DVF-INVALID-COMM-RATE = 'T' OR
                DVF-INVALID-CAR-YEAR = 'T'
                THEN MOVE 'T' TO DVF-INVALID-RECORD.
                
                
      *    OUTPUT THE RECORD TO CORRECT FILE WITH ERROR MESSAGES
           PERFORM WRITE-OUTPUT-RECORD.

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
           IF SALE-LOCATION OF INPUT-RECORD = SPACES 
               MOVE 'T' TO DVF-MISSING-DATA.

           IF BRANCH OF INPUT-RECORD = SPACES
               MOVE 'T' TO DVF-MISSING-DATA.

           IF SALESPERSON OF INPUT-RECORD = SPACES
               MOVE 'T' TO DVF-MISSING-DATA.

           IF CUSTOMER-NAME OF INPUT-RECORD = SPACES
               MOVE 'T' TO DVF-MISSING-DATA.

           IF SALE-AMOUNT OF INPUT-RECORD = SPACES 
               MOVE 'T' TO DVF-MISSING-DATA.


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
           IF BRANCH = SPACES THEN
               MOVE 'T' TO DVF-NONNUMERIC-DATA.

           IF SALE-AMOUNT = SPACES THEN
               MOVE 'T' TO DVF-NONNUMERIC-DATA.


      ******************************************************************
      *
      *    VALIDATE-SALES-DATA
      *
      *    Validates that the input record has a valid sales date.
      *
      ******************************************************************
       VALIDATE-SALES-DATE.

           IF SALE-DATE IS NOT NUMERIC
               MOVE 'T' TO DVF-NONNUMERIC-DATA
           ELSE
               IF VALID-MONTH THEN
                   PERFORM CHECK-DAYS-IN-MONTH
               ELSE
                   MOVE 'T' TO DVF-INVALID-MONTH
               END-IF
           END-IF. 



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

           IF 31-DAYS THEN
               IF SALE-DAY > 31 OR SALE-DAY < 1 THEN
                   MOVE 'T' TO DVF-INVALID-DAY.
                   
           IF 30-DAYS THEN
               IF SALE-DAY > 30 OR SALE-DAY < 1 THEN
                   MOVE 'T' TO DVF-INVALID-DAY.
                   
           IF 28-DAYS THEN
               IF SALE-DAY > 28 OR SALE-DAY < 1 THEN
                   MOVE 'T' TO DVF-INVALID-DAY.
           

      ******************************************************************
      *
      *    VALIDATE-COMMISSION-RATE
      *1
      *    Validates that the input commission rate is not blank, 
      *    numeric, and between 0-100.
      *
      ******************************************************************
       VALIDATE-COMMISSION-RATE.
           IF COMMISSION-RATE = SPACES THEN
               MOVE 'T' TO DVF-MISSING-DATA
           ELSE
               IF COMMISSION-RATE IS NOT NUMERIC THEN
                   MOVE 'T' TO DVF-NONNUMERIC-DATA
               ELSE
                   IF NOT VALID-COMM-RATE THEN
                       MOVE 'T' TO DVF-INVALID-COMM-RATE
               END-IF
           END-IF.  


      ******************************************************************
      *
      *    VALIDATE-CAR-YEAR
      *
      *    Validates that the input record has a Car Year between 30-95.
      *
      ******************************************************************
       VALIDATE-CAR-YEAR.
           IF CAR-YEAR = SPACES THEN
               MOVE 'T' TO DVF-MISSING-DATA
           ELSE
               IF CAR-YEAR IS NOT NUMERIC THEN
                   MOVE 'T' TO DVF-INVALID-CAR-YEAR
               ELSE
                   IF NOT VALID-CAR-YEAR THEN
                       MOVE 'T' TO DVF-INVALID-CAR-YEAR
               END-IF
           END-IF.


      ******************************************************************
      *
      *    WRITE-FILE-HEADINGS
      *
      *    Writes out the column headings to the error report.
      *
      ******************************************************************
       WRITE-FILE-HEADINGS.
           WRITE BAD-PRINT-LINE FROM INVALID-RECORD.

       
      ******************************************************************
      *
      *    WRITE-OUTPUT-RECORD
      *
      *    Writes out the record and errors to appropriate files.
      *
      ******************************************************************
       WRITE-OUTPUT-RECORD.
           IF DVF-INVALID-RECORD =  'F' THEN
               WRITE GOOD-PRINT-LINE FROM INPUT-RECORD
           ELSE
               MOVE INPUT-RECORD TO RECORD-DATA
               
               IF DVF-MISSING-DATA = 'T' THEN
                   MOVE ERR-MISSING-DATA TO ERROR-MESSAGE
                   WRITE BAD-PRINT-LINE FROM INVALID-RECORD
               END-IF

               IF DVF-NONNUMERIC-DATA = 'T' THEN
                   MOVE ERR-NONNUMERIC-DATA TO ERROR-MESSAGE
                   WRITE BAD-PRINT-LINE FROM INVALID-RECORD
               END-IF

               IF DVF-INVALID-MONTH = 'T' THEN
                   MOVE ERR-INVALID-MONTH TO ERROR-MESSAGE
                   WRITE BAD-PRINT-LINE FROM INVALID-RECORD
               END-IF

               IF DVF-INVALID-DAY = 'T' THEN
                   MOVE ERR-INVALID-DAY TO ERROR-MESSAGE
                   WRITE BAD-PRINT-LINE FROM INVALID-RECORD
               END-IF

               IF DVF-INVALID-COMM-RATE = 'T' THEN
                   MOVE ERR-INVALID-COMMISSION TO ERROR-MESSAGE
                   WRITE BAD-PRINT-LINE FROM INVALID-RECORD
               END-IF

               IF DVF-INVALID-CAR-YEAR = 'T' THEN
                   MOVE ERR-INVALID-CAR-YEAR TO ERROR-MESSAGE
                   WRITE BAD-PRINT-LINE FROM INVALID-RECORD
               END-IF

               WRITE BAD-PRINT-LINE FROM SPACES

           END-IF.


       END PROGRAM ASSIGNMENT2.