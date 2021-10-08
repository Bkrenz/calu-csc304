# Assignment 2

**Program Name**: Car Sales Commissions Validation Program

**Narrative**: This project will validate a file of car sales records and produce both a valid car file and an error report.

**Input File(s)**: CAR-SALES-FILE

**Input Record Layout**
```
FIELD NAME          POSITIONS           FIELD TYPE
Location            1-11                Alphanumeric
Branch              12-15               Numeric
Salesperson         16-25               Alphanumeric
Customer Name       26-35               Alphanumeric
Sale Date           36-41               Numeric
Sale Amount         42-47               Numeric
Commission Rate     48-50               Numeric
Car Model           51-63               Alphanumeric
Car Year            64-67               Numeric

```

**Test Data**: See test-data.txt

**Report Layout**: Design your own report layout, subject to the processing requirements.

**Processing Requirements**:

1. Read a file of car sales records.
2. Validate each input record for all of the following:
   1. The incoming record must contain data for the following fields: location, branch, salesperson, customer, sale amount, commission rate, and model year. If any field is missing, display a single message "INCOMING RECORD MISSING DATA", followed by the input record.
   2. The incoming fields of branch, sale date, sale amount, and commission rate must be numeric. If not, display an appropriate error message that contains the entire input record.
   3. Valid dates (sale date): month must be between 1 and 12, inclusive; day should be in conjunction with the month. Display a suitable message "INVALID MONTH" and/or "INVALID DAY", followed by the input record.
   4. A reasonable commission rate; flag any record where the rate is not between 0% and 100%. Use the message "INVALID COMMISSION RATE", followed by the input record.
   5. A reasonable car year; flag any record where the car year is not between 1930 and 1995, inclusive. Use the message "INVALID CAR YEAR", followed by the input record.
3. Any record that fails any validity test is to be rejected with no further processing, other than displaying the appropriate error message(s). It is possible that a record contain more than one error (all errors are to be flagged).
4. Valid records are to be written to a separate file. 

