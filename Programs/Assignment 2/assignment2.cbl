      ******************************************************************
      * CIS/CSC - 304 - COBOL
      * Assignment 2
      * 
      * Authors: ROBERT KRENCY
      * 
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASSIGNMENT2.
       AUTHOR. 'ROBERT KRENCY'.
       AUTHOR. 'QUANEL ROBINSON'.
       AUTHOR. 'BRIAN MORRIS'.
       AUTHOR. 'CHRISTIAN MORRISON'.


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
                 06 SALE-MONTH        PIC 99.
                 06 SALE-DAY          PIC 99.
                 06 SALE-YEAR         PIC 99.
              05  SALE-AMOUNT         PIC 9(6). 
              05  COMMISSION-RATE     PIC 9(3).
              05  CAR-MODEL           PIC X(13).
              05  CAR-YEAR            PIC 9(4).
      
      * GOOD RECORD OUTPUT INFORMATION
       FD VALID-RECORDS-FILE
           RECORD CONTAINS 50 CHARACTERS
           DATA RECORD IS GOOD-PRINT-LINE.
       01 GOOD-PRINT-LINE PIC X(67) VALUE SPACES.

      * BAD RECORD OUTPUT INFORMATION
       FD INVALID-RECORDS-FILE
           RECORD CONTAINS 67 CHARACTERS
           DATA RECORD IS BAD-PRINT-LINE.
       01 BAD-PRINT-LINE PIC X(112) VALUE SPACES.



       WORKING-STORAGE SECTION.

      * DATA-REMAINS-SWITCH: KEEP TRACK OF DATA LEFT IN INPUT
       01 DATA-REMAINS-SWITCH PIC X(2) VALUES SPACES.

      * VALID-RECORD-SWITCH: USED WHEN VALIDATING A RECORD
       01 VALID-RECORD-SWITCH PIC X(7) VALUE 'ERROR'.

      * INVALID DATA RECORD
       01 INVALID-RECORD.
           05 ERROR-MESSAGE PIC X(40) VALUE SPACES.
           05 FILLER        PIC X(5)  VALUE SPACES.
           05 RECORD-DATA   PIC X(63) VALUE SPACES.


       PROCEDURE DIVISION.

      * PREPARE-REPORTS - Main function
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



      * VALIDATE-INPUT
      *      For each potential error (see specificaiton):
      *            If the error is present in the report:
      *                  Set valid record flag to false
      *                  Write the error message and record to invalid output
      *      Read in the next record from input
       VALIDATE-DATA.

      *    CLEAR DATA IN THE INVALID RECORD OUTPUT 

           PERFORM CHECK-FOR-MISSING-DATA.
           PERFORM VALIDATE-NUMERIC-DATA.
           PERFORM VALIDATE-SALES-DATE.
           PERFORM VALIDATE-COMMISSION-RATE.
           PERFORM VALIDATE-CAR-YEAR.

      *    IF THE RECORD IS INVALID, OUTPUT A BLANK LINE TO BAD.TXT

      *    IF THE RECORD IS STILL VALID, OUTPUT AS GOOD RECORD



       CHECK-FOR-MISSING-DATA.

       VALIDATE-NUMERIC-DATA.

       VALIDATE-SALES-DATE.

       VALIDATE-COMMISSION-RATE.

       VALIDATE-CAR-YEAR.

      * WRITE-FILE-HEADINGS
      *    WRITE OUT THE FILE HEADINGS FOR THE ERROR REPORT
       WRITE-FILE-HEADINGS.


       END PROGRAM ASSIGNMENT2.