# utl_interval

`utl_interval` is a small Oracle PL/SQL utility library for working with
`INTERVAL DAY TO SECOND` values.

Its primary feature is `sum_interval`, an aggregate function for summing
interval values in Oracle database versions that do not provide native interval
aggregation. Oracle added native support for aggregating interval data types in
Oracle 23ai, so this project is mainly useful for pre-23ai databases and for
systems that need a stable compatibility utility.

## Public API

- `sum_interval` - aggregate function for summing `INTERVAL DAY TO SECOND`
  values.
- `pkg_interval.to_seconds` - converts an interval to total seconds.
- `pkg_interval.to_minutes` - converts an interval to total minutes.
- `pkg_interval.to_hours` - converts an interval to total hours.
- `pkg_interval.divide` - returns the ratio between two intervals.

`typ_interval` implements the Oracle ODCI aggregate interface used by
`sum_interval`. It is part of the schema API surface, but normal application
code should call `sum_interval` instead of using the type directly.

`pkg_interval.add` is a support function used by `typ_interval` while
aggregating values. If it is called directly from SQL, quote the function name
as `pkg_interval."ADD"(...)` because `ADD` is an Oracle SQL keyword.

## Quick Example

```sql
SELECT sum_interval(elapsed_time) AS total_elapsed_time
FROM task_log;
```

Grouped aggregation works the same way:

```sql
SELECT project_id,
       sum_interval(elapsed_time) AS total_elapsed_time
FROM task_log
GROUP BY project_id;
```

## Documentation

- [Architecture](docs/architecture.md)
- [Installation](docs/installation.md)
- [Usage and API](docs/usage.md)
- [Deployment](docs/deployment.md)
- [Testing](docs/testing.md)
- [Contributing](docs/contributing.md)

Executable examples are available under [Examples](Examples).

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE).
