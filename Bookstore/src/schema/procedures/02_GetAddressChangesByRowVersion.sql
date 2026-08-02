CREATE PROCEDURE [dbo].[GetAddressChangesByRowVersion]
(
   @startRow BIGINT 
   ,@endRow  BIGINT 
)
AS
BEGIN
	SELECT 
	a.[address_id]
	,a.[street_name]
	,a.[street_number]
	,a.[city]
	,co.[country_name]
  FROM [dbo].[address] a
  JOIN [dbo].[country] co ON (a.country_id = co.country_id)
  WHERE (a.[rowversion] > CONVERT(ROWVERSION,@startRow) AND a.[rowversion] <= CONVERT(ROWVERSION,@endRow))
  OR (co.[rowversion] > CONVERT(ROWVERSION,@startRow) AND co.[rowversion] <= CONVERT(ROWVERSION,@endRow))
END
