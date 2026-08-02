CREATE TABLE [staging].[book]
(
	[BookSK] [int] NOT NULL,
	[BookID] [int] NOT NULL,
	[Title] [varchar](400) NOT NULL,
	[ISBN13] [varchar](13) NULL,
	[NumPages] [int] NULL,
	[PublicationDate] [date] NULL,
	[LanguageCode] [varchar](8) NULL,
	[LanguageName] [varchar](50) NULL,
	[PublisherName] [varchar](400) NULL,
	[AuthorName] [varchar](400) NULL
)
GO
