use gram_panchayat_db;
SELECT * FROM certificate_application;
SET AUTOCOMMIT = 0; 
SELECT @@AUTOCOMMIT;
-- PART-B

START transaction;
ALTER TABLE certificate_application ADD remarks VARCHAR(100);
COMMIT;

START TRANSACTION;
UPDATE certificate_application 
SET application_status = 'Approved',
	remarks='Approved after verification'
WHERE application_id=1003;
COMMIT;

START TRANSACTION;
UPDATE certificate_application
SET application_status='Under Review',
	remarks='still in process'
where application_id=1003;
ROLLBACK;

START TRANSACTION;
SET sql_mode='';
INSERT INTO certificate_application(application_id,citizen_id,application_status,remarks)VALUES(1000,107,'Pending','Test Application');
rollback;

START TRANSACTION;
DELETE FROM certificate_application
WHERE application_id=1005;
ROLLBACK;-- VERIFY ALSO

START TRANSACTION;
UPDATE Certificate_Application
SET application_status = 'REJECTED',
    remarks = 'Rejected due to issues'
WHERE application_id = 1002;
INSERT INTO Certificate_Application
(application_id, citizen_id,application_status, remarks)
VALUES
(999, 102,'Pending', 'New test application');
SELECT *
FROM Certificate_Application
WHERE application_id IN (1002, 999);
COMMIT;
SELECT *
FROM Certificate_Application
WHERE application_id IN (1002,999 );

-- PART-C
START TRANSACTION;
UPDATE certificate_application
SET remarks='Document is under review'
WHERE application_id=1001;
SAVEPOINT remark_update;
select * from certificate_application;
UPDATE certificate_application
SET  issued_date=CURDATE()
WHERE application_id=1001;
ROLLBACK to SAVEPOINT remark_update;

START TRANSACTION;
INSERT INTO citizen(citizen_id,full_name) VALUES(1,'GOD');
SAVEPOINT citizen_update;
select  * from citizen;
UPDATE certificate_application
SET  issued_date=CURDATE()
WHERE application_id=1002;
SELECT * FROM certificate_application;
ROLLBACK to SAVEPOINT citizen_update;
COMMIT;

START TRANSACTION ;
UPDATE certificate_application 
SET remarks='work in progress'
WHERE application_id=1006;
SAVEPOINT first_savepoint;
UPDATE citizen 
SET mobile_number = 1234567890
where citizen_id = 3;
SAVEPOINT second_savepoint;
UPDATE citizen 
set occupation ='Electrician'
where citizen_id=1;
ROLLBACK TO SAVEPOINT first_savepoint;
COMMIT;

START TRANSACTION;
UPDATE citizen
set village_name='Heaven'
where citizen_id = 1;
SAVEPOINT god;
DELETE FROM certificate_application where application_id=999;
ROLLBACK TO SAVEPOINT god;
COMMIT;

START TRANSACTION;
UPDATE CERTIFICATE_APPLICATION
SET application_status='Rejected'
WHERE application_id=999;
SAVEPOINT UPDATED;
RELEASE SAVEPOINT UPDATED;
ROLLBACK TO SAVEPOINT UPDATED; -- DOES NOT EXIST
COMMIT;

START TRANSACTION;
UPDATE CERTIFICATE_APPLICATION
SET REMARKS='TEST APPLICATION'
WHERE APPLICATION_ID=999;
SAVEPOINT first_change;
UPDATE CERTIFICATE_APPLICATION
SET REMARKS='FLAG FOR REVIEW'
WHERE APPLICATION_ID=1001;
ROLLBACK TO SAVEPOINT first_change;
SELECT APPLICATION_ID,APPLICATION_STATUS FROM CERTIFICATE_APPLICATION WHERE APPLICATION_ID IN (999,1001);
COMMIT;

-- PART D
DROP USER IF EXISTS 'clerk'@'localhost';
CREATE USER 'clerk'@'localhost'
IDENTIFIED BY 'Clerk@123';
SELECT USER,Host
FROM mysql.user 
WHERE user = 'clerk';
GRANT SELECT ON gram_panchayat_db.approved_applications TO 'clerk'@'localhost';
GRANT INSERT ON gram_panchayat_db.certificate_application to 'clerk'@'localhost';
SELECT CURRENT_USER();
SELECT User,Host
FROM mysql.user;
DROP USER IF EXISTS 'clerk'@'localhost';
CREATE USER 'clerk'@'localhost'
IDENTIFIED BY 'Clerk@123';
SELECT User,Host
FROM mysql.user WHERE User ='clerk';
ALTER USER 'clerk'@'localhost'
IDENTIFIED BY 'H@123';
FLUSH PRIVILEGES;

GRANT SELECT ON gram_panchayat_db.certificate_application TO 'clerk'@'localhost';
SHOW GRANTS FOR 'clerk'@'localhost';

GRANT INSERT ON gram_panchayat_db.certificate_application TO 'clerk'@'localHost';
SHOW GRANTS FOR 'clerk'@'localhost';
INSERT INTO certificate_application(application_id,citizen_id,certificate_id,application_status)VALUES (777,106,5,'Pending');

UPDATE certification_application 
SET application_status='Approved'
WHERE application_id=1003;

GRANT SELECT ON gram_panchayat_db.approved_applications TO 'clerk'@'localhost';
SHOW GRANTS FOR 'clerk'@'localhost';
SELECT * FROM gram_panchayat_db.approved_applications;

REVOKE INSERT ON gram_panchayat_db.certificate_application FROM 'clerk'@'localhost';
SHOW GRANTS FOR 'clerk'@'localhost';
INSERT INTO certificate_application (application_id,citizen_id,certificate_id,application_status) VALUES (789,105,4,'Test Application');

-- PART E
REVOKE ALL PRIVILEGES, GRANT OPTION
FROM 'clerk'@'localhost';
GRANT SELECT,INSERT ON gram_panchayat_db.certificate_application
TO 'clerk'@'localhost';
SHOW GRANTS FOR 'clerk'@'localhost';
-- testing grants
SELECT * FROM gram_panchayat_db.certificate_application;
INSERT INTO gram_panchayat_db.certificate_application(application_id,citizen_id,certificate_id,application_status,reference_number)VALUES (777,103,4,'TEST APPLICATION',78653421);
UPDATE gram_panchayat_db.certificate_application 
SET application_status='YET TO DECLARE'
WHERE application_id=1003;
DELETE FROM gram_panchayat_db.certificate_application
WHERE application_id=1003;

DROP USER IF EXISTS 'officer1'@'localhost';
CREATE USER 'officer1'@'localhost'
IDENTIFIED BY 'Officer@123';
ALTER USER 'officer1'@'localhost'
IDENTIFIED BY 'OFF@123';
GRANT SELECT,INSERT,UPDATE ON gram_panchayat_db.certificate_application
TO 'officer1'@'localhost';
SHOW GRANTS FOR 'officer1'@'localhost';
-- tests as officer 1
SELECT current_user();
REVOKE all privileges,GRANT OPTION FROM 'officer1'@'localhost';

-- PART F
START TRANSACTION;
SET sql_mode =" " ;
INSERT INTO Certificate_Application
(application_id, citizen_id, certificate_id, application_status,reference_number) VALUES (777, 104, 3, 'TEST APPLICATION',9564321);
SELECT * FROM Certificate_Application WHERE application_id =777;
COMMIT;
SELECT * FROM Certificate_Application WHERE application_id = 777; -- VERIFY

START TRANSACTION;

UPDATE Certificate_Application
SET application_status = 'Rejected',
    remarks = 'Incorrectly rejected'
WHERE application_id = 777;
SELECT application_id, application_status, remarks
FROM Certificate_Application
WHERE application_id = 777;
ROLLBACK;
SELECT application_id, application_status, remarks
FROM Certificate_Application
WHERE application_id = 777;

START TRANSACTION;
UPDATE Certificate_Application
SET application_status = 'Approved'
WHERE application_id = 777;
SAVEPOINT valid_update;
UPDATE Certificate_Application
SET application_status = 'Rejected'
WHERE application_id = 999;
ROLLBACK TO SAVEPOINT valid_update;
SELECT application_id, application_status
FROM Certificate_Application
WHERE application_id IN (777, 999);
COMMIT;

DROP USER IF EXISTS 'clerk2'@'localhost';
CREATE USER 'clerk2'@'localhost'
IDENTIFIED BY 'Clerk@123';
GRANT SELECT, INSERT
ON gram_panchayat_db.Certificate_Application
TO 'clerk2'@'localhost';
SHOW GRANTS FOR 'clerk2'@'localhost';

REVOKE ALL PRIVILEGES ON gram_panchayat_db.Certificate_Application FROM 'clerk2'@'localhost';
GRANT SELECT
ON gram_panchayat_db.Approved_Applications
TO 'clerk2'@'localhost';

GRANT DELETE
ON gram_panchayat_db.Certificate_Application
TO 'officer1'@'localhost'; -- GIVING
REVOKE DELETE -- REMOVING
ON gram_panchayat_db.Certificate_Application
FROM 'officer1'@'localhost';
SHOW GRANTS FOR 'officer1'@'localhost';


GRANT SELECT ON gram_panchayat_db.Approved_Applications TO 'officer1'@'localhost';