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
  company_id INT PRIMARY KEY,
  company_name VARCHAR(50),
  Company_Password VARCHAR(50),
  email_id VARCHAR(100),
  phone_number CHAR(10)
)
/


CREATE TABLE BUILDING (
  Building_id INT PRIMARY KEY,
  Company_id INT,
  building_name VARCHAR(100),
  number_of_floors INT,
  parking_spots INT,
  type_of_building VARCHAR(10),
  Address VARCHAR(100),
  Zipcode INT,
  CONSTRAINT fk_company_id FOREIGN KEY (Company_id) REFERENCES MANAGEMENT_COMPANY(COMPANY_ID)
)
/
CREATE TABLE unit (
  unit_no INT PRIMARY KEY,
  building_id INT CONSTRAINT fk_building_id REFERENCES building(building_id),
  unit_number INT,
  no_of_bedrooms INT,
  no_of_bathrooms INT,
  area DECIMAL(10,2),
  price DECIMAL(10,2)
)
/

CREATE TABLE tenant (
  tenant_id NUMBER(10) NOT NULL,
  tenant_password VARCHAR2(100) NOT NULL,
  tenant_name VARCHAR2(50) NOT NULL,
  tenant_username VARCHAR2(50) NOT NULL,
  date_of_birth DATE DEFAULT NULL,
  occupation VARCHAR2(50) DEFAULT NULL,
  phone_number VARCHAR2(10) NOT NULL,
  CONSTRAINT tusername_unique UNIQUE (tenant_username),
  CONSTRAINT pk_tenant_id PRIMARY KEY (tenant_id)
);
/

CREATE TABLE maintainance_personnel (
  Maintainance_Person_id NUMBER(10) NOT NULL,
  Maintainance_Person_name VARCHAR2(50) NOT NULL,
  company_id NUMBER(10) NOT NULL,
  phone_number VARCHAR2(10) NOT NULL,
  CONSTRAINT maintaince_personnel_pk PRIMARY KEY (Maintainance_Person_id),
  CONSTRAINT maintaince_personnel_fk FOREIGN KEY (company_id) REFERENCES management_company (company_id)
)
/

CREATE TABLE request (
  Request_ID NUMBER(10) NOT NULL,
  unit_no NUMBER(10) NOT NULL,
  maintainance_person_id NUMBER(10) NOT NULL,
  request_description VARCHAR2(200) NOT NULL,
  request_status NUMBER(1) NOT NULL ,
  request_date DATE NOT NULL,
  CONSTRAINT pk_Request_id PRIMARY KEY (Request_ID),
  CONSTRAINT fk_Maintainance_person_id FOREIGN KEY (maintainance_person_id) REFERENCES maintainance_personnel (maintainance_person_id),
  CONSTRAINT fk_unit_no FOREIGN KEY (unit_no) REFERENCES unit (unit_no)
)
/

CREATE TABLE amenity (
  amenity_id NUMBER(10) NOT NULL,
  amenity_description VARCHAR2(100) NOT NULL,
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
