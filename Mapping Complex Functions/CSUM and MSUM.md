
# CSUM and MSUM

## Definitions and Usage
`CSUM` is a "cumulative SUM" so it just sums up the previous data and keeps accumulating it

`MSUM` does the same but for a specific number of rows. **!IMPORTANT** the number of rows in **MSUM = (number of rows - 1)** when translating to `SUM`

## Syntax

### CSUM Example
**Example of CSUM in Teradata**

```sql
select cmonth, CSUM(csales,cdate)
from sales
group by cmonth
```

**Translated to Snowflake**

```sql
select cmonth, SUM(csales) OVER (PARTITION cdate ORDER BY cdate ROWS UNBOUNDED PRECEDING)
from sales
```
### MSUM Example

**Example of MSUM in Teradata**
```sql
select cmonth, MSUM(csales,3,cdate)
from sales
group by cmonth
```

**Translated to Snowflake**
```
select cmonth, MSUM(csales) OVER (PARTITION cdate ORDER BY cdate ROWS 2 PRECEDING)
from sales
```


