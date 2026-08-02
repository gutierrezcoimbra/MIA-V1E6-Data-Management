-- 05_book_author.sql
-- Definición de la tabla book_author (simplificada para SSDT)
CREATE TABLE dbo.book_author (
	book_id INT NOT NULL,
	author_id INT NOT NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_bookauthor PRIMARY KEY CLUSTERED (book_id, author_id),
	CONSTRAINT fk_ba_book FOREIGN KEY (book_id) REFERENCES dbo.book(book_id),
	CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES dbo.author(author_id)
);

