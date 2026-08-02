CREATE PROCEDURE [dbo].[DW_MergeFactOrders]
AS
BEGIN

	UPDATE fo
	SET [OrderDateKey]     = sc.[OrderDateKey]
	   ,[StatusDateKey]    = sc.[StatusDateKey]
	   ,[CustomerSK]       = sc.[CustomerSK]
	   ,[BookSK]           = sc.[BookSK]
	   ,[ShippingMethodSK] = sc.[ShippingMethodSK]
	   ,[Price]            = sc.[Price]
	   ,[OrderStatus]      = sc.[OrderStatus]
	   ,[OrderDate]        = sc.[OrderDate]
	   ,[StatusDate]       = sc.[StatusDate]
	FROM [dbo].[FactOrders]           fo
	INNER JOIN [staging].[orders] sc ON (fo.[OrderID] = sc.[OrderID] AND fo.[LineID] = sc.[LineID])
END
GO
