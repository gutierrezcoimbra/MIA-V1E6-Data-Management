CREATE PROCEDURE [dbo].[DW_MergeDimShippingMethod]
AS
BEGIN

	UPDATE dsm
	SET [MethodName] = sc.[MethodName]
	   ,[Cost]       = sc.[Cost]
	FROM [dbo].[DimShippingMethod]           dsm
	INNER JOIN [staging].[shipping_method] sc ON (dsm.[ShippingMethodSK] = sc.[ShippingMethodSK])
END
GO
