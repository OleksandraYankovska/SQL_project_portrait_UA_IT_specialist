	-- INDEXING

USE IT2022;
	-- check out TYPE and ROWS from explain result to see how many rows mysql has to check to get the result.

EXPLAIN(
	SELECT * FROM personal_data 
	WHERE gender ='Жінка'
);

CREATE INDEX idx_gender ON personal_data(gender);

CREATE INDEX idx_age ON personal_data(age);

EXPLAIN(
	SELECT * FROM job 
	WHERE position_title='SysAdmin'
);

CREATE INDEX idx_position_title ON job(position_title);

CREATE INDEX idx_level ON job(level);

	ANALYZE TABLE job;
	SHOW INDEXES IN job;

CREATE INDEX idx_english ON education(english);

CREATE INDEX idx_company ON job_related_data(company);


	-- Create full text index to search for certain emotion in 'emotions_last_week' column since each row contains a list of emotions

CREATE FULLTEXT INDEX idx_emotions ON general_data(emotions_last_week);

	ANALYZE TABLE general_data;
	SHOW INDEXES IN general_data;
    

	-- checking if it works better 
EXPLAIN SELECT * FROM general_data WHERE MATCH(emotions_last_week) AGAINST ('злість спокій');
EXPLAIN SELECT * FROM general_data WHERE emotions_last_week LIKE '%злість%' OR emotions_last_week LIKE '%спокій%';


CREATE FULLTEXT INDEX idx_field ON job_related_data(field);
CREATE FULLTEXT INDEX idx_salary_changes ON finances(salary_changes);


	-- Create composite index to speed up the search when creating 
	-- a report on the number of people in each region in Ukraine
	-- a report on the number of people in each country 

CREATE INDEX idx_country_location ON location(now_country,current_location);

	ANALYZE TABLE location;
	SHOW INDEXES IN location;
