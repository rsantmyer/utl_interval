SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE utl_interval_smoke_test PURGE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

PROMPT Creating smoke-test table

CREATE TABLE utl_interval_smoke_test
(
   project_code VARCHAR2(30),
   elapsed_time INTERVAL DAY TO SECOND
);

INSERT INTO utl_interval_smoke_test VALUES
   ('ALPHA', INTERVAL '0 01:00:00' DAY TO SECOND);

INSERT INTO utl_interval_smoke_test VALUES
   ('ALPHA', INTERVAL '0 00:30:00' DAY TO SECOND);

INSERT INTO utl_interval_smoke_test VALUES
   ('BETA', INTERVAL '0 02:00:00' DAY TO SECOND);

INSERT INTO utl_interval_smoke_test VALUES
   ('BETA', NULL);

COMMIT;

PROMPT Verifying sum_interval

DECLARE
   l_total INTERVAL DAY TO SECOND;
BEGIN
   SELECT sum_interval(elapsed_time)
   INTO l_total
   FROM utl_interval_smoke_test;

   IF l_total != INTERVAL '0 03:30:00' DAY TO SECOND THEN
      RAISE_APPLICATION_ERROR(-20000, 'sum_interval smoke test failed');
   END IF;

   DBMS_OUTPUT.PUT_LINE('PASS sum_interval');
END;
/

PROMPT Verifying grouped sum_interval

DECLARE
   l_total INTERVAL DAY TO SECOND;
BEGIN
   SELECT sum_interval(elapsed_time)
   INTO l_total
   FROM utl_interval_smoke_test
   WHERE project_code = 'ALPHA';

   IF l_total != INTERVAL '0 01:30:00' DAY TO SECOND THEN
      RAISE_APPLICATION_ERROR(-20001, 'ALPHA grouped sum_interval smoke test failed');
   END IF;

   SELECT sum_interval(elapsed_time)
   INTO l_total
   FROM utl_interval_smoke_test
   WHERE project_code = 'BETA';

   IF l_total != INTERVAL '0 02:00:00' DAY TO SECOND THEN
      RAISE_APPLICATION_ERROR(-20002, 'BETA grouped sum_interval smoke test failed');
   END IF;

   DBMS_OUTPUT.PUT_LINE('PASS grouped sum_interval');
END;
/

PROMPT Verifying conversion helpers

DECLARE
   l_seconds NUMBER;
   l_minutes NUMBER;
   l_hours   NUMBER;
BEGIN
   SELECT pkg_interval.to_seconds(INTERVAL '0 01:30:00' DAY TO SECOND),
          pkg_interval.to_minutes(INTERVAL '0 01:30:00' DAY TO SECOND),
          pkg_interval.to_hours  (INTERVAL '0 01:30:00' DAY TO SECOND)
   INTO l_seconds,
        l_minutes,
        l_hours
   FROM dual;

   IF l_seconds != 5400 OR l_minutes != 90 OR l_hours != 1.5 THEN
      RAISE_APPLICATION_ERROR(-20003, 'conversion helper smoke test failed');
   END IF;

   DBMS_OUTPUT.PUT_LINE('PASS conversion helpers');
END;
/

PROMPT Verifying arithmetic helpers

DECLARE
   l_added INTERVAL DAY TO SECOND;
   l_ratio NUMBER;
BEGIN
   SELECT pkg_interval."ADD"(
             INTERVAL '0 01:00:00' DAY TO SECOND,
             INTERVAL '0 00:30:00' DAY TO SECOND
          ),
          pkg_interval.divide(
             INTERVAL '0 02:00:00' DAY TO SECOND,
             INTERVAL '0 00:30:00' DAY TO SECOND
          )
   INTO l_added,
        l_ratio
   FROM dual;

   IF l_added != INTERVAL '0 01:30:00' DAY TO SECOND OR l_ratio != 4 THEN
      RAISE_APPLICATION_ERROR(-20004, 'arithmetic helper smoke test failed');
   END IF;

   DBMS_OUTPUT.PUT_LINE('PASS arithmetic helpers');
END;
/

PROMPT Verifying all-null aggregate

DECLARE
   l_total INTERVAL DAY TO SECOND;
BEGIN
   SELECT sum_interval(CAST(NULL AS INTERVAL DAY TO SECOND))
   INTO l_total
   FROM dual;

   IF l_total IS NOT NULL THEN
      RAISE_APPLICATION_ERROR(-20005, 'all-null aggregate smoke test failed');
   END IF;

   DBMS_OUTPUT.PUT_LINE('PASS all-null aggregate');
END;
/

PROMPT Cleaning up

DROP TABLE utl_interval_smoke_test PURGE;

PROMPT Smoke test completed
