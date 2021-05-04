-- <copyright file="INSTR_UDF.cs" company="Mobilize.Net">
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

-- =============================================
-- Description: UDF for Teradata INSTR function
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.INSTR(TARGET STRING, SEARCH STRING) RETURNS INT AS
$$
    POSITION(SEARCH, TARGET)
$$;

CREATE OR REPLACE FUNCTION PUBLIC.INSTR(TARGET STRING, SEARCH STRING, POSITION INT) RETURNS INT AS
$$
    CASE WHEN POSITION >= 0 THEN POSITION(SEARCH, TARGET, POSITION) ELSE 1 + LENGTH(TARGET) - POSITION(SEARCH, REVERSE(TARGET), ABS(POSITION)) END
$$;

CREATE OR REPLACE FUNCTION PUBLIC.INSTR(TARGET STRING, SEARCH STRING, POSITION DOUBLE, OCCURENCE DOUBLE) RETURNS DOUBLE LANGUAGE JAVASCRIPT AS
'
function INDEXOFNTH(TARGET, SEARCH, POSITION, N)
{
  var I = TARGET.indexOf(SEARCH, POSITION);
  return(N == 1 ? I : INDEXOFNTH(TARGET, SEARCH, I + 1, N - 1));
}

function LASTINDEXOFNTH(TARGET, SEARCH, POSITION, N)
{
  var I = TARGET.lastIndexOf(SEARCH, POSITION);
  return(N == 1 ? I : LASTINDEXOFNTH(TARGET, SEARCH, I - 1, N - 1));
}

function INSTR(TARGET, SEARCH, POSITION, OCCURENCE)
{
  if(OCCURENCE < 1) RETURN - 1;
  if(POSITION == 0) POSITION = 1;
  if(POSITION > 0) {
    var INDEX = INDEXOFNTH(TARGET, SEARCH, POSITION - 1, OCCURENCE);
    return(INDEX == -1) ? INDEX : INDEX + 1;
  }
  else {
    var INDEX = LASTINDEXOFNTH(TARGET, SEARCH, TARGET.length + POSITION, OCCURENCE);
    return(INDEX == -1) ? INDEX : INDEX + 1;
  }
}

return INSTR(TARGET, SEARCH, POSITION, OCCURENCE);
';