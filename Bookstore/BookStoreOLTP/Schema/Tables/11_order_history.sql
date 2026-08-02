-- 11_order_history.sql
-- Definición de la tabla order_history (simplificada para SSDT)
CREATE TABLE dbo.order_history (
	history_id INT IDENTITY(1,1) NOT NULL,
	order_id INT NULL,
	status_id INT NULL,
	status_date DATETIME NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_orderhist PRIMARY KEY CLUSTERED (history_id),
	CONSTRAINT fk_oh_order FOREIGN KEY (order_id) REFERENCES dbo.cust_order(order_id),
	CONSTRAINT fk_oh_status FOREIGN KEY (status_id) REFERENCES dbo.order_status(status_id)
);

