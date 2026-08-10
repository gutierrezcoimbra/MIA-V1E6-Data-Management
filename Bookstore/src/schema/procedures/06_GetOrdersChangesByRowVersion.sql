CREATE OR ALTER PROCEDURE [dbo].[GetOrdersChangesByRowVersion]
(
   @startRow BIGINT 
   ,@endRow  BIGINT 
)
AS
BEGIN
	WITH ChangedOrders AS (
		SELECT DISTINCT co.order_id
		FROM [dbo].[cust_order] co
		INNER JOIN [dbo].[order_line] ol ON (co.order_id = ol.order_id)
		INNER JOIN [dbo].[order_history] oh ON (co.order_id = oh.order_id)
		INNER JOIN [dbo].[order_status] os ON (oh.status_id = os.status_id)
		WHERE (co.[rowversion] > CONVERT(ROWVERSION,@startRow) AND co.[rowversion] <= CONVERT(ROWVERSION,@endRow))
		OR (ol.[rowversion] > CONVERT(ROWVERSION,@startRow) AND ol.[rowversion] <= CONVERT(ROWVERSION,@endRow))
		OR (oh.[rowversion] > CONVERT(ROWVERSION,@startRow) AND oh.[rowversion] <= CONVERT(ROWVERSION,@endRow))
		OR (os.[rowversion] > CONVERT(ROWVERSION,@startRow) AND os.[rowversion] <= CONVERT(ROWVERSION,@endRow))
	),
	LatestOrderHistory AS (
		SELECT 
			oh.order_id,
			oh.history_id,
			oh.status_id,
			oh.status_date,
			ROW_NUMBER() OVER (PARTITION BY oh.order_id ORDER BY oh.status_date DESC, oh.history_id DESC) AS rn
		FROM [dbo].[order_history] oh
		WHERE oh.order_id IN (SELECT order_id FROM ChangedOrders)
	)
	SELECT 
	co.[order_id]
	,OrderDateKey = CONVERT(INT,
							(CONVERT(CHAR(4),DATEPART(YEAR,co.[order_date]))
						  + CASE 
								WHEN DATEPART(MONTH,co.[order_date]) < 10 THEN '0' + CONVERT(CHAR(1),DATEPART(MONTH,co.[order_date]))
								ELSE + CONVERT(CHAR(2),DATEPART(MONTH,co.[order_date]))
							END
						  + CASE 
								WHEN DATEPART(DAY,co.[order_date]) < 10 THEN '0' + CONVERT(CHAR(1),DATEPART(DAY,co.[order_date]))
								ELSE + CONVERT(CHAR(2),DATEPART(DAY,co.[order_date]))
							END))
	,StatusDateKey = CONVERT(INT,
							(CONVERT(CHAR(4),DATEPART(YEAR,oh.[status_date]))
						  + CASE 
								WHEN DATEPART(MONTH,oh.[status_date]) < 10 THEN '0' + CONVERT(CHAR(1),DATEPART(MONTH,oh.[status_date]))
								ELSE + CONVERT(CHAR(2),DATEPART(MONTH,oh.[status_date]))
							END
						  + CASE 
								WHEN DATEPART(DAY,oh.[status_date]) < 10 THEN '0' + CONVERT(CHAR(1),DATEPART(DAY,oh.[status_date]))
								ELSE + CONVERT(CHAR(2),DATEPART(DAY,oh.[status_date]))
							END))
	,co.[customer_id]
	,co.[shipping_method_id]
	,co.[dest_address_id]
	,ol.[line_id]
	,ol.[book_id]
	,ol.[price]
	,oh.[history_id]
	,os.[status_value]
	,co.[order_date]
	,oh.[status_date]
	FROM ChangedOrders ca
	INNER JOIN [dbo].[cust_order] co ON (ca.order_id = co.order_id)
	INNER JOIN [dbo].[order_line] ol ON (co.order_id = ol.order_id)
	INNER JOIN LatestOrderHistory oh ON (co.order_id = oh.order_id AND oh.rn = 1)
	INNER JOIN [dbo].[order_status] os ON (oh.status_id = os.status_id)
END
