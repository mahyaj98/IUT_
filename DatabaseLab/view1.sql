CREATE VIEW UserIncomePS (
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
    INNER JOIN ProductSale
        ON u.UserName = ProductSale.UserName)
    GROUP BY 
        u.UserName