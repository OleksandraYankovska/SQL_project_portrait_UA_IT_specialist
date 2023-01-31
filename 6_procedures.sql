-- PROCEDURES

-- Creating Stored Procedure to get total number of IT specialists by gender in company using input from user 

USE IT2022;
DROP PROCEDURE IF EXISTS get_total_by_company_by_gender;
DELIMITER $$
CREATE PROCEDURE get_total_by_company_by_gender(company VARCHAR(150))
BEGIN
		IF company IS NULL THEN
			SELECT * FROM job_related_data
            LIMIT 1000;
		ELSE 
			SELECT pd.gender, j.company, COUNT(*) AS total
            FROM job_related_data j
            JOIN personal_data pd USING(id)
			WHERE j.company = company 
            GROUP BY pd.gender, j.company
            LIMIT 1000;
		END IF;
END $$
DELIMITER ;

