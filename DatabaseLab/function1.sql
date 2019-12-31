IF OBJECT_ID (N'dbo.getSumByCatIDPSe', N'FN') IS NOT NULL  
    DROP FUNCTION getSumByCatIDPSe;  
GO  
CREATE FUNCTION dbo.getSumByCatIDPSe(@CategoryID char(5))  
RETURNS int   
AS   
-- Returns the stock level for the product.  
BEGIN  
    DECLARE @ret int;  
    SELECT @ret = SUM(p.Price)   
    FROM ProvideService p   
    WHERE p.CategoryID = @CategoryID;
     IF (@ret IS NULL)   
        SET @ret = 0;  
    RETURN @ret;  
END; 