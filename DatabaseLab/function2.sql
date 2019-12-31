IF OBJECT_ID (N'dbo.getSumByCatIDRSe', N'FN') IS NOT NULL  
    DROP FUNCTION getSumByCatIDRSe;  
GO  
CREATE FUNCTION dbo.getSumByCatIDRSe(@CategoryID char(5))  
RETURNS int   
AS   
BEGIN  
    DECLARE @ret int;  
    SELECT @ret = SUM(p.Price)   
    FROM RequestService p   
    WHERE p.CategoryID = @CategoryID;
     IF (@ret IS NULL)   
        SET @ret = 0;  
    RETURN @ret;  
END; 