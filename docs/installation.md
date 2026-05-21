# Installation

`utl_interval` is installed by running the SQL*Plus deployment wrapper from a
schema that can create packages, object types, and functions.

## Prerequisites

- Oracle Database with `INTERVAL DAY TO SECOND` support.
- SQL*Plus or a compatible script runner.
- Privileges to create packages, object types, and functions in the target
  schema.
- The repository's deployment flow expects the `CORE` application dependency
  (containing `pkg_application` ) to be available.

Oracle 23ai includes native interval aggregation support. For 23ai and newer,
confirm whether the built-in behavior is preferred before installing this
compatibility utility.

## Deploy

From the `Deployment_Manifests` directory, run:

```sql
@deploy_wrapper.sql
```

The wrapper defines the deploy commit hash and calls `deploy.sql`. The manifest:

- registers the `UTL_INTERVAL` application through `pkg_application`
- validates the `CORE` dependency
- creates package, type, and function objects
- validates deployed objects
- writes a spool log named for the application and current schema

## Verify

After installation, run the smoke test:

```sql
@Tests/smoke_test.sql
```
