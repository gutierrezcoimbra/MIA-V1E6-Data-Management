CREATE TABLE [staging].[book]
(
	[BookSK]          [int]          NOT NULL,
	[Title]           [varchar](400) NULL,
	[ISBN13]          [varchar](13)  NULL,
	[LanguageName]    [varchar](50)  NULL,
	[NumPages]        [int]          NULL,
	[PublicationDate] [date]         NULL,
	[PublisherName]   [varchar](400) NULL,
	[AuthorName]      [varchar](400) NULL
);
GO
