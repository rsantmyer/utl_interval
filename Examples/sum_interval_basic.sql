SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE utl_interval_example_tasks PURGE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

PROMPT Creating example table

CREATE TABLE utl_interval_example_tasks
(
   task_name    VARCHAR2(100),
   elapsed_time INTERVAL DAY TO SECOND
);

INSERT INTO utl_interval_example_tasks VALUES
   ('design', INTERVAL '0 01:15:00' DAY TO SECOND);

INSERT INTO utl_interval_example_tasks VALUES
   ('build', INTERVAL '0 02:30:00' DAY TO SECOND);

INSERT INTO utl_interval_example_tasks VALUES
   ('review', INTERVAL '0 00:45:00' DAY TO SECOND);

COMMIT;

PROMPT Total elapsed time

SELECT sum_interval(elapsed_time) AS total_elapsed_time
FROM utl_interval_example_tasks;

PROMPT Cleaning up

DROP TABLE utl_interval_example_tasks PURGE;
