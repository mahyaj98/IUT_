WITH T(UserName, ProductSalePrice, ProvideServicePrice, RequestServicePrice, RequestProductPrice) AS (
SELECT ProductSale.UserName AS UN, 
	   SUM(ProductSale.Price) , 
	   SUM(ProvideService.Price),
	   SUM(RequestService.Price), 
	   SUM(RequestProduct.Price) 
	   FROM ProductSale FULL JOIN ProvideService ON (ProductSale.UserName = ProvideService.UserName)
	   FULL JOIN RequestService ON (ProvideService.UserName = RequestService.UserName)
	   FULL JOIN RequestProduct ON (RequestService.UserName = RequestProduct.UserName)
	   GROUP BY ProductSale.UserName)

SELECT * FROM T

SELECT 
	FullName,
	CASE CountryID
		WHEN '1' THEN 'Iran'
		WHEN '2' THEN 'USA' 
		WHEN '3' THEN 'Canada' 
		WHEN '4' THEN 'UK'
		ELSE 'No Country!'
	END AS CountryInfo
	FROM Users
	
		 
SELECT COUNT(UserName) AS Count FROM Users 

SELECT COUNT(DISTINCT CityID) AS Count FROM USERS


SELECT FullName, Country.Name AS Country, City.Name AS City FROM Users 
INNER JOIN Country ON (Users.CountryID = Country.ID)
INNER JOIN City ON (Users.CityID = City.ID)

SELECT FullName, ProductSale.Descriptions, ProductSale.Price FROM Users
FULL JOIN ProductSale ON Users.UserName = ProductSale.UserName

SELECT FullName, ProductSale.Descriptions, ProductSale.Price FROM Users
LEFT JOIN ProductSale ON Users.UserName = ProductSale.UserName

SELECT FullName, ProductSale.Descriptions, ProductSale.Price FROM Users
RIGHT JOIN ProductSale ON Users.UserName = ProductSale.UserName




SELECT FullName, UserName FROM Users 
WHERE CityID = 1 OR CountryID = 2
ORDER BY FullName

SELECT * FROM RequestProduct 
WHERE isExpired = 0
ORDER BY PostDate

SELECT * FROM RequestService
WHERE CategoryID = 2
ORDER BY Price

SELECT * FROM City

SELECT * FROM Country

SELECT * FROM Categories

SELECT FullName, UserName FROM Users

SELECT * FROM RequestProduct 

SELECT * FROM RequestService

SELECT * FROM ProductSale 

SELECT * FROM ProvideService 

SELECT * FROM ProductSale WHERE Price < 10000 UNION SELECT * FROM ProductSale WHERE Price > 1000 

SELECT * FROM ProductSale WHERE CityID = 1 INTERSECT SELECT * FROM ProductSale WHERE  CountryID = 2

SELECT * FROM ProductSale WHERE CityID = 2  EXCEPT  SELECT * FROM ProductSale WHERE  CountryID = 2

SELECT FullName, UserName FROM Users 
WHERE CityID = 1 OR CountryID = 2

SELECT * FROM RequestProduct 
WHERE isExpired = 0

SELECT * FROM RequestService
WHERE CategoryID = 2

SELECT * FROM ProductSale 
WHERE Price > 1000

SELECT * FROM ProvideService 
WHERE UserName = 'dina'
