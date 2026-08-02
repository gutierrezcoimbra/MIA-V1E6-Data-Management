CREATE TABLE [dbo].[FactOrders]
(
	[OrderID]            [int]            NOT NULL,
	[LineID]             [int]            NOT NULL,
	[OrderDateKey]       [int]            NOT NULL,
	[StatusDateKey]      [int]            NOT NULL,
	[CustomerSK]         [int]            NULL,
	[BookSK]             [int]            NULL,
	[ShippingMethodSK]   [int]            NULL,
	[Price]              [decimal](5, 2)  NULL,
	[OrderStatus]        [varchar](50)    NULL,
	[OrderDate]          [datetime]       NULL,
	[StatusDate]         [datetime]       NULL
);
GO

ALTER TABLE [dbo].[FactOrders] ADD CONSTRAINT PK_FactOrders PRIMARY KEY (OrderID, LineID);
GO

ALTER TABLE [dbo].[FactOrders] ADD CONSTRAINT [FK_FactOrders_DimCustomer]
	FOREIGN KEY ([CustomerSK]) REFERENCES [dbo].[DimCustomer] ([CustomerSK]);
GO

ALTER TABLE [dbo].[FactOrders] ADD CONSTRAINT [FK_FactOrders_DimBook]
	FOREIGN KEY ([BookSK]) REFERENCES [dbo].[DimBook] ([BookSK]);
GO

ALTER TABLE [dbo].[FactOrders] ADD CONSTRAINT [FK_FactOrders_DimShippingMethod]
	FOREIGN KEY ([ShippingMethodSK]) REFERENCES [dbo].[DimShippingMethod] ([ShippingMethodSK]);
GO

ALTER TABLE [dbo].[FactOrders] ADD CONSTRAINT [FK_FactOrders_DimDate_OrderDate]
	FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
GO

ALTER TABLE [dbo].[FactOrders] ADD CONSTRAINT [FK_FactOrders_DimDate_StatusDate]
	FOREIGN KEY ([StatusDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
GO
