# SYS_CALENDAR in Snowflake

SYS_CALENDAR is a helper view used in some databases for DATE calculations

This calendar has one row for every day from 1st Jan 1900 to 31st Dec 2100.

Select count(*) from  SYS_CALENDAR.CALENDAR --> 73414

Following are the columns available in the calendar view:


| Column            | Description.                                                                     | Example   |
--------------------|----------------------------------------------------------------------------------|-----------|
calendar_date       | DATE  , Default DATE format, values 1900/01/01 - 2100/12/31 is the primary key   | 3/18/2013 |
day_of_week         | INTEGER, 1 (Sunday) - 7 (Saturday)                                               | 2         |
day_of_month        | INTEGER, 1 - 31                                                                  | 18        |
day_of_year         | INTEGER, 1 - 366                                                                 | 77        |
day_of_calendar     | INTEGER, indicating number of days since and including 1900/01/01                | 41350     |
weekday_of_month    | INTEGER, 1 - 5, the nth occurrence of the weekday in the month                   | 3         |
week_of_month       | INTEGER, 0 - 5, the nth full week of month, first partial week is 0              | 3         |
week_of_year        | INTEGER, 0 - 53, the nth full week of year, first partial week is 0              | 11        |
week_of_calendar    | INTEGER, indicating the nth full week of calendar, the first partial week is 0   | 5907      |
month_of_quarter    | INTEGER, 1 - 3                                                                   | 3         |
month_of_year       | INTEGER, 1 (January) - 12 (December)                                             | 3         |
month_of_calendar   | INTEGER, indicating number of months since and including 1900/01                 | 1359      |
quarter_of_year     | INTEGER, 1 (Jan/Feb/Mar) - 4 (Oct/Nov/Dec)                                       | 1         |
quarter_of_calendar | INTEGER indicating number of quarters since and including 1900Q1                 | 453       |
year_of_calendar    | INTEGER indicating number of calendar years in 4 digit format                    | 2013      |



The following code creates this view in SNOWFLAKE.

Following is how the sys_calendar is built:

CALENDAR(view) -> CALENDARTMP(view) -> CALBASICS(view) -> CALDATES(table)

```sql
CREATE SCHEMA SYS_CALENDAR;
```

```sql
create or replace TABLE CALDATES (
	CDATE DATE NOT NULL,
	constraint UNIQ_CDATE unique (CDATE)
);
```

and to fill CALDATES:

```sql
CREATE OR REPLACE TABLE sys_calendar.CALDATES (cdate DATE)

AS

SELECT DATEADD(day, seq4(), '1900-01-01') cdate FROM TABLE(GENERATOR(RowCount => 365.25*200)) WHERE cdate < '2200-01-01';
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
FROM LIMU_PL_DEV.sys_calendar.CALDATES
--WHERE cdate = to_date('1900-01-01')
;
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

```sql
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