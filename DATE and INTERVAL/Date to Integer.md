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

