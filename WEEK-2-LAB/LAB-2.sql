use gram_panchayat_db;
SHOW tables;
SELECT * FROM certificate_type;
-- BULITIN STRING FUNCTIONS
DESC citizen;
SELECT UPPER(full_name) FROM citizen;
SELECT LOWER(village_name) FROM citizen;
SELECT LENGTH(full_name) From citizen;
SELECT LEFT(reference_number,4) FROM certificate_application;
SELECT concat(full_name," - ",village_name) FROM citizen;
select replace(certificate_name,'Certificate','Cert.') from certificate_type;
SELECT TRIM(certificate_name) FROM certificate_type;
SELECT SUBSTRING(full_name,1,LOCATE(' ' ,full_name)-1) AS First_name FROM citizen;
select CONCAT("Citizen : ",full_name, '\n' ,"Village :",  village_name) as "citizeen and village_name" from citizen;
select * from certificate_application where left(reference_number,6)='GP2026';

-- BUILT IN NUMERICAL FUNCTIONS
SELECT application_fee, ROUND(application_fee) from certificate_type;
SELECT processing_days, ABS(processing_days-10) from certificate_type;
select processing_days, power(processing_days,2) from certificate_type;
select processing_days, mod(processing_days,3) from certificate_type;
SELECT application_fee, ROUND(application_fee,1) from certificate_type;
SELECT application_fee, ceil(application_fee),floor(application_fee) from certificate_type;
SELECT FLOOR(RAND()*100)+1 as Random_Number;
select processing_days, sqrt(processing_days) from certificate_type;
select certificate_name, abs(processing_days*2) from certificate_type;

-- DATE FUNCTIONS
select curdate() as "Today's_date";
select now() as "Today's_date and Time";
select application_date, YEAR(application_date) from certificate_application; 
select application_date, MONTH(application_date) from certificate_application; 
select application_date, DAY(application_date) from certificate_application; 
SELECT  dayofmonth(curdate()) AS "DAY OF THE MONTH";
select application_date,processing_days , DATE_ADD(application_date,interval(processing_days)day) AS "EXPECTED CERTIFICATE ISSUE DATE" from certificate_type,certificate_application;
select * from certificate_application;
select application_date , date_add(application_date,INTERVAL 30 DAY) AS "DATE AFTER 30 DAYS" FROM certificate_application;
SELECT application_date,DATE_SUB(application_date,intervaL 7 DAY) as "DATE BEFORE 7 DAYS" from certificate_application; 
select application_date, datediff(CURDATE(),application_date)AS "DAYS DIFFERENCE" FROM certificate_application;
select * from certificate_application WHERE YEAR (application_date)=YEAR(CURDATE());

-- CONVERT AND CAST FUNCTIONS

SELECT application_fee,CONVERT(application_fee,signed) AS "FEE IN INTEGER" FROM certificate_type;
select processing_days ,convert(processing_days , CHAR) AS "DAYS IN CHAR" FROM certificate_type;
SELECT application_date,convert(application_date,DATETIME) AS "DATE AND TIME" FROM certificate_application;
select processing_days ,cast(processing_days as decimal(8,2)) "IN DECIMAL" from certificate_type;
SELECT application_fee,Cast(application_fee as CHAR) AS "FEE IN CHAR STRINGS" FROM certificate_type;
select processing_days ,cast(processing_days as signed)+5 "IN DECIMAL" from certificate_type;
SELECT application_fee,Cast(application_fee as signed)+100 AS "FEE IN NEW NUMERICALS" FROM certificate_type;