CREATE PROCEDURE [dbo].[GetCustomerChangesByRowVersion]
(
   @startRow BIGINT 
   ,@endRow  BIGINT 
)
AS
BEGIN
	SELECT c.[customer_id]
	  ,c.[first_name]
	  ,c.[last_name]
	  ,c.[email]
	  ,a.[street_name]
	  ,a.[street_number]
	  ,a.city
	  ,adds.address_status
	  ,co.country_name
  FROM [dbo].[customer] c
  JOIN [dbo].[customer_address] ca ON (c.customer_id = ca.customer_id)
  JOIN [dbo].[address_status] adds ON (ca.status_id = adds.status_id)
  JOIN [dbo].[address] a ON (ca.address_id = a.address_id)
  JOIN [dbo].[country] co ON (a.country_id = co.country_id)
  WHERE (c.[rowversion] > CONVERT(ROWVERSION,@startRow) AND c.[rowversion] <= CONVERT(ROWVERSION,@endRow))
  OR (ca.[rowversion] > CONVERT(ROWVERSION,@startRow) AND ca.[rowversion] <= CONVERT(ROWVERSION,@endRow))
  OR (adds.[rowversion] > CONVERT(ROWVERSION,@startRow) AND adds.[rowversion] <= CONVERT(ROWVERSION,@endRow))
  OR (a.[rowversion] > CONVERT(ROWVERSION,@startRow) AND a.[rowversion] <= CONVERT(ROWVERSION,@endRow))
  OR (co.[rowversion] > CONVERT(ROWVERSION,@startRow) AND co.[rowversion] <= CONVERT(ROWVERSION,@endRow))
END
