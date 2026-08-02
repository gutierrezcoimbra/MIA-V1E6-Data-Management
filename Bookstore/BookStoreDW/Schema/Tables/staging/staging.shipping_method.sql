CREATE TABLE [staging].[shipping_method]
(
	[ShippingMethodSK] [int] NOT NULL,
	[MethodID] [int] NOT NULL,
	[MethodName] [varchar](100) NOT NULL,
	[Cost] [decimal](6,2) NULL
)
GO
