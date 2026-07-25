-- 12_order_line.sql
-- Definición de la tabla order_line (simplificada para SSDT)
CREATE TABLE dbo.order_line (
	line_id INT IDENTITY(1,1) NOT NULL,
	order_id INT NULL,
	book_id INT NULL,
	price DECIMAL(5,2) NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_orderline PRIMARY KEY CLUSTERED (line_id),
	CONSTRAINT fk_ol_order FOREIGN KEY (order_id) REFERENCES dbo.cust_order(order_id),
	CONSTRAINT fk_ol_book FOREIGN KEY (book_id) REFERENCES dbo.book(book_id)
);

