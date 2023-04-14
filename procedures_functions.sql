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

BEGIN
  COMPANY_ADMIN_LOGIN('YUVARAJfff_MY2', 'YUVARAJMY');
END;
