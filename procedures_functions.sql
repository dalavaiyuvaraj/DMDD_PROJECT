






CREATE OR REPLACE PROCEDURE get_all_buildings AS
  v_building_name BUILDING.BUILDING_NAME%TYPE;
BEGIN
  -- Cursor to retrieve building_name
  FOR c_building_name IN (SELECT BUILDING_NAME FROM BUILDING)
  LOOP
    v_building_name := c_building_name.BUILDING_NAME;
    DBMS_OUTPUT.PUT_LINE(v_building_name);
  END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE get_company_buildings (CompanyUsername IN VARCHAR)
AS
  companyid NUMBER;
  building_name building.building_name%TYPE; -- declare variable with the same type as column
BEGIN
  SELECT company_id INTO companyid FROM management_company WHERE lower(company_username) = lower(CompanyUsername);
  -- use a cursor to retrieve the building names
  FOR building_rec IN (SELECT building_name FROM building WHERE company_id = companyid) LOOP
    building_name := building_rec.building_name;
    DBMS_OUTPUT.PUT_LINE(building_name); -- print the building name
  END LOOP;
END;
/


CREATE OR REPLACE PROCEDURE get_building_details (buildingname IN VARCHAR)
AS
  address building.address%TYPE;
  zipcode building.zipcode%TYPE;
  number_of_floors building.number_of_floors%TYPE;
  parking_spots building.parking_spots%TYPE;
  type_of_building building.type_of_building%TYPE;
BEGIN
  SELECT address, zipcode, number_of_floors, parking_spots, type_of_building
  INTO address, zipcode, number_of_floors, parking_spots, type_of_building
  FROM building
  WHERE building_name = buildingname;

  DBMS_OUTPUT.PUT_LINE('Address: ' || address);
  DBMS_OUTPUT.PUT_LINE('Zipcode: ' || zipcode);
  DBMS_OUTPUT.PUT_LINE('Number of floors: ' || number_of_floors);
  DBMS_OUTPUT.PUT_LINE('Parking spots: ' || parking_spots);
  DBMS_OUTPUT.PUT_LINE('Type of building: ' || type_of_building);
END;
/


CREATE OR REPLACE FUNCTION get_tenants(
    unitno IN NUMBER
)
RETURN VARCHAR2
DETERMINISTIC
IS
    tenantname VARCHAR2(50);
    tenantid NUMBER;
BEGIN
    SELECT tenant_id INTO tenantid 
    FROM leased_units il 
    LEFT JOIN unit u ON il.unit_no = u.unit_no
    WHERE il.unit_no = unitno;

    SELECT first_name||' '||last_name|| ' and Phone Number is ' ||Phone_number INTO tenantname 
    FROM tenant t 
    WHERE t.tenant_id = tenantid;

    RETURN tenantname;
END;
/

CREATE OR REPLACE PROCEDURE get_maintenance_requests(
  unitno IN NUMBER
)
IS
  description VARCHAR2(200);
  status VARCHAR2(200);
BEGIN
  SELECT request_description, request_status INTO description, status
  FROM request r 
  WHERE r.unit_no = unitno;
  
  DBMS_OUTPUT.PUT_LINE('Description: ' || description || ', Status: ' || status);
END;
/



CREATE OR REPLACE PROCEDURE COMPANY_ADMIN_LOGIN(P_USERNAME IN VARCHAR2, P_PASSWORD IN VARCHAR2) AS
    V_USERNAME VARCHAR2(50);
    V_PASSWORD VARCHAR2(50);
    V_NAME VARCHAR(50);
  BEGIN
    -- Do some database logic
    SELECT COMPANY_NAME,COMPANY_USERNAME, COMPANY_PASSWORD INTO V_NAME,V_USERNAME, V_PASSWORD FROM MANAGEMENT_COMPANY
    WHERE LOWER(COMPANY_USERNAME) = LOWER(P_USERNAME) AND LOWER(COMPANY_PASSWORD) = LOWER(P_PASSWORD);
    
    dbms_output.put_line('Result: LOGIN SUCCESS. WELCOME ' || V_NAME);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('Result: LOGIN FAILED PLEASE CHECK YOUR USERNAME OR PASSWORD');
  END COMPANY_ADMIN_LOGIN;
/

CREATE OR REPLACE PROCEDURE COMPANY_REGISTER(
    P_COMPANY_NAME MANAGEMENT_COMPANY.COMPANY_NAME%TYPE,
    P_COMPANY_USERNAME MANAGEMENT_COMPANY.COMPANY_USERNAME%TYPE,
    P_COMPANY_PASSWORD MANAGEMENT_COMPANY.COMPANY_PASSWORD%TYPE,
    P_COMPANY_EMAIL_ID MANAGEMENT_COMPANY.EMAIL_ID%TYPE,
    P_PHONE_NUMBER MANAGEMENT_COMPANY.PHONE_NUMBER%TYPE
    ) AS
    phone_number_too_large EXCEPTION;
    PRAGMA EXCEPTION_INIT(phone_number_too_large, -12899);
    max_size NUMBER(2) := 15;
  BEGIN
    -- Check for NULL values
    IF P_COMPANY_NAME IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Company name cannot be NULL');
        RETURN;
    END IF;
    
    IF P_COMPANY_USERNAME IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Company username cannot be NULL');
        RETURN;
    END IF;
    
    IF P_COMPANY_PASSWORD IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Company password cannot be NULL');
        RETURN;
    END IF;
    
    IF P_COMPANY_EMAIL_ID IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Company email ID cannot be NULL');
        RETURN;
    END IF;
    
    IF P_PHONE_NUMBER IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Phone number cannot be NULL');
        RETURN;
    END IF;
    
    -- Do some database logic
    INSERT INTO MANAGEMENT_COMPANY VALUES(
    COMPANY_ID_SEQ.NEXTVAL,
    P_COMPANY_NAME,
    P_COMPANY_USERNAME,
    P_COMPANY_PASSWORD,
    P_COMPANY_EMAIL_ID,
    P_PHONE_NUMBER);
    
    IF LENGTH(P_PHONE_NUMBER) > max_size THEN
        RAISE phone_number_too_large;  
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Result: REGISTER SUCCESS');
    
  EXCEPTION
    WHEN phone_number_too_large THEN
      DBMS_OUTPUT.PUT_LINE('Result: PHONE_NUMBER SHOULD NOT BE MORE THAN 15 DIGITS');
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Result: REGISTER FAILED,COMPANY USERNAME ALREADY EXISTS PLEASE USE DIFFERENT USERNAME');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
  END COMPANY_REGISTER;
/



CREATE OR REPLACE PROCEDURE create_building (
   companyusername IN VARCHAR2,
   buildingname IN VARCHAR2,
   nooffloors IN NUMBER,
   noofparkingspots IN NUMBER,
   typeofbuilding IN VARCHAR2,
   address IN VARCHAR2,
   zip_code IN VARCHAR2
)
IS
   companyid NUMBER;
BEGIN
   -- Check for NULL values
   IF companyusername IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Error: Company username cannot be NULL');
      RETURN;
   END IF;
   
   IF buildingname IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Error: Building name cannot be NULL');
      RETURN;
   END IF;
   
   IF nooffloors IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Error: Number of floors cannot be NULL');
      RETURN;
   END IF;
   
   IF noofparkingspots IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Error: Number of parking spots cannot be NULL');
      RETURN;
   END IF;
   
   IF typeofbuilding IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Error: Type of building cannot be NULL');
      RETURN;
   END IF;
   
   IF address IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Error: Address cannot be NULL');
      RETURN;
   END IF;
   
   IF zip_code IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Error: Zip code cannot be NULL');
      RETURN;
   END IF;
   
   -- Get the company ID from the management_company table
   SELECT company_id INTO companyid FROM management_company WHERE lower(company_username) = lower(companyusername);
   
   -- Insert the building information into the building table
   INSERT INTO building
   VALUES (BUILDING_ID_SEQ.nextval,companyid,buildingname, nooffloors, noofparkingspots,typeofbuilding,address,zip_code);
   
   DBMS_OUTPUT.PUT_LINE('Result: Building Created');
   
EXCEPTION   
  WHEN DUP_VAL_ON_INDEX THEN
         DBMS_OUTPUT.PUT_LINE('Result: Building Already Exists, Please select different name');
  WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Result: Invalid Username.Please check company user name');
  WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/



CREATE OR REPLACE PROCEDURE add_unit (
  buildingname IN VARCHAR2,
  noofbedrooms IN NUMBER,
  noofbathrooms IN NUMBER,
  unit_price IN NUMBER,
  unit_area IN NUMBER,
  unitNo IN NUMBER
) AS
  buildingid NUMBER;
BEGIN
  IF buildingname IS NULL THEN
    dbms_output.put_line('Result: Building Name cannot be null.');
    RETURN;
  END IF;

  IF noofbedrooms IS NULL THEN
    dbms_output.put_line('Result: No of Bedrooms cannot be null.');
    RETURN;
  END IF;

  IF noofbathrooms IS NULL THEN
    dbms_output.put_line('Result: No of Bathrooms cannot be null.');
    RETURN;
  END IF;

  IF unit_area IS NULL THEN
    dbms_output.put_line('Result: Unit Area cannot be null.');
    RETURN;
  END IF;

  IF unitNo IS NULL THEN
    dbms_output.put_line('Result: Unit No cannot be null.');
    RETURN;
  END IF;

  SELECT building_id INTO buildingid FROM building WHERE lower(building_name) = lower(buildingname);
  INSERT INTO unit (unit_no, building_id, no_of_bedrooms, no_of_bathrooms, price, area)
    VALUES (buildingid || 0 || unitNo, buildingid, noofbedrooms, noofbathrooms, unit_price, unit_area);
    
  dbms_output.put_line('Result: Unit '|| unitNo || ' Added to '|| buildingname);
EXCEPTION   
  WHEN DUP_VAL_ON_INDEX THEN
    dbms_output.put_line('Result: Unit No Already Exists, Please select different unit no');
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('Result: Building Not Found.Please check Building name');
END;
/



CREATE OR REPLACE PROCEDURE add_tenant_to_unit(
  buildingname IN VARCHAR2,
  unitno IN NUMBER,
  Tenant_Fname in VARCHAR2,
  Tenant_Lname in VARCHAR2,
  Tenant_username in VARCHAR2,
  tenantpassword IN VARCHAR2,
  dob IN DATE,
  occupation IN VARCHAR2,
  phno IN VARCHAR2
)
IS
  tenantid NUMBER;
  leaseid NUMBER;
  buildingid NUMBER;
  currdate DATE;
  randomseqid NUMBER;
  unit_no_Fixed NUMBER;
  tenant_id_Fixed Number;
  lease_search NUMBER;
  GET_OUT exception;
BEGIN
    IF buildingname IS NULL OR unitno IS NULL OR Tenant_Fname IS NULL OR Tenant_Lname IS NULL OR Tenant_username IS NULL OR tenantpassword IS NULL OR dob IS NULL OR occupation IS NULL OR phno IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Missing required argument(s)');
        RETURN;
    END IF;

    SELECT SYSDATE INTO currdate FROM DUAL;

    BEGIN
        SELECT building_id INTO buildingid FROM building b WHERE lower(b.building_name) = lower(buildingname);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Could not find building with name ' || buildingname);
            RAISE GET_OUT;
    END;

    BEGIN
        SELECT tenant_id INTO tenant_id_Fixed from tenant t where lower(t.username) = lower(Tenant_username);
        dbms_output.put_line('Tenant ID successfully Retrevied');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN
                tenant_id_Fixed := buildingid|| 0 ||unitno|| 0 ||TENANT_ID_SEQ.nextval;
                INSERT INTO tenant VALUES (tenant_id_Fixed,Tenant_Fname,Tenant_Lname,Tenant_username, tenantpassword, dob, occupation, phno);
                dbms_output.put_line('Tenant Created');
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    dbms_output.put_line('Error: Username Already Exists. Please choose different username');
                    RAISE GET_OUT;
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error: Could not insert tenant record ' || SQLERRM);
                    RAISE GET_OUT;
            END;
    END;

    BEGIN
        INSERT INTO lease VALUES (LEASE_ID_SEQ.nextval,currdate, ADD_MONTHS(currdate, 12));
        dbms_output.put_line('Lease Created');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: Could not insert lease record ' || SQLERRM);
            RAISE GET_OUT;
    END;

    BEGIN
        lease_search := LEASE_ID_SEQ.currval;
        SELECT lease_id INTO leaseid FROM lease WHERE lease_id = lease_search;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Could not find lease record for tenant');
            RAISE GET_OUT;
    END;

    BEGIN
        select RANDOM_ID_SEQ.nextval into randomseqid from dual;
        unit_no_Fixed := buildingid|| 0 ||unitno;
        INSERT INTO Leased_units VALUES (randomseqid,leaseid, unit_no_Fixed, tenant_id_Fixed);
        DBMS_OUTPUT.PUT_LINE('Success: Tenant Added to the lease');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('Error: Lease Already exists on tenant name. Please choose different tenant or different unit');
            RAISE GET_OUT;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: Could not insert leased_unit record'|| SQLERRM);
            RAISE GET_OUT;
  END;

EXCEPTION
   WHEN GET_OUT THEN
   Rollback;

  
END;
/


CREATE OR REPLACE PROCEDURE add_maintenance_personnel(
    companyusername IN VARCHAR2,
    personnel_Fname IN VARCHAR2,
    personnel_Lname IN VARCHAR2,
    phone_number IN VARCHAR2
)
AS
  companyid NUMBER;
  GET_OUT exception;
  Search_count NUMBER;
BEGIN
  IF companyusername IS NULL OR personnel_Fname IS NULL OR personnel_Lname IS NULL OR phone_number IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Error: Required input parameter(s) is missing');
    RETURN;
  END IF;

  SELECT company_id INTO companyid FROM management_company WHERE LOWER(company_username) = LOWER(companyusername);
  BEGIN
    SELECT count(*) into Search_count FROM maintainance_personnel WHERE FIRSTNAME = personnel_Fname and LASTNAME = personnel_Lname;
    IF Search_count >=1 THEN
         RAISE GET_OUT;
    ELSE
      INSERT INTO maintainance_personnel VALUES (MAINTAINANCE_PERSON_ID_SEQ.NEXTVAL,personnel_Fname,personnel_Lname,companyid,phone_number);
      DBMS_OUTPUT.PUT_LINE('Success: Maintenance Person Created');
    END IF;
  END;
  EXCEPTION
  WHEN GET_OUT THEN
    DBMS_OUTPUT.PUT_LINE('Error: Person Already Exists');
  WHEN OTHERS THEN
    IF SQLERRM LIKE '%ORA-12899%' THEN
      DBMS_OUTPUT.PUT_LINE('Error: Please give correct phone number (maximum: 10 digits)');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Error: Could not insert record '|| SQLERRM);
      ROLLBACK;
    END IF;
END;
/


CREATE OR REPLACE PROCEDURE add_amenity(
    buildingname IN VARCHAR2,
    amenity IN VARCHAR2
)
AS
  buildingid NUMBER;
  amenityid NUMBER;
  Search_count NUMBER;
BEGIN
  IF buildingname IS NULL OR amenity IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Error: Building Name or Amenity is NULL');
    RETURN;
  END IF;
  
  BEGIN
    SELECT building_id INTO buildingid FROM building b WHERE lower(b.building_name) = lower(buildingname);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Building not found. Please check Building Name');
      RETURN;
  END;
  
  BEGIN
    SELECT amenity_id INTO amenityid FROM amenity WHERE lower(amenity_description) = lower(amenity);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Amenity not found.Please Contact Admin');
      RETURN;
  END;
  
  BEGIN
    SELECT count(*) into Search_count FROM building_has_amenity WHERE AMENITY_ID = amenityid and BUILDING_ID = buildingid;
    IF Search_count >=1 THEN
         DBMS_OUTPUT.PUT_LINE('Error: Amenity Already Exists in Building');
    ELSE
      INSERT INTO building_has_amenity VALUES (buildingid,amenityid,RANDOM_ID2_SEQ.nextval);
      DBMS_OUTPUT.PUT_LINE('Success: Amenity Added to Building');
    END IF;
  END;
  
  COMMIT;
  
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    ROLLBACK;
END;
/


CREATE OR REPLACE PROCEDURE delete_building(
    buildingName IN VARCHAR2
)
IS
BEGIN
    IF buildingName IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Building Name is NULL');
        RETURN;
    END IF;
    
    DELETE FROM building WHERE building_name = buildingName;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Building Does not Exists');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/


CREATE OR REPLACE PROCEDURE create_maintenance_requests(
    buildingname IN VARCHAR2,
    unitno IN NUMBER,
    RequestDescription IN VARCHAR2
)
IS
    mpersonnelid NUMBER;
    buildingid NUMBER;
    Search_count NUMBER;
    GET_OUT EXCEPTION;
BEGIN
    IF unitno IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Unit No cannot be NULL');
        RETURN;
    END IF;
    
    IF buildingname IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Building Name cannot be NULL');
        RETURN;
    END IF;
    
    IF RequestDescription IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Request Description cannot be NULL');
        RETURN;
    END IF;
    
    BEGIN
        SELECT building_id INTO buildingid FROM building b WHERE lower(b.building_name) = lower(buildingname);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('Building not found. Please check Building Name');
          RETURN;
    END; 
    
    BEGIN
        SELECT maintainance_person_id INTO mpersonnelid FROM maintainance_personnel WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('No data found in maintainance_personnel table.');
    END;
    
    BEGIN
        SELECT count(*) into Search_count FROM request WHERE Unit_no = buildingid|| 0 || unitno and Request_description = lower(RequestDescription);
        IF Search_count >=1 THEN
             RAISE GET_OUT;
        ELSE
          INSERT INTO request VALUES (REPAIR_REQUEST_ID_SEQ.nextval,buildingid|| 0 || unitno, mpersonnelid, lower(RequestDescription),0,sysdate);
          DBMS_OUTPUT.PUT_LINE('Success: Maintenance Request Created');
        END IF;
    END;

EXCEPTION
    WHEN GET_OUT THEN
        DBMS_OUTPUT.PUT_LINE('Error: Request Already Exists');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/


CREATE OR REPLACE PROCEDURE update_request_status(
  buidingName IN VARCHAR2,
  descr IN VARCHAR2,
  unit IN NUMBER
)
AS
  buildingid NUMBER;
BEGIN
  IF buidingName IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Error: Building name cannot be null');
    RETURN;
  END IF;

  IF descr IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Error: Request description cannot be null');
    RETURN;
  END IF;

  IF unit IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Error: Unit number cannot be null');
    RETURN;
  END IF;
  
  BEGIN
    SELECT building_id INTO buildingid FROM building b WHERE lower(b.building_name) = lower(buidingName);
    
    IF buildingid IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Error: Building does not exist');
      RETURN;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Error: Building does not exist');
      RETURN;
  END;
  
  BEGIN
    UPDATE request SET request_status = 1, request_date = SYSDATE WHERE unit_no = buildingid || 0 || unit AND request_description = lower(descr);
    DBMS_OUTPUT.PUT_LINE('Success: Status Changed');
    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Error: No request found for the given building, unit, and description');
      RETURN;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Error: No request found for the given building, unit, and description');
      RETURN;
  END;
  
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


select * from building;

CREATE OR REPLACE FUNCTION get_tenants(buildingname VARCHAR2, unitno NUMBER)
RETURN VARCHAR2
DETERMINISTIC
IS
  tenantname VARCHAR2(50);
  tenantid NUMBER;
  buildingid NUMBER;
BEGIN
  SELECT building_id INTO buildingid FROM building WHERE lower(building_name) = lower(buildingname);
  SELECT tenant_id INTO tenantid 
  FROM leased_units il 
  LEFT JOIN unit u ON il.unit_no = u.unit_no 
  WHERE il.unit_no = buildingid|| 0 ||unitno;
  
  SELECT First_name || ' ' || Last_name INTO tenantname 
  FROM tenant t  
  WHERE t.tenant_id = tenantid;
  
  RETURN tenantname;
END;
/

SELECT get_tenants('Building1', 101) FROM DUAL;


CREATE OR REPLACE PROCEDURE get_maintenance_requests(
  buildingname IN VARCHAR2,
  unitno IN NUMBER
)
IS
  buildingid NUMBER;
  description VARCHAR2(200);
  status VARCHAR2(20);
BEGIN
  SELECT building_id INTO buildingid FROM building WHERE lower(building_name) = lower(buildingname);
  SELECT request_description, request_status
  INTO description, status
  FROM request r 
  WHERE r.unit_no = buildingid || 0||unitno;
  
  -- do something with the result, such as print it to the console
  DBMS_OUTPUT.PUT_LINE('Description: ' || description);
  DBMS_OUTPUT.PUT_LINE('Status: ' || status);
END;
/