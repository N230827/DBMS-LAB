use gram_panchayat_db;
DELIMITER //
CREATE PROCEDURE welcome_panchayat()
BEGIN 
SELECT "Welcome to Gram Panchayat Certificate System";
END//
DELIMITER ;
CALL welcome_panchayat;

DELIMITER //

CREATE PROCEDURE get_citizen_name(IN p_citizen_id INT)
BEGIN
    SELECT full_name
    FROM Citizen
    WHERE citizen_id = p_citizen_id;
END //
DELIMITER ;
CALL get_citizen_name(102);

DELIMITER //
CREATE PROCEDURE get_application_status(IN p_application_id INT)
BEGIN 
SELECT application_id,application_status
FROM certificate_application 
WHERE application_id = p_application_id;
END//
DELIMITER ;
CALL get_application_status(1004);
select * from certificate_application;

-- level 0
DELIMITER //

CREATE PROCEDURE display_citizen(IN p_citizen_id INT)
BEGIN
    SELECT citizen_id,full_name
    FROM Citizen
    WHERE citizen_id = p_citizen_id;
    SELECT p_citizen_id AS citizen_id,
           p_full_name AS full_name;
END //
DELIMITER ;
drop procedure display_citizen;
CALL display_citizen(106);


DELIMITER //
CREATE PROCEDURE citizen_details(IN p_citizen_id INT)
BEGIN 
SELECT citizen_id,full_name,mobile_number,village_name 
FROM citizen
WHERE citizen_id=p_citizen_id;
END//
DELIMITER ;
CALL citizen_details(101);

DELIMITER //
CREATE PROCEDURE check_application_status(IN p_status VARCHAR(30))
BEGIN 
IF p_status = 'Approved' THEN 
SELECT 'Certificate Approved' AS message;
ELSEIF p_status ='Pending' THEN 
SELECT 'Application under Process' AS message;
ELSEIF p_status ='Rejected' THEN 
SELECT 'Application Rejected' AS message;
ELSE
SELECT 'Unknown Status' AS message;
END IF;
END //
DELIMITER ;
CALL check_application_status('Approved');
DELIMITER //

CREATE FUNCTION get_application_status(p_application_id INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
DECLARE v_status VARCHAR(30);
SELECT application_status
INTO v_status
FROM Certificate_Application
WHERE application_id = p_application_id;
RETURN v_status;
END //
DELIMITER ;
CALL get_application_status(777);

DELIMITER //

CREATE PROCEDURE display_numbers()
BEGIN
DECLARE v_count INT DEFAULT 1;
count_loop: LOOP
SELECT v_count AS number;
SET v_count = v_count + 1;
IF v_count > 5 THEN
LEAVE count_loop;
END IF;
END LOOP;
END //
DELIMITER ;
CALL display_numbers;
DELIMITER // 
 
 CREATE PROCEDURE classify_application (IN p_application_id INT)
 BEGIN 
 DECLARE v_status VARCHAR(15);
 SELECT application_status INTO v_status
 FROM certificate_application
 WHERE application_id=p_application_id;
IF v_status='Approved' THEN
SELECT 'CERTIFICATE_READY' AS message;
ELSEIF v_status='Pending' THEN
SELECT 'Under Verification' AS message;
ELSEIF v_status='Rejected' THEN
SELECT 'APPLICATION_REJECTED' AS message;
ELSE SELECT 'NO STATUS FOUND' AS message;
END IF;
END //
DELIMITER ;
drop procedure classify_application;
CALL classify_application(777);

DELIMITER //
CREATE FUNCTION citizen_application_count(p_citizen_id INT)
RETURNS INT 
DETERMINISTIC 
BEGIN 
DECLARE V_count INT;
SELECT count(*) 
INTO v_count
FROM certificate_application
WHERE citizen_id=p_citizen_id;
RETURN v_count;
END // 
DELIMITER ;
SELECT c.full_name,
citizen_application_count(c.citizen_id) AS number_of_applications
FROM Citizen c
WHERE citizen_id=1;

DELIMITER // 
 
CREATE PROCEDURE display_pending_applications() 
BEGIN 
    DECLARE done INT DEFAULT FALSE; 
    DECLARE v_application_id INT; 
    DECLARE v_status VARCHAR(30);
    DECLARE v_citizen_id INT;
    DECLARE application_cursor CURSOR FOR 
        SELECT application_id,citizen_id,application_status
        FROM Certificate_Application 
        WHERE application_status = 'Pending'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND 
        SET done = TRUE; 
    OPEN application_cursor; 
 
    read_loop: LOOP 
 
        FETCH application_cursor 
        INTO v_application_id, v_citizen_id,v_status; 
 
        IF done THEN 
            LEAVE read_loop; 
        END IF; 
 
       SELECT v_application_id AS application_id,
               v_citizen_id AS citizen_id,
               v_status AS application_status;

 
    END LOOP; 
 
    CLOSE application_cursor; 
 
END // 
DELIMITER ;
CALL display_pending_applications();


DELIMITER //
CREATE PROCEDURE find_application(IN p_application_id INT)
BEGIN
    DECLARE v_status VARCHAR(30);
    DECLARE v_not_found BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_not_found = TRUE;
    SELECT application_status
    INTO v_status
    FROM Certificate_Application
    WHERE application_id = p_application_id;
    IF v_not_found THEN
        SELECT 'Application not found' AS message;
    ELSE
        SELECT p_application_id AS application_id,
               v_status AS application_status;
    END IF;
END //

DELIMITER ;
drop procedure find_application;
CALL find_application(1004);
