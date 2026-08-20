use gram_panchayat_db;
SHOW TABLES;
-- LEVEL 1
SELECT application_date FROM certificate_application
WHERE application_date=(
		SELECT max(application_date)
        FROM certificate_applicatIon);

SELECT application_date FROM certificate_application
WHERE application_date=(
		SELECT min(application_date) 
        FROM certificate_application);
        
SELECT application_id FROM CERTIFICATE_APPLICATION
WHERE APPLICATION_DATE=(
			SELECT MAX(APPLICATION_DATE)
            FROM CERTIFICATE_APPLICATION);
            
SELECT application_id FROM certificate_application
WHERE application_date=(
			SELECT MIN(application_date)
            from certificate_application);
            
SELECT * FROM CITIZEN C
WHERE CITIZEN_ID IN (
			select citizen_id from certificate_application CA
            where application_status='APPROVED');

-- LEVEL 2
SELECT * FROM certificate_application 
WHERE application_date>(
			SELECT min(application_date)
            FROM certificate_application);

SELECT * FROM certificate_application
WHERE application_date < (
		    SELECT MAX(application_date)
			FROM certificate_application
);

SELECT * FROM citizen
WHERE citizen_id IN (
    SELECT citizen_id
    FROM certificate_application
);

SELECT *
FROM citizen
WHERE citizen_id NOT IN (
    SELECT citizen_id
    FROM certificate_application
    WHERE application_status = 'Approved'
);

SELECT *
FROM citizen
WHERE citizen_id IN (
    SELECT citizen_id
    FROM certificate_application
    WHERE application_status = 'Approved'
);

SELECT certificate_name from certificate_type
where certificate_type_id IN (
			select certificate_id
            from certificate_application
            where application_status='Approved');
            
SELECT certificate_name from certificate_type
where certificate_type_id NOT IN (
			select certificate_id
            from certificate_application
            where application_status='Approved');

select * from certificate_application
where application_date > (
			 select avg(application_date)
             from certificate_application);
             
SELECT ct.certificate_name, ca.application_date
FROM certificate_application ca
JOIN certificate_type ct 
ON ca.certificate_id = ct.certificate_type_id
WHERE ca.application_date = (SELECT MAX(application_date) FROM certificate_application);

select ct.certificate_name
FROM certificate_type ct 
JOIN certificate_application ca 
ON ca.certificate_id = ct.certificate_type_id
GROUP BY ct.certificate_type_id,ct.certificate_name
HAVING COUNT(*)=(
		SELECT max(cnt)
        from(
        select count(*) as cnt 
        from certificate_application 
        group by certificate_id
        )AS X
	);

SELECT po.office_name FROM panchayat_office po
JOIN certificate_application ca 
on ca.office_id = po.office_id
GROUP BY po.office_id,po.office_name
HAVING COUNT(*)=(
		SELECT MAX(cnt)
        FROM(
        SELECT COUNT(*) as cnt 
        FROM certificate_application
        GROUP BY office_id
        )AS X
	);

SELECT ct.certificate_name
FROM certificate_type ct 
join certificate_application ca
on ca.certificate_id =ct.certificate_type_id
group by ct.certificate_type_id,ct.certificate_name
having count(*)>(
		select avg(cnt)
        from(
        select count(*) as cnt
        from certificate_application
        group by certificate_id
        )as x
	);
    
select po.office_name
from panchayat_office po
join certificate_application ca
on ca.office_id = po.office_id
group by po.office_id,po.office_name
having count(*)> any(
		select count(*)
        from certificate_application
        group by office_id
);

select po.office_name
from panchayat_office po
join certificate_application ca
on ca.office_id = po.office_id
group by po.office_name,po.office_id
having count(*) >= all(
select count(*)
from certificate_application 
group by office_id
);

select ct.certificate_name
from certificate_type ct
join certificate_application ca
on ca.certificate_id = ct.certificate_type_id
join (
	select max(application_date) as latest_date
    from certificate_application 
    )as x
on ca.application_date = x.latest_date;

select full_name from citizen
where citizen_id in (
		select citizen_id 
        from certificate_application 
        group by citizen_id 
        having count(*)>1
);
        
select application_status from certificate_application
group by application_status
having count(*)=(
		select max(cnt)
        from (
			select count(*) as cnt
            from certificate_application
            group by application_status
            )as x
);

select * from certificate_application;