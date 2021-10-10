# Assignment 2 - Notes

Here are some notes I've gathered about Assignment 2.

## Files

The files that will be used, and need File Descriptors written for, are:

1. Input Data, specified in the assignment
2. Good Data Output, probably just a single line for writing
3. Bad Data Output, probably just a single line for writing


## Records

The complex COBOL Records that could be written:

1. Input Data
2. Good Data Output
3. Bad Data Output
   1. Error Message
   2. Bad Data Record


## Processing Flow

1. Open the Files
2. Read the Input File
3. For each input record
   1. Validate Data
      1. Validate each field of the record that it adheres to specifications
      2. If it's good, do nothing
      3. If it's bad
         1. Write the specific error message and the record to bad output file
         2. Set a flag that this is a bad record
   2. If the flag for good data is still good, then output the record to good data
4. Close the files


## Error Report

Good data is written out same as it came in, no modifications.

A layout for the error report needs to be developed, with the approrpriate accompanying information.
A suggested reference is available in the book, on page 210 (jump to 222).
The column formatting makes sense.
