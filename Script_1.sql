
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
  First_name VARCHAR(50) NOT NULL,
  Last_name VARCHAR(50) NOT NULL,
  username VARCHAR(50) NOT NULL,
  tenant_password VARCHAR(100) NOT NULL,
  date_of_birth DATE DEFAULT NULL,
  occupation VARCHAR(50) DEFAULT NULL,
  phone_number CHAR(15) NOT NULL,
  CONSTRAINT tusername_unique UNIQUE (username),
  CONSTRAINT pk_tenant_id PRIMARY KEY (tenant_id)
);
/

CREATE TABLE maintainance_personnel (
  Maintainance_Person_id NUMBER(10) NOT NULL,
  Firstname VARCHAR(50) NOT NULL,
  Lastname VARCHAR(50) NOT NULL,
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

insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (1, 2, 'Boni', 5, 5, 'Townhouse', '92825 Union Plaza', '770955');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (2, 1, 'Draude', 8, 7, 'Apartment', '55527 8th Trail', '900751');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (3, 2, 'Ivancevic', 7, 4, 'Individual', '3 Welch Point', '807434');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (4, 5, 'Fruchter', 8, 3, 'Townhouse', '88536 Meadow Valley Junction', '101565');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (5, 1, 'Simnett', 8, 7, 'Individual', '07 Oak Valley Crossing', '387894');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (6, 1, 'Izard', 4, 7, 'Individual', '0 Prairieview Drive', '523180');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (7, 8, 'Latta', 7, 6, 'Apartment', '24 Forest Dale Plaza', '894040');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (8, 2, 'Torrans', 8, 4, 'Apartment', '2346 Manitowish Center', '646435');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (9, 2, 'Megainey', 9, 4, 'Townhouse', '50 Almo Court', '074389');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (10, 3, 'Yielding', 4, 5, 'Apartment', '74678 Ohio Street', '529424');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (11, 10, 'Geaves', 7, 3, 'Townhouse', '8 Loftsgordon Drive', '029424');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (12, 5, 'Campsall', 4, 7, 'Individual', '04030 Londonderry Drive', '479932');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (13, 4, 'Tinwell', 9, 1, 'Townhouse', '26 American Ash Drive', '667463');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (14, 10, 'Newberry', 9, 3, 'Townhouse', '5 Ohio Terrace', '460461');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (15, 5, 'Epinoy', 4, 5, 'Townhouse', '9 Redwing Street', '991634');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (16, 10, 'Dorken', 7, 2, 'Apartment', '6 Homewood Road', '977146');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (17, 8, 'Gentile', 8, 6, 'Apartment', '1 Southridge Street', '503770');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (18, 6, 'Stoker', 4, 4, 'Individual', '2 Dwight Trail', '577132');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (19, 10, 'Howsego', 3, 5, 'Individual', '710 Muir Alley', '450218');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (20, 9, 'Daniels', 9, 7, 'Apartment', '43 Walton Park', '670700');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (21, 3, 'Toop', 3, 7, 'Apartment', '27168 Gulseth Park', '140538');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (22, 3, 'Foxley', 9, 3, 'Townhouse', '35407 Porter Center', '015765');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (23, 6, 'Buessen', 7, 4, 'Townhouse', '48 Algoma Parkway', '309875');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (24, 5, 'Uglow', 9, 6, 'Individual', '00142 Ridgeway Alley', '048747');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (25, 10, 'Grinikhinov', 6, 7, 'Individual', '84 5th Road', '688787');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (26, 5, 'Elsby', 9, 5, 'Townhouse', '63547 Hooker Hill', '761185');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (27, 6, 'Maty', 6, 6, 'Individual', '2 Upham Crossing', '449550');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (28, 5, 'Cawsy', 5, 7, 'Individual', '00 Maple Wood Road', '190814');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (29, 7, 'Rosenbush', 7, 1, 'Townhouse', '3 Scoville Junction', '611669');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (30, 7, 'Domke', 2, 2, 'Individual', '6 Myrtle Drive', '848158');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (31, 10, 'Reicherz', 6, 7, 'Townhouse', '97 Kinsman Point', '123416');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (32, 1, 'Belle', 7, 2, 'Apartment', '79 Lotheville Circle', '264304');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (33, 2, 'Dennant', 2, 2, 'Apartment', '28 Porter Avenue', '555044');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (34, 2, 'Pilmer', 9, 5, 'Apartment', '31321 Green Ridge Place', '369467');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (35, 6, 'Barense', 4, 3, 'Townhouse', '41 Dixon Crossing', '064733');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (36, 5, 'Gathercole', 4, 7, 'Individual', '92136 Atwood Pass', '059109');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (37, 1, 'Libbe', 9, 7, 'Apartment', '23468 Northview Lane', '266735');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (38, 3, 'Sarton', 7, 3, 'Townhouse', '9472 Hoard Pass', '455081');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (39, 2, 'Aleksidze', 7, 5, 'Individual', '0768 Johnson Parkway', '783833');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (40, 1, 'Bampfield', 6, 3, 'Townhouse', '5 Muir Drive', '683996');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (41, 2, 'Seint', 3, 6, 'Apartment', '13 Harper Parkway', '219865');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (42, 8, 'Obern', 6, 2, 'Individual', '1739 Northfield Avenue', '486898');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (43, 10, 'Dellar', 2, 7, 'Townhouse', '63 Mayer Plaza', '790053');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (44, 1, 'Bachs', 6, 3, 'Individual', '51688 Union Park', '024716');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (45, 5, 'Dreghorn', 7, 4, 'Townhouse', '12580 Debra Road', '415394');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (46, 2, 'Bourdel', 7, 4, 'Individual', '8 Banding Parkway', '412175');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (47, 7, 'Tandy', 3, 6, 'Individual', '79514 Roth Drive', '705942');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (48, 6, 'Benam', 9, 6, 'Townhouse', '18 Westerfield Avenue', '413499');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (49, 4, 'Orgee', 9, 7, 'Apartment', '7572 Reindahl Parkway', '701858');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (50, 9, 'Kippen', 2, 3, 'Apartment', '5 Elka Terrace', '566399');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (51, 4, 'Mantrip', 6, 3, 'Townhouse', '71122 Marquette Park', '769678');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (52, 5, 'Lainton', 7, 5, 'Apartment', '65507 Maryland Junction', '245720');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (53, 1, 'Kirwood', 2, 4, 'Townhouse', '89 Forster Hill', '750619');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (54, 6, 'Pinshon', 6, 1, 'Individual', '009 Ruskin Circle', '355973');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (55, 10, 'Cashford', 8, 5, 'Townhouse', '65650 North Drive', '664491');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (56, 8, 'Flahive', 4, 2, 'Apartment', '29488 Menomonie Way', '106342');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (57, 3, 'Brearton', 3, 1, 'Individual', '8 Vidon Crossing', '633642');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (58, 2, 'Axcell', 3, 4, 'Apartment', '61998 Anhalt Terrace', '053255');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (59, 4, 'Swindell', 7, 3, 'Townhouse', '22 Katie Trail', '851533');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (60, 8, 'Blunkett', 5, 1, 'Apartment', '0035 Cody Crossing', '642885');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (61, 8, 'Guilliatt', 3, 2, 'Apartment', '8461 Johnson Hill', '346322');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (62, 2, 'Fleckno', 8, 6, 'Townhouse', '8 Florence Pass', '364210');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (63, 9, 'Tambling', 6, 5, 'Townhouse', '06 Eagan Trail', '167150');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (64, 8, 'Orrah', 9, 5, 'Townhouse', '2351 Esch Street', '956432');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (65, 3, 'Everill', 4, 3, 'Apartment', '08 Hoffman Crossing', '173777');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (66, 6, 'Harsnipe', 9, 4, 'Apartment', '6115 Clove Park', '829561');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (67, 1, 'Prior', 5, 1, 'Individual', '0 Marquette Road', '999892');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (68, 1, 'Hamprecht', 9, 3, 'Individual', '26 Doe Crossing Avenue', '606038');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (69, 5, 'Volette', 5, 2, 'Townhouse', '0926 Derek Trail', '489938');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (70, 7, 'Rosenzveig', 4, 6, 'Individual', '2 Amoth Alley', '956117');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (71, 8, 'Gaze', 4, 5, 'Individual', '2477 Hayes Place', '189738');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (72, 10, 'Ledley', 4, 4, 'Townhouse', '03355 Village Green Road', '530403');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (73, 1, 'Mobberley', 9, 1, 'Apartment', '12 Esch Crossing', '053139');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (74, 4, 'Rostron', 9, 7, 'Townhouse', '80 Laurel Avenue', '772158');
insert into BUILDING (BUILDING_ID, COMPANY_ID, BUILDING_NAME, NUMBER_OF_FLOORS, PARKING_SPOTS, TYPE_OF_BUILDING, ADDRESS, ZIPCODE) values (75, 8, 'Battson', 2, 5, 'Townhouse', '2 Lukken Street', '446200');

insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (1, 13, 8, 3, 1555.14, 9277.02);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (2, 9, 5, 1, 2705.88, 4128.35);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (3, 7, 9, 1, 2073.02, 2919.56);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (4, 15, 1, 1, 2634.45, 7574.45);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (5, 7, 8, 2, 2480.51, 5962.6);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (6, 21, 1, 3, 1461.87, 9319.19);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (7, 17, 7, 1, 2881.31, 3492.9);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (8, 2, 3, 3, 2940.93, 2890.49);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (9, 17, 8, 2, 1099.98, 6741.13);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (10, 7, 7, 3, 1638.1, 8265.92);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (11, 11, 1, 1, 1421.77, 1435.95);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (12, 23, 8, 1, 939.2, 9164.81);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (13, 13, 3, 4, 2427.56, 7960.97);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (14, 8, 9, 4, 2759.58, 5757.8);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (15, 23, 2, 4, 2279.29, 2550.09);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (16, 12, 4, 2, 2842.27, 7697.95);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (17, 12, 1, 2, 1417.53, 7945.46);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (18, 5, 6, 3, 1186.96, 2228.8);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (19, 22, 9, 3, 1350.08, 8621.36);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (20, 15, 3, 2, 906.76, 8895.28);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (21, 4, 2, 3, 2467.68, 8330.41);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (22, 2, 6, 2, 2590.69, 4600.64);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (23, 24, 2, 1, 1821.69, 8569.9);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (24, 24, 3, 1, 2926.52, 9664.41);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (25, 11, 2, 2, 1612.13, 3659.44);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (26, 22, 5, 3, 1379.22, 2244.59);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (27, 12, 4, 3, 2897.26, 7720.24);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (28, 2, 8, 3, 2413.24, 8789.23);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (29, 16, 3, 3, 884.6, 9392.19);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (30, 24, 6, 4, 1715.44, 2315.63);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (31, 6, 3, 2, 1880.07, 8655.92);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (32, 5, 6, 4, 1510.78, 1821.0);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (33, 17, 9, 1, 2882.64, 7554.88);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (34, 9, 3, 1, 892.99, 5256.89);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (35, 3, 6, 1, 1281.34, 4732.71);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (36, 15, 3, 4, 1975.33, 3469.8);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (37, 18, 4, 4, 2527.98, 4585.95);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (38, 6, 2, 2, 1437.17, 1957.29);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (39, 16, 4, 4, 2730.09, 8778.08);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (40, 25, 2, 3, 2602.06, 1867.36);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (41, 1, 4, 1, 2252.56, 5248.39);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (42, 6, 1, 3, 2296.7, 7479.34);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (43, 20, 1, 4, 1740.26, 8432.71);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (44, 19, 5, 3, 2356.45, 6794.91);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (45, 5, 5, 2, 1796.5, 9635.37);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (46, 20, 1, 4, 2955.58, 2824.62);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (47, 6, 2, 2, 1716.53, 6346.85);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (48, 10, 6, 1, 1635.97, 7809.52);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (49, 19, 6, 3, 1674.09, 6878.29);
insert into Unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, area, price) values (50, 2, 8, 4, 2477.09, 1382.56);


insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (1, 'Benyamin', 'Fairfull', 'bfairfull0', 'jo5pKbs5TR', '29-Apr-2009', 'Analog Circuit Design manager', '8866502121');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (2, 'Dyanne', 'Leversuch', 'dleversuch1', 'lTTKIoKmJB', '29-Nov-2020', 'Nurse', '1653984271');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (3, 'Hi', 'Stegell', 'hstegell2', 'qzrMWz', '28-Oct-2012', 'Teacher', '3117930660');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (4, 'Kellyann', 'Starr', 'kstarr3', 'asm8q8f', '14-Nov-1996', 'Safety Technician I', '4167093286');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (5, 'Tiphani', 'McKinnon', 'tmckinnon4', 'qOGmJIrOs', '04-Jul-1998', 'Safety Technician III', '5471993772');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (6, 'Regen', 'Tordiffe', 'rtordiffe5', 'Sly5a8gtf', '08-Mar-2000', 'Senior Developer', '3706413038');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (7, 'Hertha', 'Heppner', 'hheppner6', 'ncddrUTpq', '01-Apr-2003', 'Actuary', '4886927832');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (8, 'Dru', 'Frenzl', 'dfrenzl7', 'g9cin5MGA', '19-Aug-2010', 'Assistant Media Planner', '3412149822');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (9, 'Chaunce', 'Huie', 'chuie8', 'RboHJT', '19-Apr-1991', 'Mechanical Systems Engineer', '5998655473');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (10, 'Eirena', 'Spilling', 'espilling9', '08gmeV', '18-Feb-2019', 'GIS Technical Architect', '1143456097');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (11, 'Feodor', 'Le Noury', 'flenourya', 'SorKTj', '30-Oct-2009', 'Automation Specialist III', '3992210537');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (12, 'Anastassia', 'Plumley', 'aplumleyb', 'gW1R5t', '29-Dec-1998', 'Senior Developer', '4575536958');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (13, 'Lenard', 'Bielefeld', 'lbielefeldc', 'qNh6ir5', '19-Mar-2019', 'Staff Scientist', '2048526273');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (14, 'Jonathan', 'Mirfin', 'jmirfind', '1vp5Nqjs', '18-Sep-1990', 'Assistant Professor', '1083087731');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (15, 'Melesa', 'Tasseler', 'mtasselere', 'bEEQp6w', '22-Nov-1996', 'Physical Therapy Assistant', '7239509153');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (16, 'Malchy', 'Lejeune', 'mlejeunef', '0g25OP', '30-Mar-1997', 'Design Engineer', '2146328253');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (17, 'Cherry', 'Whitlaw', 'cwhitlawg', 'wOLI1AHA', '31-Dec-1996', 'Clinical Specialist', '4184235999');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (18, 'Maurie', 'Reitenbach', 'mreitenbachh', 'JcPZ8e50TH3', '13-Nov-2011', 'Budget/Accounting Analyst I', '2259191930');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (19, 'Sollie', 'Waddell', 'swaddelli', 'YznLhG01Qj', '04-Mar-1998', 'Cost Accountant', '7175015735');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (20, 'Carver', 'Borrel', 'cborrelj', 'gdmnw9iCB', '20-Aug-1997', 'Senior Cost Accountant', '5907677846');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (21, 'Mariska', 'Wassung', 'mwassungk', 'GT95DUFS', '22-Mar-2011', 'Occupational Therapist', '4342678597');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (22, 'Olenolin', 'MacAindreis', 'omacaindreisl', 'UaWcs2YljJqM', '20-Dec-1992', 'Sales Associate', '2865920789');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (23, 'Cesaro', 'Goodby', 'cgoodbym', 'JPpSdi7', '04-Jul-2006', 'Mechanical Systems Engineer', '9459965407');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (24, 'Curry', 'Jewson', 'cjewsonn', 'hyCFFHzx', '08-May-2003', 'Help Desk Technician', '5727032753');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (25, 'Gertie', 'Gillibrand', 'ggillibrando', 'FVvbgsyF', '11-Mar-2006', 'Web Designer I', '8821491918');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (26, 'Saw', 'Gorthy', 'sgorthyp', 'aQRB8uu', '28-Mar-2010', 'Marketing Assistant', '9668164202');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (27, 'Pamella', 'Ropp', 'proppq', 'kX9Z3XXrh', '09-Jan-2007', 'Chemical Engineer', '8161546657');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (28, 'Farr', 'Perle', 'fperler', 'GLECDcXQIwZ2', '24-Jul-2020', 'Research Assistant I', '3197510551');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (29, 'Cad', 'Gyver', 'cgyvers', 'LrCWTl6auV', '07-May-2021', 'Geological Engineer', '7798828051');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (30, 'Brena', 'Ranklin', 'branklint', 'NtKhdKDnl', '06-Apr-2002', 'Physical Therapy Assistant', '6288099176');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (31, 'Cristabel', 'McCowan', 'cmccowanu', 'hoYIgU', '07-Jan-1994', 'Quality Control Specialist', '2176301886');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (32, 'Kaylyn', 'Merwe', 'kmerwev', '5t4bdW0XpU', '18-Sep-2003', 'Assistant Manager', '2947983195');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (33, 'Lon', 'Beden', 'lbedenw', '6w7g9Xu', '31-Jul-2011', 'Assistant Media Planner', '3347723470');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (34, 'Liza', 'Oppy', 'loppyx', 'GPDSkIXbW9gm', '09-Jan-1997', 'Project Manager', '7732288032');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (35, 'Joelle', 'Parradice', 'jparradicey', 'Mrju0oDr', '22-Aug-2010', 'Office Assistant IV', '3705948814');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (36, 'Scottie', 'Wyss', 'swyssz', 'FhAAd4oY1', '18-Mar-2017', 'VP Accounting', '1517737340');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (37, 'Sibbie', 'Hardman', 'shardman10', 'vjG3aeUga1KM', '13-Mar-2005', 'Design Engineer', '7319163493');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (38, 'Mortimer', 'Dallow', 'mdallow11', '2wZwxnsULQU', '23-Nov-1990', 'Account Coordinator', '9759612351');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (39, 'Jeanne', 'Iacobini', 'jiacobini12', '71BHdQhIeX', '12-May-1990', 'VP Product Management', '9022669390');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (40, 'Burtie', 'Fraulo', 'bfraulo13', '8toiQVbBZP3', '07-Jun-1993', 'Developer II', '9077991491');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (41, 'Raimund', 'Paolotto', 'rpaolotto14', 'gtg9X87Tb1OM', '05-Jan-1992', 'Compensation Analyst', '8164282511');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (42, 'Jeanne', 'Patrie', 'jpatrie15', 'c0pd1V', '23-Feb-2002', 'Senior Sales Associate', '2138714617');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (43, 'Aili', 'Kapelhoff', 'akapelhoff16', 'xS2y7ypx', '14-Nov-1993', 'Analog Circuit Design manager', '8341261923');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (44, 'Kile', 'Ulrik', 'kulrik17', 'i5CtaV7lum', '13-Jun-2018', 'Information Systems Manager', '1824355240');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (45, 'Claresta', 'Milthorpe', 'cmilthorpe18', 'AIUxtc6vWO9o', '31-Oct-2000', 'General Manager', '6893546119');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (46, 'Judith', 'Nijssen', 'jnijssen19', '24406mX', '13-May-2000', 'Desktop Support Technician', '3994326796');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (47, 'Martynne', 'Peat', 'mpeat1a', 'EMaBdTzYX', '22-Mar-2004', 'Sales Associate', '9342080098');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (48, 'Kaile', 'Fellgatt', 'kfellgatt1b', 'rS0cTDGHMqe', '06-Jan-2008', 'Nurse Practicioner', '8712018334');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (49, 'Jerrine', 'Gubbins', 'jgubbins1c', 'fTxAzAx', '28-Jun-2013', 'Web Developer IV', '1105222044');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (50, 'Nathanil', 'O'' Driscoll', 'nodriscoll1d', '59vIDp3BKxql', '25-Mar-2000', 'Environmental Tech', '7016898837');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (51, 'Mireille', 'Thorrington', 'mthorrington1e', 'e2vKNitLO2', '14-Jul-2004', 'Administrative Assistant III', '2873319932');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (52, 'Odille', 'Silveston', 'osilveston1f', 'ymyqbFjKl', '26-Dec-2005', 'Account Coordinator', '7224631627');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (53, 'Adriana', 'Abramowsky', 'aabramowsky1g', 'qEj47x6MgFS', '30-Sep-2016', 'Social Worker', '9968960924');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (54, 'Glenna', 'Tillard', 'gtillard1h', 'lHuI3VAQV6', '10-Aug-2006', 'Recruiter', '7949000498');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (55, 'James', 'Scoular', 'jscoular1i', '10Ex0ny6R8', '06-Jun-1994', 'Legal Assistant', '2643895070');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (56, 'Rafaelita', 'Poznan', 'rpoznan1j', 'qLVihjjuH', '27-Jul-2021', 'Pharmacist', '4042343663');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (57, 'Brien', 'Forder', 'bforder1k', 'JN1Yxn0GFa', '24-Mar-2018', 'Engineer III', '9056954650');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (58, 'Iseabal', 'Massy', 'imassy1l', 'P6bbJDdxvOHs', '25-Feb-2003', 'Electrical Engineer', '4279171042');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (59, 'Marquita', 'Giacomazzo', 'mgiacomazzo1m', 've9rgDbUXIq', '11-Sep-1995', 'Quality Control Specialist', '8934075786');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (60, 'Hannie', 'Bodsworth', 'hbodsworth1n', 'qsHktzOO', '13-Jun-2014', 'Geologist I', '4461007333');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (61, 'Nelli', 'Cresser', 'ncresser1o', 'HT1yVhU', '31-Dec-1994', 'VP Quality Control', '1847023275');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (62, 'Marcella', 'Keuntje', 'mkeuntje1p', 'zXI1CgclDk8', '16-Mar-2020', 'VP Sales', '9894303379');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (63, 'Shell', 'Hyrons', 'shyrons1q', 'vUmQ0t', '08-Feb-2023', 'VP Marketing', '9219684588');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (64, 'Paulo', 'Balderstone', 'pbalderstone1r', 'Yx3DZCdikJt', '23-Aug-1996', 'Food Chemist', '7015243256');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (65, 'Carissa', 'Sycamore', 'csycamore1s', 'oLMnDsdQ6', '07-Sep-2005', 'Biostatistician II', '7186890359');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (66, 'Ethelda', 'Tett', 'etett1t', 'fhMfbrifPj', '10-Sep-1993', 'Senior Financial Analyst', '9861379913');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (67, 'Hatty', 'Strapp', 'hstrapp1u', 'n6CpkVdHPF', '17-Jan-2010', 'Social Worker', '1333984211');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (68, 'Georgianne', 'Conn', 'gconn1v', 'rX7mjGMncjYO', '17-Oct-1998', 'Clinical Specialist', '6809683892');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (69, 'Hansiain', 'Nelson', 'hnelson1w', 'hxOWrIsFV5', '12-Oct-1997', 'Internal Auditor', '8089557733');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (70, 'Lazaro', 'Skally', 'lskally1x', 'Y80WVXF', '11-Jun-1998', 'Budget/Accounting Analyst IV', '4959271924');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (71, 'Angus', 'Ferenczi', 'aferenczi1y', '1DA0JjILG', '22-Jan-2017', 'Assistant Media Planner', '2072742551');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (72, 'Binky', 'MacWhan', 'bmacwhan1z', 'YEjc889ip2jl', '13-Apr-1993', 'VP Marketing', '2544928677');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (73, 'Llewellyn', 'St Pierre', 'lstpierre20', 'o3IKyLr7Bce', '09-Jan-1993', 'Research Associate', '1063367404');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (74, 'Isaiah', 'Lyburn', 'ilyburn21', 'chMHT9r', '08-Apr-2013', 'Engineer IV', '2058700006');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (75, 'Michele', 'Karlolczak', 'mkarlolczak22', 'JnCAPKlnv', '27-Nov-2022', 'Web Developer II', '2244714912');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (76, 'Van', 'Spire', 'vspire23', 'afjx89', '20-Aug-2014', 'Environmental Specialist', '4331397828');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (77, 'Annie', 'Whardley', 'awhardley24', 'WHdLL6ZWAj', '15-Sep-2016', 'Recruiting Manager', '7861838460');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (78, 'Sib', 'Chaffyn', 'schaffyn25', '1YLQjbhx', '25-Oct-2009', 'Physical Therapy Assistant', '7928629695');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (79, 'Ive', 'Froment', 'ifroment26', 'STHQJaCn', '12-Aug-2009', 'Food Chemist', '4966369980');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (80, 'Lucio', 'Giacomi', 'lgiacomi27', 'BpzT1B', '17-Mar-2000', 'Recruiting Manager', '2396073149');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (81, 'Tulley', 'Empringham', 'tempringham28', 'tEqO2txMLh', '26-Aug-2020', 'Budget/Accounting Analyst I', '2534952480');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (82, 'Nert', 'Lackner', 'nlackner29', 'FJSAvd', '15-Sep-2002', 'Design Engineer', '1258265781');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (83, 'Harmonia', 'Sharper', 'hsharper2a', 'sHoiof', '12-Jan-2005', 'Teacher', '5222954048');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (84, 'Chery', 'Rappport', 'crappport2b', 'ATWIGZ', '02-Mar-2017', 'Analog Circuit Design manager', '9919836040');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (85, 'Aloise', 'Stranio', 'astranio2c', 'ltEdHQyt', '25-Jul-2015', 'Social Worker', '9407998889');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (86, 'Saba', 'Frie', 'sfrie2d', 'wk6OtV', '29-Jun-2021', 'Budget/Accounting Analyst III', '3173327134');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (87, 'Eba', 'Plumtree', 'eplumtree2e', '854Hsi5Z', '14-May-2001', 'Associate Professor', '2844839859');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (88, 'Harlene', 'Guerreru', 'hguerreru2f', 'kwkLZbv1K', '08-May-2004', 'Automation Specialist I', '7645986545');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (89, 'Shaun', 'Houltham', 'shoultham2g', 'q3eSpI', '14-Jul-2021', 'Help Desk Technician', '3831076860');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (90, 'Luce', 'Raylton', 'lraylton2h', 'btTNJdI5Ye2T', '25-Aug-2002', 'Human Resources Manager', '8865209910');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (91, 'Richard', 'Lockhart', 'rlockhart2i', 'rgMbUyPNAhw', '27-May-2016', 'Research Assistant IV', '1044079072');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (92, 'Gilli', 'Hugli', 'ghugli2j', 'r5c89JXbUoC', '18-Feb-2012', 'Junior Executive', '1876682320');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (93, 'Devon', 'Wilcocke', 'dwilcocke2k', '0FyzgX78C', '28-Jul-2019', 'Recruiter', '5888074132');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (94, 'Augustine', 'Karby', 'akarby2l', 'ixb6ERXxLPY', '17-Feb-2007', 'Operator', '5472580178');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (95, 'Sherwynd', 'Mcasparan', 'smcasparan2m', 'HD2wpFe9YrP', '13-Dec-2016', 'Technical Writer', '2457371871');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (96, 'Arnold', 'Dalliwater', 'adalliwater2n', '7bT8Jjna62', '26-Jul-2021', 'Tax Accountant', '4876438783');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (97, 'Rosalinde', 'Schimonek', 'rschimonek2o', 'XBuflkzt97', '14-Aug-1997', 'Marketing Assistant', '6943698518');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (98, 'Rhodie', 'Petrou', 'rpetrou2p', 'oXLcPJJa', '28-Oct-1991', 'Nuclear Power Engineer', '1751698258');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (99, 'Thor', 'Strange', 'tstrange2q', 'PqbTKUj5VQa', '03-Sep-2006', 'Civil Engineer', '9981712066');
insert into tenant (TENANT_ID, first_name, last_name, username, Tenant_password, DATE_OF_BIRTH, OCCUPATION, PHONE_NUMBER) values (100, 'Hatty', 'Slingsby', 'hslingsby2r', 'zJ3HBtPzq', '08-Nov-2022', 'Account Executive', '3551034736');
