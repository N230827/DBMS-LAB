USE gram_panchayat_db;
SELECT current_user();
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

