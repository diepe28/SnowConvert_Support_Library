



```sql
CREATE OR REPLACE FUNCTION PUBLIC.ISDATE_UDF(DATE_VALUE VARCHAR)
RETURNS BOOLEAN 
AS
$$
/**
   * Returns true if the given string is a valid date following the standard format YYYY-MM-DD
   * NOTE: There is an overload for specifying the separator
   * @param {VARCHAR}    DATE_VALUE the date value
   * @example 
   * SELECT ISDATE_UDF('2020-01-01') -- returns true
   * SELECT ISDATE_UDF('2020-99-99') -- returns false
   */                                                                
   iff(TRY_TO_DATE(DATE_VALUE) is null,FALSE, TRUE), 
$$;
```

```sql
CREATE OR REPLACE FUNCTION PUBLIC.ISDATE_UDF(DATE_VALUE VARCHAR,SEPARATOR CHAR)
RETURNS BOOLEAN 
AS
$$
  /**
   * Returns true if the given string is a valid date following the standard format 
   * NOTE: There is an overload without the separator. 
   * @param {VARCHAR}    DATE_VALUE the date value
   * @param {CHAR}       SEPARATOR  the date separator char
   * @example 
   * SELECT ISDATE_UDF('2020/01/01','/') -- returns true
   * SELECT ISDATE_UDF('2020/99/99','/') -- returns false
   */                                                                
   iff(TRY_TO_DATE(DATE_VALUE,'YYYY' || SEPARATOR || 'MM' || SEPARATOR || 'DD' ) is null,FALSE, TRUE), 
$$;
```

Teradata ISDate functions supports several formats if you want an exact replica of its behaviour then you need something like:

```sql
CREATE OR REPLACE FUNCTION PUBLIC.ISDATE2_UDF(DATE_VALUE VARCHAR)
RETURNS BOOLEAN 
AS
$$
/**
   * Returns true if the given string is a valid date following these formats:
   *    ddmmyy
   *    ddmmyyyy
   *    yymmdd
   *    yyyymmdd
   *    mmddyy
   *    mmddyyyy
   *    dd-mm-yy
   *    dd-mm-yyyy
   *    yy-mm-dd
   *    yyyy-mm-dd
   *    mm-dd-yy
   *    mm-dd-yyyy
   *    ddmmmyyyy (Jan -> Dec)
   *    dd-mmm-yyyy (Jan -> Dec)
   *    ddmmmmyyyy (January -> December)
   *    dd-mmmm-yyyy (January -> December)
   *    d-m-yy
   *    d-m-yyyy
   *    yy-m-d
   *    yyyy-m-d
   * NOTE: There is an overload for specifying the separator
   * @param {VARCHAR}    DATE_VALUE the date value
   * @example 
   * SELECT ISDATE2_UDF('2020-01-01') -- returns true
   * SELECT ISDATE2_UDF('2020-99-99') -- returns false
   */                                                                
   iff(TRY_TO_DATE(DATE_VALUE,'ddmmyy') is null,
        iff(TRY_TO_DATE(DATE_VALUE,'ddmmyyyy') is null,
             iff(TRY_TO_DATE(DATE_VALUE,'yymmdd') is null,
                iff(TRY_TO_DATE(DATE_VALUE,'yyyymmdd') is null,
                    iff(TRY_TO_DATE(DATE_VALUE,'yyyymmdd') is null,
                        iff(TRY_TO_DATE(DATE_VALUE,'mmddyy') is null,
                            iff(TRY_TO_DATE(DATE_VALUE,'mmddyyyy') is null,
                                iff(TRY_TO_DATE(DATE_VALUE,'dd-mm-yy') is null,
                                    iff(TRY_TO_DATE(DATE_VALUE,'dd-mm-yyyy') is null,
                                        iff(TRY_TO_DATE(DATE_VALUE,'yy-mm-dd') is null,
                                            iff(TRY_TO_DATE(DATE_VALUE,'yyyy-mm-dd') is null,
                                                iff(TRY_TO_DATE(DATE_VALUE,'mm-dd-yyyy') is null,
                                                    iff(TRY_TO_DATE(DATE_VALUE,'mm-dd-yyyy') is null,
                                                        iff(TRY_TO_DATE(DATE_VALUE,'ddmmmyyyy') is null,
                                                            iff(TRY_TO_DATE(DATE_VALUE,'dd-mmm-yyyy') is null,
                                                                iff(TRY_TO_DATE(DATE_VALUE,'d-m-yy') is null,
                                                                    iff(TRY_TO_DATE(DATE_VALUE,'d-m-yyyy') is null,
                                                                        iff(TRY_TO_DATE(DATE_VALUE,'yy-m-d') is null,
                                                                            iff(TRY_TO_DATE(DATE_VALUE,'yyyy-m-d') is null,FALSE
                                                                           , TRUE)
                                                                        , TRUE)
                                                                    , TRUE)
                                                                , TRUE)
                                                            , TRUE)
                                                        , TRUE)
                                                    , TRUE)
                                                , TRUE)
                                            , TRUE)
                                        , TRUE)
                                    , TRUE)
                                , TRUE)
                            , TRUE)
                        , TRUE)
                    , TRUE)
                , TRUE)
            , TRUE)
        , TRUE)
    , TRUE) 
$$;
```
