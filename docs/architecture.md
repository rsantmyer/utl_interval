# Architecture

`utl_interval` is intentionally small. It provides a compatibility layer for
Oracle `INTERVAL DAY TO SECOND` aggregation and a few supporting interval
helpers.

## Components

```text
sum_interval
  -> user-facing aggregate function
  -> implemented by typ_interval

typ_interval
  -> Oracle ODCI aggregate type
  -> stores aggregate state in v_result
  -> delegates interval addition to pkg_interval.add

pkg_interval
  -> utility package for interval conversion and ratio helpers
  -> includes add as a support function for typ_interval

Deployment_Manifests/deploy_wrapper.sql
  -> SQL*Plus deployment entry point
  -> passes the deploy commit hash to deploy.sql

Deployment_Manifests/deploy.sql
  -> SQL*Plus deployment manifest
  -> registers application metadata through pkg_application
  -> depends on CORE
```

## Dependency Order

Objects must be created in this order:

1. `pkg_interval` package specification
2. `pkg_interval` package body
3. `typ_interval` type specification
4. `typ_interval` type body
5. `sum_interval` function

`sum_interval` depends on `typ_interval`, and `typ_interval` depends on
`pkg_interval`.

## User-Facing API

Most users should use:

- `sum_interval`
- `pkg_interval`

`typ_interval` is public because Oracle aggregate implementations require a
schema-level object type, but it is implementation-facing. Application SQL
should not call the ODCI methods directly.

`pkg_interval.add` is also primarily implementation-facing. It remains part of
the package specification because `typ_interval` depends on it, but normal users
usually do not need to call it directly.

## Oracle 23ai Note

Oracle 23ai added native support for aggregating interval data types. This
project remains useful for earlier Oracle versions and for applications that
need one documented compatibility API across supported database versions.
