      * Tables/Arrays
       
       IDENTIFICATION DIVISION.
       PROGRAM-ID. NOTES-NOV9.
       AUTHOR. 'BOB KRENCY'.

       
       ENVIRONMENT DIVISION.
       

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      * SUBSCRIPT TO USE FOR ARRAY INDEX
       01 SUB-1 PIC 99 USAGE IS COMPUTATIONAL.

       
      * USE THE OCCURS STATEMENT TO MAKE A TABLE
       01 BOWLING-TEAM.
           05 BOWLER OCCURS 10 TIMES.
               08 NAME PIC X(20).
               08 AVG  PIC 999.


       PROCEDURE DIVISION.
       
       PROCESS-TABLES.
           COMPUTE AVG = AVG OF BOWLER (1) + AVG OF BOWLER (2).
           PERFORM 100-PROCESS 
               VARYING SUB-1 FROM 1 BY 1 UNTIL SUB-1 > 10.

       100-PROCESS.
           DISPLAY BOWLER (SUB-1).