CREATE DATABASE FinalProject;

USE FinalProject;

CREATE TABLE DonorDetails
(Donor_ID INT NOT NULL PRIMARY KEY,
Donor_Name VARCHAR(30) NOT NULL,
Donor_Age INT NULL,
Gender VARCHAR(10) NULL,
Blood_Group VARCHAR(4)  NOT NULL,
Location VARCHAR (30) NOT NULL,
Day INT NULL,
Month INT NULL,
Year INT NULL);

INSERT INTO DonorDetails
VALUES
("1", "James Elijah","21", "Male", "A+", "Hillingdon", "12","10","2022"),
("2", "Michelle Robinson","38","Female","AB-","Victoria","01","04","2020"),
("3", "Josie Manfred", "50", "Female", "O-","Birmingham","27","07","2023"),
("4", "Luke Smith","32", "Male", "B+","Croydon","31","01","2021"),
("5",'Rose Clara',"26","Female",'A-',"Nottingham","15","03","2022"),
("6",'Ray Spencer',"45","Female",'O+', "London","28","06","2023"),
("7",'Jose Adams','29','Male','AB+','Ilford','09','12','2021'),
("8",'Charlie Mudson','55','Male','B-','Wembley','23','05','2023'),
("9",'Reign Stomy','25','Male','AB-','Leciester','03','11','2020'),
("10",'Emily Davidson','29','Female','A-','Milton Keynes','17','05','2020');


select * from DonorDetails;

CREATE TABLE PatientDetails
(Patient_ID INT NOT NULL PRIMARY KEY,
Patient_Name VARCHAR(30) NOT NULL,
Patient_Age INT NOT NULL,
Gender VARCHAR(10) NOT NULL,
Blood_Group VARCHAR(4) NOT NULL,
Location VARCHAR (20) NOT NULL,
Day INT NULL,
Month INT NULL,
Year INT NULL);

INSERT INTO PatientDetails
VALUES
("11", "Adam Smith","10", "Male", "O-", "London", "15","01","2021"),
("12", "Phil Dunphy","48","Male","B-","Manchester","20","07","2021"),
("13", "Gaberiela Hasting", "50", "Female", "AB+","Milton Keynes","13","08","2022"),
("14", "Aria Fields","32", "Female", "B+","Croydon","20","06","2022"),
("15",'Mike Monte',"26","Male",'A+',"Nottingham","18","04","2020"),
("16",'Toby Briar',"45","Male",'A-', "Croydon","09","09","2021"),
("17",'Steven Longfield','29','Male','AB-','Nottingham','01','12','2023'),
("18",'Amy Jackson','55','Female','O+','Wembley','07','03','2020'),
("19",'Elle Stormy','25','Female','AB+','Wembley','20','08','2021'),
("20",'Kim Davidson','29','Female','A-','Oxford','14','06','2023');

select * from PatientDetails;

CREATE TABLE BloodDonor
(PatientID INT NOT NULL,
DonorID INT NOT NULL,
Blood_Type VARCHAR (5) NOT NULL,
Date_received INT NOT NULL,
Month_received INT NOT NULL,
Year_received INT NOT NULL,
Hospital_Name VARCHAR (50) NOT NULL,
Location VARCHAR(20)NOT NULL,
AmountofBD_ml INT NOT NULL);


INSERT INTO BloodDonor
VALUES
("11","3","O-", "15","01","2021","Guy's Hospital","London",500),
("12","8","B-","20","07","2021","Nottingham Blood Donor Centre","Nottingham",460),
("13","7","AB+","13","08","2022","Royal London Hospital","London",560),
("14","4","B+","20","06","2022", "St George's Hospital","South London",1000),
("15","1","A+","18","04","2020","London West End Blood Donor Centre","London",1200),
("16","10","A-","09","09","2021","Edgware Blood Donor Centre","North-west London",800),
("17","2","AB-",'01','12','2023',"White City NHS Blood Donor Centre","London",510),
("18","6","O+",'07','03','2020',"Manchester Blood Donor Centre","Manchester",460),
("19","7","AB+",'20','08','2021',"Manchester Blood Donor Centre","Manchester",700),
("20","5","A-",'14','06','2023',"St George's Hospital", "South London",800);

select * from BloodDonor;

-- MONTH TABLE
CREATE TABLE BDDateTable
(MonthNo INT PRIMARY KEY,
MonthName VARCHAR(20),
QuarterName VARCHAR(2));

INSERT INTO BDDateTable
VALUES
(1, "January", "Q1"),
(2, "February", "Q1"),
(3, "March", "Q1"),
(4, "April", "Q2"),
(5, "May", "Q2"), 
(6, "June","Q2"),
(7, "July", "Q3"),
(8, "August", "Q3"),
(9, "September", "Q3"),
(10, "October", "Q4"),
(11, "November", "Q4"),
(12, "December", "Q4");

-- YEAR TABLE
CREATE TABLE BDYear
(Year INT NOT NULL PRIMARY KEY);

INSERT INTO BDYear
VALUES
(2020),
(2021),
(2022),
(2023);

-- Set Primary and Foreign Key constraints to create relations between the tables 
ALTER TABLE BloodDonor
ADD CONSTRAINT FKMonth
FOREIGN KEY (Month_received)
REFERENCES
BDDateTable(MonthNo);

ALTER TABLE BloodDonor
ADD CONSTRAINT FKYear
FOREIGN KEY (Year_received)
REFERENCES 
BDYear(Year);

ALTER TABLE BloodDonor
ADD CONSTRAINT FKPatient_ID
FOREIGN KEY(PatientID)
REFERENCES
PatientDetails(Patient_ID);

ALTER TABLE BloodDonor
ADD CONSTRAINT FKDonor_ID
FOREIGN KEY(DonorID)
REFERENCES
DonorDetails(Donor_ID);

Select P1.Donor_ID as DonorID, P2.Patient_ID as PatientID, P1.Blood_Group as BloodDonor, P2.Blood_Group as BloodPatient
FROM DonorDetails P1
INNER JOIN PatientDetails P2
ON P1.Blood_Group=P2.Blood_Group;

-- Left and Right join 

SELECT * FROM DonorDetails P1
LEFT JOIN PatientDetails P2 ON P1.Blood_Group = P2.Blood_Group
UNION
SELECT * FROM DonorDetails P1
RIGHT JOIN PatientDetails P2 ON P1.Blood_Group = P2.Blood_Group;

-- A subquery to demonstrate how to extract data from your DB for analysis 

SELECT * from BloodDonor
WHERE Blood_Type = "AB-"
AND Location= "London";

Select * from Donordetails
WHERE Blood_Group= 'A-';

select DonorID, SUM(AmountofBD_ml) AS TotalDonor from BloodDonor
Group by DonorID;

SELECT DonorID,
COUNT(AmountofBD_ml) AS DonorCount,
MIN(AmountofBD_ml) AS 'Minimum_Donation(ml)',
MAX(AmountofBD_ml) AS 'Maximum_Donation(ml)'
From BloodDonor
GROUP BY DonorID;

-- GROUP BY and Having query
SELECT
Distinct(Hospital_Name),
COUNT(Hospital_Name)AS 'No.Hospital'
FROM BloodDonor
Group by Hospital_Name
HAVING COUNT(PatientID)>1;


CREATE OR REPLACE VIEW PersonalDetails
AS 
SELECT  
PatientDetails.Gender As 'Patient Gender',
BloodDonor.Blood_Type AS 'Blood Group',
PatientDetails.Patient_Age AS Age
FROM BloodDonor
LEFT JOIN PatientDetails 
ON PatientDetails.Patient_ID = BloodDonor.PatientID
WHERE BloodDonor.PatientID = PatientDetails.Patient_ID;


SELECT * FROM PersonalDetails;

CREATE OR REPLACE VIEW JoinTable_Personal
AS 
SELECT 
BloodDonor.Hospital_Name, 
PatientDetails.Patient_Age,
BloodDonor.Blood_Type,
BloodDonor.AmountofBD_ml,
DonorDetails.Donor_Age,
DonorDetails.Blood_Group
FROM BloodDonor
LEFT JOIN PatientDetails 
ON PatientDetails.Patient_ID = BloodDonor.PatientID
LEFT JOIN DonorDetails 
ON DonorDetails.Donor_ID = BloodDonor.DonorID
#tO ADD 
#LEFT JOIN T4NAME
#ON T4NAME.T4COL = T1NAME.T1.COL
WHERE PatientDetails.Patient_ID = BloodDonor.PatientID
AND DonorDetails.Donor_ID = BloodDonor.DonorID;

SELECT * FROM JoinTable_Personal;

##To see the query you used to make a View later: two methods

SELECT VIEW_DEFINITION FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'JoinTable_Personal';

SHOW CREATE VIEW JoinTable_Personal;

CREATE OR REPLACE VIEW VW_Table1
AS 
SELECT 
PatientID, 
DonorID,
Concat(Date_received, "/", Month_received, "/",Year_received) AS "Date",
Location,
AmountofBD_ml
FROM BloodDonor
ORDER BY PatientID ASC;

SELECT * FROM VW_Table1;

CREATE OR REPLACE VIEW Table1
AS 
SELECT 
PatientID, 
DonorID,
Concat(Date_received, "/", Month_received, "/",Year_received) AS "Date",
AmountofBD_ml,
Location
FROM BloodDonor
WHERE Location = "London"
WITH CHECK OPTION;

SELECT * FROM Table1;

-- Stored function
DELIMITER //
CREATE PROCEDURE InsertInfo
(
IN Donor_ID INT, 
IN Donor_Name VARCHAR(30),
IN Donor_Age INT,
IN Gender VARCHAR(10),
IN Blood_Group VARCHAR(4),
IN Location VARCHAR (30),
IN Day INT,
IN Month INT,
Year INT)
BEGIN
INSERT INTO DonorDetails(Donor_ID, Donor_Name, Donor_Age, Gender, Blood_Group, Location, Day, Month, Year)
VALUES (Donor_ID, Donor_Name, Donor_Age, Gender, Blood_Group, Location, Day, Month, Year);
END//

DELIMITER ;

CALL InsertInfo (35, "Oliva Yendale", 20, "Female", "O-", "London", 07, 04, 2023);

SELECT * from DonorDetails;

DELIMITER $$
CREATE PROCEDURE InsertPatientData
(
IN Patient_ID INT,
IN Patient_name VARCHAR(30),
IN Patient_Age INT,
IN Gender VARCHAR(10),
IN Blood_Group VARCHAR(4),
IN Location VARCHAR (20),
IN Day INT,
IN Month INT,
IN Year INT)
BEGIN
INSERT INTO PatientDetails(Patient_ID, Patient_Name, Patient_Age, Gender, Blood_Group, Location, Day, Month, Year)
VALUES (Patient_ID, Patient_Name, Patient_Age, Gender, Blood_Group, Location, Day, Month, Year);
END$$

DELIMITER ;
#DROP PROCEDURE InsertPatientData;

CALL InsertPatientData (34, "Elvis Jacob", 18, "Male", "A-", "Nottingham", 12,12,2020);

Select * from PatientDetails;

-- Create a trigger 
USE FinalProject;
SELECT *
FROM FinalProject.DonorDetails;
## BEFORE Trigger Example - this one ensures font consistency for inserted items
## Change Delimiter
DELIMITER \\
CREATE TRIGGER DonorName_Before_Insert
BEFORE INSERT on DonorDetails				#fires trigger before/after action
FOR EACH ROW
BEGIN
	SET NEW.Donor_name = CONCAT(UPPER(SUBSTRING(NEW.Donor_name,1,1)),
						LOWER(SUBSTRING(NEW.Donor_name FROM 2)));
END\\
-- Change Delimiter
DELIMITER ;
-- Insert Data
INSERT INTO DonorDetails(Donor_ID, Donor_Name, Donor_Age, Gender, Blood_Group, Location, Day, Month, Year)
VALUES
(111, 'james carter', 18, 'Male', 'O-', 'London', 21, 08, 2021),
(123, 'sophie henderson', 25, 'Female', 'A+', 'Liverpool', 08, 01, 2020);
SELECT *
FROM FinalProject.DonorDetails;
DROP TRIGGER DonorName_Before_Insert;

