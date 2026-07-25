-- 02_address_status.sql
-- Definición de la tabla address_status (simplificada para SSDT)
CREATE TABLE dbo.address_status (
	status_id INT NOT NULL,
	address_status VARCHAR(30) NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_addr_status PRIMARY KEY CLUSTERED (status_id)
);

