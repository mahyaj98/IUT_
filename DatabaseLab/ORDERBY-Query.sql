
SELECT FullName, UserName FROM Users 
WHERE CityID = 1 OR CountryID = 2
ORDER BY FullName

SELECT * FROM RequestProduct 
WHERE isExpired = 0
ORDER BY PostDate

SELECT * FROM RequestService
WHERE CategoryID = 2
ORDER BY Price

