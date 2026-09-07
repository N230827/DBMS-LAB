USE gram_panchayat_db;
-- LEVEL-1
CREATE VIEW all_certificate_applications as
select application_id,application_date,purpose
from certificate_application;
select * from all_certificate_applications;

CREATE VIEW Citizens_applications_status as
select c.citizen_id,ca.application_id,ca.application_status
from citizen c
join certificate_application ca
on c.citizen_id=ca.citizen_id;
select * from Citizens_applications_status;

CREATE VIEW Approved_Applications AS
select application_id,application_status
from certificate_application
WHERE application_status='Approved';
select * from Approved_applications;

SHOW FULL TABLES 
WHERE table_type='VIEW';

-- LEVEL 2
CREATE VIEW Name_Date as
select ct.certificate_name,ca.application_date
from certificate_type ct
join certificate_application ca
on ct.certificate_type_id = ca.certificate_id;
select * from Name_Date;

CREATE VIEW Citizenname_applicationstatus as
select c.full_name,ca.application_status
from citizen c
join certificate_application ca
on c.citizen_id = ca.citizen_id;
select * from citizenname_applicationstatus;

CREATE VIEW applications_submitted_office AS
SELECT po.office_id,po.office_name,COUNT(ca.application_id) AS total_applications
FROM panchayat_office po
JOIN certificate_application ca
ON po.office_id = ca.office_id
GROUP BY po.office_id, po.office_name; -- check this too
select * from applications_submitted_office;

CREATE VIEW applications_per_certtype as
select ct.certificate_name,count(ca.application_id) as total_applications
from certificate_type ct
left join certificate_application ca
on ct.certificate_type_id = ca.certificate_id
group by ct.certificate_name,ct.certificate_type_id;
select * from applications_per_certtype;

CREATE VIEW pending_applications AS
SELECT ca.application_id,ct.certificate_name,ca.application_status
FROM certificate_application ca
JOIN certificate_type ct
ON ca.certificate_id = ct.certificate_type_id
WHERE ca.application_status = 'Pending';
select * from pending_applications;

SELECT certificate_name, application_date
FROM Name_Date
WHERE application_date = '2026-07-05';

SHOW CREATE VIEW approved_applications;

-- LEVEL 3
CREATE VIEW total_applications_per_certificate as
select ct.certificate_name,count(ca.application_id) as total_applications
from certificate_type ct
left join certificate_application ca
on ct.certificate_type_id = ca.certificate_id
group by ct.certificate_name,ct.certificate_type_id;
select * from applications_per_certtype;

create view having_morethan_one as
select po.office_name,po.office_id,count(ca.application_id) as total_applications
from panchayat_office po
join certificate_application ca
on ca.office_id=po.office_id
group by po.office_name,po.office_id
having count(ca.application_id)>1;
select * from having_morethan_one;

create view early_latest_application as
select ct.certificate_name,min(ca.application_date) as "Earliest Date",max(ca.application_date)as"Latest Date"
from certificate_type ct
join certificate_application ca
on ct.certificate_type_id = ca.certificate_id
group by ct.certificate_name;
select * from early_latest_application;

create view applications_by_citizen as
select c.citizen_id,c.full_name,count(*) as total_applications
from citizen c
join certificate_application ca
on c.citizen_id = ca.citizen_id
group by c.citizen_id,c.full_name; 
select * from applications_by_citizen;

create view all_details as
select c.citizen_id,c.full_name,c.village_name,ct.certificate_type_id,ct.certificate_name,ca.application_id,ca.application_date,po.office_id,po.office_name
from citizen c
join certificate_application ca
on c.citizen_id=ca.citizen_id
join certificate_type ct
on ct.certificate_type_id=ca.certificate_id
join panchayat_office po
on po.office_id=ca.office_id;
select * from all_details;

create view approved_applications_citizennames as
select c.full_name,ct.certificate_name
from citizen c
join certificate_application ca
on c.citizen_id=ca.citizen_id
join certificate_type ct
on ct.certificate_type_id = ca.certificate_id
where ca.application_status='Approved';
select * from approved_applications_citizennames;

-- DATA OF PERSONS HAVING HIGHEST APPROVED APPLICATIONS ORDERED BY NAMES
select full_name,count(*) as approved_applications 
FROM approved_applications_citizennames
group by full_name
having count(*)>=1
order by full_name ASC;

DROP VIEW applications_per_certtype;
SHOW FULL TABLES WHERE table_type="VIEW";
-- select * from applications_per_certtype;
