CREATE TABLE [staging].[orders]
(
	[OrderID]           [int]           NOT NULL,
	[LineID]            [int]           NOT NULL,
	[OrderDateKey]      [int]           NOT NULL,
	[StatusDateKey]     [int]           NOT NULL,
	[CustomerSK]        [int]           NULL,
	[BookSK]            [int]           NULL,
	[ShippingMethodSK]  [int]           NULL,
	[Price]             [decimal](5, 2) NULL,
	[OrderStatus]       [varchar](50)   NULL,
	[OrderDate]         [datetime]      NULL,
	[StatusDate]        [datetime]      NULL
);
GO
