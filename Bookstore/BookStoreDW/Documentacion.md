# BookStore Data Warehouse - Modelo Estrella

## Propuesta de Diseno

El presente documento describe la propuesta de diseno del Data Warehouse para **BookStore**, basado en un **modelo estrella (Star Schema)**. Este modelo organiza los datos en tablas de dimensiones (atributos descriptivos) y tablas de hechos (metricas transaccionales), optimizando las consultas analiticas y reportes de negocio.

---

## Diagrama del Modelo Estrella

```
                        +----------------------+
                        |     DimDate          |
                        |----------------------|
                        | DateKey (PK)         |
                        | FullDate             |
                        | DayNumberOfWeek      |
                        | DayNameOfWeek        |
                        | DayNumberOfMonth     |
                        | DayNumberOfYear      |
                        | WeekNumberOfYear     |
                        | MonthName            |
                        | MonthNumberOfYear    |
                        | CalendarQuarter      |
                        | CalendarYear         |
                        | CalendarSemester     |
                        +----------+-----------+
                                   |
                                   | OrderDateKey (FK)
                                   |
+-------------------+    +---------+----------+    +----------------------+
|   DimBook         |    |    FactOrder       |    |  DimCustomer         |
|-------------------|    |--------------------|    |----------------------|
| BookSK (PK)       |<---| BookSK (FK)        |    | CustomerSK (PK)      |
| BookID            |    | OrderID (PK)       |    | CustomerID           |
| Title             |    | LineID (PK)        |    | FirstName            |
| ISBN13            |    | OrderDateKey (FK)  |--->| LastName             |
| NumPages          |    | CustomerSK (FK)    |    | Email                |
| PublicationDate   |    | OrderStatusSK (FK) |    | StreetNumber         |
| LanguageCode      |    | ShippingMethodSK   |    | StreetName           |
| LanguageName      |    | Price              |    | City                 |
| PublisherName     |    | Quantity           |    | CountryName          |
| AuthorName        |    +--------------------+    | AddressStatus        |
+-------------------+              |               +----------------------+
                                   |
                    +--------------+--------------+
                    |                             |
         +----------+-----------+      +----------+------------+
         | DimOrderStatus       |      | DimShippingMethod     |
         |----------------------|      |-----------------------|
         | OrderStatusSK (PK)   |      | ShippingMethodSK (PK) |
         | StatusID             |      | MethodID              |
         | StatusValue          |      | MethodName            |
         |                      |      | Cost                  |
         +----------------------+      +-----------------------+
```

---

## Tablas de Dimensiones

### DimBook
| Columna | Tipo | Descripcion |
|---------|------|-------------|
| BookSK | INT (IDENTITY) | Clave subrogada (Surrogate Key) |
| BookID | INT | ID original del libro (OLTP) |
| Title | VARCHAR(400) | Titulo del libro |
| ISBN13 | VARCHAR(13) | Codigo ISBN13 |
| NumPages | INT | Numero de paginas |
| PublicationDate | DATE | Fecha de publicacion |
| LanguageCode | VARCHAR(8) | Codigo del idioma |
| LanguageName | VARCHAR(50) | Nombre del idioma |
| PublisherName | VARCHAR(400) | Nombre del editorial |
| AuthorName | VARCHAR(400) | Nombre del autor principal |

**Origen OLTP:** `book`, `book_author`, `author`, `book_language`, `publisher`

### DimCustomer
| Columna | Tipo | Descripcion |
|---------|------|-------------|
| CustomerSK | INT (IDENTITY) | Clave subrogada |
| CustomerID | INT | ID original del cliente (OLTP) |
| FirstName | VARCHAR(200) | Nombre |
| LastName | VARCHAR(200) | Apellido |
| Email | VARCHAR(350) | Correo electronico |
| StreetNumber | VARCHAR(10) | Numero de calle |
| StreetName | VARCHAR(200) | Nombre de calle |
| City | VARCHAR(100) | Ciudad |
| CountryName | VARCHAR(200) | Pais |
| AddressStatus | VARCHAR(30) | Estado de la direccion |

**Origen OLTP:** `customer`, `customer_address`, `address`, `country`, `address_status`

### DimDate
| Columna | Tipo | Descripcion |
|---------|------|-------------|
| DateKey | INT (PK) | Clave en formato YYYYMMDD |
| FullDate | DATE | Fecha completa |
| DayNumberOfWeek | TINYINT | Dia de la semana (1-7) |
| DayNameOfWeek | NVARCHAR(10) | Nombre del dia |
| DayNumberOfMonth | TINYINT | Dia del mes |
| DayNumberOfYear | SMALLINT | Dia del ano |
| WeekNumberOfYear | TINYINT | Semana del ano |
| MonthName | NVARCHAR(10) | Nombre del mes |
| MonthNumberOfYear | TINYINT | Mes del ano |
| CalendarQuarter | TINYINT | Trimestre |
| CalendarYear | SMALLINT | Ano |
| CalendarSemester | TINYINT | Semestre |

### DimOrderStatus
| Columna | Tipo | Descripcion |
|---------|------|-------------|
| OrderStatusSK | INT (IDENTITY) | Clave subrogada |
| StatusID | INT | ID original del estado (OLTP) |
| StatusValue | VARCHAR(20) | Valor del estado |

**Origen OLTP:** `order_status`

### DimShippingMethod
| Columna | Tipo | Descripcion |
|---------|------|-------------|
| ShippingMethodSK | INT (IDENTITY) | Clave subrogada |
| MethodID | INT | ID original del metodo (OLTP) |
| MethodName | VARCHAR(100) | Nombre del metodo de envio |
| Cost | DECIMAL(6,2) | Costo del envio |

**Origen OLTP:** `shipping_method`

---

## Tabla de Hechos

### FactOrder
| Columna | Tipo | Descripcion |
|---------|------|-------------|
| OrderID | INT (PK) | ID de la orden |
| LineID | INT (PK) | ID de la linea de la orden |
| OrderDateKey | INT (FK) | Clave fecha de la orden |
| BookSK | INT (FK) | Clave subrogada del libro |
| CustomerSK | INT (FK) | Clave subrogada del cliente |
| OrderStatusSK | INT (FK) | Clave subrogada del estado |
| ShippingMethodSK | INT (FK) | Clave subrogada del metodo de envio |
| Price | DECIMAL(5,2) | Precio del libro |
| Quantity | INT | Cantidad (default 1) |

**Origen OLTP:** `cust_order`, `order_line`, `order_history`

---

## Tablas de Staging

Las tablas de staging sirven como area intermedia entre el OLTP y el DW. Los procesos ETL cargan primero los datos aqui, luego los transforman y finalmente los insertan en las dimensiones y hechos.

| Tabla Staging | Descripcion |
|---------------|-------------|
| `staging.book` | Datos de libros enriquecidos con autor, idioma y editorial |
| `staging.customer` | Datos de clientes enriquecidos con direccion y pais |
| `staging.orders` | Datos de ordenes con claves subrogadas resueltas |
| `staging.order_status` | Estados de orden |
| `staging.shipping_method` | Metodos de envio |

---

## Mapeo OLTP a DW

```
OLTP                          DW
----                          --
book                    -->   DimBook
book_author             -->   DimBook (AuthorName)
author                  -->   DimBook (AuthorName)
book_language           -->   DimBook (LanguageCode, LanguageName)
publisher               -->   DimBook (PublisherName)

customer                -->   DimCustomer
customer_address        -->   DimCustomer (Street, City)
address                 -->   DimCustomer (Street, City)
country                 -->   DimCustomer (CountryName)
address_status          -->   DimCustomer (AddressStatus)

order_status            -->   DimOrderStatus
shipping_method         -->   DimShippingMethod

cust_order              -->   FactOrder (OrderID, OrderDateKey)
order_line              -->   FactOrder (LineID, Price, Quantity)
order_history           -->   FactOrder (OrderStatusSK)
```

---

## Estructura de Carpetas

```
BookStoreDW/
├── Schema/
│   ├── Security/
│   │   └── schemas/
│   │       └── staging.sql
│   └── Tables/
│       ├── dbo/
│       │   ├── DimBook.sql
│       │   ├── DimCustomer.sql
│       │   ├── DimDate.sql
│       │   ├── DimOrderStatus.sql
│       │   ├── DimShippingMethod.sql
│       │   └── FactOrder.sql
│       └── staging/
│           ├── staging.book.sql
│           ├── staging.customer.sql
│           ├── staging.order_status.sql
│           ├── staging.orders.sql
│           └── staging.shipping_method.sql
└── Documentacion.md
```

---

## Decisiones de Diseno

1. **Claves Subrogadas (Surrogate Keys):** Todas las dimensiones usan claves enteras auto-generadas (IDENTITY) para isolarse de cambios en las claves del OLTP.

2. **Denormalizacion:** Las dimensiones agrupan atributos de multiples tablas OLTP para facilitar las consultas analiticas (ej: DimBook incluye datos de autor, idioma y editorial).

3. **Staging Tables:** Se crean tablas intermedias en el esquema `staging` para que los procesos ETL carguen primero los datos crudos y luego los transformen hacia las dimensiones y hechos.

4. **Granularidad del Hecho:** Cada fila en FactOrder representa una linea de orden (un libro especifico dentro de una orden), permitiendo analisis detallado por producto.

5. **DimDate Independiente:** Se incluye una tabla de dimension de fecha estandar para habilitar analisis temporales (tendencias, comparativas mensuales, etc.).
