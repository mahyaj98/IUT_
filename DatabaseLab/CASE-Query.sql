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
	
		 
