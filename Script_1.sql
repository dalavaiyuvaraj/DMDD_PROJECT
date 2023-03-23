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
  date_of_birth DATE DEFAULT NULL,
  occupation VARCHAR2(50) DEFAULT NULL,
  phone_number VARCHAR2(10) NOT NULL,
  PRIMARY KEY (tenant_id),
  CONSTRAINT tname_unique UNIQUE (tenant_name)
);
/

CREATE TABLE maintainance_personnel (
  Maintainance_Person_id NUMBER(10) NOT NULL,
  Maintainance_Person_name VARCHAR2(50) NOT NULL,
  company_id NUMBER(10) NOT NULL,
  phone_number VARCHAR2(10) NOT NULL,
  CONSTRAINT maintaince_personnel_pk PRIMARY KEY (Maintainance_Person_id),
  CONSTRAINT maintaince_personnel_uk UNIQUE (phone_number),
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
  PRIMARY KEY (Request_ID, unit_no, maintainance_person_id),
  CONSTRAINT M_with_table FOREIGN KEY (maintainance_person_id) REFERENCES maintainance_personnel (maintainance_person_id),
  CONSTRAINT u_table FOREIGN KEY (unit_no) REFERENCES unit (unit_no)
)
/