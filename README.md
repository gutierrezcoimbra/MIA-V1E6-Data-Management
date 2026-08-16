# MIA-V1E6

## Módulo: Data Management and Business Intelligence

### Descripción

Solución de Business Intelligence para una librería (Bookstore). Incluye una base transaccional (OLTP), un data warehouse en esquema estrella y un proceso ETL incremental con SSIS, controlado por `ROWVERSION` y un job de SQL Agent.

### Grupo

5

### Integrantes

- Ligia Gabriela Barrera Copa
- Victor Hugo Gutierrez
- Loren Dereck Jiménez
- Limber Maldonado Casillo
- Kevin Alexis Padilla Lopez

### Proyectos

| Proyecto | Tipo | Rol |
| --- | --- | --- |
| [BookstoreOLTP](Bookstore/BookstoreOLTP.sqlproj) | SSDT | Base transaccional: 15 tablas, procedimientos CDC por `ROWVERSION` y datos semilla |
| [BookstoreDW](BookstoreDW/BookstoreDW.sqlproj) | SSDT | Data warehouse: dimensiones, `FactOrders`, esquema `staging` y `PackageConfig` |
| [BookStoreETL](BookStoreETL/BookStoreETL.dtproj) | SSIS | Paquetes que extraen cambios del OLTP, cargan staging y fusionan al DW |

El job de SQL Agent está en [Jobs/BookStoreETLJob.sql](Jobs/BookStoreETLJob.sql).

## Arquitectura

```mermaid
flowchart LR
    OLTP[BookstoreOLTP]
    CDC[Rowversion procedures]
    SSIS[BookStoreETL]
    Staging[staging schema]
    Merge[DW_Merge procedures]
    Star[Star schema]
    Agent[SQL_Agent_job]

    OLTP --> CDC
    CDC --> SSIS
    Agent --> SSIS
    SSIS --> Staging
    Staging --> Merge
    Merge --> Star
```

Carga incremental:

1. El OLTP expone cambios con `GetDatabaseRowVersion` y `Get*ChangesByRowVersion`.
2. El DW guarda el último `ROWVERSION` procesado en `dbo.PackageConfig` (`GetLastPackageRowVersion` / `UpdateLastPackageRowVersion`).
3. SSIS copia los cambios a `staging` y llama a los procedimientos `DW_Merge*`.

Orden del job: **DimShippingMethod** → **DimCustomer** → **DimBook** → **FactOrders**.

## Estructura del repositorio

```
BookStore.slnx
Bookstore/                          SSDT OLTP (BookstoreOLTP)
  src/schema/tables/                15 tablas
  src/schema/procedures/            6 procedimientos CDC
  src/scripts/                      datos semilla y post-deploy
  docs/                             runbook de publicación y baseline
  Properties/                       plantilla de perfil de publish
BookstoreDW/                        SSDT data warehouse
  src/schema/tables/dbo/            dimensiones, hecho, PackageConfig
  src/schema/tables/staging/        tablas de staging
  src/schema/programmability/       procedimientos de merge y CDC
  src/scripts/                      DimDate, PackageConfig, post-deploy
BookStoreETL/                       SSIS (4 paquetes)
Jobs/                               script del job de SQL Agent
```

La solución Visual Studio agrupa los proyectos en `Databases/OLTP`, `Databases/DataWarehouse` y `ETL`.

## Diagrama OLTP

15 tablas. Todas incluyen `rowversion` para CDC. Relaciones según las claves foráneas del proyecto SSDT.

```mermaid
erDiagram
    country ||--o{ address : has
    address ||--o{ customer_address : used_in
    address ||--o{ cust_order : destination
    address_status ||--o{ customer_address : classifies
    customer ||--o{ customer_address : has
    customer ||--o{ cust_order : places
    shipping_method ||--o{ cust_order : ships
    publisher ||--o{ book : publishes
    book_language ||--o{ book : written_in
    book ||--o{ book_author : has
    author ||--o{ book_author : writes
    book ||--o{ order_line : sold_as
    cust_order ||--o{ order_line : contains
    cust_order ||--o{ order_history : tracked_by
    order_status ||--o{ order_history : status

    country {
        int country_id PK
        varchar country_name
        rowversion rowversion
    }
    address {
        int address_id PK
        varchar street_number
        varchar street_name
        varchar city
        int country_id FK
        rowversion rowversion
    }
    address_status {
        int status_id PK
        varchar address_status
        rowversion rowversion
    }
    customer {
        int customer_id PK
        varchar first_name
        varchar last_name
        varchar email
        rowversion rowversion
    }
    customer_address {
        int customer_id PK_FK
        int address_id PK_FK
        int status_id FK
        rowversion rowversion
    }
    publisher {
        int publisher_id PK
        varchar publisher_name
        rowversion rowversion
    }
    book_language {
        int language_id PK
        varchar language_code
        varchar language_name
        rowversion rowversion
    }
    author {
        int author_id PK
        varchar author_name
        rowversion rowversion
    }
    book {
        int book_id PK
        varchar title
        varchar isbn13
        int language_id FK
        int num_pages
        date publication_date
        int publisher_id FK
        rowversion rowversion
    }
    book_author {
        int book_id PK_FK
        int author_id PK_FK
        rowversion rowversion
    }
    shipping_method {
        int method_id PK
        varchar method_name
        decimal cost
        rowversion rowversion
    }
    cust_order {
        int order_id PK
        datetime order_date
        int customer_id FK
        int shipping_method_id FK
        int dest_address_id FK
        rowversion rowversion
    }
    order_line {
        int line_id PK
        int order_id FK
        int book_id FK
        decimal price
        rowversion rowversion
    }
    order_status {
        int status_id PK
        varchar status_value
        rowversion rowversion
    }
    order_history {
        int history_id PK
        int order_id FK
        int status_id FK
        datetime status_date
        rowversion rowversion
    }
```

Procedimientos CDC del OLTP:

- `dbo.GetDatabaseRowVersion`
- `dbo.GetAddressChangesByRowVersion`
- `dbo.GetBookChangesByRowVersion`
- `dbo.GetCustomerChangesByRowVersion`
- `dbo.GetShippingMethodChangesByRowVersion`
- `dbo.GetOrdersChangesByRowVersion`

## Diagrama del data warehouse

Esquema estrella. Grano de `FactOrders`: `(OrderID, LineID)`.

```mermaid
erDiagram
    DimDate ||--o{ FactOrders : order_date
    DimDate ||--o{ FactOrders : status_date
    DimCustomer ||--o{ FactOrders : customer
    DimBook ||--o{ FactOrders : book
    DimShippingMethod ||--o{ FactOrders : shipping

    DimDate {
        int DateKey PK
        date FullDate
        nvarchar MonthName
        smallint CalendarYear
        tinyint CalendarQuarter
    }
    DimCustomer {
        int CustomerSK PK
        int CustomerID
        varchar FirstName
        varchar LastName
        varchar Email
        varchar City
        varchar Country
    }
    DimBook {
        int BookSK PK
        int BookID
        varchar Title
        varchar ISBN13
        varchar LanguageName
        varchar PublisherName
        varchar AuthorName
    }
    DimShippingMethod {
        int ShippingMethodSK PK
        int ShippingMethodID
        varchar MethodName
        decimal Cost
    }
    FactOrders {
        int OrderID PK
        int LineID PK
        int OrderDateKey FK
        int StatusDateKey FK
        int CustomerSK FK
        int BookSK FK
        int ShippingMethodSK FK
        decimal Price
        varchar OrderStatus
    }
```

Objetos de apoyo:

- `staging.book`, `staging.customer`, `staging.shipping_method`, `staging.orders`
- `dbo.PackageConfig` (`TableName`, `LastRowVersion`)
- `DW_MergeDimBook`, `DW_MergeDimCustomer`, `DW_MergeDimShippingMethod`, `DW_MergeFactOrders`

`DimDate` se carga en el post-deploy del DW (no por SSIS).

## Cómo abrir y desplegar

### Requisitos

- Visual Studio 2022 o posterior, con SQL Server Data Tools (SSDT) e Integration Services (SSIS)
- SQL Server local (o accesible) con autenticación de Windows
- `SqlPackage` y `sqlcmd` para publicar DACPAC

### Abrir la solución

Abrir `BookStore.slnx` en Visual Studio. No hay restauración de paquetes NuGet: los proyectos son SSDT y SSIS.

### Orden de despliegue

1. Publicar **BookstoreOLTP** (esquema y datos semilla).
2. Publicar **BookstoreDW** (dimensiones, hecho, staging, `DimDate` y `PackageConfig`).
3. Desplegar el proyecto SSIS al catálogo SSISDB, carpeta `BookStore`.
4. Crear o actualizar el job de SQL Agent con [Jobs/BookStoreETLJob.sql](Jobs/BookStoreETLJob.sql). El script fija el propietario `LAPTOP-LTNQC5A3\Ligia`; cámbielo antes de ejecutarlo.

El runbook de publicación del OLTP (perfil local, `SqlPackage`, revisión del script) está en [Bookstore/docs/deployment.md](Bookstore/docs/deployment.md). La comparación de esquema de referencia está en [Bookstore/docs/baseline-schema-comparison.md](Bookstore/docs/baseline-schema-comparison.md).

Paquetes SSIS:

- `DimShippingMethod.dtsx`
- `DimCustomer.dtsx`
- `DimBook.dtsx`
- `FactOrders.dtsx`
