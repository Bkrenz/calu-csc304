       identification division.
       program-id. Program1.

       environment division.
       configuration section.

       data division.
       working-storage section.
       01 PERSON.
         03 NAME.
           05 FIRST-NAME PIC X(20) VALUE SPACES.
           05 FIRST-NAME PIC X(20) VALUE SPACES.
         03 FAVORITE-NUMBER PIC 9(4) VALUE ZERO.


       procedure division.

      *    ACCEPT SOMETHNG.           GET INPUT AND PUT INTO 'SOMETHING'
      *    TO OUTPUT TO CONSOLE, USE DISPLAY <VARIABLE>.
           DISPLAY 'HELLO WORLD'.

      *    MOVE NUM2 TO NUM1.         COPY THE DATA FROM NUM2 TO NUM1.
      *    ADD NUM1 TO NUM2.
      *    ADD NUM1 TO NUM2 GIVING NUM3.  ADD AND SET SUM INTO NUM3.

      *    PRACTICE PROBLEMS FROM THE BOOK
      *    CHAPTER 1 PROBLEM 8
      *    PAGE 45 PROBLEM 2 PARTS A, B, C
      *    CHAPTER 3 



           goback.

       end program Program1.