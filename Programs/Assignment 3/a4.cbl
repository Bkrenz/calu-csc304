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

           SELECT INPUT-FILE ASSIGN TO 'input.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT OUTPUT-FILE ASSIGN TO 'output.txt'
               ORGANIZATION IS LINE SEQUENTIAL.



       DATA DIVISION.
       FILE SECTION.

      * INPUT RECORD FILE INFORMATION
       FD INPUT-FILE 
           RECORD CONTAINS 33 CHARACTERS
           DATA RECORD IS INPUT-RECORD.
       01 INPUT-RECORD.
           03 FIRST-NAME PIC X(10).
           03 LAST-NAME  PIC X(15).
           03 HOURS      PIC 99V99.
           03 RATE       PIC 99V99.

       FD OUTPUT-FILE
           RECORD CONTAINS 32 CHARACTERS
           DATA RECORD IS OUTPUT-RECORD.
       01 OUTPUT-RECORD PIC X(42).
      

       WORKING-STORAGE SECTION

      * EMPLOYEES TABLES
       01 EMPLOYEES-TABLE.
           03 EMPLOYEE OCCURS 25 TIMES.
               05 LAST-NAME PIC X(15).
               05 FIRST-NAME PIC X(10).
               05 GROSS-PAY PIC $ZZ,ZZ9.99.

      * DATA-REMAINS-SWITCH: KEEP TRACK OF DATA LEFT IN INPUT
       01 DATA-REMAINS-SWITCH PIC X(2) VALUES SPACES.

      * HOURS-WORKED-SWITCH: TRACK IF ALL EMPLOYEES WORKED 35 HOURS
       01 HOURS-WORKED-SWITCH PIC X VALUE 'T'.


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
                OUTPUT OUTPUT-FILE.

      *    READ THE FIRST DATA RECORD IN FROM INPUT-FILE
           READ INPUT-FILE
                AT END
                    MOVE 'NO' TO DATA-REMAINS-SWITCH
           END-READ.

      *    LOOP THROUGH VALIDATING RECORDS UNTIL END OF FILE
           PERFORM PROCESS-INPUT-RECORD
               UNTIL DATA-REMAINS-SWITCH = 'NO'.

      *    IF ALL EMPLOYEES WORKED 35 HOURS, APPLY BONUSES.
           IF HOURS-WORKED-SWITCH = 'T' THEN
               PERFORM APPLY-BONUS.

      *    OUTPUT ALL OF THE EMPLOYEES
           PERFORM WRITE-OUTPUT.

      *    CLOSE THE FILES
           CLOSE INPUT-FILE
                 OUTPUT-FILE.

      *    EXIT THE PROGRAM
           STOP RUN.



      ******************************************************************
      *
      *    PROCESS-INPUT-RECORD
      *
      *    PROCESSES THE INPUT RECORD BY DOING THE FOLLOWING:
      *        - MOVES NAME DATA TO RELEVANT FIELD
      *        - CHECKS IF EMPLOYEE WORKED MORE THAN 35 HOURS
      *        - CALCULATES THE GROSS PAY
      *        - READS THE NEXT RECORD IN
      *
      ******************************************************************
       PROCESS-INPUT-RECORD.

      *    MOVE NAME DATA FROM INPUT-RECORD TO EMPLOYEE TABLE AT INDEX

      *    CHECK IF HOURS WORKED IS LESS THAN 35
      *        IF < 35, SET HOURS-WORKED-SWITCH TO 'F'.

      *    CALCULATE THE GROSS PAY, REMEMBERING OVERTIME, MOVE TO TABLE

      *    READ THE NEXT RECORD IN
           READ INPUT-FILE
                AT END
                    MOVE 'NO' TO DATA-REMAINS-SWITCH
           END-READ.



      ******************************************************************
      *
      *    APPLY-BONUS.
      *
      *    IF ALL EMPLOYEES WORKED 35+ HOURS, APPLY A $50 BONUS TO ALL.
      *
      ******************************************************************
       APPLY-BONUS.

      *    LOOP THROUGH ALL EMPLOYEES IN TABLE, ADD 50 TO EACH PAY



      ******************************************************************
      *
      *    WRITE-OUTPUT.
      *
      *    WRITES OUT ALL EMPLOYEE RECORDS TO THE OUTPUT.
      *
      ******************************************************************
       WRITE-OUTPUT.

      *    FOR EACH EMPLOYEE IN THE EMPLOYEES TABLE
      *        WRITE THE EMPLOYEE TO THE OUTPUT FILE.


       END PROGRAM ASSIGNMENT2.