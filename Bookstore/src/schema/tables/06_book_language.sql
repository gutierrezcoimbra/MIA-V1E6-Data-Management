-- 06_book_language.sql
-- Definición de la tabla book_language (simplificada para SSDT)
CREATE TABLE dbo.book_language (
	language_id INT NOT NULL,
	language_code VARCHAR(8) NULL,
	language_name VARCHAR(50) NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_language PRIMARY KEY CLUSTERED (language_id)
);

