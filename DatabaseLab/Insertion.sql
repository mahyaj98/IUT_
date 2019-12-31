INSERT INTO Country(Name, ID) VALUES 
('Iran', '1'),
('USA', '2'),
('Canada', '3'),
('UK', '4')

INSERT INTO City(Name, ID, CountryID) VALUES
('Tehran', '1', '1'),
('Isfahan', '2', '1'),
('NYC', '3', '2'),
('LA', '4', '2'),
('Toronto', '5', '3'),
('Vancouver', '6', '3'),
('London', '7', '4')

INSERT INTO Categories(Name, ID) VALUES
('Gardening', '1'),
('Beauty', '2'),
('Medical', '3')

INSERT INTO Users(FullName, UserName, CountryID, CityID, Descriptions, Phone, Email) VALUES
('Mahya', 'mahya', '1', '1', 'Something abount myself', '09900990', 'asd@asd.asd'),
('Dina', 'dina', '1', '2', 'Something abount myself', '09900980', 'ase@ase.ase'),
('Negar', 'negz', '2', '1', 'Something abount myself', '09900880', 'asn@asn.asn'),
('Fati', 'fati', '2', '2', 'Something abount myself', '09900780', 'asf@asf.asf')

INSERT INTO RequestService(ID, UserName, Descriptions, PostDate, Expiration, isExpired, Price, CountryID, CityID, CategoryID) VALUES
('1', 'mahya', 'Related to service for garden', '11111111', 10, 0, 10000, 1, 1, 1), 
('2', 'dina', 'Related to service for beauty', '11111112', 20, 0, 20000, 1, 2, 2)

INSERT INTO RequestProduct(ID, UserName, Descriptions, PostDate, Expiration, isExpired, Price, CountryID, CityID) VALUES
('1', 'negz', 'Something cool', '11111113', 15, 0, 40000, 2, 1), 
('2', 'dina', 'Something even cooler', '11111114', 25, 0, 30000, 1, 2)

INSERT INTO ProvideService(ID, UserName, Descriptions, PostDate, Expiration, isExpired, Price, CountryID, CityID, CategoryID) VALUES
('1', 'mahya', 'Related to service for garden', '11111111', 10, 0, 10000, 1, 1, 1), 
('2', 'fati', 'Related to service for medical', '11111101', 30, 0, 500000, 2, 2, 3)

INSERT INTO ProductSale(ID, UserName, Descriptions, PostDate, Expiration, isExpired, Price, CountryID, CityID, forBorrow) VALUES
('1', 'fati', 'Something cool to borrow', '11110113', 5, 0, 0006, 2, 1, 1), 
('2', 'dina', 'Something even cooler not to borrow though', '11111104', 3, 0, 70000, 1, 2, 0)