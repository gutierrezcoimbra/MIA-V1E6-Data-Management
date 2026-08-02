CREATE TABLE [dbo].[DimBook]
(
	[BookSK] [int] IDENTITY(1,1) NOT NULL CONSTRAINT PK_DimBook PRIMARY KEY,
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
