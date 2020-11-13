# Date to Integer

## Definitions and Usage

Teradata allows an implicit conversion from DATE to INT.

That conversion follows this formula:


From DATE TO INT:

> `YEAR - 1900 * 10000 + MONTH * 100 + DAY`

From INT to DATE:

>`VALUE + 19000000 `


you can use an UDF

```sql
CREATE FUNCTION PUBLIC.DATE_TO_INT_UDF(datevalue DATE) 
RETURNS INT
AS 
$$
(EXTRACT(YEAR FROM datevalue) - 1900) * 10000 + (EXTRACT(MONTH FROM datevalue) * 100) + (EXTRACT(DAY FROM datevalue))
$$

CREATE OR REPLACE FUNCTION "INT_TO_DATE_UDF"(INPUT_1 NUMBER)
RETURNS DATE
LANGUAGE SQL
AS '
TO_DATE(CAST(INPUT_1+19000000 AS CHAR(8)), ''YYYYMMDD'')
';
```


A common used literal is:

`80991231 => '9999-12-31'`
  
just replace that by its date value `9999-12-31`



-- Weird date conversion behaviour
SELECT CAST(201001 as DATE format 'YYYYMM')
-- This returns 1920-10-01

-- Why
-- Teradata converts INT to date using the formula value + 19000000
-- that return 1920-10-01
SELECT CAST(CAST(201001 as DATE format 'YYYYMM') AS VARCHAR(8))
-- That retuns 192010

-- Than means that the equivalent in snowflake for int numbers is:
-- for SELECT CAST(201001 as DATE format 'YYYYMM')
is 

select TO_DATE((201001 + 19000000)::VARCHAR,'YYYYMMDD')
-- because the output is a date
-- but if you are then casting to varchar
-- like in SELECT CAST(CAST(201001 as DATE format 'YYYYMM') AS VARCHAR(8))
-- Teradata carries the last format for the date value, then the equivalent is:
SELECT CAST(CAST(201001 as DATE format 'YYYYMM') AS VARCHAR(8))
