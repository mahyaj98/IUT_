CREATE VIEW UserOutRP (
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
    INNER JOIN RequestProduct
        ON u.UserName = RequestProduct.UserName)
    GROUP BY 
        u.UserName