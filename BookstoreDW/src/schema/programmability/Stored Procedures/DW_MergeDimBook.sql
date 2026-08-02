CREATE PROCEDURE [dbo].[DW_MergeDimBook]
AS
BEGIN

	UPDATE db
	SET [Title]           = sc.[Title]
	   ,[ISBN13]          = sc.[ISBN13]
	   ,[LanguageName]    = sc.[LanguageName]
	   ,[NumPages]        = sc.[NumPages]
	   ,[PublicationDate] = sc.[PublicationDate]
	   ,[PublisherName]   = sc.[PublisherName]
	   ,[AuthorName]      = sc.[AuthorName]
	FROM [dbo].[DimBook]           db
	INNER JOIN [staging].[book] sc ON (db.[BookSK] = sc.[BookSK])
END
GO
