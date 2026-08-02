CREATE TABLE [dbo].[FactOrder]
(
	[OrderID] [int] NOT NULL,
	[LineID] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[BookSK] [int] NULL,
	[CustomerSK] [int] NULL,
	[OrderStatusSK] [int] NULL,
	[ShippingMethodSK] [int] NULL,
	[Price] [decimal](5,2) NOT NULL,
	[Quantity] [int] NOT NULL DEFAULT 1
);
GO

ALTER TABLE [dbo].[FactOrder] ADD CONSTRAINT PK_FactOrder PRIMARY KEY(OrderID, LineID);
GO

ALTER TABLE [dbo].[FactOrder] ADD CONSTRAINT [FK_FactOrder_DimDate] FOREIGN KEY([OrderDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
GO

ALTER TABLE [dbo].[FactOrder] ADD CONSTRAINT [FK_FactOrder_DimBook] FOREIGN KEY([BookSK]) REFERENCES [dbo].[DimBook] ([BookSK]);
GO

ALTER TABLE [dbo].[FactOrder] ADD CONSTRAINT [FK_FactOrder_DimCustomer] FOREIGN KEY([CustomerSK]) REFERENCES [dbo].[DimCustomer] ([CustomerSK]);
GO

ALTER TABLE [dbo].[FactOrder] ADD CONSTRAINT [FK_FactOrder_DimOrderStatus] FOREIGN KEY([OrderStatusSK]) REFERENCES [dbo].[DimOrderStatus] ([OrderStatusSK]);
GO

ALTER TABLE [dbo].[FactOrder] ADD CONSTRAINT [FK_FactOrder_DimShippingMethod] FOREIGN KEY([ShippingMethodSK]) REFERENCES [dbo].[DimShippingMethod] ([ShippingMethodSK]);
GO
