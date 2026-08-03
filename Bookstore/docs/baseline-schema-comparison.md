# Bookstore schema comparison baseline

**Compared:** 2026-08-02  
**Project:** `BookstoreOLTP.sqlproj`  
**Target:** local `localhost` / `Bookstore` (Windows authentication)  
**Scope:** application schema only; no data was read or changed.

## Filter

The target contains SQL Server Management Studio database-diagram metadata. It is excluded from this baseline and must not be added to the SSDT project:

- `dbo.sysdiagrams`
- `dbo.fn_diagramobjects`
- `dbo.sp_alterdiagram`
- `dbo.sp_creatediagram`
- `dbo.sp_dropdiagram`
- `dbo.sp_helpdiagramdefinition`
- `dbo.sp_helpdiagrams`
- `dbo.sp_renamediagram`
- `dbo.sp_upgraddiagrams`
- the `sysdiagrams` primary and unique key constraints
- permissions granted or denied only for the preceding diagram objects

This filter leaves the application objects below.

## Filtered inventory result

| Area | Project | Filtered `Bookstore` target | Result |
| --- | ---: | ---: | --- |
| Tables | 15 | 15 | Match |
| Columns | 65 | 65 | Match |
| Identity columns | 3 | 3 | Match |
| Primary keys / clustered indexes | 15 | 15 | Match |
| Foreign keys | 15 | 15 | Match |
| Non-primary-key indexes | 0 | 0 | Match |
| Defaults, check constraints, and triggers | 0 | 0 | Match |
| Application object permissions | 0 | 0 | Match |
| Rowversion procedures | 6 | 5 | **Target is missing `dbo.GetOrdersChangesByRowVersion`** |

The target procedure inventory is:

- `dbo.GetDatabaseRowVersion`
- `dbo.GetAddressChangesByRowVersion`
- `dbo.GetBookChangesByRowVersion`
- `dbo.GetCustomerChangesByRowVersion`
- `dbo.GetShippingMethodChangesByRowVersion`

The source project additionally contains `dbo.GetOrdersChangesByRowVersion`. Its referenced application tables (`dbo.cust_order`, `dbo.order_line`, `dbo.order_history`, and `dbo.order_status`) all exist in the target.

## SSDT deployment-report review

The project was built successfully in `Release` and compared to the target with DacFx `DeployReport`. The report contains no SSMS diagram artifact because those objects are absent from the DACPAC; they remain excluded by the filter above.

| Operation | Object | Review result |
| --- | --- | --- |
| Alter | `dbo.GetBookChangesByRowVersion` | Existing target definition differs from the project definition. |
| Alter | `dbo.GetCustomerChangesByRowVersion` | Existing target definition differs from the project definition. |
| Alter | `dbo.GetDatabaseRowVersion` | Existing target definition differs from the project definition. |
| Alter | `dbo.GetShippingMethodChangesByRowVersion` | Existing target definition differs from the project definition. |
| Create | `dbo.GetOrdersChangesByRowVersion` | Expected target drift; the procedure is absent from `Bookstore`. |

There are no table, column, identity, primary-key, foreign-key, non-primary-key-index, default, check, trigger, application-permission, or application-object-drop operations in the filtered report.

## Database options and remaining drift

The project declares `DefaultCollation` as `Modern_Spanish_CI_AS` in `BookstoreOLTP.sqlproj`, matching the target database collation. Its `ModelCollation` is `3082, CI`, the SSDT-supported language and case-sensitivity representation for Modern Spanish. This alignment does not alter the existing database collation.

The generated deployment script also proposes database-option changes. Do **not** deploy it as-is: each generated `ALTER DATABASE` uses `WITH ROLLBACK IMMEDIATE`.

| Area | Target | Generated script proposes | Disposition |
| --- | --- | --- | --- |
| Collation | `Modern_Spanish_CI_AS` | No `ALTER DATABASE ... COLLATE`; `DefaultCollation` is `Modern_Spanish_CI_AS` and `ModelCollation` is `3082, CI`. | Aligned; retain the target collation. |
| ANSI database options | `ANSI_NULL_DEFAULT`, `ANSI_PADDING`, `ANSI_WARNINGS`, `ARITHABORT`, `CONCAT_NULL_YIELDS_NULL`, and `QUOTED_IDENTIFIER` are off. | Set all six options on; set `CURSOR_DEFAULT LOCAL`. | Unreviewed drift; do not apply during procedure synchronization. |
| Page verification | `CHECKSUM` | `NONE` | Reject; preserve `CHECKSUM`. |
| Target recovery time | 60 seconds | 0 seconds | Unreviewed drift; do not apply. |
| Query Store | Enabled | Configure capture mode, cleanup threshold, and maximum storage. | Unreviewed drift; do not apply. |
| Temporal-history retention | Disabled | Enable | Unreviewed drift; do not apply. |

The target also has compatibility level 160, `FULL` recovery, and snapshot isolation disabled. The report does not propose changes to those settings.

## Reproduction

The local environment used for this baseline has SQL Server 2025 Developer Edition, Visual Studio SSDT MSBuild, DacFx `SqlPackage`, and `sqlcmd`. The following commands build the DACPAC and generate a read-only report:

```powershell
& "C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" `
  ".\Bookstore\BookstoreOLTP.sqlproj" /p:Configuration=Release /p:Platform=AnyCPU

& "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\SqlPackage.exe" `
  /Action:DeployReport `
  /SourceFile:".\Bookstore\bin\Release\BookstoreOLTP.dacpac" `
  /TargetConnectionString:"Server=localhost;Database=Bookstore;Integrated Security=True;TrustServerCertificate=True" `
  /OutputPath:".\Bookstore\docs\deploy-report.xml"
```

For a full review, generate a script as well, inspect every `ALTER DATABASE` statement, and do not execute it:

```powershell
& "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\SqlPackage.exe" `
  /Action:Script `
  /SourceFile:".\Bookstore\bin\Release\BookstoreOLTP.dacpac" `
  /TargetConnectionString:"Server=localhost;Database=Bookstore;Integrated Security=True;TrustServerCertificate=True" `
  /OutputPath:".\Bookstore\docs\deploy-script.sql" `
  /p:BlockOnPossibleDataLoss=True
```

Use the following query to recheck the filtered catalog counts:

```sql
SELECT COUNT(*) AS ApplicationTableCount
FROM sys.tables AS t
JOIN sys.schemas AS s ON s.schema_id = t.schema_id
WHERE s.name = 'dbo'
  AND t.is_ms_shipped = 0
  AND t.name <> 'sysdiagrams';

SELECT COUNT(*) AS ApplicationForeignKeyCount
FROM sys.foreign_keys AS fk
WHERE OBJECT_SCHEMA_NAME(fk.parent_object_id) = 'dbo'
  AND OBJECT_NAME(fk.parent_object_id) <> 'sysdiagrams';

SELECT COUNT(*) AS ApplicationProcedureCount
FROM sys.procedures AS p
JOIN sys.schemas AS s ON s.schema_id = p.schema_id
WHERE s.name = 'dbo'
  AND p.is_ms_shipped = 0
  AND p.name NOT LIKE 'sp[_]%diagram%';
```

Use the same filter in Visual Studio Schema Compare before synchronizing. At this baseline, the application-object changes are the five procedure operations above, while the database-option changes require separate review. No diagram artifact should be selected for synchronization.
