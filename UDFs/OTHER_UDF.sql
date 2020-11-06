/******************************************************/
/******************* OTHER UDFS ***********************/
/******************************************************/

----------
CREATE OR REPLACE FUNCTION PUBLIC.MONTHS_BETWEEN_UDF(INPUT_1 TIMESTAMP_LTZ, INPUT_2 TIMESTAMP_LTZ)
RETURNS NUMBER(20,6)
AS
'
CASE WHEN DAY(INPUT_2) <= DAY(INPUT_1) 
           THEN TIMESTAMPDIFF(MONTH,INPUT_2,INPUT_1) 
            ELSE TIMESTAMPDIFF(MONTH,INPUT_2,INPUT_1) - 1 
END + 
(CASE 
    WHEN DAY(INPUT_2) = DAY(INPUT_1) THEN 0
    WHEN DAY(INPUT_2) < DAY(INPUT_1) AND TO_TIME(INPUT_2) > TO_TIME(INPUT_1) THEN DAY(INPUT_1) - DAY(INPUT_2) - 1
    WHEN DAY(INPUT_2) <= DAY(INPUT_1) THEN DAY(INPUT_1) - DAY(INPUT_2) 
    ELSE 31 - DAY(INPUT_2) + DAY(INPUT_1) 
 END / 31) +
(CASE 
    WHEN DAY(INPUT_2) = DAY(INPUT_1) THEN 0
    WHEN HOUR(INPUT_2) <= HOUR(INPUT_1) THEN HOUR(INPUT_1) - HOUR(INPUT_2) 
    ELSE 24 - HOUR(INPUT_2) + HOUR(INPUT_1) 
END / (24*31)) +   
(CASE 
     WHEN DAY(INPUT_2) = DAY(INPUT_1) THEN 0   
     WHEN MINUTE(INPUT_2) <= MINUTE(INPUT_1) THEN MINUTE(INPUT_1) - MINUTE(INPUT_2) 
     ELSE 24 - HOUR(INPUT_2) + MINUTE(INPUT_1) 
        END / (24*60*31)) +
(CASE 
     WHEN DAY(INPUT_2) = DAY(INPUT_1) THEN 0   
     WHEN MINUTE(INPUT_2) <= MINUTE(INPUT_1) THEN MINUTE(INPUT_1) - MINUTE(INPUT_2) 
     ELSE 24 - HOUR(INPUT_2) + MINUTE(INPUT_1) 
END / (24*60*60*31))
'
;

----------
CREATE OR REPLACE FUNCTION PUBLIC.TRUNC_DATE_UDF(INPUT TIMESTAMP_LTZ, FMT VARCHAR(5))
RETURNS DATE
AS
'
CAST(CASE 
WHEN FMT IN ('CC','SCC') THEN DATE_FROM_PARTS(CAST(LEFT(CAST(YEAR(INPUT) as CHAR(4)),2) || '00' as INTEGER),1,1)
WHEN FMT IN ('SYYYY','YYYY','YEAR','SYEAR','YYY','YY','Y') THEN DATE_FROM_PARTS(YEAR(INPUT),1,1)
WHEN FMT IN ('IYYY','IYY','IY','I') THEN 
    CASE DAYOFWEEK(DATE_FROM_PARTS(YEAR(INPUT),1,1))
         WHEN 0 THEN DATEADD(DAY, 1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
         WHEN 1 THEN DATEADD(DAY, 0, DATE_FROM_PARTS(YEAR(INPUT),1,1))
         WHEN 2 THEN DATEADD(DAY, -1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
         WHEN 3 THEN DATEADD(DAY, -2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
         WHEN 4 THEN DATEADD(DAY, -3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
         WHEN 5 THEN DATEADD(DAY, 3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
         WHEN 6 THEN DATEADD(DAY, 2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
    END        
WHEN FMT IN ('MONTH','MON','MM','RM') THEN DATE_FROM_PARTS(YEAR(INPUT),MONTH(INPUT),1)
WHEN FMT IN ('Q') THEN DATE_FROM_PARTS(YEAR(INPUT),(QUARTER(INPUT)-1)*3+1,1)
WHEN FMT IN ('WW') THEN DATEADD(DAY, 0-MOD(TIMESTAMPDIFF(DAY,DATE_FROM_PARTS(YEAR(INPUT),1,1),INPUT),7), INPUT)
WHEN FMT IN ('IW') THEN DATEADD(DAY, 0-MOD(TIMESTAMPDIFF(DAY,(CASE DAYOFWEEK(DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                 WHEN 0 THEN DATEADD(DAY, 1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                 WHEN 1 THEN DATEADD(DAY, 0, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                 WHEN 2 THEN DATEADD(DAY, -1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                 WHEN 3 THEN DATEADD(DAY, -2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                 WHEN 4 THEN DATEADD(DAY, -3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                 WHEN 5 THEN DATEADD(DAY, 3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                 WHEN 6 THEN DATEADD(DAY, 2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                               END),      INPUT),7), INPUT)
WHEN FMT IN ('W') THEN DATEADD(DAY, 0-MOD(TIMESTAMPDIFF(DAY,DATE_FROM_PARTS(YEAR(INPUT),MONTH(INPUT),1),INPUT),7), INPUT)                                                             
WHEN FMT IN ('DDD', 'DD','J') THEN INPUT
WHEN FMT IN ('DAY', 'DY','D') THEN DATEADD(DAY, 0-DAYOFWEEK(INPUT), INPUT)
WHEN FMT IN ('HH', 'HH12','HH24') THEN INPUT
WHEN FMT IN ('MI') THEN INPUT
END AS DATE)
'
;

----------
CREATE OR REPLACE FUNCTION PUBLIC.ROUND_DATE_UDF(INPUT TIMESTAMP_LTZ, FMT VARCHAR(5))
RETURNS DATE
AS
'
CAST(
CASE 
    WHEN FMT IN ('CC','SCC') THEN 
        CASE 
            WHEN RIGHT(CAST(YEAR(INPUT) as CHAR(4)),2) >=51 
                THEN DATE_FROM_PARTS(CAST(LEFT(CAST(YEAR(INPUT) as CHAR(4)),2) || '01' as INTEGER) +100,1,1)
            ELSE DATE_FROM_PARTS(CAST(LEFT(CAST(YEAR(INPUT) as CHAR(4)),2) || '01' as INTEGER),1,1)
        END    
    WHEN FMT IN ('SYYYY','YYYY','YEAR','SYEAR','YYY','YY','Y') THEN 
        CASE WHEN MONTH(INPUT) >= 7 THEN DATE_FROM_PARTS(YEAR(INPUT)+1,1,1)
             ELSE DATE_FROM_PARTS(YEAR(INPUT),1,1)
        END
    WHEN FMT IN ('IYYY','IYY','IY','I') THEN 
        CASE WHEN MONTH(INPUT) >= 7 THEN CASE DAYOFWEEK(DATE_FROM_PARTS(YEAR(INPUT),12,31))
                                                                  WHEN 0 THEN DATEADD(DAY, 1, DATE_FROM_PARTS(YEAR(INPUT),12,31))
                                                                  WHEN 1 THEN DATEADD(DAY, 0, DATE_FROM_PARTS(YEAR(INPUT),12,31))
                                                                  WHEN 2 THEN DATEADD(DAY, -1, DATE_FROM_PARTS(YEAR(INPUT),12,31))
                                                                  WHEN 3 THEN DATEADD(DAY, -2, DATE_FROM_PARTS(YEAR(INPUT),12,31))
                                                                  WHEN 4 THEN DATEADD(DAY, -3, DATE_FROM_PARTS(YEAR(INPUT),12,31))
                                                                  WHEN 5 THEN DATEADD(DAY, 3, DATE_FROM_PARTS(YEAR(INPUT),12,31))
                                                                  WHEN 6 THEN DATEADD(DAY, 2, DATE_FROM_PARTS(YEAR(INPUT),12,31))
                                                              END
             ELSE CASE DAYOFWEEK(DATE_FROM_PARTS(YEAR(INPUT),1,1))
                      WHEN 0 THEN DATEADD(DAY, 1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                      WHEN 1 THEN DATEADD(DAY, 0, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                      WHEN 2 THEN DATEADD(DAY, -1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                      WHEN 3 THEN DATEADD(DAY, -2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                      WHEN 4 THEN DATEADD(DAY, -3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                      WHEN 5 THEN DATEADD(DAY, 3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                      WHEN 6 THEN DATEADD(DAY, 2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                  END  
        END
    WHEN FMT IN ('MONTH','MON','MM','RM') THEN 
        CASE WHEN DAYOFMONTH(INPUT) >15 THEN TIMESTAMPADD(MONTH, 1, DATE_FROM_PARTS(YEAR(INPUT),MONTH(INPUT),1))
             ELSE DATE_FROM_PARTS(YEAR(INPUT),MONTH(INPUT),1)
        END
    WHEN FMT IN ('Q') THEN 
        CASE WHEN (MOD(MONTH(INPUT),3)=2 AND DAYOFMONTH(INPUT) >15) OR MOD(MONTH(INPUT),3)=0 
                THEN TIMESTAMPADD(MONTH, 3, DATE_FROM_PARTS(YEAR(INPUT),(QUARTER(INPUT)-1)*3+1,1)) 
             ELSE DATE_FROM_PARTS(YEAR(INPUT),(QUARTER(INPUT)-1)*3+1,1)
        END
    WHEN FMT IN ('WW') THEN 
        CASE WHEN MOD(TIMESTAMPDIFF(DAY,DATE_FROM_PARTS(YEAR(INPUT),1,1),INPUT),7) < 4 
                THEN DATEADD(DAY, 0-MOD(TIMESTAMPDIFF(DAY,DATE_FROM_PARTS(YEAR(INPUT),1,1),INPUT),7), INPUT)
             ELSE DATEADD(DAY, 7-MOD(TIMESTAMPDIFF(DAY,DATE_FROM_PARTS(YEAR(INPUT),1,1),INPUT),7), INPUT)
        END
    WHEN FMT IN ('IW') THEN 
        CASE WHEN MOD(TIMESTAMPDIFF(DAY,(CASE DAYOFWEEK(DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                             WHEN 0 THEN DATEADD(DAY, 1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                             WHEN 1 THEN DATEADD(DAY, 0, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                             WHEN 2 THEN DATEADD(DAY, -1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                             WHEN 3 THEN DATEADD(DAY, -2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                             WHEN 4 THEN DATEADD(DAY, -3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                             WHEN 5 THEN DATEADD(DAY, 3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                             WHEN 6 THEN DATEADD(DAY, 2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                         END
                   ), INPUT),7) >=4 THEN DATEADD(DAY,7-MOD(TIMESTAMPDIFF(DAY,(CASE DAYOFWEEK(DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                                    WHEN 0 THEN DATEADD(DAY, 1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                                    WHEN 1 THEN DATEADD(DAY, 0, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                                    WHEN 2 THEN DATEADD(DAY, -1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                                    WHEN 3 THEN DATEADD(DAY, -2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                                    WHEN 4 THEN DATEADD(DAY, -3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                                    WHEN 5 THEN DATEADD(DAY, 3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                                    WHEN 6 THEN DATEADD(DAY, 2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                                                END), INPUT),7), INPUT)
             ELSE DATEADD(DAY,0-MOD(TIMESTAMPDIFF(DAY,(CASE DAYOFWEEK(DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                           WHEN 0 THEN DATEADD(DAY, 1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                           WHEN 1 THEN DATEADD(DAY, 0, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                           WHEN 2 THEN DATEADD(DAY, -1, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                           WHEN 3 THEN DATEADD(DAY, -2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                           WHEN 4 THEN DATEADD(DAY, -3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                           WHEN 5 THEN DATEADD(DAY, 3, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                           WHEN 6 THEN DATEADD(DAY, 2, DATE_FROM_PARTS(YEAR(INPUT),1,1))
                                                       END), INPUT),7), INPUT)
        END
    WHEN FMT IN ('W') THEN 
        CASE WHEN MOD(TIMESTAMPDIFF(DAY,DATE_FROM_PARTS(YEAR(INPUT),MONTH(INPUT),1),INPUT),7) < 4 
                THEN DATEADD(DAY, 0-MOD(TIMESTAMPDIFF(DAY,DATE_FROM_PARTS(YEAR(INPUT),MONTH(INPUT),1),INPUT),7), INPUT)
            ELSE DATEADD(DAY, 7-MOD(TIMESTAMPDIFF(DAY,DATE_FROM_PARTS(YEAR(INPUT),MONTH(INPUT),1),INPUT),7), INPUT)
        END
    WHEN FMT IN ('DDD', 'DD','J') THEN INPUT
    WHEN FMT IN ('DAY', 'DY','D') THEN 
        CASE WHEN DAYOFWEEK(INPUT) > 3 THEN DATEADD(DAY, 7-DAYOFWEEK(INPUT), INPUT)
             ELSE DATEADD(DAY, 0-DAYOFWEEK(INPUT), INPUT)
        END
    WHEN FMT IN ('HH', 'HH12','HH24') THEN INPUT
    WHEN FMT IN ('MI') THEN INPUT
END AS DATE)
';

CREATE OR REPLACE FUNCTION PUBLIC.DATE_TO_INT_UDF(INPUT_1 TIMESTAMP_LTZ)
RETURNS NUMBER(7,0)
AS
$$
(YEAR(INPUT_1) - 1900) * 10000 + 
MONTH(INPUT_1) * 100 + 
DAY(INPUT_1)
$$;

CREATE OR REPLACE FUNCTION PUBLIC.INT_TO_DATE_UDF(INPUT_1 INTEGER)
RETURNS DATE
AS
$$
TO_DATE(CAST(INPUT_1+19000000 AS CHAR(8)), 'YYYYMMDD')
$$;

CREATE OR REPLACE FUNCTION PUBLIC.TIMESTAMP_ADD_UDF(A TIMESTAMP_LTZ, B TIMESTAMP_LTZ)
RETURNS TIMESTAMP
AS
$$
TIMESTAMPADD(YEAR, YEAR(B), TIMESTAMPADD(MONTH, MONTH(B), TIMESTAMPADD(DAY, DAY(B), TIMESTAMPADD(SECOND, SECOND(B), TIMESTAMPADD(MINUTE, MINUTE(B), TIMESTAMPADD(HOUR, HOUR(B), A))))))
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATE_ADD_UDF(A DATE, B DATE)
RETURNS DATE
AS
$$
 DATEADD(YEAR, YEAR(B), DATEADD(MONTH, MONTH(B), DATEADD(DAY, DAY(B), A)))
$$
;

CREATE OR REPLACE FUNCTION PUBLIC.DAY_OF_WEEK_LONG(VAL2 timestamp)
RETURNS VARCHAR(16777216)
LANGUAGE SQL
AS
$$
    decode(dayname(val2), 'Sun' , 'Sunday'
         , 'Mon' ,'Monday'
         , 'Tue' ,'Tuesday'
         , 'Wed' ,'Wednesday'
         , 'Thu' ,'Thursday'
         , 'Fri','Friday'
         , 'Sat' ,'Saturday'
         ,'None')
$$;

CREATE OR REPLACE FUNCTION PUBLIC.MONTH_NAME_LONG(VAL2 timestamp)
RETURNS VARCHAR(16777216)
LANGUAGE SQL
AS
$$
    decode(monthname(val2)
         , 'Jan' ,'January'
         , 'Feb' ,'February'
         , 'Mar' ,'March'
         , 'Apr' ,'April'
         , 'May' ,'May'
         , 'Jun' ,'June'
         , 'Jul' ,'July'
         , 'Aug' ,'August'
         , 'Sep' ,'September'
         , 'Oct' ,'October'
         , 'Nov' ,'November'
         , 'Dec' ,'December'
         ,'None')
$$;

CREATE OR REPLACE FUNCTION PUBLIC.NULLIFZERO_UDF(VAL2 NUMBER)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
    decode(val2)
         , 0 , NULL
         ,val2)
$$;
