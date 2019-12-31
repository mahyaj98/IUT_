
SELECT FullName, Country.Name AS Country, City.Name AS City FROM Users 
INNER JOIN Country ON (Users.CountryID = Country.ID)
INNER JOIN City ON (Users.CityID = City.ID)

SELECT FullName, ProductSale.Descriptions, ProductSale.Price FROM Users
FULL JOIN ProductSale ON Users.UserName = ProductSale.UserName

SELECT FullName, ProductSale.Descriptions, ProductSale.Price FROM Users
LEFT JOIN ProductSale ON Users.UserName = ProductSale.UserName

SELECT FullName, ProductSale.Descriptions, ProductSale.Price FROM Users
RIGHT JOIN ProductSale ON Users.UserName = ProductSale.UserName



