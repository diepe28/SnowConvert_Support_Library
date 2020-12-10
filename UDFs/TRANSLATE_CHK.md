```javascript
CREATE OR REPLACE FUNCTION PUBLIC.TRANSLATE_CHK(STR STRING, TARGETNAME STRING)
RETURNS FLOAT
language javascript
AS
$$
  /**
  * Determines if translating the string to `targetname` will have any conflicts.
  * @param {STRING} STR         string value that will be tested.
  * @param {STRING} TARGETNAME  currently only UNICODE_TO_LATIN value is supported
  * @return {INT} 0 if not errors, the first problematic character index (1-based).
  * @example 
  * SELECT TRANSLATE_CHK('like ü, ö, ß, and ñ','UNICODE_TO_LATIN'); -- it will return  6
  * @example
  * SELECT TRANSLATE_CHK('ö, ß, and ñ','UNICODE_TO_LATIN'); -- it will return  1
  * @example
  * SELECT TRANSLATE_CHK('Hello World','UNICODE_TO_LATIN'); -- it wil return 0 
  **/
  TARGETNAME = ("" + TARGETNAME).toUpperCase();
  if (TARGETNAME != 'UNICODE_TO_LATIN') throw new Error("Only UNICODE_TO_LATIN supported");
  var match = /[^\u0000-\u007F]/.exec(STR);
  return match && match.index + 1 || 0;
$$;
```
