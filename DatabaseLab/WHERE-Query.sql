
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
