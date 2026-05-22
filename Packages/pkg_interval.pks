CREATE OR REPLACE PACKAGE pkg_interval
AS
/*
   Package: pkg_interval

   Utilities for working with Oracle INTERVAL DAY TO SECOND values.

   This package supports sum_interval and may also be called directly from SQL
   or PL/SQL. It does not support INTERVAL YEAR TO MONTH values.
*/

/*
   Converts an INTERVAL DAY TO SECOND value to total seconds.

   Parameters:
      ip_interval1 - interval to convert.

   Returns:
      Total seconds as NUMBER. Returns NULL when ip_interval1 is NULL.
*/
FUNCTION to_seconds(ip_interval1 IN INTERVAL DAY TO SECOND)
   RETURN NUMBER;

/*
   Converts an INTERVAL DAY TO SECOND value to total minutes.

   Parameters:
      ip_interval - interval to convert.

   Returns:
      Total minutes as NUMBER. Returns NULL when ip_interval is NULL.
*/
FUNCTION to_minutes(ip_interval IN INTERVAL DAY TO SECOND)
   RETURN NUMBER;

/*
   Converts an INTERVAL DAY TO SECOND value to total hours.

   Parameters:
      ip_interval - interval to convert.

   Returns:
      Total hours as NUMBER. Returns NULL when ip_interval is NULL.
*/
FUNCTION to_hours(ip_interval IN INTERVAL DAY TO SECOND)
   RETURN NUMBER;

/*
   Divides one INTERVAL DAY TO SECOND value by another.

   Parameters:
      ip_numerator   - numerator interval.
      ip_denominator - denominator interval.

   Returns:
      Numeric ratio of numerator seconds to denominator seconds. Returns NULL
      when either input is NULL. A zero denominator follows Oracle numeric
      division behavior and raises a divide-by-zero error.
*/
FUNCTION divide(ip_numerator   IN INTERVAL DAY TO SECOND
               ,ip_denominator IN INTERVAL DAY TO SECOND)
   RETURN NUMBER;

/*
   Adds two INTERVAL DAY TO SECOND values.

   This function primarily supports typ_interval. When calling it directly
   from SQL, quote the function name as pkg_interval."ADD"(...) because ADD is
   an Oracle SQL keyword.

   Parameters:
      ip_interval1 - first interval.
      ip_interval2 - second interval.

   Returns:
      Sum of both intervals. If one input is NULL, returns the other input. If
      both inputs are NULL, returns NULL.
*/
FUNCTION add(ip_interval1 IN INTERVAL DAY TO SECOND
            ,ip_interval2 IN INTERVAL DAY TO SECOND)
   RETURN INTERVAL DAY TO SECOND;

END pkg_interval;
/
