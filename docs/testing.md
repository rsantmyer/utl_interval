# Testing

This repository currently uses executable SQL scripts for verification.

## Smoke Test

Run:

```sql
@Tests/smoke_test.sql
```

The smoke test verifies:

- `sum_interval`
- grouped aggregation
- interval conversion helpers
- interval addition
- interval division
- null aggregation behavior

## Example Scripts

Examples under `Examples` are also intended to execute successfully. They are
small, self-contained scripts that can be run in a scratch schema.

## Recommended Edge-Case Coverage

When changing code, verify:

- positive interval aggregation
- grouped interval aggregation
- all-null aggregation
- mixed null and non-null aggregation
- fractional seconds
- negative intervals
- zero denominator behavior for `pkg_interval.divide`
- large totals near Oracle interval precision limits
- parallel aggregate behavior where supported by the environment

## Test Environment

Use a disposable schema or a development database. The examples create and drop
tables with names prefixed by `utl_interval_`.
