-- 09_customer.sql
-- Definición de la tabla customer (simplificada para SSDT)
CREATE TABLE dbo.customer (
	customer_id INT NOT NULL,
	first_name VARCHAR(200) NULL,
	last_name VARCHAR(200) NULL,
	email VARCHAR(350) NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_customer PRIMARY KEY CLUSTERED (customer_id)
);

