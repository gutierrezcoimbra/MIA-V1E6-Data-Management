-- 15_shipping_method.sql
-- Definición de la tabla shipping_method (simplificada para SSDT)
CREATE TABLE dbo.shipping_method (
	method_id INT NOT NULL,
	method_name VARCHAR(100) NULL,
	cost DECIMAL(6,2) NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_shipmethod PRIMARY KEY CLUSTERED (method_id)
);

