CREATE OR REPLACE TYPE BODY typ_interval
IS

    STATIC FUNCTION odciaggregateinitialize(ctx          IN OUT typ_interval)
        RETURN NUMBER
    IS
    BEGIN
        ctx  := typ_interval(NULL);
        RETURN odciconst.success;
    END odciaggregateinitialize;



    MEMBER FUNCTION odciaggregateiterate(self            IN OUT typ_interval
                                        ,ip_val          IN     INTERVAL DAY TO SECOND
                                        )
        RETURN NUMBER
    IS
    BEGIN
        IF self.v_result IS NULL
        THEN
            self.v_result  := ip_val;
        ELSE
            self.v_result  := pkg_interval.add(self.v_result, ip_val);
        END IF;

        RETURN odciconst.success;
    END odciaggregateiterate;



    MEMBER FUNCTION odciaggregatemerge(self              IN OUT typ_interval
                                      ,ctx2              IN     typ_interval
                                      )
        RETURN NUMBER
    IS
    BEGIN
        IF self.v_result IS NULL
        THEN
            self.v_result  := ctx2.v_result;
        ELSIF ctx2.v_result IS NOT NULL
        THEN
            self.v_result  := pkg_interval.add(self.v_result, ctx2.v_result);
        END IF;

        RETURN odciconst.success;
    END odciaggregatemerge;



    MEMBER FUNCTION odciaggregateterminate(self          IN     typ_interval
                                          ,returnvalue      OUT INTERVAL DAY TO SECOND
                                          ,flags         IN     NUMBER
                                          )
        RETURN NUMBER
    IS
    BEGIN
        returnvalue  := self.v_result;
        RETURN odciconst.success;
    END odciaggregateterminate;

END;
/
