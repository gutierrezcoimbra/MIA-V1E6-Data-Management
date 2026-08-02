CREATE TABLE [dbo].[DimShippingMethod]
(
	[ShippingMethodSK]   [int] IDENTITY(1,1) NOT NULL CONSTRAINT PK_DimShippingMethod PRIMARY KEY,
	[ShippingMethodID]   [int]           NOT NULL,
	[MethodName]         [varchar](100)  NULL,
	[Cost]               [decimal](6, 2) NULL
);
GO
