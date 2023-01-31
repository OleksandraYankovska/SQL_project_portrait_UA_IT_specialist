	-- REPORTS

USE IT2022;
/*
1. Intro
	1.1 Total number of IT specialists by gender
	1.2 Total number by position and by gender 
	1.3 Total number by level and by gender

2. Demography 
	2.1 IT specialists by age; the oldest and the youngest person by gender
    2.2 Marital status of IT specialists by gender
    2.2.1 Children of IT specialists
    2.3 Total number of persons staying in Ukraine and the number of people who are abroad, by gender, at the time of the survey
    2.4 Total number of persons staying in Ukraine by region
    2.5 10 countries to which Ukrainian IT specialists moved the most because of the war, by gender
    2.6 Plans to come back to Ukraine / plans to move from Ukraine by gender
    
3. Education
	3.1 Education level by gender
    3.2 Knowledge of English by gender and by position; 

4. Finances
	4.1 The connection between knowledge of English and the level of satisfaction with salary
	4.2 The connection between hours of work per week and the level of satisfaction with salary
	
5. Emotions by gender at the time of the survey

*/


	-- 1.1 Total number of IT specialist by gender

SELECT gender, sum(number_of_people) as num
FROM vw_by_Age
GROUP BY gender;

	-- 1.2 Total number of people in IT by position and by gender 

SELECT 
	gender, position_title, 
	sum(number_of_people) as num
FROM vw_by_Age
WHERE gender = 'Жінка'
GROUP BY gender, position_title
	UNION ALL
SELECT 
	gender, position_title, 
    sum(number_of_people) as num
FROM vw_by_Age
WHERE gender = 'Чоловік'
GROUP BY gender, position_title
ORDER BY gender, num DESC, position_title;

/*
 Conclusion:  
the largest number of female IT specialists work as QA Engineer - 857 of 3544 in total number of women in IT
the largest number of male IT specialists work as Software Engineer - 6949 of 11591 in total number of men in IT
*/

	-- 1.3 Total number of people in IT by level and by gender 
    
SELECT 
	gender, level, 
    sum(number_of_people) as num
FROM vw_by_Age
WHERE gender = 'Жінка'
GROUP BY gender, level
	UNION ALL
SELECT 
	gender, level, 
    sum(number_of_people) as num
FROM vw_by_Age
WHERE gender = 'Чоловік'
GROUP BY gender, level
ORDER BY gender, num DESC, level;

/*
 Conclusion:
the largest number of people by level have Middle position in both gender (women-1352, men-3909)
in second place in terms of the number of people: among women - at the Junior level (770), among men - at the Senior level (3404)
*/


	-- 2.1 Let's find the total number of people by gender and by age and the oldest and the youngest person by gender

SELECT 
	gender, age, 
    sum(number_of_people) as num
FROM vw_by_Age
GROUP BY age, gender
ORDER BY gender, age DESC;

SELECT DISTINCT
(SELECT MAX(age) FROM vw_by_Age WHERE gender LIKE '%чоловік%') as 'Oldest M',
(SELECT MIN(age) FROM vw_by_Age WHERE gender LIKE '%чоловік%') as 'Youngest M',
(SELECT MAX(age)FROM vw_by_Age WHERE gender LIKE '%жінка%') as 'Oldest W',
(SELECT MIN(age) FROM vw_by_Age WHERE gender LIKE '%жінка%') as 'Youngest W'
FROM vw_by_Age vw;


/*
 Conclusion:
the youngest female and male IT specialists are 18 and 16 years old, accordingly, the oldest - 53y.o(woman) and 61y.o(man)
*/


	-- 2.2 Let's find out the marital status by gender 

SELECT 
	marital_status, gender, 
    COUNT(marital_status) as total,
CASE 
	WHEN gender = 'Жінка' 
		THEN CONCAT( ROUND( COUNT(marital_status) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
	ELSE CONCAT( ROUND( COUNT(marital_status) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
END AS percentage_of_all
FROM personal_data
GROUP BY marital_status, gender
ORDER BY gender, percentage_of_all DESC;


/*
 Conclusion:
782 women (22,07%) and 2,683 men (23,15%) are single
2,762 women and 8,908 men are in relationships/married/living in a de facto marriage
*/

	-- 2.2.1 IT specialists with/without children

SELECT 
	pd.gender, 
	IF(children = 'Так', 'Є діти', 'Нема дітей') AS status,
    COUNT(*) as total,
CASE 
	WHEN gender = 'Жінка' 
		THEN CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
	ELSE CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
END AS percentage_of_all
FROM personal_data pd
GROUP BY gender, status
ORDER BY total DESC, gender;

/*
 Conclusion:
The number of women who have children - 659(18,59%), who does not - 2885(81,41%)
The number of men who have children - 3445(29,72%), who does not - 8146(70,28%)

*/


	-- 2.3 Creating a report on the total number of persons staying in Ukraine
	-- and the number of people who are abroad, by gender, at the time of the survey

SELECT 
	vw.gender, 
	IF(now_country != 'Україна', 'Abroad', 'Ukraine') AS status,
    SUM(number_of_people) as total,
CASE 
	WHEN gender = 'Жінка' 
		THEN CONCAT( ROUND( SUM(number_of_people) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
	ELSE CONCAT( ROUND( SUM(number_of_people) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
END AS percentage_of_all
FROM vw_by_Location vw
GROUP BY gender, status;


SELECT 
	count(*) AS no_location 
FROM location 
WHERE current_location IS NULL AND now_country IS NULL;

/*
 Conclusion:
number of men abroad - 1021(8,81%), women - 860;(24,27%) 
number of men staying in Ukraine - 10496(90,32%), women - 2667(75,25%)

118 persons does not have this information entered
*/

	-- 2.4 Let's see the situation of locations in Ukraine

SELECT 
	gender, now_country, current_location, 
	SUBSTRING_INDEX(current_location, " ", 1) AS cities, 
	SUM(number_of_people) as total,
CASE 
	WHEN gender = 'Жінка' 
		THEN CONCAT( ROUND( SUM(number_of_people) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
	ELSE CONCAT( ROUND( SUM(number_of_people) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
END AS percentage_of_all
FROM vw_by_location vw
WHERE current_location IS NOT NULL -- current_location after cleaning represent region in Ukraine
	GROUP BY gender, now_country, current_location, cities
	ORDER BY gender, total DESC;

/*
 Conclusion:
By both gender the largest number of people are in Kyiv (778 of women - 21,95%, 3111 of men - 26,84%) 
and in Lviv(18,03%; 19,11%); 
*/

	-- 2.5 Find 10 countries to which Ukrainian IT specialists moved the most because of the war, by gender
    
SELECT 
	gender, now_country, 
    MAX(total) AS max_num,
CASE 
	WHEN gender = 'Жінка' 
		THEN CONCAT( ROUND( MAX(total) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
	ELSE CONCAT( ROUND( MAX(total) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
END AS percentage_of_all
FROM(
	SELECT vw.gender, vw.now_country, sum(number_of_people) as total
	FROM vw_by_location vw 
    WHERE vw.now_country != 'Україна'
	GROUP BY vw.gender, vw.now_country
) AS summary 
	GROUP BY gender, now_country
	ORDER BY max_num DESC, now_country
LIMIT 20;


/*
 Conclusion:
By both gender the largest number of people are in Poland(269 of men and 262 of women), 
Germany, Spain, Chech Republich, Portugal
 */
 
	-- 2.6 Plans to come back to Ukraine / plans to move from Ukraine
    
SELECT 
	pd.gender, 
    l.plans_to_come_back_to_Ukraine,
    COUNT(*) as total
FROM location l
	JOIN personal_data pd USING(id)
WHERE plans_to_come_back_to_Ukraine IS NOT NULL 
AND plans_to_come_back_to_Ukraine != ""
	GROUP BY gender, plans_to_come_back_to_Ukraine
	ORDER BY gender, plans_to_come_back_to_Ukraine, total DESC;


SELECT 
	pd.gender, 
    l.emigration_plans,
    COUNT(*) as total
FROM location l
	JOIN personal_data pd USING(id)
WHERE emigration_plans IS NOT NULL 
AND emigration_plans != ""
	GROUP BY gender, emigration_plans
	ORDER BY total DESC, emigration_plans, gender;

/*
 Conclusion:
The majority of IT specialists of both gender of those who went abroad plan to return to Ukraine soon or 
as soon as it becomes safe in their region or after our Victory (567 of 860 women abroad, 572 among of 1021 men abroad) 


However the numbers about emigration plans of Ukrainian IT specialists are not so good. 
- 2483 men and 471 women are thinking about emigrating, but they are not doing anything yet
- 1203 men and 169 women are actively preparing to leave (among 2667 women and 10469 men staying in Ukraine)
So we see the posibility that 3686 men - 35% of men and 640 women - 24% of women staying in Ukraine are going to move abroad
*/


	-- 3.1 Education level by gender

SELECT 
	pd.gender, 
     e.education,
	COUNT(*) as total, 
CASE 
	WHEN gender = 'Жінка' 
		THEN CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
	ELSE CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
END AS percentage_of_all
FROM education e
	JOIN personal_data pd USING(id)
GROUP BY gender, education
ORDER BY gender, education, total DESC;

/*
 Conclusion:
By both gender the largest number of people have 1 / 2 degree as a specialist, bachelor's degree, master's degree 
- 2689 (80,95%) / 372 (10,5%) of women
- 9092 (78,44%) / 839 (7,24%) of men
 */


	-- 3.2 Knowledge of English by gender; 

SELECT 
	gender, 
	english, 
    SUM(total) AS total_eng,
CASE 
	WHEN gender = 'Жінка' 
		THEN CONCAT( ROUND( SUM(total) *100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
	ELSE CONCAT( ROUND( SUM(total) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
END AS percentage_of_all
FROM vw_english
GROUP BY gender, english
ORDER BY gender, total_eng DESC;


	-- 4.1 The connection between knowledge of English and the level of satisfaction with salary
    
SELECT 
	gender, english, 
    SUM(total) AS people,
CASE
	WHEN salary = 'Абсолютно незадоволений(-а)' THEN '2.No'
		ELSE '1.Yes / More likely yes than no'
END AS satisfaction
FROM vw_english 
GROUP BY gender, english, satisfaction
ORDER BY gender, satisfaction, people DESC, english;


/* 
 Conclusion:
Among 3544 of women in IT the majority - 1431 persons (40,38%) have Upper-Intermediate level 
(1212 of them satisfied with the level of wages and only 219 of them are not satisfied) 

Among 11591 of men in IT the majority - 4550 persons (39,25%) have Upper-Intermediate level as well 
(4086 of them satisfied with the level of wages, while 464 - not) 

 */


	-- 4.2 Hours of work per week by gender / 
    -- The connection between hours of work per week and the level of satisfaction with salary

SELECT *,
	CASE 
		WHEN gender = 'Жінка' 
			THEN CONCAT( ROUND( total * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
		ELSE CONCAT( ROUND( total * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
	END AS percentage_of_all
FROM vw_hrs
GROUP BY gender, hours_of_work
ORDER BY gender, total DESC ;


/* 
 Conclusion:
The majority of IT specialists work for 35-45 hours per week (63,86% of men and 67,13% of women)
Less than 20 hours per week work 346 (2,99%) men and 116 (3,27%) women 
More than 60 hours per week work 239 (2,06%) men and 25 (0,71%) women 

 */

SELECT 
	pd.gender, j.hours_of_work, 
    COUNT(*) AS people,
CASE 
	WHEN pd.gender = 'Жінка' 
		THEN CONCAT( ROUND( COUNT(*) * 100 / (SELECT vw.total FROM vw_hrs vw WHERE gender = 'Жінка' 
        AND j.hours_of_work = vw.hours_of_work),2), '%')
	ELSE CONCAT( ROUND( COUNT(*) * 100 / (SELECT vw.total FROM vw_hrs vw WHERE gender = 'Чоловік' 
    AND j.hours_of_work = vw.hours_of_work),2), '%')
END AS percentage_of_all,
f.salary
FROM personal_data pd 
JOIN finances f USING (ID)
JOIN job_related_data j USING (ID)
GROUP BY pd.gender, f.salary, j.hours_of_work
ORDER BY pd.gender, j.hours_of_work DESC, people DESC;

/* 
 Conclusion:
The majority of IT specialists who work for 35-45 hours per week are satisfied/most likely satisfied with salary
	 - WOMEN : 30,31% / 54,14% and 
					15,55 % who are not satisfied 
	 - MEN : 32,95% / 55,5% and
				   11,55% who are not satisfied
 
 
Among people who work less than 20 hours per week 
	-- satisfied/most likely satisfied with salary 
		- WOMEN: 18,97% / 49,14 %; 
					31,9% who are not satisfied
        - MEN: 25,43 % / 48,55%;
					26,01% who are not satisfied
                    
Among people who work more than 60 hours per week 
	-- satisfied/most likely satisfied with salary
		- WOMEN: 20% / 64% and 
					16% who are not satisfied
        - MEN: 25,36% / 51.88% and 
					21,76 % who are not satisfied

 */
 
	-- 5. Emotions_last_week

SELECT 'Втома' as emotions, gender, COUNT(*) AS total,
	CASE 
		WHEN gender = 'Жінка' 
			THEN CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
		ELSE CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
	END AS percentage_of_all
FROM vw_emotions 
WHERE MATCH(emotions_last_week) AGAINST ('втому')
	GROUP BY gender
		
        UNION ALL 
SELECT 'Тривога' as emotions, gender, COUNT(*) AS total,
	CASE 
		WHEN gender = 'Жінка' 
			THEN CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
		ELSE CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
	END AS percentage_of_all
FROM vw_emotions 
WHERE MATCH(emotions_last_week) AGAINST ('тривогу')
	GROUP BY gender
		
        UNION ALL
SELECT 'Надія' as emotions, gender, COUNT(*) AS total,
	CASE 
		WHEN gender = 'Жінка' 
			THEN CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
		ELSE CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
	END AS percentage_of_all
FROM vw_emotions 
WHERE MATCH(emotions_last_week) AGAINST ('надію')
	GROUP BY gender
		
        UNION ALL
SELECT 'Оптимізм' as emotions, gender, COUNT(*) AS total,
CASE 
	WHEN gender = 'Жінка' 
		THEN CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Жінка'),2), '%')
	ELSE CONCAT( ROUND( COUNT(*) * 100 / (SELECT COUNT(*) FROM personal_data pd WHERE gender = 'Чоловік'),2), '%')
END AS percentage_of_all
FROM vw_emotions 
WHERE MATCH(emotions_last_week) AGAINST ('оптимізм')
GROUP BY gender

/*
Conclusion:
What IT specialists feel the most often:
-втома (56,26 % of men, 64,76% of women)
-тривога (44,75% of men, 59,25% of women)
-надія (45,39% of men, 48,34% of women)
-оптимізм (40,60% of men, 29,23% of women)

*/

