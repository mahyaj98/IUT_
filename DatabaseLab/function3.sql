IF OBJECT_ID (N'dbo.getSumByCatIDRSe', N'FN') IS NOT NULL  
    DROP FUNCTION getSumByCatIDRSe;  
GO  
CREATE FUNCTION dbo.getSumByCatIDRSe()  
RETURNS TABLE
AS   
RETURN
(
	SELECT SUM(Price) AS [SUM], AVG(Price) AS [AVG], MAX(Price) AS [MAX]
	FROM RequestService
	GROUP BY CategoryID
);
