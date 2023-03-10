CREATE OR REPLACE PACKAGE pkg_interval
AS
--
FUNCTION to_seconds(ip_interval1 IN INTERVAL DAY TO SECOND)
   RETURN NUMBER;
--
FUNCTION to_minutes(ip_interval IN INTERVAL DAY TO SECOND)
   RETURN NUMBER;
--
FUNCTION to_hours(ip_interval IN INTERVAL DAY TO SECOND)
   RETURN NUMBER;
--
FUNCTION divide(ip_numerator   IN INTERVAL DAY TO SECOND
               ,ip_denominator IN INTERVAL DAY TO SECOND)
   RETURN NUMBER;
--
FUNCTION add(ip_interval1 IN INTERVAL DAY TO SECOND
            ,ip_interval2 IN INTERVAL DAY TO SECOND)
   RETURN INTERVAL DAY TO SECOND;

END pkg_interval;
/