CREATE TABLE UsersLogs(
	[FullName] [varchar](20) NOT NULL,
	[UserName] [char](5) NOT NULL,
	[Phone] [varchar](15) NOT NULL,
	[Email] [varchar](20) NOT NULL,
	[ChangeType] [varchar](20)
)
GO
CREATE TRIGGER UserDatabaseLogger
ON Users
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
			INSERT INTO UsersLogs(FullName, UserName, Phone, Email, ChangeType)
			SELECT d.FullName, d.UserName, d.Phone, d.Email, @operation
			FROM deleted d

	IF @operation = 'Insert'
			INSERT INTO UsersLogs(FullName, UserName, Phone, Email, ChangeType)
			SELECT i.FullName, i.UserName, i.Phone, i.Email, @operation
			FROM inserted i

	IF @operation = 'Update'
			INSERT INTO UsersLogs(FullName, UserName, Phone, Email, ChangeType)
			SELECT d.FullName, d.UserName, d.Phone, d.Email, @operation
			FROM deleted d
END
GO
