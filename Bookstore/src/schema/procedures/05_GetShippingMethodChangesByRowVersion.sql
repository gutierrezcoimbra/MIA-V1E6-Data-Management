CREATE PROCEDURE [dbo].[GetShippingMethodChangesByRowVersion]
(
   @startRow BIGINT 
   ,@endRow  BIGINT 
)
AS
BEGIN
	SELECT [method_id]
	  ,[method_name]
	  ,[cost]
	  FROM [dbo].[shipping_method]
	  WHERE [rowversion] > CONVERT(ROWVERSION,@startRow) 
	  AND [rowversion] <= CONVERT(ROWVERSION,@endRow)
END
