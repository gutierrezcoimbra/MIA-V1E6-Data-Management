-- 08_cust_order.sql
-- Definición de la tabla cust_order (simplificada para SSDT)
CREATE TABLE dbo.cust_order (
	order_id INT IDENTITY(1,1) NOT NULL,
	order_date DATETIME NULL,
	customer_id INT NULL,
	shipping_method_id INT NULL,
	dest_address_id INT NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_custorder PRIMARY KEY CLUSTERED (order_id),
	CONSTRAINT fk_order_cust FOREIGN KEY (customer_id) REFERENCES dbo.customer(customer_id),
	CONSTRAINT fk_order_ship FOREIGN KEY (shipping_method_id) REFERENCES dbo.shipping_method(method_id),
	CONSTRAINT fk_order_addr FOREIGN KEY (dest_address_id) REFERENCES dbo.address(address_id)
);

