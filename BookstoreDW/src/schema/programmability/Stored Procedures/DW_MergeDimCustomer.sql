CREATE PROCEDURE [dbo].[DW_MergeDimCustomer]
AS
BEGIN

	UPDATE dc
	SET [FirstName]    = sc.[FirstName]
	   ,[LastName]     = sc.[LastName]
	   ,[Email]        = sc.[Email]
	   ,[StreetNumber] = sc.[StreetNumber]
	   ,[StreetName]   = sc.[StreetName]
	   ,[City]         = sc.[City]
	   ,[Country]      = sc.[Country]
	FROM [dbo].[DimCustomer]           dc
	INNER JOIN [staging].[customer] sc ON (dc.[CustomerSK] = sc.[CustomerSK])
END
GO
