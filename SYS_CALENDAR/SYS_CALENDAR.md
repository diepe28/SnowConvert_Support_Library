# SYS_CALENDAR in Snowflake

```sql
CREATE SCHEMA SYS_CALENDAR;
```

```sql
CREATE OR REPLACE VIEW CALBASICS (
calendar_date,
day_of_calendar,
day_of_month,
day_of_year,
month_of_year,
year_of_calendar)
AS
   SELECT
   cdate as calendar_date,
   datediff('d','1900-01-01',cdate)+1 as day_of_calendar,
   dayofmonth(cdate) as day_of_month,
   dayofyear(cdate) as day_of_year,
   month(cdate) as month_of_year,
   year(cdate)-1900 as year_of_calendar
FROM sys_calendar.CALDATES
--WHERE cdate = to_date('1900-01-01')
;
```


```sql
CREATE OR REPLACE VIEW CALENDARTMP(
  calendar_date,
  day_of_week,
  day_of_month,
  day_of_year,
  day_of_calendar,
  weekday_of_month,
  week_of_month,
  week_of_year,
  week_of_calendar,
  month_of_quarter,
  month_of_year,
  month_of_calendar,
  quarter_of_year,
  quarter_of_calendar,
  year_of_calendar)
AS
   SELECT
   calendar_date,
   dayofweek(calendar_date)+1 as day_of_week,
   day_of_month,
   day_of_year,
   day_of_calendar,
   TRUNC((day_of_month - 1) / 7) + 1 as  weekday_of_month,
   TRUNC((day_of_month - mod( (day_of_calendar + 0), 7) + 6) / 7) as week_of_month,
   TRUNC((day_of_year - mod( (day_of_calendar + 0), 7) + 6) / 7) as week_of_year,
   TRUNC((day_of_calendar - mod( (day_of_calendar + 0), 7) + 6) / 7) as week_of_calendar,
   mod((month_of_year - 1), 3) + 1 as month_of_quarter,
   month_of_year,
   month_of_year + 12 * year_of_calendar as month_of_calendar,
   quarter(calendar_date) as quarter_of_year,
   TRUNC((month_of_year + 2) / 3) + 4 * year_of_calendar as quarter_of_calendar,
   year_of_calendar + 1900 as year_of_calendar
 FROM sys_calendar.CALBASICS;
```

```
CREATE OR REPLACE VIEW CALENDAR (
calendar_date,
day_of_calendar,
day_of_week,
day_of_month,
day_of_year,
month_of_year,
weekday_of_month,
week_of_month,
week_of_year,
week_of_calendar,
month_of_quarter,
month_of_calendar,
quarter_of_year,
quarter_of_calendar,
year_of_calendar
)
AS
select
calendar_date,
day_of_calendar,
day_of_week,
day_of_month,
day_of_year,
month_of_year,
weekday_of_month,
week_of_month,
week_of_year,
week_of_calendar,
month_of_quarter,
month_of_calendar,
quarter_of_year,
quarter_of_calendar,
year_of_calendar
 FROM Sys_Calendar.CALENDARTMP;
```