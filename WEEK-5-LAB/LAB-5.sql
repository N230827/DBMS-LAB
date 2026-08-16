use gram_panchayat_db;
select * from citizen;
select * from certificate_application;
select * from certificate_type;
select * from panchayat_office;

INSERT INTO certificate_application
(application_id, citizen_id, application_date, purpose, application_status,
 fee_paid, reference_number, issued_date, certificate_id, office_id)
VALUES
(1007, 101, '2026-07-07', 'Income certificate requirement', 'Submitted',
 35.00, 'GP20260007', NULL, 7, 2),
(1008, 102, '2026-07-06', 'Income certificate application', 'Approved',
 45.00, 'GP20260008', '2026-07-10', 7, 3),
(1009, 103, '2026-07-05', 'Residence proof requirement', 'Under Review',
 30.00, 'GP20260009', NULL, 3, 1),
(1010, 104, '2026-07-4', 'Scholarship application', 'Submitted',
 40.00, 'GP20260010', NULL, 4, 3),
(1011, 105, '2026-07-3', 'Employment documentation', 'Approved',
 25.00, 'GP20260011', '2026-07-13', 5, 1),
(1012, 106, '2026-07-2', 'Personal documentation', 'Rejected',
 20.00, 'GP20260012', NULL, 6, 2);
 
 -- AGGREGATE FUNCTIONS
 SELECT COUNT(*) AS total_certificate_applications
FROM certificate_application;
SELECT COUNT(*) AS total_citizens
FROM citizen;
SELECT COUNT(DISTINCT certificate_id) AS different_certificate_types
FROM certificate_application;
SELECT MIN(application_date) AS earliest_application_date
FROM certificate_application;
SELECT MAX(application_date) AS latest_application_date
FROM certificate_application;

-- LEVEL-2
SELECT application_status, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY application_status;

SELECT certificate_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id;

SELECT office_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY office_id;

SELECT village_name, COUNT(*) AS total_citizens
FROM citizen
GROUP BY village_name;

SELECT application_date,COUNT(*) AS total_applications
FROM certificate_application 
GROUP BY application_date;

SELECT certificate_id, office_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id, office_id;

SELECT ct.certificate_name, COUNT(*) AS total_applications
FROM certificate_application ca
JOIN certificate_type ct
ON ca.certificate_id = ct.certificate_type_id
GROUP BY ct.certificate_type_id, ct.certificate_name;

SELECT po.office_name, COUNT(*) AS total_applications
FROM certificate_application ca
JOIN panchayat_office po
ON ca.office_id = po.office_id
GROUP BY po.office_id, po.office_name;

-- LEVEL-3
SELECT certificate_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id
HAVING COUNT(*) > 2;

SELECT office_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY office_id
HAVING COUNT(*) > 2;

SELECT certificate_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id
ORDER BY count(*) DESC;

SELECT office_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY office_id
ORDER BY total_applications ASC;

SELECT certificate_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id
HAVING COUNT(*) > 2
ORDER BY total_applications DESC;

SELECT certificate_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id
HAVING COUNT(*) > 2
ORDER BY total_applications DESC;

SELECT certificate_id, office_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id, office_id
ORDER BY total_applications DESC
LIMIT 1;

SELECT application_status, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY application_status
ORDER BY total_applications DESC
LIMIT 1;

SELECT application_status,COUNT(*) AS total_applications
FROM certificate_application 
GROUP BY application_status
ORDER BY total_applications ASC 
LIMIT 1;

-- OPTIONAL
SELECT certificate_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id
ORDER BY total_applications DESC
LIMIT 1;

SELECT office_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY office_id
ORDER BY total_applications DESC
LIMIT 1;

SELECT application_status, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY application_status
ORDER BY total_applications DESC
LIMIT 1;

SELECT certificate_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id
HAVING COUNT(*) > 2;

SELECT office_id, COUNT(*) AS total_applications
FROM certificate_application
GROUP BY office_id
HAVING COUNT(*) > 2;

SELECT 
    c.certificate_name AS certificate_type,
    COUNT(ca.application_id) AS number_of_applications,
    MIN(ca.application_date) AS earliest_application_date,
    MAX(ca.application_date) AS latest_application_date
FROM certificate_application ca
JOIN certificate_type c
    ON ca.certificate_id = c.certificate_type_id
GROUP BY c.certificate_type_id, c.certificate_name;

SELECT 
    po.office_name AS panchayat_office,
    COUNT(ca.application_id) AS total_applications,
    COUNT(DISTINCT ca.certificate_id) AS different_certificate_types
FROM certificate_application ca
JOIN panchayat_office po
    ON ca.office_id = po.office_id
GROUP BY po.office_id, po.office_name;