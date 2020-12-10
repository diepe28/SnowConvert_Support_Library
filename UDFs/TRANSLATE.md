```javascript
CREATE OR REPLACE FUNCTION PUBLIC.TRANSLATE_UDF(STR STRING,TARGETNAME STRING, WITH_ERROR BOOLEAN)
RETURNS STRING
language javascript
AS
$$
  /**
  * Currently only supports UNICODE_TO_LATIN. It will strip any non latin characters.
  * @param {STRING} STR         string value that will be converted.
  * @param {STRING} TARGETNAME  currently only UNICODE_TO_LATIN value is supported
  * @param {BOOLEAN} WITH_ERROR indicates whether this function will throw an error for untranslatable character.
  * @return {INT} 0 if not errors, the first problematic character index (1-based).
  * @example 
  * SELECT TRANSLATE_UDF('like ü, ö, ß, and ñ','UNICODE_TO_LATIN',FALSE); -- it will return  'like , , , and'
  * @example
  * SELECT TRANSLATE_UDF('ö, ß, and ñ','UNICODE_TO_LATIN',FALSE); -- it will return ', , and'
  * @example
  * SELECT TRANSLATE_UDF('Hello World','UNICODE_TO_LATIN',FALSE); -- it wil return 'Hello World'
  **/
  TARGETNAME = ("" + TARGETNAME).toUpperCase();
  if (TARGETNAME != 'UNICODE_TO_LATIN') throw new Error("Only UNICODE_TO_LATIN supported");
  if (WITH_ERROR) {
    var match = /[^\u0000-\u007F]/.exec(STR);
    var hasErrors = (match && match.index + 1 || 0);
    if (hasErrors)
    {
      throw new Error(`Untranslable character found at ${hasErrors}`);
    }
  }
  const searchRegExp = /[^\u0000-\u007F]/g;
  const replaceWith = '';
  STR = STR.replace(searchRegExp, replaceWith);
  return STR;
$$;
```
