CREATE VIEW UserIncomePSe (
        FullName, 
        UserName, 
        amount
)
AS 
    SELECT 
        u.FullName,
        u.UserName,
        SUM(Price) amount
    FROM(
        Users u
    INNER JOIN ProvideService
        ON u.UserName = ProvideService.UserName)
    GROUP BY 
        u.UserName