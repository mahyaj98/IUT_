CREATE TABLE Country
(
 Name varchar(20) NOT NULL ,
 ID char(5) PRIMARY KEY,
);
(
 Name varchar(20) NOT NULL ,
 ID char(5) PRIMARY KEY,
 CountryID char(5), 
 FOREIGN KEY (CountryID) REFERENCES Country(ID)
);
(
 Name varchar(20) NOT NULL ,
 ID char(5) PRIMARY KEY,
);
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
);
 CityID char(5),
 FOREIGN KEY (CityID) REFERENCES City(ID),
 CityID char(5),
 FOREIGN KEY (CityID) REFERENCES City(ID),
 CityID char(5),
 FOREIGN KEY (CityID) REFERENCES City(ID),
 CityID char(5),
 FOREIGN KEY (CityID) REFERENCES City(ID),