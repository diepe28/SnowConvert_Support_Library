-- <copyright file="SUBSTR_TD_UDF.cs" company="Mobilize.Net">
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
-- Description: UDF for Teradata SUBSTR function
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.SUBSTR_TD(base_exp string, startpos float, length float)
  RETURNS string
  LANGUAGE JAVASCRIPT
AS
$$
  if ( STARTPOS > 0 ) {
      return BASE_EXP.substr(STARTPOS -1, LENGTH   );
  } else if (STARTPOS == 0 ) {
      return BASE_EXP.substr(STARTPOS , LENGTH  - 1 );
  } else {
      return BASE_EXP.substr(0, LENGTH + STARTPOS  -  1 );
  }
 
$$
;

CREATE OR REPLACE FUNCTION PUBLIC.SUBSTR_TD(base_exp string, startpos float )
  RETURNS string
  LANGUAGE JAVASCRIPT
AS
$$
  if ( STARTPOS > 0 ) {
      return BASE_EXP.substr(STARTPOS -1   );
  }  else {
      return BASE_EXP.substr( 0  );
  }
 
$$
;  