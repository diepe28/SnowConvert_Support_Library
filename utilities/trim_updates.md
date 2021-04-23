# Usage 

Sometimes you have .csv files and there is the need to load the data AS-IS from the CSV files into Snowflake first.
Then pass 2, we will run the TRIM script to trim the leading and trailing spaces in all the VARCHAR columns

`trim_updates.py [-h] --account ACCOUNT --database DATABASE --role ROLE
                       --user USER --password PASSWORD --warehouse WAREHOUSE`

Generate Update Scripts to apply TRIM to all TEXT columns for an Snowflake DB

## optional arguments:
```
  -h, --help            show this help message and exit
  --account ACCOUNT     Snowflake account name
  --database DATABASE   Snowflake database
  --role ROLE           Snowflake role
  --user USER           Snowflake account user
  --password PASSWORD   Snowflake account password
  --warehouse WAREHOUSE  Snowflake warehouse
```  

It will then generate statements like this:
```sql
UPDATE GLS.RPT.ACTIVEDIRECTORYDATA SET 
     "USERID" = TRIM("USERID"),
     "DEFIID" = TRIM("DEFIID"),
     "DEPARTMENT" = TRIM("DEPARTMENT"),
     "LASTUPDATED" = TRIM("LASTUPDATED"),
     "MANAGER" = TRIM("MANAGER"),
     "EMAIL" = TRIM("EMAIL"),
     "LOC" = TRIM("LOC"),
     "EXTENSION" = TRIM("EXTENSION"),
     "LNAME" = TRIM("LNAME"),
     "ISACTIVE" = TRIM("ISACTIVE"),
     "WORKGROUP" = TRIM("WORKGROUP"),
     "TITLE" = TRIM("TITLE"),
     "FNAME" = TRIM("FNAME"),
     "CREATETIMESTAMP" = TRIM("CREATETIMESTAMP");
``

Quoting is used for the columns names because you can have a table that was created like CREATE TABLE TABLE1("column 1" varchar);

>> NOTE: In order to run this make sure you have the snowflake connector and its dependencies.
>> For example run: 
>> `pip install "snowflake-connector-python[secure-local-storage,pandas]"`
