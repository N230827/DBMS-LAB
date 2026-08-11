use gram_panchayat_db;
show tables ;
select * from citizen;
select * from certificate_application;
select * from certificate_type;
select * from panchayat_office;
ALTER TABLE certificate_application DROP COLUMN certificate_name;
ALTER TABLE certificate_application ADD certificate_id INT;
ALTER TABLE certificate_application ADD office_id INT; 
UPDATE certificate_application set certificate_id = 1, office_id=1 where citizen_id=101;
UPDATE certificate_application set certificate_id = 2, office_id=1 where citizen_id=102;
UPDATE certificate_application set certificate_id = 3, office_id=2 where citizen_id=103;
UPDATE certificate_application set certificate_id = 4, office_id=3 where citizen_id=104;
UPDATE certificate_application set certificate_id = 5, office_id=4 where citizen_id=105;
UPDATE certificate_application set certificate_id = 6, office_id=5 where citizen_id=106;

-- ACTIVITY-4 FOREIGN KEY CONSTRAINTS 
ALTER TABLE certificate_application ADD CONSTRAINT fk_citizen FOREIGN KEY (citizen_id) REFERENCES citizen(citizen_id);
ALTER TABLE certificate_application ADD CONSTRAINT fk_certificate FOREIGN KEY (certificate_id) REFERENCES certificate_type(certificate_type_id);
ALTER TABLE certificate_application ADD CONSTRAINT fk_office FOREIGN KEY (office_id) REFERENCES panchayat_office(office_id);

show create table certificate_application;
-- ACTIVITY-6 TESTING F_KEYS
INSERT INTO certificate_application(application_id,citizen_id,application_date,purpose,application_status,fee_paid,reference_number,certificate_id,office_id) values (1007,999,'2026-07-27',"MIGRATION",'Pending',30,"GP2026000009",6,6);
INSERT INTO certificate_application (certificate_id)values(11) ;
DELETE FROM citizen where citizen_id=101;

-- DISPLAY RECORDS
SELECT * FROM citizen;
SELECT * FROM certificate_application;
SELECT full_name from citizen order by full_name ASC;
SELECT DISTINCT village_name From citizen;
SELECT DISTINCT office_name from panchayat_office;
SELECT * FROM certificate_application WHERE application_status='pending';
SELECT * FROM citizen where village_name='Ramapuram';
SELECT * FROM certificate_application where year(application_date)=2026; 
SELECT * FROM certificate_application order by application_date desc;
select * from cert ificate_application where office_id IN (SELECT office_id from panchayat_office where office_name='Lakshmipuram Gram Panchayat'); -- IN MANUAL WE HAVE NUZVID HERE
SELECT full_name from citizen where citizen_id IN (select citizen_id from  certificate_application where certificate__type_id =(7));

-- SET OPERATIONS
SELECT full_name
FROM Citizen
WHERE citizen_id IN (
    SELECT citizen_id
    FROM Certificate_Application
    WHERE certificate_id = (
        SELECT certificate_type_id
        FROM Certificate_Type
        WHERE certificate_name = 'Income Certificate'
    )
)
UNION 
SELECT full_name
FROM Citizen
WHERE citizen_id IN (
    SELECT citizen_id
    FROM Certificate_Application
    WHERE certificate_id = (
        SELECT certificate_type_id
        FROM Certificate_Type
        WHERE certificate_name = 'Residence Certificate'
    )
); 
SELECT *
FROM Certificate_Application
WHERE MONTH(application_date) = 1
UNION
SELECT *
FROM Certificate_Application
WHERE MONTH(application_date) = 2;

SELECT citizen_id
FROM Certificate_Application
WHERE certificate_id = 1
AND citizen_id IN (
    SELECT citizen_id
    FROM Certificate_Application
    WHERE certificate_id = 2
);

SELECT citizen_id
FROM Certificate_Application
WHERE YEAR(application_date) = 2025
AND citizen_id IN (
    SELECT citizen_id
    FROM Certificate_Application
    WHERE YEAR(application_date) = 2026
);

SELECT citizen_id
FROM Certificate_Application
WHERE certificate_id = (
    SELECT certificate_id
    FROM Certificate_Type
    WHERE certificate_name = 'Income Certificate'
)
AND citizen_id NOT IN (
    SELECT citizen_id
    FROM Certificate_Application
    WHERE certificate_id = (
        SELECT certificate_id
        FROM Certificate_Type
        WHERE certificate_name = 'Residence Certificate'
    )
);
SELECT application_id
FROM Certificate_Application
WHERE YEAR(application_date) = 2026
  AND application_id NOT IN (
      SELECT application_id
      FROM Certificate_Application
      WHERE YEAR(application_date) = 2025
  );
  
INSERT INTO certificate_application 
(citizen_id, application_id, office_id, application_date,purpose, application_status)
VALUES
(9999, 1001, 1, '2026-08-03'," ",'Pending');

DELETE FROM Citizen
WHERE citizen_id = 101;

-- 22. Write a short note on Foreign Key Constraints.
-- Answer:
-- Foreign Key constraints maintain referential integrity between related tables. They ensure that values in a child table correspond to valid records in the parent table. They prevent invalid data from being inserted. They can also prevent deletion of parent records that are referenced by child records. Thus, Foreign Keys help maintain data consistency.

SELECT full_name
FROM Citizen
WHERE citizen_id IN
(
    SELECT citizen_id
    FROM Certificate_Application
);

SELECT * FROM Citizen
WHERE village_name IN
(
    SELECT village_name
    FROM Citizen
    WHERE citizen_id IN
    (
        SELECT citizen_id
        FROM Certificate_Application
        WHERE certificate_id IN
        (
            SELECT certificate_id
            FROM Certificate_Type
            WHERE certificate_name = 'Income Certificate'
        )
    )
);

SELECT full_name FROM Citizen
WHERE citizen_id NOT IN
(
    SELECT citizen_id
    FROM Certificate_Application
);

SELECT office_name
FROM Panchayat_Office
WHERE office_id NOT IN
(
    SELECT office_id
    FROM Certificate_Application
);
SELECT * FROM Citizen c
WHERE EXISTS
(
    SELECT *
    FROM Certificate_Application ca
    WHERE ca.citizen_id = c.citizen_id
);
SELECT *
FROM certificate_type
WHERE EXISTS
(
    SELECT *
    FROM Certificate_Application
    WHERE Certificate_Application.certificate_id = Certificate_Type.certificate_type_id
);
SELECT *
FROM Citizen
WHERE NOT EXISTS
(
    SELECT *
    FROM Certificate_Application
    WHERE Certificate_Application.citizen_id = Citizen.citizen_id
);
SELECT *
FROM Certificate_Type
WHERE NOT EXISTS
(
    SELECT *
    FROM Certificate_Application
    WHERE Certificate_Application.certificate_id = Certificate_Type.certificate_type_id
);
SELECT *
FROM Citizen
WHERE date_of_birth > ANY
(
    SELECT date_of_birth
    FROM Citizen
    WHERE village_name = 'Ramapuram'
);

SELECT *
FROM Certificate_type
WHERE processing_days > ANY
(
    SELECT processing_days
    FROM certificate_type
    WHERE office_id IN
    (
        SELECT office_id
        FROM panchayat_office
        WHERE office_name = 'Ramapuram Gram Panchayat'
    )
);

SELECT full_name, 
       TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM Citizen
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) > ALL
(
    SELECT TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())
    FROM Citizen
    WHERE village_name = 'Ramapuram'
);
ALTER TABLE Certificate_Type
ADD COLUMN office_id INT,
ADD CONSTRAINT fk_cert_office
    FOREIGN KEY (office_id) REFERENCES Panchayat_Office(office_id);

SELECT *
FROM Certificate_type
WHERE office_id IN (
    SELECT office_id
    FROM Panchayat_Office
    WHERE office_name = 'Ramapuram Gram Panchayat'
)
AND processing_days >= ALL (
    SELECT processing_days
    FROM Certificate_type
    WHERE office_id IN (
        SELECT office_id
        FROM Panchayat_Office
        WHERE office_name = 'Ramapuram Gram Panchayat'
    )
);

-- MINI CHALLENGES
SELECT citizen_id, COUNT(*) AS total_applications
FROM Certificate_Application
GROUP BY citizen_id
ORDER BY total_applications DESC
LIMIT 1;

SELECT office_id, COUNT(*) AS total_applications
FROM Certificate_Application
GROUP BY office_id
ORDER BY total_applications DESC
LIMIT 1;

SELECT certificate_id, COUNT(*) AS total_applications
FROM Certificate_Application
GROUP BY certificate_id
HAVING COUNT(*) > 5;

SELECT DISTINCT village_name
FROM Citizen
WHERE village_name NOT IN
(
    SELECT village_name
    FROM Citizen
    WHERE citizen_id IN
    (
        SELECT citizen_id
        FROM Certificate_Application
    )
);

SELECT full_name
FROM Citizen
WHERE citizen_id IN
(
    SELECT citizen_id
    FROM Certificate_Application
    WHERE application_status = 'Approved'
);