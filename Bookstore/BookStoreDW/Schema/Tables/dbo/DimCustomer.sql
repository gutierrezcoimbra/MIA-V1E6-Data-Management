CREATE TABLE [dbo].[DimCustomer]
(
	[CustomerSK] [int] IDENTITY(1,1) NOT NULL CONSTRAINT PK_DimCustomer PRIMARY KEY,
	[CustomerID] [int] NOT NULL,
	[FirstName] [varchar](200) NOT NULL,
	[LastName] [varchar](200) NOT NULL,
	[Email] [varchar](350) NULL,
	[StreetNumber] [varchar](10) NULL,
	[StreetName] [varchar](200) NULL,
	[City] [varchar](100) NULL,
	[CountryName] [varchar](200) NULL,
	[AddressStatus] [varchar](30) NULL
)
GO
