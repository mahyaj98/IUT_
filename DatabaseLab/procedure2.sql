CREATE PROCEDURE UserNameSum
@UserName [varchar](10)
AS
	SELECT SUM(p.Price)
	FROM ProvideService p
	WHERE p.UserName = @UserName
GO