-- creating database 

DROP DATABASE IF EXISTS IT2022;
CREATE DATABASE IT2022;

USE IT2022;


	-- create table to import data from .json to exsisting table in database IT2022
CREATE TABLE personal_data(
	id INT NOT NULL PRIMARY KEY,
    gender VARCHAR(20),
    age INT,
    marital_status VARCHAR(100),
    children VARCHAR(55)
);

	-- importing data to personal_data table, checking

	-- importing data from .json by creating a new table we get the TEXT Datatype - so let's change this and add a Foreigh Key

ALTER TABLE location MODIFY id INTEGER;
ALTER TABLE location MODIFY before_war VARCHAR(150);
ALTER TABLE location MODIFY current_location VARCHAR(150);
ALTER TABLE location MODIFY now_country VARCHAR(150);
ALTER TABLE location MODIFY moved_or_not VARCHAR(150);
ALTER TABLE location MODIFY city_or_village_now VARCHAR(150);
ALTER TABLE location MODIFY emigration_plans VARCHAR(150);
ALTER TABLE location MODIFY moved_to_region VARCHAR(150);
ALTER TABLE location MODIFY plans_to_come_back VARCHAR(150);
ALTER TABLE location MODIFY moved_to_country VARCHAR(150);
ALTER TABLE location MODIFY work_at VARCHAR(150);
ALTER TABLE location MODIFY plans_to_come_back_to_Ukraine VARCHAR(150);


ALTER TABLE location 
ADD CONSTRAINT 
fk_id 
FOREIGN KEY 
(id) 
REFERENCES 
personal_data 
(id); 

	-- importing another tables, changing the Datatype of existing columns using schema tables settings and then adding FK

ALTER TABLE job 
ADD CONSTRAINT 
fk_id_2
FOREIGN KEY 
(id) 
REFERENCES 
personal_data 
(id);

ALTER TABLE education 
ADD CONSTRAINT 
fk_id_3
FOREIGN KEY 
(id) 
REFERENCES 
personal_data 
(id);

ALTER TABLE finances 
ADD CONSTRAINT 
fk_id_4
FOREIGN KEY 
(id) 
REFERENCES 
personal_data 
(id);

ALTER TABLE job_related_data 
ADD CONSTRAINT 
fk_id_5
FOREIGN KEY 
(id) 
REFERENCES 
personal_data 
(id);

ALTER TABLE general_data
ADD CONSTRAINT 
fk_id_6
FOREIGN KEY 
(id) 
REFERENCES 
personal_data 
(id);

    