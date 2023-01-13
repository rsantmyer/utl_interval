CREATE OR REPLACE TYPE typ_interval
    AS OBJECT
(
    v_result INTERVAL DAY TO SECOND
--
,   STATIC FUNCTION odciaggregateinitialize(ctx          IN OUT typ_interval)
        RETURN NUMBER
,   MEMBER FUNCTION odciaggregateiterate(self            IN OUT typ_interval
                                        ,ip_val          IN     INTERVAL DAY TO SECOND
                                        )
        RETURN NUMBER
,   MEMBER FUNCTION odciaggregatemerge(self              IN OUT typ_interval
                                      ,ctx2              IN     typ_interval
                                      )
        RETURN NUMBER
,   MEMBER FUNCTION odciaggregateterminate(self          IN     typ_interval
                                          ,returnvalue      OUT INTERVAL DAY TO SECOND
                                          ,flags         IN     NUMBER
                                          )
        RETURN NUMBER
);
/
