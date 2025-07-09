--Table ,function,procedure creation
ALTER SESSION SET CONTAINER = XEPDB1;
CONNECT novadup/nova123@localhost:1521/XEPDB1;
set linesize 200;
CONNECT nova/nova123@localhost:1521/XEPDB1;



CREATE TABLE doctor ( AadharID Varchar2(12) PRIMARY KEY, Name varchar2(100), Speciality varchar2(100), Experience number );
CREATE TABLE patient ( AadharID Varchar2(12) PRIMARY KEY, Name varchar2(100), Address varchar2(100), Age number, Primary_Phy_ID Varchar2(12) );
create table pharma_company( Name varchar2(100) primary key,PhoneNo varchar2(10));
create table pharmacy( Name varchar2(100) primary key,Address varchar2(100),PhoneNo varchar2(10));
create table drug(TradeName varchar2(100),CompanyName varchar2(100),Formula varchar2(100),primary key(TradeName,CompanyName));
create table prescription(PatientID varchar2(12),DoctorID varchar2(12),CompanyName varchar2(100),DrugName varchar2(100),Quantity number, Pres_Date date,primary key(PatientID,DoctorID,CompanyName,DrugName));
create table pharmacy_drug(PharmacyName varchar2(100),CompanyName varchar2(100),DrugName varchar2(100), price number,primary key(PharmacyName,CompanyName,DrugName));
create table contract(PharmacyName varchar2(100),CompanyName varchar2(100),Supervisor varchar2(100),StDate date, EndDate date, Content varchar2(100),primary key(PharmacyName,CompanyName));

--COLUMN TradeName FORMAT A20;
--COLUMN CompanyName FORMAT A15;
--COLUMN Formula FORMAT A25;


ALTER TABLE Patient
ADD CONSTRAINT fk_doctor
FOREIGN KEY (Primary_Phy_ID)
REFERENCES Doctor(AadharID);

ALTER TABLE Prescription
ADD CONSTRAINT fk_pres_doctor
FOREIGN KEY (DoctorID)
REFERENCES Doctor(AadharID);

ALTER TABLE Prescription
ADD CONSTRAINT fk_pres_patient
FOREIGN KEY (PatientID)
REFERENCES Patient(AadharID);
--
ALTER TABLE Contract
ADD CONSTRAINT fk_pharco_contract
FOREIGN KEY (CompanyName)
REFERENCES Pharma_Company(Name);

ALTER TABLE Drug
ADD CONSTRAINT fk_pharco_drug
FOREIGN KEY (CompanyName)
REFERENCES Pharma_Company(Name);
--

ALTER TABLE Pharmacy_Drug
ADD CONSTRAINT fk_phar_phardrug
FOREIGN KEY (PharmacyName)
REFERENCES Pharmacy(Name);

ALTER TABLE Contract
ADD CONSTRAINT fk_phar_contract
FOREIGN KEY (PharmacyName)
REFERENCES Pharmacy(Name);

--
ALTER TABLE Prescription
ADD CONSTRAINT fk_tradename_pres
FOREIGN KEY (DrugName,CompanyName)
REFERENCES Drug(TradeName,CompanyName);

ALTER TABLE Pharmacy_Drug
ADD CONSTRAINT fk_tradename_phardrug
FOREIGN KEY (DrugName,CompanyName)
REFERENCES Drug(TradeName,CompanyName);

--
create or replace procedure addPharmacy(
Name in Varchar2,
Address in Varchar2,
PhoneNo in Varchar2
) AS
BEGIN
INSERT INTO PHARMACY VALUES(Name,Address,PhoneNo);
end;

/
create or replace procedure addCompany(
Name in Varchar2,
PhoneNo in Varchar2
) AS
BEGIN
INSERT INTO Pharma_Company VALUES(Name,PhoneNo);
end;
/
create or replace procedure addPatient(
AadharID in Varchar2,
Name in Varchar2,
Address in Varchar2,
Age in number,
Primary_Phy_ID in Varchar2
) AS
BEGIN
INSERT INTO Patient VALUES(AadharID,Name,Address,Age,Primary_Phy_ID);
end;
/
create or replace procedure addDoctor(
AadharID in Varchar2,
Name in Varchar2,
Speciality in Varchar2,
Experience in number
) AS
BEGIN
INSERT INTO Doctor VALUES(AadharID,Name,Speciality,Experience);
end;
/
CREATE OR REPLACE PROCEDURE addPrescription (
p_patid in Varchar2,
p_docid in Varchar2,
CName in Varchar2,
DName in Varchar2,
Qty in number,
PDate in varchar2
) IS
P_date date;
BEGIN
    P_date := TO_DATE(PDate, 'DD MM YYYY');
    DELETE FROM Prescription
    WHERE PatientID = p_patid AND DoctorID = p_docid ;
    INSERT INTO Prescription VALUES(p_patid,p_docid,CName,DName,Qty,P_Date);
    
    COMMIT;
END;
/


create or replace procedure addContract(
PharmacyName in Varchar2,
CompanyName in Varchar2,
Supervisor in Varchar2,
StDate in Varchar2,
EndDate in Varchar2,
Content in Varchar2
) IS
st_date date;
end_date date;
BEGIN
st_date := TO_DATE(StDate, 'DD MM YYYY');
end_date:= TO_DATE(EndDate, 'DD MM YYYY');
INSERT INTO Contract VALUES(PharmacyName,CompanyName,Supervisor,st_date,end_date,Content);
end;
/

create or replace procedure addDrug(
TradeName in Varchar2,
CompanyName in Varchar2,
Formula in Varchar2
) AS
BEGIN
INSERT INTO Drug VALUES (TradeName ,CompanyName,Formula);
end;
/

--delete and update doctor exp
CREATE OR REPLACE PROCEDURE delete_doctor(p_id VARCHAR2) IS
BEGIN
    DELETE FROM doctor WHERE AadharID = p_id;
END;
/
CREATE OR REPLACE PROCEDURE update_doctor_exp(p_id VARCHAR2, p_exp NUMBER) IS
BEGIN
    UPDATE doctor SET Experience = p_exp WHERE AadharID = p_id;
END;
/
--delete and update patient address/primary physician
CREATE OR REPLACE PROCEDURE delete_patient(p_id VARCHAR2) IS
BEGIN
    DELETE FROM patient WHERE AadharID = p_id;
END;
/
CREATE OR REPLACE PROCEDURE update_patient_address(p_id VARCHAR2, p_addr VARCHAR2) IS
BEGIN
    UPDATE patient SET Address = p_addr WHERE AadharID = p_id;
END;
/
CREATE OR REPLACE PROCEDURE update_patient_primary_phy (p_id VARCHAR2, p_primphy VARCHAR2) IS
BEGIN
    UPDATE patient SET Primary_Phy_ID = p_primphy WHERE AadharID = p_id;
END;
/
--Pharma company delete and update phone 
CREATE OR REPLACE PROCEDURE delete_pharma_company(p_name VARCHAR2) IS
BEGIN
    DELETE FROM pharma_company WHERE Name = p_name;
END;
/
CREATE OR REPLACE PROCEDURE update_pharma_phone(p_name VARCHAR2, p_phone VARCHAR2) IS
BEGIN
    UPDATE pharma_company SET PhoneNo = p_phone WHERE Name = p_name;
END;
/
--Pharmacy delete and update phone 
CREATE OR REPLACE PROCEDURE delete_pharmacy(p_name VARCHAR2) IS
BEGIN
    DELETE FROM pharmacy WHERE Name = p_name;
END;
/
CREATE OR REPLACE PROCEDURE update_pharmacy_phone(p_name VARCHAR2, p_phone VARCHAR2) IS
BEGIN
    UPDATE pharmacy SET PhoneNo = p_phone WHERE Name = p_name;
END;
/
--Drug deletion
CREATE OR REPLACE PROCEDURE delete_drug(p_tradename VARCHAR2, p_compname VARCHAR2) IS
BEGIN
    DELETE FROM drug WHERE TradeName = p_tradename AND CompanyName = p_compname;
END;
/
CREATE OR REPLACE PROCEDURE update_drug_formula(p_tradename varchar2,p_compname varchar2,f varchar2) is
begin
     update drug set Formula = f where TradeName = p_tradename and CompanyName = p_compname;
end;
/

CREATE OR REPLACE PROCEDURE delete_prescription(p_pid VARCHAR2, p_did VARCHAR2, p_cname VARCHAR2, p_dname VARCHAR2) IS
BEGIN
    DELETE FROM prescription 
    WHERE PatientID = p_pid AND DoctorID = p_did AND CompanyName = p_cname AND DrugName = p_dname;
END;
/
CREATE OR REPLACE PROCEDURE delete_pharmacy_drug(p_pname VARCHAR2, p_cname VARCHAR2, p_dname VARCHAR2) IS
BEGIN
    DELETE FROM pharmacy_drug 
    WHERE PharmacyName = p_pname AND CompanyName = p_cname AND DrugName = p_dname;
END;
/
CREATE OR REPLACE PROCEDURE delete_contract(p_pname VARCHAR2, p_cname VARCHAR2) IS
BEGIN
    DELETE FROM contract WHERE PharmacyName = p_pname AND CompanyName = p_cname;
END;
/
--2nd
create or replace procedure report(patid varchar2, date1_str varchar2, date2_str varchar2) as
    D1 varchar2(12);
    C varchar2(30);
    D2 varchar2(30);
    Q number;
    patname varchar2(30);
    docname varchar2(30);
    D3 date;
    date1 date;
    date2 date;
    
    cursor cursor3 is
        select Name from Doctor where AadharID = (select Primary_Phy_ID from Patient where AadharID = patid);
    cursor cursor2 is
        select Name from Patient where AadharID = patid;
    cursor cursor1 is
        select DoctorID,CompanyName,DrugName,Quantity,Pres_Date 
        from Prescription 
        where PatientID = patid and Pres_Date < date2 and Pres_Date > date1;

begin
    -- Convert string dates to DATE type using DD-MM-YYYY format
    date1 := TO_DATE(date1_str, 'DD-MM-YYYY');
    date2 := TO_DATE(date2_str, 'DD-MM-YYYY');
    
    open cursor3;
    fetch cursor3 into docname;
    close cursor3;
    
    open cursor2;
    fetch cursor2 into patname;
    close cursor2;
    
    dbms_output.put_line('Report for '||patname||' with patient ID: '||patid||' between the dates '||TO_CHAR(date1, 'DD-MM-YYYY')||' and '||TO_CHAR(date2, 'DD-MM-YYYY'));
    
    open cursor1;
    loop
        fetch cursor1 into D1,C,D2,Q,D3;
        exit when cursor1%notfound;
        dbms_output.put_line('Prescription for '||patname||' with patient ID: '||patid||' prescribed by '||docname||' for '||Q||' units of '||D2||' from the Company '||C||' on '||TO_CHAR(D3, 'DD-MM-YYYY'));
    end loop;
    close cursor1;
end;
/
--3rd
 CREATE OR REPLACE PROCEDURE get_prescriptions_by_patient_and_date (
    pid IN VARCHAR2,
    p_pres_date_str IN VARCHAR2
)
AS
    did VARCHAR2(12);
    CNAME VARCHAR2(30);
    DRUG VARCHAR2(30);
    QUAN NUMBER;
    pname varchar2(30);
    dname varchar2(30);
    p_pres_date DATE;
    
    cursor c1 is
        SELECT DoctorID,CompanyName,DrugName,Quantity 
        FROM prescription 
        WHERE PatientID=PID AND Pres_date=p_pres_date;

BEGIN
    -- Convert string date to DATE type
    p_pres_date := TO_DATE(p_pres_date_str, 'DD-MM-YYYY');
    
    select Name into pname from Patient where AadharID = pid;
    select Name into dname from Doctor where AadharID = (select Primary_Phy_ID from Patient where AadharID = pid);
    
    open c1;
    fetch c1 into did,cname,drug,quan;
    close c1;
    
    dbms_output.put_line('Prescription for '||pname||' with patient ID: '||pid||' prescribed by '||dname||' for '||quan||' units of '||drug||' from the Company '||cname||' on '||TO_CHAR(p_pres_date, 'DD-MM-YYYY'));
END;
/
--4th
create or replace procedure drug_details(name in varchar2) as
drug_name varchar2(30);
cursor dr_cur is
select TradeName from drug where CompanyName=name;
begin
open dr_cur;
loop
fetch dr_cur into drug_name;
exit when dr_cur%notfound;
dbms_output.put_line(drug_name);
end loop;
close dr_cur;
end;
/
--5th
CREATE OR REPLACE PROCEDURE stock_position(pharmacy_name IN VARCHAR2) AS
    comp_name VARCHAR2(30);
    drug_name VARCHAR2(30);
    price_val NUMBER;

    CURSOR stock_cur IS
        SELECT CompanyName, DrugName, Price
        FROM pharmacy_drug
        WHERE PharmacyName = pharmacy_name;

BEGIN
    dbms_output.put_line('Stock Position for : ' || pharmacy_name);
    OPEN stock_cur;
    LOOP
        FETCH stock_cur INTO comp_name, drug_name, price_val;
        EXIT WHEN stock_cur%NOTFOUND;
        dbms_output.put_line('Drug: ' || drug_name || ', Company: ' || comp_name || ', Price: ' || price_val||' rupees');
    END LOOP;
    CLOSE stock_cur;
END;
/
--6th
CREATE OR REPLACE PROCEDURE contract_details(
    p_pharmacy_name IN VARCHAR2,
    p_company_name IN VARCHAR2
) AS
    supervisor_name VARCHAR2(30);
    start_d DATE;
    end_d DATE;
    content_txt VARCHAR2(100);
BEGIN
    SELECT Supervisor, StDate, EndDate, Content
    INTO supervisor_name, start_d, end_d, content_txt
    FROM contract
    WHERE PharmacyName = p_pharmacy_name AND CompanyName = p_company_name;

    dbms_output.put_line('--- Contract Details ---');
    dbms_output.put_line('Pharmacy: ' || p_pharmacy_name);
    dbms_output.put_line('Company: ' || p_company_name);
    dbms_output.put_line('Supervisor: ' || supervisor_name);
    dbms_output.put_line('Start Date: ' || start_d);
    dbms_output.put_line('End Date: ' || end_d);
    dbms_output.put_line('Content: ' || content_txt);
END;
/

--7th
create or replace procedure Doctor_List(doc_id varchar2) as
patient_name varchar2(30);
cursor curs is 
select Name from Patient where Primary_Phy_ID = doc_id;
begin
open curs;
loop
fetch curs into patient_name;
exit when curs%notfound;
dbms_output.put_line(patient_name);
end loop;
close curs;
end;
/

--

INSERT INTO doctor VALUES ('111122223333', 'Dr. Sharma', 'Cardiology', 15);
INSERT INTO doctor VALUES ('222233334444', 'Dr. Patel', 'Pediatrics', 8);
INSERT INTO doctor VALUES ('333344445555', 'Dr. Gupta', 'Neurology', 20);
INSERT INTO doctor VALUES ('444455556666', 'Dr. Reddy', 'Oncology', 12);
INSERT INTO doctor VALUES ('555566667777', 'Dr. Khan', 'General Medicine', 10);

INSERT INTO patient VALUES ('666677778888', 'Rahul Verma', '12 MG Road, Bangalore', 35, '111122223333');
INSERT INTO patient VALUES ('777788889999', 'Priya Singh', '45 Koramangala, Bangalore', 28, '222233334444');
INSERT INTO patient VALUES ('888899990000', 'Amit Joshi', '78 Indiranagar, Bangalore', 42, '333344445555');
INSERT INTO patient VALUES ('999900001111', 'Neha Kapoor', '23 Jayanagar, Bangalore', 50, '444455556666');
INSERT INTO patient VALUES ('000011112222', 'Vikram Malhotra', '56 Whitefield, Bangalore', 65, '555566667777');

INSERT INTO pharma_company VALUES ('Sun Pharma', '9876543210');
INSERT INTO pharma_company VALUES ('Cipla', '8765432109');
INSERT INTO pharma_company VALUES ('Dr. Reddy''s', '7654321098');
INSERT INTO pharma_company VALUES ('Lupin', '6543210987');
INSERT INTO pharma_company VALUES ('Glenmark', '5432109876');

INSERT INTO pharmacy VALUES ('NOVA Central', '100 Brigade Road, Bangalore', '9876123450');
INSERT INTO pharmacy VALUES ('NOVA Health Plus', '45 Malleshwaram, Bangalore', '8765234561');
INSERT INTO pharmacy VALUES ('NOVA Care', '78 Koramangala 5th Block, Bangalore', '7654345672');
INSERT INTO pharmacy VALUES ('NOVA Wellness', '23 Indiranagar 100ft Road, Bangalore', '6543456783');
INSERT INTO pharmacy VALUES ('NOVA Life', '56 Whitefield Main Road, Bangalore', '5432567894');

-- Sun Pharma drugs
INSERT INTO drug VALUES ('Pantop', 'Sun Pharma', 'Pantoprazole Sodium');
INSERT INTO drug VALUES ('Rosuvas', 'Sun Pharma', 'Rosuvastatin Calcium');
INSERT INTO drug VALUES ('Volix', 'Sun Pharma', 'Voglibose');

-- Cipla drugs
INSERT INTO drug VALUES ('Montair', 'Cipla', 'Montelukast Sodium');
INSERT INTO drug VALUES ('Cipcal', 'Cipla', 'Calcium Carbonate');
INSERT INTO drug VALUES ('Seroquel', 'Cipla', 'Quetiapine Fumarate');

-- Dr. Reddy's drugs
INSERT INTO drug VALUES ('Omez', 'Dr. Reddy''s', 'Omeprazole');
INSERT INTO drug VALUES ('Razo', 'Dr. Reddy''s', 'Rabeprazole Sodium');
INSERT INTO drug VALUES ('Nise', 'Dr. Reddy''s', 'Nimesulide');

-- Lupin drugs
INSERT INTO drug VALUES ('Lupifin', 'Lupin', 'Fexofenadine Hydrochloride');
INSERT INTO drug VALUES ('Lupoxa', 'Lupin', 'Oxcarbazepine');
INSERT INTO drug VALUES ('Lupitril', 'Lupin', 'Clonazepam');

-- Glenmark drugs
INSERT INTO drug VALUES ('Telma', 'Glenmark', 'Telmisartan');
INSERT INTO drug VALUES ('Cetanil', 'Glenmark', 'Cetirizine Hydrochloride');
INSERT INTO drug VALUES ('Remylin', 'Glenmark', 'Memantine Hydrochloride');
-- NOVA Central prices
INSERT INTO pharmacy_drug VALUES ('NOVA Central', 'Sun Pharma', 'Pantop', 120);
INSERT INTO pharmacy_drug VALUES ('NOVA Central', 'Sun Pharma', 'Rosuvas', 180);
INSERT INTO pharmacy_drug VALUES ('NOVA Central', 'Cipla', 'Montair', 95);
INSERT INTO pharmacy_drug VALUES ('NOVA Central', 'Dr. Reddy''s', 'Omez', 85);
INSERT INTO pharmacy_drug VALUES ('NOVA Central', 'Lupin', 'Lupifin', 110);

-- NOVA Health Plus prices
INSERT INTO pharmacy_drug VALUES ('NOVA Health Plus', 'Sun Pharma', 'Pantop', 125);
INSERT INTO pharmacy_drug VALUES ('NOVA Health Plus', 'Cipla', 'Cipcal', 65);
INSERT INTO pharmacy_drug VALUES ('NOVA Health Plus', 'Dr. Reddy''s', 'Razo', 150);
INSERT INTO pharmacy_drug VALUES ('NOVA Health Plus', 'Lupin', 'Lupoxa', 200);
INSERT INTO pharmacy_drug VALUES ('NOVA Health Plus', 'Glenmark', 'Telma', 175);

-- NOVA Care prices
INSERT INTO pharmacy_drug VALUES ('NOVA Care', 'Cipla', 'Seroquel', 220);
INSERT INTO pharmacy_drug VALUES ('NOVA Care', 'Dr. Reddy''s', 'Nise', 45);
INSERT INTO pharmacy_drug VALUES ('NOVA Care', 'Lupin', 'Lupitril', 85);
INSERT INTO pharmacy_drug VALUES ('NOVA Care', 'Glenmark', 'Cetanil', 55);
INSERT INTO pharmacy_drug VALUES ('NOVA Care', 'Glenmark', 'Remylin', 300);

-- NOVA Wellness prices
INSERT INTO pharmacy_drug VALUES ('NOVA Wellness', 'Sun Pharma', 'Volix', 90);
INSERT INTO pharmacy_drug VALUES ('NOVA Wellness', 'Cipla', 'Montair', 100);
INSERT INTO pharmacy_drug VALUES ('NOVA Wellness', 'Dr. Reddy''s', 'Omez', 80);
INSERT INTO pharmacy_drug VALUES ('NOVA Wellness', 'Lupin', 'Lupifin', 115);
INSERT INTO pharmacy_drug VALUES ('NOVA Wellness', 'Glenmark', 'Telma', 170);

-- NOVA Life prices
INSERT INTO pharmacy_drug VALUES ('NOVA Life', 'Sun Pharma', 'Rosuvas', 185);
INSERT INTO pharmacy_drug VALUES ('NOVA Life', 'Cipla', 'Cipcal', 60);
INSERT INTO pharmacy_drug VALUES ('NOVA Life', 'Dr. Reddy''s', 'Razo', 155);
INSERT INTO pharmacy_drug VALUES ('NOVA Life', 'Lupin', 'Lupoxa', 195);
INSERT INTO pharmacy_drug VALUES ('NOVA Life', 'Glenmark', 'Cetanil', 50);

INSERT INTO contract VALUES ('NOVA Central', 'Sun Pharma', 'Mr. Agarwal', TO_DATE('01-JAN-2024', 'DD-MON-YYYY'), TO_DATE('31-DEC-2024', 'DD-MON-YYYY'), 'Annual supply contract for Sun Pharma drugs');
INSERT INTO contract VALUES ('NOVA Health Plus', 'Cipla', 'Ms. Desai', TO_DATE('15-FEB-2024', 'DD-MON-YYYY'), TO_DATE('14-FEB-2025', 'DD-MON-YYYY'), 'Exclusive Cipla products contract');
INSERT INTO contract VALUES ('NOVA Care', 'Dr. Reddy''s', 'Mr. Iyer', TO_DATE('01-MAR-2024', 'DD-MON-YYYY'), TO_DATE('28-FEB-2025', 'DD-MON-YYYY'), 'Dr. Reddy''s products with 10% discount');
INSERT INTO contract VALUES ('NOVA Wellness', 'Lupin', 'Ms. Choudhary', TO_DATE('10-APR-2024', 'DD-MON-YYYY'), TO_DATE('09-APR-2025', 'DD-MON-YYYY'), 'Lupin specialty drugs contract');
INSERT INTO contract VALUES ('NOVA Life', 'Glenmark', 'Mr. Kapoor', TO_DATE('20-MAY-2024', 'DD-MON-YYYY'), TO_DATE('19-MAY-2025', 'DD-MON-YYYY'), 'Glenmark cardiovascular drugs');
INSERT INTO prescription VALUES ('666677778888', '111122223333', 'Sun Pharma', 'Pantop', 30, TO_DATE('10-MAR-2024', 'DD-MON-YYYY'));
INSERT INTO prescription VALUES ('666677778888', '111122223333', 'Sun Pharma', 'Rosuvas', 15, TO_DATE('10-MAR-2024', 'DD-MON-YYYY'));
INSERT INTO prescription VALUES ('777788889999', '222233334444', 'Cipla', 'Montair', 60, TO_DATE('15-MAR-2024', 'DD-MON-YYYY'));
INSERT INTO prescription VALUES ('888899990000', '333344445555', 'Dr. Reddy''s', 'Omez', 45, TO_DATE('20-MAR-2024', 'DD-MON-YYYY'));
INSERT INTO prescription VALUES ('999900001111', '444455556666', 'Lupin', 'Lupifin', 90, TO_DATE('25-MAR-2024', 'DD-MON-YYYY'));
INSERT INTO prescription VALUES ('000011112222', '555566667777', 'Glenmark', 'Telma', 30, TO_DATE('30-MAR-2024', 'DD-MON-YYYY'));
INSERT INTO prescription VALUES ('666677778888', '111122223333', 'Cipla', 'Montair', 20, TO_DATE('05-APR-2024', 'DD-MON-YYYY'));
INSERT INTO prescription VALUES ('777788889999', '222233334444', 'Dr. Reddy''s', 'Razo', 30, TO_DATE('10-APR-2024', 'DD-MON-YYYY'));

