# MAVG

## Definitions and Usage

from: https://www.wisdomjobs.com/e-university/teradata-tutorial-212/moving-average-using-the-mavg-function-6079.html

> A moving average incorporates the same window of rows and addition as seen in the MSUM. However, the aspect of the average incorporates a count of all the values involved and then divides the sum by the count to obtain the average.

> The Moving Average (MAVG) function provides a moving average on a column's value, based on a defined number of rows also known as the query width. Like the MSUM, the MAVG defaults to ascending order for the sort. So, once you learn the MSUM, the MAVG is easier to learn because of the similarities.

> If the number of rows is less than the width defined then the calculation will be based on the rows present.

## Syntax

```sql
SELECT MAVG( <column-name>, <width>, <sort-key> [ASC |  DESC])[, <sort-key> [ASC | DESC] )
  FROM  <table-name>
  [GROUP BY  
        <group-by-column-name1> 
      [,<group-by-column-number1> ] ]
  ;
```  

**Translated to Snowflake**

```sql
select AVG( <column-name>) OVER (
    [PARTITION BY 
        <group-by-column-name1> 
        [,<group-by-column-number1> ] ]
    ]
    ORDER BY <sort-key> ROWS UNBOUNDED <width> PRECEDING)
from <table-name>
```