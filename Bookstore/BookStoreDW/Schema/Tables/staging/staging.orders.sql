CREATE TABLE [staging].[orders]
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
)
GO
