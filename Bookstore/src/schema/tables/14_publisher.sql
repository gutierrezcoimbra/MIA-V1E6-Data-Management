-- 14_publisher.sql
-- Definición de la tabla publisher (simplificada para SSDT)
CREATE TABLE dbo.publisher (
	publisher_id INT NOT NULL,
	publisher_name VARCHAR(400) NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_publisher PRIMARY KEY CLUSTERED (publisher_id)
);

