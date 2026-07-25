-- 04_book.sql
-- Definición de la tabla book (simplificada para SSDT)
CREATE TABLE dbo.book (
	book_id INT NOT NULL,
	title VARCHAR(400) NULL,
	isbn13 VARCHAR(13) NULL,
	language_id INT NULL,
	num_pages INT NULL,
	publication_date DATE NULL,
	publisher_id INT NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_book PRIMARY KEY CLUSTERED (book_id),
	CONSTRAINT fk_book_lang FOREIGN KEY (language_id) REFERENCES dbo.book_language(language_id),
	CONSTRAINT fk_book_pub FOREIGN KEY (publisher_id) REFERENCES dbo.publisher(publisher_id)
);

