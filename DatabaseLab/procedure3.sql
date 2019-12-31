CREATE PROCEDURE CityStuff
@CityID [varchar](5)
AS
	SELECT SUM(p.Price) 
	FROM ProvideService p
	WHERE p.CityID = @CityID

GO
