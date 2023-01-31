	-- CLEANING DATA

USE IT2022;

	-- the main information that we need are about gender and position title
    
	-- checking if every row in dataset has a gender 
SELECT * FROM personal_data 
WHERE gender IS NULL OR (gender != 'Чоловік' and gender!='Жінка');
	-- 0 row(s) returned 

	-- checking if every row in database has a position_title 
SELECT * FROM job 
WHERE position_title IS NULL;
	-- 0 row(s) returned 


	-- STANDARDIZING

	-- checking if the age are in the correct range
SELECT *
FROM personal_data
WHERE age NOT BETWEEN 1 AND 100;
	-- 0 row(s) returned 
    

	-- checking if the location in the first column was entered correctly
SELECT DISTINCT before_war
FROM location
ORDER BY before_war;

	-- we get 26 rows, however there are incorrect data ' чи область' - we need to see if it will affect our report 
    -- which are not useful while creating report about location of people before the war
    
SHOW VARIABLES like 'autocommit';
SET autocommit = 0;

START TRANSACTION;
UPDATE location
	SET before_war = NULL
WHERE before_war = ' чи область';
COMMIT;

	-- obviously the "current_location" column was originally asking about the region in Ukraine -
    -- 'Де живуть зараз - області' 
	-- since the next column asking about current country - 'Де живуть зараз - країни'
    -- so we need to check if there are correct data in both columns

SELECT DISTINCT(current_location)
FROM location;

	-- we get 70 rows which are more than we expecting, let's see if the column current_location might have a rows 
	-- that duplicate data from next column - 'now_country' 

SELECT *
FROM location l1
JOIN location l2
	ON l1.id=l2.id
WHERE 
	l1.current_location=l2.now_country;

		
	-- we get 1999 rows where column 'current_location' has duplicate value about country 
	-- which are supposed to be only in the next column - 'now_country' 
		-- (including a few NULL values in both columns)


	-- now let's check if there are rows where values in these two columns are different


SELECT DISTINCT l3.now_country -- all unique values from column about countries - 44 ROWS
FROM location l3
	UNION
SELECT DISTINCT l1.current_location -- all unique values thar are duplicate of each other in two columns - 43 ROWS
FROM location l1
JOIN location l2
	ON l1.id=l2.id
WHERE 
	l1.current_location=l2.now_country;

	-- by union we get 44 rows that are equal to all unique values from column about countries 
    -- (43 foreign countries + Ukraine)
    
	-- now we need to remove incorrect values from 'current_location' so that they only appear in the 'now_country' column

START TRANSACTION;
UPDATE location
	SET current_location = NULL
WHERE now_country!='Україна';

SELECT* 
FROM location;

COMMIT;

	-- let's see what else we could clean up to get correct results 
    
SELECT DISTINCT current_location -- '0'
FROM location;

SELECT current_location, id
FROM location
WHERE current_location='0';
	-- 19 rows
    
START TRANSACTION;
UPDATE location
	SET current_location = NULL
WHERE current_location = '0';
COMMIT;


SELECT DISTINCT now_country -- 'N/A', '0', ''
FROM location;

START TRANSACTION;
UPDATE location
	SET now_country = NULL 
    WHERE now_country = '0' OR now_country = '#N/A' OR now_country = '';
COMMIT;


SELECT DISTINCT now_country 
FROM location;

	-- it is look like we have duplicate data in distinct values, let's check if it could be extra space 

SELECT DISTINCT now_country 
FROM location 
WHERE now_country='США ' OR now_country='США';

	-- we see that it is extra space on several countries so let's remove first and last space(s) of column 
    
START TRANSACTION;
UPDATE location SET now_country = TRIM(now_country);
COMMIT;


	-- now let's check all tables to see distinct values in each column to know if those columns need to be cleansed

START TRANSACTION;
UPDATE location
SET current_location = 'Ужгород чи Закарпатська область' 
WHERE current_location = 'Ужгород чи область';

COMMIT;

UPDATE location
SET current_location = 'Луцьк чи Волинська область'
WHERE current_location = 'Луцьк чи область';
COMMIT;

	-- all columns are clean

SET autocommit = 1;