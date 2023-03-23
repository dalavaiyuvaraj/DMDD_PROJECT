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