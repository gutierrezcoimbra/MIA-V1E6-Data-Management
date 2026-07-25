-- 13_order_status.sql
-- Definición de la tabla order_status (simplificada para SSDT)
CREATE TABLE dbo.order_status (
	status_id INT NOT NULL,
	status_value VARCHAR(20) NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_orderstatus PRIMARY KEY CLUSTERED (status_id)
);

