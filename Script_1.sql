
--CLEANUP SCRIPT
set serveroutput on
declare
    v_table_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start schema cleanup');
   for i in (select 'LEASED_UNITS' table_name from dual union all
             select 'REQUEST' table_name from dual union all
             select 'BUILDING_HAS_AMENITY' table_name from dual union all
             select 'MAINTAINANCE_PERSONNEL' table_name from dual union all
             select 'UNIT' table_name from dual union all
             select 'BUILDING' table_name from dual union all
             select 'TENANT' table_name from dual union all
             select 'LEASE' table_name from dual union all
             select 'AMENITY' table_name from dual union all
             select 'MANAGEMENT_COMPANY' table_name from dual      
   )
   loop
   dbms_output.put_line('....Drop table '||i.table_name);
   begin
       select 'Y' into v_table_exists
       from USER_TABLES
       where TABLE_NAME=i.table_name;

       v_sql := 'drop table '||i.table_name;
       execute immediate v_sql;
       dbms_output.put_line('........Table '||i.table_name||' dropped successfully');
       
   exception
       when no_data_found then
           dbms_output.put_line('........Table already dropped');
   end;
   end loop;
   dbms_output.put_line('Schema cleanup successfully completed');
exception
   when others then
      dbms_output.put_line('Failed to execute code:'||sqlerrm);
end;
/


--CREATE TABLES AS PER DATA MODEL
CREATE TABLE Management_Company (
  company_id NUMBER(10),
  company_name VARCHAR(50) NOT NULL,
  company_username VARCHAR(50) NOT NULL,
  Company_Password VARCHAR(50)NOT NULL,
  email_id VARCHAR(100)NOT NULL,
  phone_number CHAR(15),
  CONSTRAINT uk_Company_username UNIQUE (company_username),
  CONSTRAINT pk_CompanyID PRIMARY KEY (company_id)
)
/


CREATE TABLE BUILDING (
  Building_id NUMBER(10) NOT NULL,
  Company_id NUMBER(10) NOT NULL,
  building_name VARCHAR(100) NOT NULL,
  number_of_floors NUMBER(20) NOT NULL,
  parking_spots NUMBER(20) NOT NULL,
  type_of_building VARCHAR(10) NOT NULL,
  Address VARCHAR(100) NOT NULL,
  Zipcode VARCHAR(20) NOT NULL,
  CONSTRAINT fk_company_id FOREIGN KEY (Company_id) REFERENCES MANAGEMENT_COMPANY(COMPANY_ID),
  CONSTRAINT uk_building_name UNIQUE (building_name),
  CONSTRAINT pk_BuildingID PRIMARY KEY (Building_id)
)
/
CREATE TABLE unit (
  unit_no NUMBER(10) NOT NULL,
  building_id NUMBER(10) NOT NULL,
  no_of_bedrooms NUMBER(10) NOT NULL,
  no_of_bathrooms NUMBER(10) NOT NULL,
  area DECIMAL(10,2) NOT NULL,
  price DECIMAL(10,2),
  CONSTRAINT fk_building_id FOREIGN KEY(building_id) REFERENCES building(building_id),
  CONSTRAINT pk_unit_no PRIMARY KEY (unit_no)
)
/

CREATE TABLE tenant (
  tenant_id NUMBER(10) NOT NULL,
  tenant_password VARCHAR(100) NOT NULL,
  tenant_name VARCHAR(50) NOT NULL,
  tenant_username VARCHAR(50) NOT NULL,
  date_of_birth DATE DEFAULT NULL,
  occupation VARCHAR(50) DEFAULT NULL,
  phone_number CHAR(15) NOT NULL,
  CONSTRAINT tusername_unique UNIQUE (tenant_username),
  CONSTRAINT pk_tenant_id PRIMARY KEY (tenant_id)
);
/

CREATE TABLE maintainance_personnel (
  Maintainance_Person_id NUMBER(10) NOT NULL,
  Maintainance_Person_name VARCHAR(50) NOT NULL,
  company_id NUMBER(10) NOT NULL,
  phone_number VARCHAR(10) NOT NULL,
  CONSTRAINT maintaince_personnel_pk PRIMARY KEY (Maintainance_Person_id),
  CONSTRAINT maintaince_personnel_fk FOREIGN KEY (company_id) REFERENCES management_company (company_id)
)
/

CREATE TABLE request (
  Request_ID NUMBER(10) NOT NULL,
  unit_no NUMBER(10) NOT NULL,
  maintainance_person_id NUMBER(10) NOT NULL,
  request_description VARCHAR(200) NOT NULL,
  request_status NUMBER(1) NOT NULL ,
  request_date DATE NOT NULL,
  CONSTRAINT pk_Request_id PRIMARY KEY (Request_ID),
  CONSTRAINT fk_Maintainance_person_id FOREIGN KEY (maintainance_person_id) REFERENCES maintainance_personnel (maintainance_person_id),
  CONSTRAINT fk_unit_no FOREIGN KEY (unit_no) REFERENCES unit (unit_no)
)
/


CREATE TABLE amenity (
  amenity_id NUMBER(10) NOT NULL,
  amenity_description VARCHAR(100) NOT NULL,
  CONSTRAINT amenity_pk PRIMARY KEY (amenity_id),
  CONSTRAINT amenity_description_uk UNIQUE (amenity_description)
)
/

CREATE TABLE building_has_amenity (
  building_id NUMBER(10) NOT NULL,
  amenity_id NUMBER(10) NOT NULL,
  sequence1 NUMBER(10) NOT NULL,
  CONSTRAINT building_has_amenity_pk PRIMARY KEY (sequence1),
  CONSTRAINT building_has_amenity_b_fk FOREIGN KEY (building_id) REFERENCES building (building_id),
  CONSTRAINT building_has_amenity_a_fk FOREIGN KEY (amenity_id) REFERENCES amenity (amenity_id)
)
/

CREATE TABLE lease (
  lease_id NUMBER(10) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  CONSTRAINT lease_pk PRIMARY KEY (lease_id)
)
/

CREATE TABLE Leased_units (
  sequence2 NUMBER(10) NOT NULL,
  lease_id NUMBER(10) NOT NULL,
  unit_no NUMBER(10) NOT NULL,
  tenant_id NUMBER(10) NOT NULL,
  CONSTRAINT leased_units_pk PRIMARY KEY (sequence2),
  CONSTRAINT leased_units_l_fk FOREIGN KEY (lease_id) REFERENCES lease (lease_id),
  CONSTRAINT leased_units_t_fk FOREIGN KEY (tenant_id) REFERENCES tenant (tenant_id),
  CONSTRAINT leased_units_u_fk FOREIGN KEY (unit_no) REFERENCES unit (unit_no)
);
/

INSERT INTO MANAGEMENT_COMPANY (Company_ID,COMPANY_NAME,Company_username,Company_Password,email_ID,Phone_Number)
VALUES (1,'Cakewalk','sed','nibh','velit@yahoo.net','7452335100');
INSERT INTO MANAGEMENT_COMPANY (Company_ID,COMPANY_NAME,Company_username,Company_Password,email_ID,Phone_Number)
VALUES (2,'Chami','Aliquam','cursus.','donec@icloud.ca','3425796329');
INSERT INTO MANAGEMENT_COMPANY (Company_ID,COMPANY_NAME,Company_username,Company_Password,email_ID,Phone_Number)
VALUES (3,'Cakewalk','dui','porttitor','arcu.iaculis@yahoo.couk','7029908536');
INSERT INTO MANAGEMENT_COMPANY (Company_ID,COMPANY_NAME,Company_username,Company_Password,email_ID,Phone_Number)
VALUES (4,'Finale','a','Nulla','lectus.sit@yahoo.couk','4485926762');
INSERT INTO MANAGEMENT_COMPANY (Company_ID,COMPANY_NAME,Company_username,Company_Password,email_ID,Phone_Number)
VALUES (5,'Cakewalk','magnis','ut,','nonummy@yahoo.couk','2223554522');
INSERT INTO MANAGEMENT_COMPANY (Company_ID,COMPANY_NAME,Company_username,Company_Password,email_ID,Phone_Number)
VALUES (6,'Cakewalk','egestas.','libero','suspendisse.aliquet@icloud.org','3127891531');
INSERT INTO MANAGEMENT_COMPANY (Company_ID,COMPANY_NAME,Company_username,Company_Password,email_ID,Phone_Number)
VALUES (7,'Cakewalk','aliquam','amet','dolor.dolor@hotmail.org','7201018056');
INSERT INTO MANAGEMENT_COMPANY (Company_ID,COMPANY_NAME,Company_username,Company_Password,email_ID,Phone_Number)
VALUES (8,'Lavasoft','sem,','ante','nullam@hotmail.edu','3567161152');
INSERT INTO MANAGEMENT_COMPANY (Company_ID,COMPANY_NAME,Company_username,Company_Password,email_ID,Phone_Number)
VALUES (9,'Microsoft','quis','bibendum.','suspendisse.ac@google.net','4255921863');
INSERT INTO MANAGEMENT_COMPANY (Company_ID,COMPANY_NAME,Company_username,Company_Password,email_ID,Phone_Number)
VALUES (10,'Lavasoft','Vivamus','Cras','adipiscing@protonmail.ca','2452746961');