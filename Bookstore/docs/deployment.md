# Deploying the Bookstore SSDT project

This runbook deploys the schema-only `BookstoreOLTP` DACPAC. Application data and SQL Server Management Studio (SSMS) database-diagram metadata are outside its scope. Do not add `dbo.sysdiagrams`, `dbo.fn_diagramobjects`, or `sp_*diagram` objects to the project.

## Prerequisites

- Visual Studio with SQL Server Data Tools (SSDT), including MSBuild.
- DacFx `SqlPackage` and `sqlcmd`.
- Windows authentication access to the target SQL Server.

Open the repository with `DataManagement.slnx`, then build the `BookstoreOLTP` project in the `Release` configuration.

## Configure a local profile

The committed template contains no credentials and targets a local `Bookstore` database through Windows authentication:

```powershell
Copy-Item ".\Bookstore\Properties\BookstoreOLTP.publish.xml.template" `
  ".\Bookstore\Properties\BookstoreOLTP.publish.xml"
```

For another SQL Server, edit only `TargetConnectionString` in the copied `.publish.xml` file. Keep credentials out of it; use Windows authentication or a securely supplied connection string. The active `.publish.xml` is local-only and must not be committed.

The template prevents object drops, blocks possible data loss, and sets `ScriptDatabaseOptions` to `False`. The last setting is intentional: the baseline identified unrelated database-option drift, so those options must not be changed as part of application-schema deployment.

## Review before deployment

Build the DACPAC:

```powershell
& "C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" `
  ".\Bookstore\BookstoreOLTP.sqlproj" /p:Configuration=Release /p:Platform=AnyCPU
```

Generate a deployment report and script using the copied profile:

```powershell
$sqlPackage = "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\SqlPackage.exe"
$dacpac = ".\Bookstore\bin\Release\BookstoreOLTP.dacpac"
$profile = ".\Bookstore\Properties\BookstoreOLTP.publish.xml"

& $sqlPackage /Action:DeployReport /SourceFile:$dacpac /Profile:$profile `
  /OutputPath:".\Bookstore\docs\deploy-report.xml"

& $sqlPackage /Action:Script /SourceFile:$dacpac /Profile:$profile `
  /OutputPath:".\Bookstore\docs\deploy-script.sql"
```

Review both generated files before deploying. Stop if the script proposes an object drop, data-loss operation, or unapproved database-option change. The approved baseline permits the missing `dbo.GetOrdersChangesByRowVersion` procedure to be created. See [the schema-comparison baseline](baseline-schema-comparison.md) for the expected comparison result and diagram-artifact filter.

## Deploy and verify

After review, publish with the same profile:

```powershell
& $sqlPackage /Action:Publish /SourceFile:$dacpac /Profile:$profile
```

Then rerun the deployment report and confirm it contains no application-schema changes. To verify that the missing procedure was deployed:

```powershell
sqlcmd -S localhost -d Bookstore -E -Q "SELECT OBJECT_ID(N'dbo.GetOrdersChangesByRowVersion', N'P') AS ProcedureId;"
```

Use the appropriate server name if the profile was changed. Keep generated reports and scripts out of version control unless they are deliberately retained as reviewed evidence.
