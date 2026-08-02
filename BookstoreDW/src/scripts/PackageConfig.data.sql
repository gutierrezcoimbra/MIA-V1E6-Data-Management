IF NOT EXISTS(SELECT TOP(1) 1
			  FROM [dbo].[PackageConfig]
			  WHERE [TableName] = 'Customer')
 BEGIN
	INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) VALUES ('Customer', 0)
 END
GO
IF NOT EXISTS(SELECT TOP(1) 1
			  FROM [dbo].[PackageConfig]
			  WHERE [TableName] = 'Book')
 BEGIN
	INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) VALUES ('Book', 0)
 END
GO
IF NOT EXISTS(SELECT TOP(1) 1
			  FROM [dbo].[PackageConfig]
			  WHERE [TableName] = 'ShippingMethod')
 BEGIN
  INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) VALUES ('ShippingMethod', 0)
 END
GO
IF NOT EXISTS(SELECT TOP(1) 1
			  FROM [dbo].[PackageConfig]
			  WHERE [TableName] = 'Orders')
 BEGIN
	INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) VALUES ('Orders', 0)
 END
GO
