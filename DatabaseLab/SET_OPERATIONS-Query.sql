SELECT * FROM ProductSale WHERE Price < 10000 UNION SELECT * FROM ProductSale WHERE Price > 1000 

SELECT * FROM ProductSale WHERE CityID = 1 INTERSECT SELECT * FROM ProductSale WHERE  CountryID = 2

SELECT * FROM ProductSale WHERE CityID = 2  EXCEPT  SELECT * FROM ProductSale WHERE  CountryID = 2
