CREATE TABLE RPLogs(
	[ID] [char](5) NOT NULL,
	[UserName] [char](5) NULL,
	[PostDate] [char](10) NOT NULL,
	[Price] [int] NULL,
	ChangeType [varchar](10) NOT NULL

)
GO
CREATE TRIGGER UserDatabaseLogger
ON RequestProduct
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @operation CHAR(6)
		SET @operation = CASE
				WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
					THEN 'Update'
				WHEN EXISTS(SELECT * FROM inserted)
					THEN 'Insert'
				WHEN EXISTS(SELECT * FROM deleted)
					THEN 'Delete'
				ELSE NULL
		END
	IF @operation = 'Delete'
			INSERT INTO RPLogs(ID, UserName, PostDate, Price, ChangeType)
			SELECT d.ID, d.UserName, d.PostDate, d.Price, @operation
			FROM deleted d

	IF @operation = 'Insert'
			INSERT INTO RPLogs(ID, UserName, PostDate, Price, ChangeType)
			SELECT d.ID, d.UserName, d.PostDate, d.Price, @operation
			FROM Inserted d

	IF @operation = 'Updated'
			INSERT INTO RPLogs(ID, UserName, PostDate, Price, ChangeType)
			SELECT d.ID, d.UserName, d.PostDate, d.Price, @operation
			FROM deleted d
END
GO
