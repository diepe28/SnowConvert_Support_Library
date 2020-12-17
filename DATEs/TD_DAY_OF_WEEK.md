# TERADATA TD_DAY_OF_WEEK

Teradata TD_DAY_OF_WEEK returns an integer corresponding to the day of the week.

| Day       | Result |
+-----------|--------|
| Sunday    | 1      |
| Monday    | 2      |
| Tuesday   | 3      |
| Wednesday | 4      |
| Thurday   | 5      |
| Friday    | 6      |
| Saturday  | 7      |

for example:
```sql
select 
td_day_of_week(to_date('1976-01-04')) Sunday,
td_day_of_week(to_date('1976-01-05')) Monday,
td_day_of_week(to_date('1976-01-06')) Tuesday,
td_day_of_week(to_date('1976-01-07')) Wednesday,
td_day_of_week(to_date('1976-01-08')) Thursday,
td_day_of_week(to_date('1976-01-09')) Friday,
td_day_of_week(to_date('1976-01-10')) Saturday
```

But in snowflake 

```sql
select 
dayofweek(to_date('1976-01-04')) Sunday,
dayofweek(to_date('1976-01-05')) Monday,
dayofweek(to_date('1976-01-06')) Tuesday,
dayofweek(to_date('1976-01-07')) Wednesday,
dayofweek(to_date('1976-01-08')) Thursday,
dayofweek(to_date('1976-01-09')) Friday,
dayofweek(to_date('1976-01-10')) Saturday
```

| Day       | Result |
+-----------|--------|
| Sunday    | 0      |
| Monday    | 1      |
| Tuesday   | 2      |
| Wednesday | 3      |
| Thurday   | 4      |
| Friday    | 5      |
| Saturday  | 6      |

In case you just want to minimize your code changes you can create an udf:

```sql
CREATE OR REPLACE FUNCTION "TD_DAY_OF_WEEK"(D DATE)
RETURNS NUMBER(38,0)
LANGUAGE SQL
AS 
$$
DayOfWeek(d) + 1
$$;
```