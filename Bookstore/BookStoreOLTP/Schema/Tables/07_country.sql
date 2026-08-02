-- 07_country.sql
-- Definición de la tabla country (simplificada para SSDT)
CREATE TABLE dbo.country (
	country_id INT NOT NULL,
	country_name VARCHAR(200) NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_country PRIMARY KEY CLUSTERED (country_id)
);

