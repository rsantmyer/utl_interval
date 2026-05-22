# Maven Packaging

This repository is an Oracle PL/SQL/database tooling project, not a Java library.
Maven is used here for versioning, dependency metadata, artifact distribution, and future dependency resolution between database repositories.

The initial distributable artifact is a ZIP archive of the repository contents:

```text
target/utl_interval-0.1.0-SNAPSHOT.zip
```

The ZIP includes source code, install/deployment scripts, documentation, manifests, examples, and tests if present. It excludes local build output, VCS metadata, GitHub workflow metadata, IDE files, SQL*Plus spool logs, and temporary files.

## Local Build

From the repository root:

```sh
mvn package
```

This runs the Maven Assembly Plugin and creates:

```text
target/utl_interval-0.1.0-SNAPSHOT.zip
```

The project uses `pom` packaging because Maven is serving as a metadata and distribution tool. There is no Java compile step.

## Build Metadata

The Maven build generates a filtered properties file and packages it inside the ZIP at:

```text
META-INF/utl_interval-build.properties
```

Example contents:

```properties
artifact.groupId=com.512itconsulting.database
artifact.artifactId=utl_interval
artifact.version=0.1.0-SNAPSHOT
git.commit.id=5af0af4c86abef934e10e76744fcc05854dc580d
git.commit.id.abbrev=5af0af4
git.branch=main
git.dirty=true
build.time=2026-05-22T15:30:00Z
```

The Git values are generated dynamically from the current repository state by `git-commit-id-maven-plugin`. Maven resource filtering then combines those Git values with artifact values from `pom.xml`; `build.time` comes from Maven's build timestamp.

This supports deployment traceability without embedding Git hashes into the Maven version string. Deployment tooling can inspect the ZIP and record exactly which artifact coordinates and Git commit produced a deployed database state. Later, this metadata may be injected into `deploy_wrapper.sql` or loaded into deployment audit tables so Oracle deployments can be tied back to the source commit that produced them.

The `git.dirty` value is included as an additional traceability guard. A value of `true` means the artifact was built with uncommitted working-tree changes, so the commit hash alone does not fully describe the source content. Future release or deployment automation may choose to reject dirty builds.

The plugin first writes Git metadata under `target/generated-git/`. The Maven Resources Plugin then uses that file as a filter and creates the final metadata file under `target/generated-build-metadata/`. The assembly descriptor places the resolved file at `META-INF/utl_interval-build.properties` inside the final ZIP. The template file under `assembly/` is excluded from the ZIP so the artifact contains resolved metadata rather than unresolved Maven placeholders.

## Dependency Metadata

`utl_interval` declares a Maven dependency on:

```text
com.512itconsulting.database:core:0.1.0-SNAPSHOT
```

This mirrors the database deployment dependency on `CORE`, which provides `pkg_application` and deployment metadata validation. Maven does not understand PL/SQL install order by itself, so the SQL deployment manifest remains the source of truth for object creation and runtime validation.

## Publishing To GitHub Packages

The `pom.xml` publishes to GitHub Packages using this repository URL:

```text
https://maven.pkg.github.com/rsantmyer/utl_interval
```

Publish with:

```sh
mvn deploy
```

Maven will deploy the POM metadata and the attached ZIP artifact to GitHub Packages.

GitHub's Maven registry documentation is here: [Working with the Apache Maven registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-apache-maven-registry).

## Authentication

GitHub Packages requires Maven credentials in `~/.m2/settings.xml`. The `<server><id>` must match the repository id in `pom.xml`, which is currently `github`.

Example:

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <servers>
    <server>
      <id>github</id>
      <username>YOUR_GITHUB_USERNAME</username>
      <password>YOUR_GITHUB_TOKEN</password>
    </server>
  </servers>
</settings>
```

Use a GitHub personal access token with permission to publish packages for this repository. For private package consumption, consumers will also need credentials with package read access.

## Assumptions

- The package coordinates match the repository and application name: `com.512itconsulting.database:utl_interval:0.1.0-SNAPSHOT`.
- The GitHub Packages owner/repository path is `rsantmyer/utl_interval`, matching the canonical GitHub owner for this repository.
- The ZIP should preserve the repository's current layout instead of moving files into Maven's standard `src/main` tree.
- The ZIP includes Maven packaging files themselves because it is currently a repository-content distribution.
- `.claude/` is excluded as local tooling metadata, similar to IDE files.
