USE myschool; 

/* 1. Select f_name, l_name of students, group by student_id */

SELECT f_name, l_name, student_id
FROM students
ORDER BY student_id; 

/* 2 Select f_name, l_name, dob and order by last name. */

SELECT f_name, l_name, DATE_FORMAT(dob, '%M %d, %Y') AS "Birthday"
FROM students
ORDER BY l_name;

/*  3. Select average base fee in each school with 2 decimal */

SELECT school_name, format(avg(base_fee),2) AS average_fee
FROM schools s
JOIN grade_levels g
ON s.school_id = g.school_id
GROUP BY school_name
HAVING average_fee > 4;   


/* 4. Write a query displaying the parent name, amount paid where the dob is greater than march 21 2017 */

SELECT parent_name, amt_paid, dob
FROM parents p
JOIN students s
ON p.parent_id = s.parent_id
WHERE dob > 2017-03-21;

/* 4.5 Show how much each parent owes, how much they have paid, and how much is still due */
CREATE OR REPLACE VIEW where_is_my_money AS
SELECT p.parent_id, p.parent_name, sg.student_id, sg.grade_level_id, amt_paid, 
registration_fee, grade, (base_fee + monthly_fee) AS monthly,
CASE 
	WHEN DATEDIFF(end_date, start_date) IS NOT NULL
		THEN ROUND(DATEDIFF(end_date, start_date) / 30, 0)
	WHEN DATEDIFF(end_date, start_date) IS NULL
		THEN ROUND(DATEDIFF(NOW(), start_date) / 30, 0)
END AS num_months
	FROM parents p
		JOIN students st
			ON p.parent_id = st.parent_id
		JOIN students_grade_levels sg
			ON st.student_id = sg.student_id
		JOIN grade_levels g
			ON g.grade_level_id = sg.grade_level_id
		JOIN schools sc
			ON sc.school_id = g.school_id;

CREATE OR REPLACE VIEW there_is_my_money AS
SELECT parent_name, amt_paid, SUM(monthly * num_months) AS outstanding_fee
FROM where_is_my_money
GROUP BY parent_name, amt_paid;

SELECT parent_name, outstanding_fee - amt_paid AS amt_owed
FROM there_is_my_money;

/* 5. Update */

 -- Create store procedue to update states --
DROP PROCEDURE IF EXISTS update_states; 
DELIMITER //

CREATE PROCEDURE  update_states
(
	IN old_state VARCHAR(25),
    IN new_state VARCHAR(25)
)

BEGIN 

DECLARE sql_error TINYINT DEFAULT FALSE;

DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	SET sql_error = TRUE;
    
    
START TRANSACTION; 

	UPDATE states
    SET state_name = new_state
    WHERE state_name = old_state;

-- error handling

	IF sql_error THEN
		ROLLBACK;
		SELECT 'ERROR: State cannot be updated';
	else
		COMMIT;
		SELECT 'State updated successfully ';
	END IF;
END // 

CALL update_states ('GURAGON' , 'GURUGRAM');//

SELECT state_name FROM states;//


/* 6. Delete */

 -- Create store procedue to delete registration fee --
 

DROP PROCEDURE IF EXISTS delete_fee; 
DELIMITER //

CREATE PROCEDURE delete_fee
(
	IN fname_param VARCHAR(25),
    IN lname_param VARCHAR(25)
)

BEGIN 

DECLARE sql_error TINYINT DEFAULT FALSE;

DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	SET sql_error = TRUE;
    
    
START TRANSACTION;

	DELETE FROM students_grade_levels
    WHERE student_id = (SELECT student_id
						FROM students
                        WHERE f_name = fname_param AND l_name = lname_param);

	DELETE FROM students
    WHERE f_name = fname_param AND l_name = lname_param;

-- error handling

	IF sql_error THEN
		ROLLBACK;
		SELECT 'ERROR: Student can not be deleted';
	else
		COMMIT;
		SELECT 'Student deleted ';
	END IF;
END // 

CALL delete_fee ("Moses","Manual");//

SELECT f_name, l_name FROM students;//



