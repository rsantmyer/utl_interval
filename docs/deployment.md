# Deployment

The primary deployment entry point is:

```text
Deployment_Manifests/deploy_wrapper.sql
```

The wrapper and manifest are intended for SQL*Plus-compatible execution.

## Application Metadata

The manifest defines:

```sql
DEFINE APPLICATION_NAME = 'UTL_INTERVAL'
DEFINE DEPLOY_VERSION_MAJOR = '1'
DEFINE DEPLOY_VERSION_MINOR = '0'
DEFINE DEPLOY_VERSION_PATCH = '0'
DEFINE DEPLOY_COMMIT_HASH = '&&1'
```

`deploy_wrapper.sql` passes the commit hash into `deploy.sql`. The deployment
metadata is registered through `pkg_application`. Keep the wrapper hash and
version values aligned with the release being deployed.

## Dependency

The manifest registers one application dependency:

```sql
CORE
```

`pkg_application` must be available before the manifest can run.

## Object Registration

The manifest registers and validates:

- `TYP_INTERVAL` type specification
- `TYP_INTERVAL` type body
- `SUM_INTERVAL` function
- `PKG_INTERVAL` package specification
- `PKG_INTERVAL` package body

## Object Creation Order

The manifest creates objects in dependency order:

1. `pkg_interval` package specification
2. `pkg_interval` package body
3. `typ_interval` type specification
4. `typ_interval` type body
5. `sum_interval` function

## Validation

The manifest calls:

- `pkg_application.validate_dependencies_p`
- `pkg_application.validate_objects_p`
- `pkg_application.set_deployment_complete_p`

Run `Tests/smoke_test.sql` after deployment to verify the user-facing API.

## Maven Artifact

The repository can also be packaged as a Maven-distributed ZIP:

```sh
mvn package
```

This creates:

```text
target/utl_interval-0.1.0-SNAPSHOT.zip
```

The ZIP contains the repository layout plus generated build provenance at:

```text
META-INF/utl_interval-build.properties
```

See [Maven Packaging](maven-packaging.md) for details.
