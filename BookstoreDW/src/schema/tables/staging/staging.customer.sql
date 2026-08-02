CREATE TABLE [staging].[customer]
(
	[CustomerSK]  [int]          NOT NULL,
	[FirstName]   [varchar](200) NULL,
	[LastName]    [varchar](200) NULL,
	[Email]       [varchar](350) NULL,
	[StreetNumber][varchar](10)  NULL,
	[StreetName]  [varchar](200) NULL,
	[City]        [varchar](100) NULL,
	[Country]     [varchar](200) NULL
);
GO
