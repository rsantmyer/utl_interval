# Contributing

`utl_interval` is a small Oracle PL/SQL compatibility utility. Contributions
should keep the project focused, easy to deploy, and easy to verify.

## Project Layout

```text
Packages/              package specifications and bodies
Types/                 object type specifications and bodies
Functions/             standalone functions
Deployment_Manifests/  SQL*Plus deployment manifests
Examples/              executable usage examples
Tests/                 executable verification scripts
docs/                  markdown documentation
```

## Documentation Expectations

- Keep public API comments close to the code in package, type, and function
  specifications.
- Keep user-facing documentation concise and practical.
- Add or update executable examples when behavior changes.
- Update deployment and testing docs when install or verification steps change.

## PL/SQL Style

- Preserve the existing object naming style: `pkg_`, `typ_`, and descriptive
  standalone function names.
- Prefer explicit parameter names with the existing `ip_` input prefix.
- Document null handling for every public function.
- Avoid introducing new public APIs unless they solve a compatibility need.

## Release Notes

When preparing a release, keep deployment metadata aligned with the source
being released, including version values and deploy commit hash.
