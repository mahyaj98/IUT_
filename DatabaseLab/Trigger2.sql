CREATE TABLE RSLogs(
	[ID] [char](5) NOT NULL,
	[UserName] [char](5) NULL,
	[PostDate] [char](10) NOT NULL,
	[Price] [int] NULL,
	[CategoryID] [char](5) NULL,
	ChangeType [varchar](15) NOT NULL
)
GO
CREATE TRIGGER RSDatabaseLogger
ON RequestService
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
			INSERT INTO RSLogs(ID, UserName, PostDate, Price, CategoryID, ChangeType)
			SELECT d.ID, d.UserName, d.PostDate, d.Price, d.CategoryID, @operation
			FROM deleted d

	IF @operation = 'Insert'
			INSERT INTO RSLogs(ID, UserName, PostDate, Price, CategoryID,ChangeType)
			SELECT d.ID, d.UserName, d.PostDate, d.Price, d.CategoryID, @operation
			FROM inserted d

	IF @operation = 'Update'
			INSERT INTO RSLogs(ID, UserName, PostDate, Price, CategoryID, ChangeType)
			SELECT d.ID, d.UserName, d.PostDate, d.Price, d.CategoryID, @operation
			FROM deleted d
END
GO
