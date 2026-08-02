CREATE TABLE [staging].[shipping_method]
(
	[ShippingMethodSK] [int]           NOT NULL,
	[MethodName]       [varchar](100)  NULL,
	[Cost]             [decimal](6, 2) NULL
);
GO
