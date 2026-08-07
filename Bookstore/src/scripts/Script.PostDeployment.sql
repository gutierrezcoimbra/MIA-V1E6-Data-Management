-- Script.PostDeployment.sql
-- Este script se ejecuta después de la publicación del esquema.
-- Inserta los datos de referencia y de prueba en el orden correcto
-- para respetar las restricciones de clave foránea.
-- Los archivos incluidos con :r son relativos a este script.

-- ---------------------------------------------------------------
-- Tablas de referencia sin dependencias
-- ---------------------------------------------------------------
:r .\country.data.sql
:r .\book_language.data.sql
:r .\address_status.data.sql
:r .\order_status.data.sql
:r .\shipping_method.data.sql
:r .\publisher.data.sql
:r .\author.data.sql

-- ---------------------------------------------------------------
-- Tablas que dependen de las anteriores
-- ---------------------------------------------------------------
:r .\address.data.sql
:r .\book.data.sql
:r .\customer.data.sql

-- ---------------------------------------------------------------
-- Tablas de relación y transaccionales
-- ---------------------------------------------------------------
:r .\book_author.data.sql
:r .\customer_address.data.sql
:r .\cust_order.data.sql
:r .\order_line.data.sql
:r .\order_history.data.sql
