CREATE PROCEDURE dbo.CatID
@CategoryID char(5)
AS   
BEGIN  
    SELECT * FROM ProvideService p
	WHERE p.CategoryID = @CategoryID
END; 