CREATE TABLE ISJHospital.Patient (
    PID	VARCHAR(50),HospitalID VARCHAR(50),Family VARCHAR(50),Given VARCHAR(50),
    FamilyKana VARCHAR(50),GivenKana VARCHAR(50),DOB DATE,Gender VARCHAR(50),
    ZIP VARCHAR(50),Pref VARCHAR(50),City VARCHAR(50),Address VARCHAR(50),Tel VARCHAR(50)
)

LOAD DATA FROM FILE '/home/irisowner/InputDataPatient.csv'
 INTO ISJHospital.Patient
 USING {"from":{"file":{"charset":"UTF-8"}}}

CREATE TABLE ISJHospital.Observation (
    PID VARCHAR(50),LabTestCode VARCHAR(50),LabTestText VARCHAR(100),Value INTEGER,
    Unit VARCHAR(50),LabTestDateTime DATE
)

LOAD DATA FROM FILE '/home/irisowner/InputDataLabTest.csv'
 INTO ISJHospital.Observation
 USING {"from":{"file":{"charset":"UTF-8"}}}