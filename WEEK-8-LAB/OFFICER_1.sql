USE gram_panchayat_db;
SELECT CURRENT_USER();
GRANT SELECT,INSERT,UPDATE ON gram_panchayat_db.certificate_application
TO 'officer1'@'localhost';
SHOW GRANTS FOR 'officer1'@'localhost';
-- TESTING GRANTS
SELECT * FROM gram_panchayat_db.Certificate_Application;
UPDATE gram_panchayat_db.Certificate_Application
SET application_status = 'Approved'
WHERE application_id = 1002;
DELETE FROM gram_panchayat_db.Certificate_Application
WHERE application_id = 777;
GRANT SELECT ON gram_panchayat_db.Approved_Applications TO 'officer1'@'localhost';
SHOW GRANTS FOR 'officer1'@'localhost';
REVOKE GRANT OPTION FROM 'officer1'@'localhost' ;
GRANT DELETE
ON gram_panchayat_db.Certificate_Application
TO 'officer1'@'localhost';
SHOW GRANTS FOR 'officer1'@'localhost';
REVOKE DELETE
ON gram_panchayat_db.Certificate_Application
FROM 'officer1'@'localhost';
SHOW GRANTS FOR 'officer1'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION
FROM 'clerk1'@'localhost';

GRANT SELECT, INSERT
ON gram_panchayat_db.Certificate_Application
TO 'clerk1'@'localhost';

SHOW GRANTS FOR 'clerk1'@'localhost';