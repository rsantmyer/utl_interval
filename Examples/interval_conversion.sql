SET SERVEROUTPUT ON

PROMPT Convert an interval to total seconds, minutes, and hours

SELECT pkg_interval.to_seconds(INTERVAL '1 02:30:00' DAY TO SECOND) AS seconds,
       pkg_interval.to_minutes(INTERVAL '1 02:30:00' DAY TO SECOND) AS minutes,
       pkg_interval.to_hours  (INTERVAL '1 02:30:00' DAY TO SECOND) AS hours
FROM dual;

PROMPT NULL input returns NULL

SELECT pkg_interval.to_seconds(CAST(NULL AS INTERVAL DAY TO SECOND)) AS null_seconds,
       pkg_interval.to_minutes(CAST(NULL AS INTERVAL DAY TO SECOND)) AS null_minutes,
       pkg_interval.to_hours  (CAST(NULL AS INTERVAL DAY TO SECOND)) AS null_hours
FROM dual;
