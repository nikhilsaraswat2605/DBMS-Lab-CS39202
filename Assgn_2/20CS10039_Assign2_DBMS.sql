DROP TABLE IF EXISTS On_Call;
DROP TABLE IF EXISTS Undergoes;
DROP TABLE IF EXISTS Trained_In;
DROP TABLE IF EXISTS `Procedure`;
DROP TABLE IF EXISTS Affiliated_with;
DROP TABLE IF EXISTS Prescribes;
DROP TABLE IF EXISTS Medication;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Stay;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS Block;
DROP TABLE IF EXISTS Nurse;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Physician;

CREATE TABLE Physician (
    EmployeeID INTEGER NOT NULL,
    Name VARCHAR(40) NOT NULL,
    Position VARCHAR(40) NOT NULL,
    SSN INTEGER NOT NULL,
    PRIMARY KEY(EmployeeID)
); 

CREATE TABLE `Procedure` (
    Code INTEGER NOT NULL,
    Name VARCHAR(40) NOT NULL,
    Cost INTEGER NOT NULL,
    PRIMARY KEY(Code)
);

CREATE TABLE Trained_In (
    Physician INTEGER NOT NULL,
    Treatment INTEGER NOT NULL,
    CertificationDate DATETIME NOT NULL,
    CertificationExpires DATETIME NOT NULL,
    PRIMARY KEY(Physician, Treatment),
    FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
    FOREIGN KEY(Treatment) REFERENCES `Procedure`(Code)
);

CREATE TABLE Medication (
    Code INTEGER NOT NULL,
    Name VARCHAR(40) NOT NULL,
    Brand VARCHAR(40) NOT NULL,
    Description VARCHAR(150) NOT NULL,
    PRIMARY KEY(Code)
);

CREATE TABLE Nurse (
    EmployeeID INTEGER NOT NULL,
    Name VARCHAR(40) NOT NULL,
    Position VARCHAR(40) NOT NULL,
    Registered BOOLEAN NOT NULL,
    SSN INTEGER NOT NULL,
    PRIMARY KEY(EmployeeID)
);

CREATE TABLE Block (
    Floor INTEGER NOT NULL,
    Code INTEGER NOT NULL,
    PRIMARY KEY(Floor, Code)
); 

CREATE TABLE On_Call (
    Nurse INTEGER NOT NULL,
    BlockFloor INTEGER NOT NULL, 
    BlockCode INTEGER NOT NULL,
    Start DATETIME NOT NULL,
    End DATETIME NOT NULL,
    PRIMARY KEY(Nurse, BlockFloor, BlockCode, Start, End),
    FOREIGN KEY(Nurse) REFERENCES Nurse(EmployeeID),
    FOREIGN KEY(BlockFloor, BlockCode) REFERENCES Block(Floor, Code) 
);

CREATE TABLE Room (
    Number INTEGER NOT NULL,
    Type VARCHAR(40) NOT NULL,
    BlockFloor INTEGER NOT NULL,    
    BlockCode INTEGER NOT NULL,    
    Unavailable BOOLEAN NOT NULL,
    PRIMARY KEY(Number),
    FOREIGN KEY(BlockFloor, BlockCode) REFERENCES Block(Floor, Code)
);


CREATE TABLE Patient (
    SSN INTEGER NOT NULL,
    Name VARCHAR(40) NOT NULL,
    Address VARCHAR(150) NOT NULL,
    Phone VARCHAR(40) NOT NULL,
    InsuranceID INTEGER NOT NULL,
    PCP INTEGER NOT NULL,
    PRIMARY KEY(SSN),
    FOREIGN KEY(PCP) REFERENCES Physician(EmployeeID)
);

CREATE TABLE Stay (
    StayID INTEGER NOT NULL,
    Patient INTEGER NOT NULL,
    Room INTEGER NOT NULL,
    Start DATETIME NOT NULL,
    End DATETIME NOT NULL,
    PRIMARY KEY(StayID),
    FOREIGN KEY(Patient) REFERENCES Patient(SSN),
    FOREIGN KEY(Room) REFERENCES Room(Number)
);

CREATE TABLE Department (
    DepartmentID INTEGER NOT NULL,
    Name VARCHAR(40) NOT NULL,
    Head INTEGER NOT NULL,
    PRIMARY KEY(DepartmentID),
    FOREIGN KEY(Head) REFERENCES Physician(EmployeeID)
);

CREATE TABLE Affiliated_with (
    Physician INTEGER NOT NULL,
    Department INTEGER NOT NULL,
    PrimaryAffiliation BOOLEAN NOT NULL,
    PRIMARY KEY(Physician, Department),
    FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
    FOREIGN KEY(Department) REFERENCES Department(DepartmentID)
);

CREATE TABLE Appointment (
    AppointmentID INTEGER NOT NULL,
    Patient INTEGER NOT NULL,        
    PrepNurse INTEGER,
    Physician INTEGER NOT NULL,
    Start DATETIME NOT NULL,
    End DATETIME NOT NULL,
    ExaminationRoom TEXT NOT NULL,
    PRIMARY KEY(AppointmentID),
    FOREIGN KEY(Patient) REFERENCES Patient(SSN),
    FOREIGN KEY(PrepNurse) REFERENCES Nurse(EmployeeID),
    FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID)
);

CREATE TABLE Prescribes (
    Physician INTEGER NOT NULL,
    Patient INTEGER NOT NULL, 
    Medication INTEGER NOT NULL, 
    Date DATETIME NOT NULL,
    Appointment INTEGER,    
    Dose VARCHAR(40) NOT NULL,
    PRIMARY KEY(Physician, Patient, Medication, Date),
    FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
    FOREIGN KEY(Patient) REFERENCES Patient(SSN),
    FOREIGN KEY(Medication) REFERENCES Medication(Code),
    FOREIGN KEY(Appointment) REFERENCES Appointment(AppointmentID)
);

CREATE TABLE Undergoes (
    Patient INTEGER NOT NULL,
    `Procedure` INTEGER NOT NULL,
    Stay INTEGER NOT NULL,
    Date DATETIME NOT NULL,
    Physician INTEGER NOT NULL,
    AssistingNurse INTEGER,
    PRIMARY KEY(Patient, `Procedure`, Stay, Date),
    FOREIGN KEY(Patient) REFERENCES Patient(SSN),
    FOREIGN KEY(`Procedure`) REFERENCES `Procedure`(Code),
    FOREIGN KEY(Stay) REFERENCES Stay(StayID),
    FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
    FOREIGN KEY(AssistingNurse) REFERENCES Nurse(EmployeeID)
);
/* Data population */
-- Physician Data
INSERT INTO
Physician (EmployeeID, Name, Position, SSN)
VALUES
(1, 'Abhijeet', 'Medical Director', 1),
(2, 'Shivansh', 'Senior Resident', 2),
(3, 'Abhay', 'Medical Director', 3),
(4, 'Rushil', 'Head of Department', 4),
(5, 'Amit', 'Head of Department', 5),
(9, 'Jay', 'Surgeon', 12);
-- Procedure Data
INSERT INTO
`Procedure` (Code, Name, Cost)
VALUES
(1, 'bypass surgery', 450000),
(2, 'RTPCR test', 1400),
(3, 'Immunotherapy', 30010),
(4, 'colonoscopy', 255000),
(5, 'CT Scan', 10000);
-- Department
INSERT INTO
Department (DepartmentID, Name, Head)
VALUES
(1, 'cardiology', 4),
(2, 'Orthopedics', 5),
(3, 'Oncology', 3),
(4, 'Gastroenterology', 9);
(5, 'Neurology', 9);
-- Affiliated_with
INSERT INTO
Affiliated_with (Physician, Department, PrimaryAffiliation)
VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 1, 1),
(5, 2, 1),
(9, 2, 1),
(9, 4, 1);
-- Trained In
INSERT INTO
Trained_In (
Physician,
Treatment,
CertificationDate,
CertificationExpires
)
VALUES
(1, 1, '2020-01-03', '2024-01-03'),
(2, 4, '2020-11-13', '2023-01-13'),
(3, 5, '2020-10-07', '2024-04-07'),
(4, 1, '2021-04-20', '2025-04-20'),
(5, 1, '2021-01-17', '2026-01-17');
-- Block
INSERT INTO
Block (Floor, Code)
VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 1);
-- Nurse
INSERT INTO
Nurse (EmployeeID, Name, Position, Registered, SSN)
VALUES
(6, 'Sarita', 'Registered Nurse', 1, 6),
(7, 'Vaishnavi', 'Nurse Practitioner', 0, 7),
(8, 'Anjali', 'icu Registered Nurse', 1, 8),
(9, 'Seema', 'Nurse Practitioner', 0, 9),
(10, 'Sakshi', 'Nurse Practitioner', 0, 10);
-- Room
INSERT INTO
Room (Number, Type, BlockFloor, BlockCode, Unavailable)
VALUES
(121, 'icu', 1, 1, 0),
(122, 'Operation Theatre', 1, 2, 0),
(123, 'Single Room', 2, 1, 0),
(124, 'Single Room', 2, 1, 0),
(125, 'Ventilator', 3, 1, 1),
(126, 'Ventilator', 3, 1, 1);
(127, 'Ventilator', 3, 1, 1);
-- On_Call
INSERT INTO
On_Call (Nurse, BlockFloor, BlockCode, Start, End)
VALUES
(6, 2, 1, '2023-01-27', '2023-01-31'),
(7, 3, 1, '2023-01-30', '2023-02-01'),
(8, 2, 1, '2023-02-01', '2023-02-03'),
(7, 1, 1, '2023-02-05', '2023-02-08'),
(9, 1, 1, '2023-02-05', '2023-02-08'),
(10, 1, 1, '2023-02-05', '2023-02-08');
-- Patient
INSERT INTO
Patient (SSN, Name, Address, Phone, InsuranceID, PCP)
VALUES
(
9,
'Shivam',
'A-1/2, 3rd Floor, Shanti Nagar, Goregaon West, Mumbai, Maharashtra 400104',
'63045',
100,
1
),
(
10,
'Naina',
'4 San Juan Ave. Grove City, OH 43123',
'45879',
101,
2
),
(
11,
'Mohan',
'371 Locust Drive Glenview, IL 60025',
'87564',
102,
3
),
(12,'Rahul','A-1/2, 3rd Floor, Shanti Nagar, Goregaon West, Mumbai, Maharashtra 400104','63045',100,1),
(13,'Raj','4 San Juan Ave. Grove City, OH 43123','45879',101,2),
(14,'Ravi','371 Locust Drive Glenview, IL 60025','87564',102,3);
-- Medication
INSERT INTO
Medication (Code, Name, Brand, Description)
VALUES
(
1,
'remdesivir',
'Zydus Cadila',
'antiviral medicine that works against severe acute respiratory syndrome '
),
(
2,
'paracetamol',
'AstraZeneca',
'a prescription and over-the-counter medicine used to treat the symptoms of '
),
(
3,
'ibrutinib',
'Pharmacyclics LLC',
'a prescription medication used as an inhibitor of Bruton''s tyrosine kinase '
),
(4,'ibuflam','AstraZeneca','a prescription and over-the-counter medicine used to treat the symptoms of '),
(5,'ibuprofen','AstraZeneca','a prescription and over-the-counter medicine used to treat the symptoms of ');
-- Appointment
INSERT INTO
Appointment (
AppointmentID,
Patient,
PrepNurse,
Physician,
Start,
End,
ExaminationRoom
)
VALUES
(
1,
9,
6,
1,
'2023-01-29 16:30:00',
'2023-01-29 17:30:00',
'Cardiovascular Exam Room'
),
(
2,
10,
NULL,
2,
'2023-01-31 19:00:00',
'2023-01-31 19:30:00',
'X-Ray Examination Room'
),
(
3,
11,
8,
3,
'2023-02-06 09:00:00',
'2023-02-06 10:15:00',
'Radiation Exam Room'
),
(
4,
9,
6,
4,
'2023-02-15 10:00:00',
'2023-02-15 11:00:00',
'Cardiovascular Exam Room'
);
-- Prescribes
INSERT INTO
Prescribes (
Physician,
Patient,
Medication,
Date,
Appointment,
Dose
)
VALUES
(1, 9, 1, '2023-02-10', 1, '100 mg'),
(2, 10, 2, '2023-01-31', NULL, '20 mg'),
(3, 11, 3, '2023-02-06', 3, '420 mg'),
(9, 10, 1, '2023-02-11', NULL, '100 mg'),
(9, 10, 2, '2023-02-11', NULL, '20 mg');
-- Stay
INSERT INTO
Stay (StayID, Patient, Room, Start, End)
VALUES
(1, 10, 124, '2023-01-31', '2023-02-04'),
(
2,
11,
121,
'2023-02-06 14:30:00',
'2023-02-22 17:30:00'
),
(3, 9, 124, '2023-02-10', '2023-02-13'),
(4, 9, 124, '2023-02-15', '2023-02-18');
-- Undergoes
INSERT INTO
Undergoes (
Patient,
`Procedure`,
Stay,
Date,
Physician,
AssistingNurse
)
VALUES
(11, 3, 2, '2023-02-06', 3, 8),
(9, 1, 3, '2023-02-11', 1, 6),
(10, 4, 1, '2023-02-02', 2, NULL),
(9, 2, 3, '2023-02-12', 1, 6);

/* **********  Queries  ********** */

-- Query - 1
SELECT Physician.Name
FROM Physician
WHERE Physician.EmployeeID IN (SELECT Trained_In.Physician
                                FROM Trained_In, `Procedure`
                                WHERE Trained_In.Treatment = `Procedure`.Code 
                                    AND `Procedure`.Name = 'bypass surgery');

-- Query - 2
SELECT Physician.Name
FROM Physician
WHERE Physician.EmployeeID IN (SELECT Trained_In.Physician
                                FROM Trained_In, `Procedure`
                                WHERE Trained_In.Treatment = `Procedure`.Code 
                                    AND `Procedure`.Name = 'bypass surgery')
    AND Physician.EmployeeID IN (SELECT Affiliated_with.Physician
                                    FROM Affiliated_with, Department
                                    WHERE Affiliated_with.Department = Department.DepartmentID
                                        AND Department.Name = 'cardiology');
-- Query - 3
SELECT Nurse.Name
FROM Nurse
WHERE Nurse.EmployeeID IN (SELECT On_Call.Nurse
                            FROM On_Call, Room, Block
                            WHERE Room.Number = 123
                                AND Room.BlockFloor = Block.Floor
                                AND Room.BlockCode = Block.Code
                                AND On_Call.BlockCode = Block.Code
                                AND On_Call.BlockFloor = Block.Floor);
-- Query - 4
SELECT Patient.Name, Patient.Address
FROM Patient
WHERE Patient.SSN IN (SELECT Prescribes.Patient
                        FROM Prescribes, Medication
                        WHERE Prescribes.Medication = Medication.Code
                            AND Medication.Name = 'remdesivir');
-- Query - 5
SELECT Patient.Name, Patient.InsuranceID
FROM Patient
WHERE Patient.SSN IN (SELECT Stay.Patient
                        FROM Stay, Room
                        WHERE Stay.Room = Room.Number
                            AND Room.Type = 'icu'
                            AND DATEDIFF(Stay.End, Stay.Start)+1 > 15);
-- Query - 6
SELECT Nurse.Name
FROM Nurse
WHERE Nurse.EmployeeID IN (SELECT Undergoes.AssistingNurse
                            FROM Undergoes, `Procedure`
                            WHERE Undergoes.`Procedure` = `Procedure`.Code 
                                AND `Procedure`.Name = 'bypass surgery');
-- Query - 7
with Assistance as (
    SELECT DISTINCT Undergoes.AssistingNurse, Undergoes.Physician
    FROM Undergoes, `Procedure`
    WHERE Undergoes.`Procedure` = `Procedure`.Code 
        AND `Procedure`.Name = 'bypass surgery'
)
SELECT Nurse.Name as Nurse_Name, Nurse.Position, Physician.Name as Physician_Name
FROM Nurse, Physician, Assistance
WHERE Nurse.EmployeeID = Assistance.AssistingNurse
    AND Physician.EmployeeID = Assistance.Physician;
-- Query - 8
SELECT Physician.Name
FROM Physician
WHERE Physician.EmployeeID IN (SELECT Undergoes.Physician
                                FROM Undergoes, `Procedure`
                                WHERE Undergoes.`Procedure` = `Procedure`.Code 
                                    AND `Procedure`.Code NOT IN (SELECT T.Treatment FROM Trained_In T WHERE T.Physician = Undergoes.Physician));
-- Query - 9
SELECT Physician.Name
FROM Physician
WHERE Physician.EmployeeID IN (SELECT Undergoes.Physician
                                FROM Undergoes, `Procedure`, Trained_In
                                WHERE Physician.EmployeeID = Undergoes.Physician 
                                    AND Undergoes.`Procedure` = `Procedure`.Code 
                                    AND `Procedure`.Code = Trained_In.Treatment 
                                    AND Trained_In.Physician = Physician.EmployeeID 
                                    AND Undergoes.Date > Trained_In.CertificationExpires);
-- Query - 10
with T as (SELECT Physician.EmployeeID as ID, `Procedure`.Name, Undergoes.Date, Patient.Name as Patient_Name
FROM Physician, Undergoes, `Procedure`, Trained_In, Patient
WHERE Physician.EmployeeID = Undergoes.Physician 
    AND Undergoes.`Procedure` = `Procedure`.Code 
    AND `Procedure`.Code = Trained_In.Treatment
    AND Trained_In.Physician = Physician.EmployeeID 
    AND Undergoes.Date > Trained_In.CertificationExpires
    AND Patient.SSN = Undergoes.Patient)
SELECT Physician.Name as Physician_Name, T.Name as Procedure_Name, T.Date as Date, T.Patient_Name as Patient_Name
FROM Physician, T
WHERE Physician.EmployeeID IN (SELECT ID FROM T);
-- Query - 11
SELECT Pt.Name as 'Patient Name', PhPCP.Name as 'Physician Name' FROM Patient Pt, Physician PhPCP
 WHERE Pt.PCP = PhPCP.EmployeeID
   AND EXISTS
       (
         SELECT * FROM Prescribes Pr
          WHERE Pr.Patient = Pt.SSN
            AND Pr.Physician = Pt.PCP
       )
   AND EXISTS
       (
         SELECT * FROM Undergoes U, `Procedure` Pr
          WHERE U.`Procedure` = Pr.Code
            AND U.Patient = Pt.SSN
            AND Pr.Cost > 5000
       )
   AND 2 <=
       (
         SELECT COUNT(A.AppointmentID) FROM Appointment A, Physician P, Affiliated_with AWF, Department D
          WHERE A.Patient = Pt.SSN
            AND A.Physician = P.EmployeeID
            AND P.EmployeeID = AWF.Physician
            AND AWF.Department = D.DepartmentID
            AND D.Name = 'cardiology'
       )
   AND NOT Pt.PCP IN
       (
          SELECT Head FROM Department
       );
-- Query - 12
with T as (
    SELECT Medication.Name as Name, Medication.Brand as Brand, COUNT(Prescribes.Patient) as Num_Patients
    FROM Medication, Prescribes
    WHERE Medication.Code = Prescribes.Medication
    GROUP BY Medication.Name, Medication.Brand
)
SELECT T.Name, T.Brand
FROM T
WHERE T.Num_Patients >= ALL (SELECT Num_Patients FROM T);

