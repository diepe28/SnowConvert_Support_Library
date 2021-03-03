
# Definition and Usage
The INSTR() function returns the position of the first occurrence of a string in another string.

This function performs a case-insensitive search.

## Syntax
`INSTR(string1, string2)`

## Parameter Values
| Parameter	| Description |
|-----------|-------------|
| source	| Required. The string to search for in string1. If string2 is not found, this function returns 0
| target	| Required. The string that will be searched
| position  | Optional. The position where to start searching |
| occur     | Optional. The occurence to replace.

## Snowflake Implementation

> Credit goes to Zack Howe

```sql
create or replace function public.instr(target string, search string) returns int as
$$
    POSITION(search, target)
$$;

create or replace function public.instr(target string, search string, position int) returns int as
$$
    CASE WHEN position >= 0 THEN POSITION(search, target, position) ELSE 1 + LENGTH(target) - POSITION(search, REVERSE(target), ABS(position)) END
$$;

 
create or replace function public.instr(TARGET string, SEARCH string, POSITION DOUBLE, OCCURENCE DOUBLE) returns DOUBLE language javascript as
$$
function indexOfNth(search, target, position, n)
{
    var i = target.indexOf(search, position);
    return (n == 1 ? i : indexOfNth(search, target, i + 1, n - 1));
}
function instr(search, target, position, occurence) {
    if (occurence < 1) return -1;
    if (position == 0) position = 1;
    if (position > 0) {
        var index = indexOfNth(search, target, position - 1, occurence);
        return (index == -1) ? index : index + 1;
    } else {
        var index = indexOfNth(search, target.split("").reverse().join(""), Math.abs(position) - 1, occurence);
        return (index == -1) ? index : target.length - index;
    }
}
return instr(SEARCH, TARGET, POSITION, OCCURENCE);
$$;
```
 
```sql
select instr('abcda','a');        -- Returns 1
select instr('abcda','a',0);     -- Returns 1
select instr('abcda','a', 1);     -- Returns 1
select instr('abcda','a', 2);     -- Returns 5
select instr('abcda','a',  -1);    -- Returns 5
select instr('abcda','a',  0, 0);  -- Returns -1
select instr('abcda','a',  0, 1);  -- Returns 1
select instr('abcda','a',  0, 2);  -- Returns 5
select instr('abcda','a',  1, 1);  -- Returns 1
select instr('abcda','a',  1, 2);  -- Returns 5
select instr('abcda','a', -1, 1); -- Returns 5
select instr('abcda','a', -1, 2); -- Returns 1
```
