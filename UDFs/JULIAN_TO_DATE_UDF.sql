-- <copyright file="JULIAN_TO_DATE.cs" company="Mobilize.Net">
--        Copyright (C) Mobilize.Net info@mobilize.net - All Rights Reserved
-- 
--        This file is part of the Mobilize Frameworks, which is
--        proprietary and confidential.
-- 
--        NOTICE:  All information contained herein is, and remains
--        the property of Mobilize.Net Corporation.
--        The intellectual and technical concepts contained herein are
--        proprietary to Mobilize.Net Corporation and may be covered
--        by U.S. Patents, and are protected by trade secret or copyright law.
--        Dissemination of this information or reproduction of this material
--        is strictly forbidden unless prior written permission is obtained
--        from Mobilize.Net Corporation.
-- </copyright>

-- =========================================================================================================
-- Description: Given a valid julian DATE string (YYYYDDD), returns the DATE it represents, otherwise NULL.
-- =========================================================================================================
CREATE OR REPLACE FUNCTION PUBLIC.JULIAN_TO_DATE(julian_date CHAR(7))
  RETURNS DATE  
AS
$$
  SELECT
    CASE 
        -- Assertion: Must be exactly 7 digits
        WHEN julian_date NOT regexp '\\d{7}' THEN NULL
        -- Assertion: Don't accept 0 or negative days in DDD format
        WHEN RIGHT(julian_date, 3)::INTEGER < 1 THEN NULL  
        -- Assertion: All years have 365 days 
        WHEN RIGHT(julian_date, 3)::INTEGER <366 THEN ((LEFT(julian_date, 4)||'-01-01')::DATE + RIGHT(julian_date, 3)::INTEGER - 1)::DATE
        -- Assertion: If days part is 366, test for leap year (noting that the change of century is not a leap year, but the millenia is)
        WHEN RIGHT(julian_date, 3)::INTEGER = 366 THEN
            CASE 
                WHEN SUBSTR(julian_date, 2,3) = '000' THEN ((LEFT(julian_date, 4)||'-01-01')::DATE + RIGHT(julian_date, 3)::INTEGER - 1)::DATE -- valid millenia leap year
                WHEN SUBSTR(julian_date, 3,2) = '00' THEN NULL -- Century years except millenia are not leap years
                WHEN mod(LEFT(julian_date,4)::INTEGER,4) = 0 THEN ((LEFT(julian_date, 4)||'-01-01')::DATE + RIGHT(julian_date, 3)::INTEGER - 1)::DATE -- valid leap year
            END
    ELSE -- days part is invalid
            NULL
    END
$$
;