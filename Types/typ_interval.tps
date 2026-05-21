CREATE OR REPLACE TYPE typ_interval
    AS OBJECT
(
    /*
       Implementation type for the sum_interval aggregate function.

       This type implements Oracle's ODCI aggregate interface and stores the
       running aggregate value in v_result. Application code should normally
       call sum_interval instead of calling this type directly.
    */
    v_result INTERVAL DAY TO SECOND

-- Initializes aggregate state for sum_interval.
,   STATIC FUNCTION odciaggregateinitialize(ctx          IN OUT typ_interval)
        RETURN NUMBER
-- Adds one interval value to the aggregate state.
,   MEMBER FUNCTION odciaggregateiterate(self            IN OUT typ_interval
                                        ,ip_val          IN     INTERVAL DAY TO SECOND
                                        )
        RETURN NUMBER
-- Merges aggregate state during parallel or distributed aggregation.
,   MEMBER FUNCTION odciaggregatemerge(self              IN OUT typ_interval
                                      ,ctx2              IN     typ_interval
                                      )
        RETURN NUMBER
-- Returns the final aggregate value.
,   MEMBER FUNCTION odciaggregateterminate(self          IN     typ_interval
                                          ,returnvalue      OUT INTERVAL DAY TO SECOND
                                          ,flags         IN     NUMBER
                                          )
        RETURN NUMBER
);
/
