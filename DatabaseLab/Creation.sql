CREATE TABLE Country
(
 Name varchar(20) NOT NULL ,
 ID char(5) PRIMARY KEY,
);CREATE TABLE City
(
 Name varchar(20) NOT NULL ,
 ID char(5) PRIMARY KEY,
 CountryID char(5), 
 FOREIGN KEY (CountryID) REFERENCES Country(ID)
);CREATE TABLE Categories
(
 Name varchar(20) NOT NULL ,
 ID char(5) PRIMARY KEY,
);CREATE TABLE Users
(
 FullName varchar(20) NOT NULL ,
 UserName char(5) PRIMARY KEY,
 CountryID char(5), 
 CityID char(5),
 Descriptions varchar(100), 
 Phone varchar(15) NOT NULL,
 Email varchar(20) NOT NULL,
 FOREIGN KEY (CountryID) REFERENCES Country(ID),
 FOREIGN KEY (CityID) REFERENCES City(ID)
);CREATE TABLE RequestProduct( ID char(5) PRIMARY KEY,  UserName char(5), Descriptions varchar(100) NOT NULL,  PostDate char(10) NOT NULL,  Expiration int,  isExpired int NOT NULL,  Price int,  CountryID char(5), 
 CityID char(5), FOREIGN KEY (CountryID) REFERENCES Country(ID),
 FOREIGN KEY (CityID) REFERENCES City(ID), FOREIGN KEY (UserName) REFERENCES Users(UserName));CREATE TABLE RequestService( ID char(5) PRIMARY KEY,  UserName char(5), Descriptions varchar(100) NOT NULL,  PostDate char(10) NOT NULL,  Expiration int,  isExpired int CHECK (isExpired in (0,1)) NOT NULL, Price int,  CountryID char(5), 
 CityID char(5), CategoryID char(5), FOREIGN KEY (CategoryID) REFERENCES Categories(ID), FOREIGN KEY (CountryID) REFERENCES Country(ID),
 FOREIGN KEY (CityID) REFERENCES City(ID), FOREIGN KEY (UserName) REFERENCES Users(UserName));CREATE TABLE ProvideService( ID char(5) PRIMARY KEY,  UserName char(5), Descriptions varchar(100) NOT NULL,  PostDate char(10) NOT NULL,  Expiration int,  isExpired int CHECK (isExpired in (0,1)) NOT NULL, Price int,  CountryID char(5), 
 CityID char(5), CategoryID char(5), FOREIGN KEY (CategoryID) REFERENCES Categories(ID), FOREIGN KEY (CountryID) REFERENCES Country(ID),
 FOREIGN KEY (CityID) REFERENCES City(ID), FOREIGN KEY (UserName) REFERENCES Users(UserName));CREATE TABLE ProductSale( ID char(5) PRIMARY KEY,  UserName char(5), Descriptions varchar(100) NOT NULL,  PostDate char(10) NOT NULL,  Expiration int,  isExpired int CHECK (isExpired in (0,1)) NOT NULL, Price int,  CountryID char(5), 
 CityID char(5), forBorrow int CHECK (forBorrow in (0,1)), FOREIGN KEY (CountryID) REFERENCES Country(ID),
 FOREIGN KEY (CityID) REFERENCES City(ID), FOREIGN KEY (UserName) REFERENCES Users(UserName));