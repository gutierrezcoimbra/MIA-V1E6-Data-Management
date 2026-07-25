-- 10_customer_address.sql
-- Definición de la tabla customer_address (simplificada para SSDT)
CREATE TABLE dbo.customer_address (
	customer_id INT NOT NULL,
	address_id INT NOT NULL,
	status_id INT NULL,
	rowversion ROWVERSION NOT NULL,
	CONSTRAINT pk_custaddr PRIMARY KEY CLUSTERED (customer_id, address_id),
	CONSTRAINT fk_ca_cust FOREIGN KEY (customer_id) REFERENCES dbo.customer(customer_id),
	CONSTRAINT fk_ca_addr FOREIGN KEY (address_id) REFERENCES dbo.address(address_id),
	CONSTRAINT fk_customer_address_addres_status_id FOREIGN KEY (status_id) REFERENCES dbo.address_status(status_id) ON UPDATE CASCADE ON DELETE CASCADE
);

