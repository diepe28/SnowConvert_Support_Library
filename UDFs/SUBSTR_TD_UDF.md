
# Definition and Usage
 It returns a substring from the given string, starting at the startpos index. SUBSTR_TD() function is equivalent to Teradata SUBSTR() when the startpos is lower or equal than zero. For all other cases, the internal function of Snowflake SUBSTR() is used.


## Syntax
`SUBSTR_TD(julian_date)`

## Parameter Values
| Parameter	    | Description |
|---------------|-------------|
| base_exp	| Required. The string to take a substring from.
| startpos	| Required. The start position in base_exp to start the substring.
| length	  | The length of the substring, if not given it will take the substring until the end of base_exp.

## Snowflake Implementation

> Credit goes to Mike Gohl

```sql
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
 
$$;
```
 
```sql
SELECT SUBSTR_TD('ABCDE',-1,1); 	-- Returns empty string
SELECT SUBSTR_TD('ABCDE',-1,2); 	-- Returns empty string
SELECT SUBSTR_TD('ABCDE',-1,3); 	-- Returns 'A'
SELECT SUBSTR_TD('ABCDE',-1,4); 	-- Returns 'AB'
SELECT SUBSTR_TD('ABCDE',0,1); 		-- Returns empty string
SELECT SUBSTR_TD('ABCDE',0,2); 		-- Returns 'A'
SELECT SUBSTR_TD('ABCDE',0,3); 		-- Returns 'AB'
SELECT SUBSTR_TD('ABCDE',0,4); 		-- Returns 'ABC'
```