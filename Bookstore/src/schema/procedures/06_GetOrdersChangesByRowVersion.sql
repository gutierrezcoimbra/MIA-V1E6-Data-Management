CREATE PROCEDURE [dbo].[GetOrdersChangesByRowVersion]
(
   @startRow BIGINT 
   ,@endRow  BIGINT 
)
AS
BEGIN
	SELECT 
	co.[order_id]
	,co.[order_date]
	,co.[customer_id]
	,co.[shipping_method_id]
	,co.[dest_address_id]
	,ol.[line_id]
	,ol.[book_id]
	,ol.[price]
	,oh.[history_id]
	,oh.[status_date]
	,os.[status_value]
	FROM [dbo].[cust_order] co
	INNER JOIN [dbo].[order_line] ol ON (co.order_id = ol.order_id)
	INNER JOIN [dbo].[order_history] oh ON (co.order_id = oh.order_id)
	INNER JOIN [dbo].[order_status] os ON (oh.status_id = os.status_id)
	WHERE (co.[rowversion] > CONVERT(ROWVERSION,@startRow) AND co.[rowversion] <= CONVERT(ROWVERSION,@endRow))
	OR (ol.[rowversion] > CONVERT(ROWVERSION,@startRow) AND ol.[rowversion] <= CONVERT(ROWVERSION,@endRow))
	OR (oh.[rowversion] > CONVERT(ROWVERSION,@startRow) AND oh.[rowversion] <= CONVERT(ROWVERSION,@endRow))
	OR (os.[rowversion] > CONVERT(ROWVERSION,@startRow) AND os.[rowversion] <= CONVERT(ROWVERSION,@endRow))
END
