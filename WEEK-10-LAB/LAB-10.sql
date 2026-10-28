use gram_panchayat_db;
-- TASK-1
DELIMITER //
CREATE FUNCTION classify_status(p_status VARCHAR(30))
RETURNS VARCHAR(30)
DETERMINISTIC 
BEGIN 
	DECLARE v_category VARCHAR(30);
    
    IF p_status = "Approved" THEN
      SET v_category ='Certficate Ready';
	
	ELSEIF p_status='Pending' THEN 
      SET v_category='Under processing';
	
    ELSEIF p_status='Rejected' THEN 
      SET v_category='Application closed';
	
    ELSE set v_category = 'Unknown status';
    END IF;
    RETURN v_category;
END//
DELIMITER ;
SELECT classify_status('Rejected') AS result;

-- LEVEL -1 
DELIMITER //
CREATE PROCEDURE citizen_application_summary(IN p_citizen_id int)
BEGIN 
IF NOT EXISTS (
		SELECT 1 FROM citizen where citizen_id= p_citizen_id
        )
        THEN SELECT 'citizen not found' AS message ;
ELSE SELECT c.full_name AS citizen_name,
COUNT(ca.certificate_id) AS total_applications,
SUM(CASE 
		WHEN ca.application_status='Approved'
        THEN 1 ELSE 0
END) AS approved_applications,
SUM(CASE
		WHEN ca.application_status = 'Pending'
        THEN 1 ELSE 0 
END) AS pending_applications,
SUM(CASE 
		WHEN ca.application_status='Rejected'
        THEN 1 ELSE 0
END) AS rejected_applications
FROM citizen c
LEFT JOIN certificate_application ca
ON c.citizen_id=ca.citizen_id
WHERE c.citizen_id=p_citizen_id
GROUP BY c.citizen_id,c.full_name;
END IF;
END //
DELIMITER ;

DROP PROCEDURE citizen_application_summary;
CALL citizen_application_summary(106);

DELIMITER //
CREATE FUNCTION get_certificate_type(p_type_id INT)
RETURNS VARCHAR(30)
deterministic 
BEGIN 
	DECLARE v_type_name VARCHAR(30);
    SELECT certificate_name INTO v_type_name
    FROM certificate_type WHERE certificate_type_id=p_type_id
	LIMIT 1;
    RETURN v_type_name;
END //
DELIMITER ;
SELECT
    ca.certificate_id AS application_id,
    ca.citizen_id,
    get_certificate_type(ct.certificate_type_id)
        AS certificate_type,
    ca.application_status
FROM Certificate_Application ca
JOIN Certificate_Type ct
ON ct.certificate_type_id = ca.certificate_id;

DELIMITER //
CREATE PROCEDURE classify_application(
    IN p_application_id INT
)
BEGIN
    DECLARE v_status VARCHAR(30) DEFAULT NULL;
    DECLARE v_found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_found = 0;

    SELECT application_status
    INTO v_status
    FROM Certificate_Application
    WHERE certificate_id = p_application_id;
    IF v_found = 0 THEN
        SELECT 'Application not found' AS message;
    ELSEIF v_status = 'Approved' THEN
        SELECT 'Certificate Ready for Collection' AS message;
    ELSEIF v_status = 'Pending' THEN
        SELECT 'Application Under Verification' AS message;
    ELSEIF v_status = 'Rejected' THEN
        SELECT 'Application Closed' AS message;
    ELSE
        SELECT 'Unknown Status' AS message;
    END IF;
END //
DELIMITER ;
CALL classify_application(1008);

-- LEVEL 2
DELIMITER //
CREATE PROCEDURE pending_application_report()
BEGIN 
	DECLARE v_done INT DEFAULT 0;
    DECLARE v_app_id INT ;
    DECLARE v_name VARCHAR(50);
    DECLARE v_type VARCHAR(50);
    DECLARE v_status VARCHAR(50);
    DECLARE v_date DATE;
    DECLARE app_cursor CURSOR FOR
			SELECT ca.certificate_id,c.full_name,ct.certificate_name,ca.application_status,ca.application_date
            FROM certificate_application ca
            JOIN citizen c
            ON ca.citizen_id=c.citizen_id
            JOIN certificate_type ct
            ON ca.certificate_id=ct.certificate_type_id
            WHERE ca.application_status='Pending';
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
			SET v_done = 1;
	OPEN app_cursor;
    read_loop:LOOP
		FETCH app_cursor
        INTO v_app_id,v_name,v_type,v_status,v_date;
        IF v_done=1 then 
        LEAVE read_loop;
        END IF;
        SELECT v_app_id AS application_id,
			   v_name AS citizen_name,
               v_type AS certificate_type,
               v_status as application_status,
               v_date AS application_date;
	END LOOP;
    CLOSE app_cursor;
END //
DELIMITER ;
CALL pending_application_report();


DELIMITER //

CREATE PROCEDURE all_application_categories()
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(100);
    DECLARE v_type VARCHAR(100);
    DECLARE v_status VARCHAR(30);
    DECLARE v_category VARCHAR(30);

    DECLARE app_cursor CURSOR FOR
        SELECT ca.certificate_id, c.full_name,
               ct.certificate_name, ca.application_status
        FROM Certificate_Application ca
        JOIN Citizen c
        ON ca.citizen_id = c.citizen_id
        JOIN Certificate_Type ct
		ON ca.certificate_id = ct.certificate_type_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;
    OPEN app_cursor;
    read_loop: LOOP
        FETCH app_cursor
        INTO v_id, v_name, v_type, v_status;
        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;
        IF v_status = 'Approved' THEN
            SET v_category = 'Completed';
        ELSEIF v_status = 'Pending' THEN
            SET v_category = 'In Progress';
        ELSEIF v_status = 'Rejected' THEN
            SET v_category = 'Closed';
        ELSE SET v_category = 'Unknown';
        END IF;
        SELECT v_id AS application_id,
               v_name AS citizen_name,
               v_type AS certificate_type,
               v_status AS application_status,
               v_category AS processing_category;
    END LOOP;
    CLOSE app_cursor;
END //
DELIMITER ;


DELIMITER //

CREATE PROCEDURE update_application_status(
    IN p_application_id INT,
    IN p_new_status VARCHAR(30)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Certificate_Application
        WHERE certificate_id = p_application_id
    ) THEN
        SELECT 'Application not found' AS message;
    ELSEIF p_new_status NOT IN
        ('Approved', 'Pending', 'Rejected') THEN
        SELECT 'Invalid application status' AS message;
    ELSE
        UPDATE Certificate_Application
        SET application_status = p_new_status
        WHERE certificate_id = p_application_id;
        SELECT *
        FROM Certificate_Application
        WHERE application_id = p_application_id;
    END IF;
END //
DELIMITER ;
CALL update_application_status(1003, 'Approved');


DELIMITER //

CREATE PROCEDURE application_details_safe(
    IN p_application_id INT
)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_type VARCHAR(100);
    DECLARE v_status VARCHAR(30);
    DECLARE v_found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_found = 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'A database error occurred' AS message;
    END;

    SELECT c.full_name, ct.certificate_name,
           ca.application_status
    INTO v_name, v_type, v_status
    FROM Certificate_Application ca
    JOIN Citizen c
	ON ca.citizen_id = c.citizen_id
    JOIN Certificate_Type ct
	ON ca.certificate_id = ct.certificate_type_id
    WHERE ca.application_id = p_application_id;
    IF v_found = 0 THEN
        SELECT 'Application not found' AS message;
    ELSE
        SELECT v_name AS citizen_name,
               v_type AS certificate_type,
               v_status AS application_status;
    END IF;
END //
DELIMITER ;

CALL application_details_safe(1001);

-- LEVEL 3

DELIMITER //

CREATE PROCEDURE process_certificate_application(
    IN p_application_id INT
)
BEGIN
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(100);
    DECLARE v_type VARCHAR(100);
    DECLARE v_status VARCHAR(30);
    DECLARE v_date DATE;
    DECLARE v_remarks VARCHAR(500);
    DECLARE v_category VARCHAR(50);
    DECLARE v_processing VARCHAR(50);
    DECLARE v_found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_found = 0;

    SELECT ca.certificate_id, c.full_name,
           ct.certificate_name, ca.application_status,
           ca.application_date, ca.remarks
    INTO v_id, v_name, v_type, v_status,
         v_date, v_remarks
    FROM Certificate_Application ca
    JOIN Citizen c
	ON ca.citizen_id = c.citizen_id
    JOIN Certificate_Type ct
	ON ca.certificate_id = ct.certificate_type_id
    WHERE ca.application_id = p_application_id;
    IF v_found = 0 THEN
        SELECT 'Application not found' AS message;
    ELSE
		IF v_status = 'Approved' THEN
            SET v_category = 'Certificate Ready';
            SET v_processing = 'No further processing';
        ELSEIF v_status = 'Pending' THEN
            SET v_category = 'Under Processing';
            SET v_processing = 'Further Verification Required';
        ELSEIF v_status = 'Rejected' THEN
            SET v_category = 'Application Closed';
            SET v_processing = 'No further processing';
        ELSE
            SET v_category = 'Unknown Status';
            SET v_processing = 'Status needs review';
        END IF;

        SELECT
            'CERTIFICATE APPLICATION REPORT' AS report_title,
            v_id AS application_id,
            v_name AS citizen_name,
            v_type AS certificate_type,
            v_status AS application_status,
            v_category AS processing_category,
            v_processing AS processing_requirement,
            v_date AS application_date,
            v_remarks AS remarks;
    END IF;
END //
DELIMITER ;
CALL process_certificate_application(1003);


DELIMITER //

CREATE PROCEDURE citizen_cursor_report()
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(100);
    DECLARE v_total INT;
    DECLARE v_approved INT;
    DECLARE v_pending INT;
    DECLARE v_rejected INT;

    DECLARE citizen_cursor CURSOR FOR
        SELECT citizen_id, full_name
        FROM Citizen
        WHERE citizen_id IN (
            SELECT DISTINCT citizen_id
            FROM Certificate_Application
        );

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    OPEN citizen_cursor;
    read_loop: LOOP
        FETCH citizen_cursor INTO v_id, v_name;
        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;
        SELECT
            COUNT(*),
            COALESCE(SUM(application_status = 'Approved'), 0),
            COALESCE(SUM(application_status = 'Pending'), 0),
            COALESCE(SUM(application_status = 'Rejected'), 0)
        INTO v_total, v_approved, v_pending, v_rejected
        FROM Certificate_Application
        WHERE citizen_id = v_id;
        SELECT v_id AS citizen_id,
               v_name AS citizen_name,
               v_total AS total_applications,
               v_approved AS approved_applications,
               v_pending AS pending_applications,
               v_rejected AS rejected_applications;
    END LOOP;
    CLOSE citizen_cursor;
END //
DELIMITER ;
CALL citizen_cursor_report();


DELIMITER //

CREATE FUNCTION get_application_count(
    p_citizen_id INT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*)
    INTO v_count
    FROM Certificate_Application
    WHERE citizen_id = p_citizen_id;
    RETURN v_count;
END //

CREATE PROCEDURE citizen_category_report()
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(100);
    DECLARE v_count INT;
    DECLARE v_category VARCHAR(30);

    DECLARE citizen_cursor CURSOR FOR
        SELECT citizen_id, full_name
        FROM Citizen;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    OPEN citizen_cursor;
    read_loop: LOOP
        FETCH citizen_cursor INTO v_id, v_name;
        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;

        SET v_count = get_application_count(v_id);
        IF v_count = 0 THEN
            SET v_category = 'No Application';
        ELSEIF v_count <= 2 THEN
            SET v_category = 'Regular Applicant';
        ELSE
            SET v_category = 'Frequent Applicant';
        END IF;
        SELECT v_id AS citizen_id,
               v_name AS citizen_name,
               v_count AS application_count,
               v_category AS application_category;
    END LOOP;
    CLOSE citizen_cursor;
END //
DELIMITER ;
CALL citizen_category_report();

-- CHALLENGE


USE gram_panchayat_db;

DELIMITER //

CREATE PROCEDURE panchayat_processing_report()
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_app_id INT;
    DECLARE v_name VARCHAR(100);
    DECLARE v_type VARCHAR(100);
    DECLARE v_status VARCHAR(30);
    DECLARE v_category VARCHAR(30);

    DECLARE v_total INT DEFAULT 0;
    DECLARE v_approved INT DEFAULT 0;
    DECLARE v_pending INT DEFAULT 0;
    DECLARE v_rejected INT DEFAULT 0;

    DECLARE app_cursor CURSOR FOR
        SELECT ca.certificate_id,
               c.full_name,
               ct.certificate_name,
               ca.application_status
        FROM Certificate_Application ca
        JOIN Citizen c
		ON ca.citizen_id = c.citizen_id
        JOIN Certificate_Type ct
		ON ca.certificate_id = ct.certificate_type_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'A database error occurred' AS message;
    END;

    OPEN app_cursor;
    read_loop: LOOP
        FETCH app_cursor
        INTO v_app_id, v_name, v_type, v_status;

        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;

        SET v_total = v_total + 1;

        IF v_status = 'Approved' THEN
            SET v_category = 'Completed';
            SET v_approved = v_approved + 1;

        ELSEIF v_status = 'Pending' THEN
            SET v_category = 'In Progress';
            SET v_pending = v_pending + 1;
        ELSEIF v_status = 'Rejected' THEN
            SET v_category = 'Closed';
            SET v_rejected = v_rejected + 1;
        ELSE
            SET v_category = 'Unknown';
        END IF;
        SELECT
            v_app_id AS application_id,
            v_name AS citizen_name,
            v_type AS certificate_type,
            v_status AS application_status,
            v_category AS processing_category;
    END LOOP;

    CLOSE app_cursor;
    SELECT
        v_total AS total_applications_processed,
        v_approved AS total_approved_applications,
        v_pending AS total_pending_applications,
        v_rejected AS total_rejected_applications;
END //
DELIMITER ;
CALL panchayat_processing_report();