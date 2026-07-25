-- 03_author.sql
-- Definición de la tabla author (simplificada para SSDT)
CREATE TABLE dbo.author (
	author_id INT NOT NULL,
	author_name VARCHAR(400) NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_author PRIMARY KEY CLUSTERED (author_id)
);

