SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE utl_interval_example_worklog PURGE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

PROMPT Creating example table

CREATE TABLE utl_interval_example_worklog
(
   project_code VARCHAR2(30),
   task_name    VARCHAR2(100),
   elapsed_time INTERVAL DAY TO SECOND
);

INSERT INTO utl_interval_example_worklog VALUES
   ('ALPHA', 'design', INTERVAL '0 01:00:00' DAY TO SECOND);

INSERT INTO utl_interval_example_worklog VALUES
   ('ALPHA', 'build', INTERVAL '0 02:30:00' DAY TO SECOND);

INSERT INTO utl_interval_example_worklog VALUES
   ('BETA', 'design', INTERVAL '0 00:45:00' DAY TO SECOND);

INSERT INTO utl_interval_example_worklog VALUES
   ('BETA', 'build', INTERVAL '0 01:15:00' DAY TO SECOND);

COMMIT;

PROMPT Total elapsed time by project

SELECT project_code,
       sum_interval(elapsed_time) AS total_elapsed_time
FROM utl_interval_example_worklog
GROUP BY project_code
ORDER BY project_code;

PROMPT Cleaning up

DROP TABLE utl_interval_example_worklog PURGE;
