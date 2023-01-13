CREATE OR REPLACE PACKAGE BODY pkg_interval
AS

FUNCTION to_seconds(ip_interval1 IN INTERVAL DAY TO SECOND)
   RETURN NUMBER
IS
   l_seconds1 NUMBER;
BEGIN
   l_seconds1 := EXTRACT(DAY    FROM ip_interval1) * 86400
               + EXTRACT(HOUR   FROM ip_interval1) *  3600
               + EXTRACT(MINUTE FROM ip_interval1) *    60
               + EXTRACT(SECOND FROM ip_interval1);

   RETURN l_seconds1;
END to_seconds;



FUNCTION to_minutes(ip_interval IN INTERVAL DAY TO SECOND)
   RETURN NUMBER
IS
BEGIN
   RETURN to_seconds(ip_interval)/60;
END to_minutes;



FUNCTION to_hours(ip_interval IN INTERVAL DAY TO SECOND)
   RETURN NUMBER
IS
BEGIN
   RETURN to_seconds(ip_interval)/3600;
END to_hours;



FUNCTION divide(ip_numerator   IN INTERVAL DAY TO SECOND
               ,ip_denominator IN INTERVAL DAY TO SECOND)
   RETURN NUMBER
IS
   l_seconds_n NUMBER;
   l_seconds_d NUMBER;
BEGIN
   l_seconds_n := to_seconds(ip_numerator);
   l_seconds_d := to_seconds(ip_denominator);
   
   RETURN l_seconds_n/l_seconds_d;
END divide;



FUNCTION add(ip_interval1 IN INTERVAL DAY TO SECOND
            ,ip_interval2 IN INTERVAL DAY TO SECOND)
   RETURN INTERVAL DAY TO SECOND
IS
   l_seconds1 NUMBER;
   l_seconds2 NUMBER;
BEGIN
   IF ip_interval1 IS NULL THEN
      RETURN ip_interval2;
   ELSIF ip_interval2 IS NULL THEN
      RETURN ip_interval1;
   ELSE
      l_seconds1 := EXTRACT(DAY    FROM ip_interval1) * 86400
                  + EXTRACT(HOUR   FROM ip_interval1) *  3600
                  + EXTRACT(MINUTE FROM ip_interval1) *    60
                  + EXTRACT(SECOND FROM ip_interval1);

      l_seconds2 := EXTRACT(DAY    FROM ip_interval2) * 86400
                  + EXTRACT(HOUR   FROM ip_interval2) *  3600
                  + EXTRACT(MINUTE FROM ip_interval2) *    60
                  + EXTRACT(SECOND FROM ip_interval2);
                  
      RETURN numtodsinterval(l_seconds1 + l_seconds2, 'SECOND');
   END IF;

END add;


END pkg_interval;
/
