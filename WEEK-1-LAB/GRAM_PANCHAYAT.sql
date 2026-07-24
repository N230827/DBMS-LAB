create database gram_panchayat_db;
USE gram_panchayat_db;
-- TABLE CREATIONS
create table Citizen (citizen_id INT PRIMARY KEY,full_name VARCHAR (100) NOT NULL,date_of_birth DATE NOT NULL, gender VARCHAR (10) NOT NULL,mobile_number VARCHAR(15) UNIQUE NOT NULL,occupation varchar(50),village_name varchar(50) NOT NULL,is_active BOOLEAN NOT NULL);

CREATE TABLE Certificate_Type( certificate_type_id INT PRIMARY KEY,certificate_name VARCHAR(100) UNIQUE NOT NULL,description varchar(200) NOT NULL,processing_days INT NOT NULL,application_fee DECIMAL(8,2) NOT NULL,is_available BOOLEAN NOT NULL);

CREATE TABLE Certificate_Apllication(application_id INT PRIMARY KEY,citizen_id INT NOT NULL,certificate_name VARCHAR(100) NOT NULL,application_date date not null,purpose VARCHAR(200) NOT NULL,application_status VARCHAR(30) NOT NULL,fee_paid DECIMAL(8,2) NOT null,reference_number VARCHAR(30) UNIQUE NOT NULL);

CREATE TABLE Panchayat_Office(office_id INT PRIMARY KEY,office_name VARCHAR(100) NOT NULL,village_name varchar(50) NOT NULL,pincode varchar(6)NOT NULL,contact_number VARCHAR(15) UNIQUE,office_email varchar(100) unique,opening_time TIME NOT NULL,is_operational BOOLEAN NOT NULL);

-- INSERTING DATA 
INSERT INTO Citizen (citizen_id,full_name,date_of_birth,gender,mobile_number,occupation,village_name,is_active) VALUES (101,'Ravi Kumar','1995-06-15','Male','9876500001','Farmer','Ramapuram',True),(102,'Lakshmi Devi','1988-11-22','Female','9876500002','Tailor','Ramapuram',True),(103,'Suresh Babu','1992-03-10','Male','9876500003','Shopkeeper','Seethampeta',True),(104,'Anjali Rao','2000-08-05','Female','9876500004','Student','Ramapuram',True),(105,'Kiran Kumar','1985-01-18','Male','9876500005','Electrician','Seethampeta',True),('106','Meena Kumari','1998-12-30','Female','9876500006','Teacher','Lakshmipuram',False);
SELECT * FROM Citizen;

INSERT INTO Certificate_Type
(certificate_type_id, certificate_name, description, processing_days, application_fee, is_available) VALUES (1,'Residence Certificate','Certifies the declared place of residence',7,30.00,TRUE),(2,'Birth Record Request','Request for a locally maintained birth record',5,20.00,TRUE),(3,'Death Record Request','Request for a locally maintained death record',5,20.00,TRUE),(4,'Family Member Certificate','Records declared family-member information',10,40.00,TRUE),(5,'Property Certificate','Certificate related to locally maintained property records',15,50.00,TRUE),(6,'No-Dues Certificate','Indicates applicable local dues status',7,25.00,FALSE);
SELECT * FROM Certificate_type;

INSERT INTO  Certificate_Apllication(application_id, citizen_id, certificate_name, application_date, purpose, application_status, fee_paid, reference_number) VALUES (1001,101,'Residence Certificate','2026-07-01','Bank account documentation','Submitted',30.00,'GP20260001'),(1002,102,'Family Member Certificate','2026-07-02','Welfare scheme application','Under Review',40.00,'GP20260002'),(1003,103,'Property Certificate','2026-07-03','Property documentation','Submitted',50.00,'GP20260003'),(1004,104,'Residence Certificate','2026-07-04','College admission','Approved',30.00,'GP20260004'),(1005,105,'No-Dues Certificate','2026-07-05','Local service requirement','Under Review',25.00,'GP20260005'),(1006,106,'Birth Record Request','2026-07-06','Personal documentation','Rejected',20.00,'GP20260006');
RENAME TABLE Certificate_Apllication to Certificate_Application;
SELECT * FROM Certificate_Application;

INSERT INTO Panchayat_Office (office_id, office_name, village_name, pincode, contact_number, office_email, opening_time, is_operational) 
VALUES (1,'Ramapuram Gram Panchayat','Ramapuram','521101','0866000001','ramapuram@gp.example','09:00:00',TRUE),(2,'Seethampeta Gram Panchayat','Seethampeta','521102','0866000002','seethampeta@gp.example','09:30:00',TRUE),(3,'Lakshmipuram Gram Panchayat','Lakshmipuram','521103','0866000003','lakshmipuram@gp.example','09:00:00',TRUE),(4,'Krishnapuram Gram Panchayat','Krishnapuram','521104','0866000004','krishnapuram@gp.example','10:00:00',TRUE),(5,'Venkatapuram Gram Panchayat','Venkatapuram','521105','0866000005','venkatapuram@gp.example','09:30:00',TRUE),(6,'Gopalapuram Gram Panchayat','Gopalapuram','521106','0866000006','gopalapuram@gp.example','09:00:00',FALSE);
SELECT * FROM Panchayat_Office;

-- DML COMMANDS
INSERT INTO Citizen (citizen_id, full_name, date_of_birth, gender, mobile_number, occupation, village_name, is_active) VALUES (107,'SREE','2000-01-10','Female','9876500007','Engineer','Lakshmipuram',TRUE);

INSERT INTO Certificate_Type (certificate_type_id, certificate_name, description, processing_days, application_fee, is_available) VALUES (7,'Income Certificate','Certificate for citizen income',10,35.00,TRUE);

UPDATE Certificate_Application 
SET application_status='Under Review' 
WHERE application_id=1001;

UPDATE Certificate_Application 
SET application_status='Approved' 
WHERE application_id=1002;

UPDATE Citizen 
SET occupation='Electrical Technician' 
WHERE citizen_id=105;

UPDATE Certificate_Type 
SET processing_days=12 
WHERE certificate_name='Property Certificate';

UPDATE Certificate_Type 
SET is_available=TRUE 
WHERE certificate_name='No-Dues Certificate';

DELETE FROM Citizen WHERE citizen_id=107;

-- DDL COMMANDS
ALTER TABLE Citizen
ADD address VARCHAR(200);

ALTER TABLE Certificate_Application
ADD issued_date DATE;

ALTER TABLE Certificate_Application
MODIFY purpose VARCHAR(500) NOT NULL;

ALTER TABLE Panchayat_Office
ADD closing_time TIME;

-- TRUNCATE AND DROP

CREATE TABLE Temporary_Request (request_id INT PRIMARY KEY,request_name VARCHAR(100) NOT NULL,request_date DATE NOT NULL);
INSERT INTO Temporary_Request(request_id, request_name, request_date) VALUES (1, 'Residence Certificate', '2026-07-10'),(2, 'Income Certificate', '2026-07-11'),(3, 'Birth Record Request', '2026-07-12');
SELECT * FROM Temporary_Request;
TRUNCATE TABLE Temporary_Request; 
SELECT * FROM Temporary_Request;
DROP TABLE Temporary_Request; -- DROPING MAKES TABLE ERASED FROM DB

-- CONSTRAINTS EXPERIMENT
INSERT INTO Citizen(citizen_id, full_name, date_of_birth, gender, mobile_number, occupation, village_name, is_active) VALUES(101,'HARSHITH','2000-12-16','Male','9876500010','Student','Ramapuram',TRUE);
INSERT INTO Citizen(citizen_id, full_name, date_of_birth, gender, mobile_number, occupation, village_name, is_active) VALUES (108,'JASWITH','1999-06-01','Male','9876500001','Student','Ramapuram',TRUE);
INSERT INTO Certificate_Type(certificate_type_id, description, processing_days, application_fee, is_available) VALUES(8,'Test Description',5,20.00,TRUE);
INSERT INTO Certificate_Application(application_id, citizen_id, certificate_name, application_date, purpose, application_status, fee_paid, reference_number) VALUES (1007,101,'Residence Certificate','2026-07-10','Testing','Submitted',30.00,'GP20260001');
