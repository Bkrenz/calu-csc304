      ******************************************************************
      * CIS/CSC - 304 - COBOL
      * Assignment 2
      * 
      * Authors: ROBERT KRENCY
      * 
      ******************************************************************

       IDENTIFICATION DIVISION.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASSIGNMENT2.
       AUTHOR. 'ROBERT KRENCY'.
      * TODO: ADD AUTHOR NAMES



       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       
       FILE-CONTROL.

      * File Descriptor for Input File
      * File Descriptor for Good Output File
      * File Descriptor for Bad Output File



       DATA DIVISION.
       FILE SECTION.

       WORKING-STORAGE SECTION.

      * Input Data Record
      * Valid Data Output Record
      * Invalid Data Output Record

      * Potential simple variables/flags
      *      End of input file
      *      Is input record a valid record
      *      A variable containing each error string 



       PROCEDURE DIVISION.

      * PREPARE-REPORTS - Main function
      *      Open the files
      *      Write column headers to error report
      *      Read first input in
      *      PERFORM VALIDATE-INPUT until end of file
      *      If valid record, write to file as valid record
      *      Close files
      *      Exit

      * VALIDATE-INPUT
      *      For each potential error (see specificaiton):
      *            If the error is present in the report:
      *                  Set valid record flag to false
      *                  Write the error message and record to invalid output
      *      Read in the next record from input
