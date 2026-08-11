use gram_panchayat_db;
SELECT full_name as Citizen_name,ct.certificate_name as Certificate_type 
FROM Citizen c 
INNER JOIN certificate_application ca 
ON c.citizen_id=ca.citizen_id
INNER JOIN certificate_type ct
ON ca.certificate_id = ct.certificate_type_id;

SELECT c.full_name AS Citizen_Name,po.office_name AS Panchayat_Office 
FROM Citizen c 
INNER JOIN certificate_application ca 
ON c.citizen_id = ca.citizen_id 
INNER JOIN panchayat_office po
ON ca.office_id = po.office_id;

SELECT ca.application_id as Application_Id,c.full_name as Citizen_Name,ca.application_status as Application_Status
FROM citizen c
INNER JOIN certificate_application ca
ON c.citizen_id = ca.citizen_id;

SELECT c.full_name as Citizen_Name,ct.certificate_name as Certificae_Type,ca.application_date AS Application_Date
FROM Citizen c 
INNER JOIN certificate_application ca 
ON c.citizen_id = ca.citizen_id
INNER JOIN certificate_type ct 
ON ca.certificate_id=ct.certificate_type_id;

select c.full_name AS Citizen_Name, ct.certificate_name as Certificate_Type,po.office_name AS Panchayat_Office,ca.application_status as Application_Status 
FROM Citizen c 
INNER JOIN certificate_Application ca 
ON c.citizen_id = ca.citizen_id
INNER JOIN certificate_type ct 
ON ca.certificate_id = ct.certificate_type_id
INNER join Panchayat_Office po
ON ca.office_id = po.office_id;

-- LEVEL-2
SELECT c.full_name AS Citizen_Name,ct.certificate_name as Certificate_Name
FROM Citizen c
INNER JOIN Certificate_application ca
ON c.citizen_id = ca.citizen_id
INNER JOIN Certificate_type ct
ON ca.certificate_id = ct.certificate_type_id
INNER JOIN Panchayat_Office po 
ON ca.office_id = po.office_id
WHERE ct.certificate_name='INCOME CERTIFICATE';

SELECT
c.full_name AS Citizen_Name,
ca.application_id,
po.office_name
FROM Citizen c
INNER JOIN Certificate_Application ca
ON c.citizen_id = ca.citizen_id
INNER JOIN Panchayat_Office po
ON ca.office_id = po.office_id
WHERE po.office_name = 'Nuzvid';

SELECT
ca.application_id,
ct.description,
ca.application_status
FROM Certificate_Application ca
INNER JOIN Certificate_Type ct
ON ca.certificate_id = ct.certificate_type_id;

SELECT
c.full_name AS Citizen_Name, c.village_name,
ct.certificate_name AS Certificate_Type,
po.office_name AS Panchayat_Office,
ca.application_date
FROM Citizen c
INNER JOIN Certificate_Application ca
ON c.citizen_id = ca.citizen_id
INNER JOIN Certificate_Type ct
ON ca.certificate_id = ct.certificate_type_id
INNER JOIN Panchayat_Office po
ON ca.office_id = po.office_id;

SELECT c.*, ct.*,po.*,ca.*
FROM Citizen c
INNER JOIN Certificate_Application ca
ON c.citizen_id = ca.citizen_id
INNER JOIN Certificate_Type ct
ON ca.certificate_id = ct.certificate_type_id
INNER JOIN Panchayat_Office po
ON ca.office_id = po.office_id;

-- PART-4
SELECT c.citizen_id, c.full_name,ca.application_id,ca.application_status
FROM Citizen c
LEFT JOIN Certificate_Application ca
ON c.citizen_id = ca.citizen_id;

SELECT ct.certificate_type_id,ct.certificate_name,ca.application_id
FROM Certificate_Application ca
RIGHT JOIN Certificate_Type ct
ON ca.certificate_id = ct.certificate_type_id;

SELECT c.citizen_id,c.full_name,ca.application_id
FROM Citizen c
LEFT JOIN Certificate_Application ca
ON c.citizen_id = ca.citizen_id
UNION
SELECT c.citizen_id,c.full_name,ca.application_id
FROM Citizen c
RIGHT JOIN Certificate_Application ca
ON c.citizen_id = ca.citizen_id;

SELECT c.full_name AS Citizen_Name,ct.certificate_name AS Certificate_Type
FROM Citizen c
CROSS JOIN Certificate_Type ct;

SELECT A.full_name AS Citizen_1, B.full_name AS Citizen_2, A.village_name
FROM Citizen A
INNER JOIN Citizen B
ON A.village_name = B.village_name
AND A.citizen_id < B.citizen_id;