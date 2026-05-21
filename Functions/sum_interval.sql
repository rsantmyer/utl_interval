/*
   Function: sum_interval

   Aggregate function for summing INTERVAL DAY TO SECOND values.

   Parameters:
      ip_interval - interval value to include in the aggregate.

   Returns:
      Sum of non-null interval values as INTERVAL DAY TO SECOND. Returns NULL
      for an all-null aggregate.

   Notes:
      This compatibility function is primarily useful on Oracle versions before
      Oracle 23ai, where interval aggregation became natively supported.
*/
CREATE OR REPLACE FUNCTION sum_interval(ip_interval IN INTERVAL DAY TO SECOND )
RETURN INTERVAL DAY TO SECOND
PARALLEL_ENABLE
AGGREGATE USING typ_interval
;
/
