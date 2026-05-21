# Usage and API

`utl_interval` supports `INTERVAL DAY TO SECOND` values. It does not support
`INTERVAL YEAR TO MONTH`.

## `sum_interval`

```sql
sum_interval(ip_interval IN INTERVAL DAY TO SECOND)
   RETURN INTERVAL DAY TO SECOND
```

Sums interval values across rows.

```sql
SELECT sum_interval(elapsed_time) AS total_elapsed_time
FROM task_log;
```

Grouped aggregation:

```sql
SELECT project_id,
       sum_interval(elapsed_time) AS total_elapsed_time
FROM task_log
GROUP BY project_id;
```

Null values do not add to the aggregate state. An all-null aggregate returns
`NULL`.

## `pkg_interval.to_seconds`

```sql
pkg_interval.to_seconds(ip_interval IN INTERVAL DAY TO SECOND)
   RETURN NUMBER
```

Converts an interval to total seconds.

```sql
SELECT pkg_interval.to_seconds(INTERVAL '0 01:30:00' DAY TO SECOND) AS seconds
FROM dual;
```

The result may include fractional seconds. `NULL` input returns `NULL`.

## `pkg_interval.to_minutes`

```sql
pkg_interval.to_minutes(ip_interval IN INTERVAL DAY TO SECOND)
   RETURN NUMBER
```

Converts an interval to total minutes.

```sql
SELECT pkg_interval.to_minutes(INTERVAL '0 01:30:00' DAY TO SECOND) AS minutes
FROM dual;
```

The result may include fractional minutes. `NULL` input returns `NULL`.

## `pkg_interval.to_hours`

```sql
pkg_interval.to_hours(ip_interval IN INTERVAL DAY TO SECOND)
   RETURN NUMBER
```

Converts an interval to total hours.

```sql
SELECT pkg_interval.to_hours(INTERVAL '1 12:00:00' DAY TO SECOND) AS hours
FROM dual;
```

The result may include fractional hours. `NULL` input returns `NULL`.

## `pkg_interval.divide`

```sql
pkg_interval.divide(
   ip_numerator   IN INTERVAL DAY TO SECOND,
   ip_denominator IN INTERVAL DAY TO SECOND
)
   RETURN NUMBER
```

Returns the ratio between two intervals.

```sql
SELECT pkg_interval.divide(
          INTERVAL '0 02:00:00' DAY TO SECOND,
          INTERVAL '0 01:00:00' DAY TO SECOND
       ) AS ratio
FROM dual;
```

`NULL` input returns `NULL`. A zero denominator follows Oracle numeric division
behavior and raises a divide-by-zero error.

## `pkg_interval.add`

```sql
pkg_interval.add(
   ip_interval1 IN INTERVAL DAY TO SECOND,
   ip_interval2 IN INTERVAL DAY TO SECOND
)
   RETURN INTERVAL DAY TO SECOND
```

Adds two intervals.

```sql
SELECT pkg_interval.add(
          INTERVAL '0 01:00:00' DAY TO SECOND,
          INTERVAL '0 00:30:00' DAY TO SECOND
       ) AS total_interval
FROM dual;
```

If one argument is `NULL`, the other argument is returned. If both arguments
are `NULL`, the result is `NULL`.

## Edge Cases

Documented and expected behaviors:

- `NULL` conversion input returns `NULL`.
- `sum_interval` ignores null rows in the same way the aggregate state remains
  unchanged for null values.
- all-null interval aggregation returns `NULL`.
- fractional seconds are converted through Oracle `EXTRACT(SECOND ...)`.
- negative intervals should follow Oracle interval arithmetic semantics.
- very large totals may be constrained by Oracle interval precision.
