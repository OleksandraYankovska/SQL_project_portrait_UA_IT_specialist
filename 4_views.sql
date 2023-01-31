-- Creating views to simplify queries

/*

*/

CREATE OR REPLACE VIEW vw_by_Age AS

SELECT pd.gender, j.position_title, j.level, pd.age, count(*) as number_of_people
FROM personal_data pd
JOIN job j USING(id)
GROUP BY pd.gender, j.position_title, j.level, pd.age
ORDER BY pd.gender, j.position_title, j.level, pd.age, count(*) DESC;

/*

*/

CREATE OR REPLACE VIEW vw_by_Location AS

SELECT pd.gender, j.position_title, count(*) AS number_of_people, l.now_country, l.current_location
FROM location l
JOIN personal_data pd USING(id)
JOIN job j USING(id)
    WHERE l.current_location IS NOT NULL OR l.now_country IS NOT NULL 
GROUP BY pd.gender, j.position_title, now_country, current_location
ORDER BY pd.gender, j.position_title, now_country, current_location, count(*) DESC;

/*

*/

CREATE OR REPLACE VIEW vw_english AS

SELECT pd.gender, j.position_title, e.english, COUNT(*) AS total, f.salary
FROM education e
JOIN personal_data pd USING(id)
JOIN job j USING(id)
JOIN finances f USING(id)
GROUP BY pd.gender, j.position_title, e.english, f.salary
ORDER BY pd.gender, j.position_title, total DESC;

/*

*/

CREATE OR REPLACE VIEW vw_emotions AS

SELECT pd.gender, g.emotions_last_week FROM general_data g JOIN personal_data pd USING(ID);

/*

*/

CREATE OR REPLACE VIEW vw_hrs AS

SELECT 
	pd.gender, j.hours_of_work, 
	COUNT(*) AS total
FROM job_related_data j
	JOIN personal_data pd USING(id)
GROUP BY pd.gender, j.hours_of_work
ORDER BY j.hours_of_work, total DESC;
