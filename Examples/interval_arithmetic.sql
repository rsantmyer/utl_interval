SET SERVEROUTPUT ON

PROMPT Add two intervals

SELECT pkg_interval."ADD"(
          INTERVAL '0 01:00:00' DAY TO SECOND,
          INTERVAL '0 00:30:00' DAY TO SECOND
       ) AS total_interval
FROM dual;

PROMPT Divide one interval by another

SELECT pkg_interval.divide(
          INTERVAL '0 02:00:00' DAY TO SECOND,
          INTERVAL '0 00:30:00' DAY TO SECOND
       ) AS interval_ratio
FROM dual;

PROMPT NULL-tolerant add behavior

SELECT pkg_interval."ADD"(
          CAST(NULL AS INTERVAL DAY TO SECOND),
          INTERVAL '0 00:30:00' DAY TO SECOND
       ) AS total_interval
FROM dual;
