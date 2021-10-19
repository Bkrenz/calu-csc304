      ******************************************************************
      * CIS/CSC - 304 - COBOL
      * CHAPTER 8 PROBLEMS
      * 
      * Authors: ROBERT KRENCY
      * Authors: QUANEL ROBINSON
      * 
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHAPTER8-PROBLEMS.
       AUTHOR. 'KRENCY, ROBINSON'.

      * PROBLEM 1.
      * A.
           IF A > B
               IF CD > D
                   MOVE E TO F
               ELSE
                   MOVE G TO H
               END-IF
           END-IF.

      * B.
           IF A > B
               IF CD > D
                   MOVE E TO F
               ELSE
                   MOVE G TO H
               END-IF
           ELSE
               MOVE X TO Y
           END-IF.
                
      * C.
       IF A > B
           IF C > D
               MOVE E TO F 
               ADD 1 TO E
           ELSE 
               MOVE G TO H
               ADD 1 TO G
           END-IF 
       END-IF.

      * D.
       IF A > B 
           MOVE X TO Y 
           MOVE Z TO W 
       ELSE 
           IF C > D 
               MOVE 1 TO N 
           ELSE 
               MOVE 2 TO Y 
               ADD 3 TO Z 
           END-IF
       END-IF.


      * PROBLEM 2

      * A. IN THE FIRST EXAMPLE, THE SECOND IF/ELSE STATEMENT WILL ONLY
      * EXECUTE IF THE FIRST STATEMENT GOES INTO THE ELSE CLAUSE. THE
      * SECOND BLOCK OF CODE WILL ALWAYS EXECUTE ALL 3 IF STATEMENTS.

      * B. THE THIRD IF STATEMENT WILL ALWAYS RUN THE PROCEDURE
      * WRITE-ERROR-MESSAGE.

      * C. THE BLOCK OF CODE UNDER THE ELSE WOULD BE RUN UNDER THE IF
      * CONDITIONAL INSTEAD.


      * PROBLEM 3
      * THEY ARE NOT EQUIVALENT. IN BLOCK 1, 'ADD 1 TO Y' ONLY EXECUTES
      * AFTER THE 'A > B' CONDITIONAL IS TRUE AND 'C > D' IS FALSE, BUT
      * IN BLOCK 2 THE 'ADD 1 TO Y' ONLY RUNS IF BOTH CONDITIONALS
      * 'A > B' AND 'C > D' ARE FALSE.


      * PROBLEM 4 
       01 EMPLOYEE-DEPARTMENT PIC 99.
           88 MANUFACTURING VALUES 10, 12, 16 THRU 30, 41, 56.
           88 MARKETING VALUES 6 THRU 9, 15, 31 THRU 33.
           88 FINANCIAL VALUES 60 THRU 62, 75.
           88 ADMINISTRATIVE VALUES 1 THRU 4, 78.
           88 VALID VALUES 10, 12, 16 THRU 30, 41, 56,
                           6 THRU 9, 15, 31 THRU 33,
                           60 THRU 62, 75,
                           1 THRU 4, 78.

      
      
      * PROBLEM 5

      * A. NO
      * B. YES
      * C. YES
      * D. YES
      * E. YES
      * F. NO
      * G. NO
      * H. YES
      * I. NO
