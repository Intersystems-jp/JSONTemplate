--- このファイルにはISJスキーマ以下テーブルのCREATE TABLE文とINSERT文が含まれています。

CREATE TABLE ISJ.Patient(		
	PatientNumber VARCHAR(10) CONSTRAINT PIDKEY PRIMARY KEY,	
	FirstName VARCHAR(50),	
	LastName VARCHAR(50),	
	FirstNameKana VARCHAR(50),	
	LastNameKana VARCHAR(50),	
	DOB DATE,	
	Zip VARCHAR(10),	
	Address VARCHAR(100),	
	Tel VARCHAR(20),	
	Gender VARCHAR(10)	
)
		
CREATE TABLE ISJ.Doctor(		
	DoctorNumber VARCHAR(10) CONSTRAINT DocKEY PRIMARY KEY,	
	FirstName VARCHAR(50),	
	LastName VARCHAR(50),	
	FirstNameKana VARCHAR(50),	
	LastNameKana VARCHAR(50)	
)	
		
		
CREATE TABLE ISJ.Encounter(		
	EncounterNumber VARCHAR(10) CONSTRAINT EncounterKEY PRIMARY KEY,	
	DoctorNumber VARCHAR(10),	
	PatientNumber VARCHAR(10),	
	StartDate DATE,	
	EndDate DATE,
	ReasonSystem VARCHAR(50),
	ReasonCode VARCHAR(50),
	Reason VARCHAR(50)
)

CREATE TABLE ISJ.MedicationRequest (	
	OrderNumber VARCHAR(10) CONSTRAINT OrderKEY PRIMARY KEY,
	PatientNumber VARCHAR(10),
	DoctorNumber VARCHAR(10),
	Category INTEGER,
	UnitCode VARCHAR(50),
	Unit VARCHAR(10),
	SingleDose INTEGER,
	DailyAmount INTEGER,
	DailyNumOfTimes INTEGER,
	MedicationOrderDate DATE,
	TotalAmountDispence INTEGER CALCULATED COMPUTECODE PYTHON {
	if cols.getfield("DailyAmount")=="":
	 return ""
	if cols.getfield("TotalDaysDispence")=="":
	 return ""
	return cols.getfield("DailyAmount") * cols.getfield("TotalDaysDispence")
	},
	TotalDaysDispence INTEGER,
	MedicationCode VARCHAR(50),
	MedicationName VARCHAR(100),
	Period INTEGER,
	StartDate DATE,
	RouteCode VARCHAR(50),
	Route VARCHAR(50)
)	
	
CREATE TABLE ISJ.Allergy (	
	AllergyNumber VARCHAR(50) CONSTRAINT AllergyKEY PRIMARY KEY,
	PatientNumber VARCHAR(10),
	DoctorNumber VARCHAR(10),
	State VARCHAR(20),
	ConfirmedState VARCHAR(20),
	Type VARCHAR(50),
	Category VARCHAR(50),
	Criticality VARCHAR(50),
	Code VARCHAR(50),
	AllergyName VARCHAR(50)
)	
	
CREATE TABLE ISJ.Condition (	
	ConditionNumber VARCHAR(50) CONSTRAINT ConditionKEY PRIMARY KEY,
	EncounterNumber VARCHAR(50),
	PatientNumber VARCHAR(10),
	DoctorNumber VARCHAR(10),
	Text VARCHAR(50),
	Code VARCHAR(50),
	Status VARCHAR(10),
	ValificationStatus VARCHAR(10),
	RecordedDate DATE
)	
	
CREATE TABLE ISJ.CarePlan (	
	PatientNumber VARCHAR(10),
	EncounterNumber VARCHAR(50),
	DoctorNumber VARCHAR(10),
	CareNumber VARCHAR(10) CONSTRAINT CareKEY PRIMARY KEY,
	CreatedDate DATE,
	Details VARCHAR(1000)
)	
	
CREATE TABLE ISJ.Organization (	
	OrgNumber VARCHAR(10) CONSTRAINT OrgKEY PRIMARY KEY,
	HospitalName VARCHAR(50),
	PrefCode INTEGER,
	Zip VARCHAR(10),
	Pref VARCHAR(10),
	City VARCHAR(50),
	Street VARCHAR(1000),
	Phone VARCHAR(15),
	Code INTEGER,
	InsuranceNum7 INTEGER,
	InsuranceNum10 INTEGER
)

--- サンプルデータ作成（管理ポータルで実行する場合は、表示モードODBCに変更後実行してください。）

-- Patient
INSERT INTO ISJ.Patient VALUES('P0001','太郎','山田','タロウ','ヤマダ','1999-01-23','111-2222','東京都新宿区','03-5321-6200','Male')
INSERT INTO ISJ.Patient VALUES('P0002','花子','佐々木','ハナコ','ササキ','1949-12-20','111-2222','東京都板橋区','03-5321-6200','Female')
INSERT INTO ISJ.Patient VALUES('P0003','次郎','田辺','ジロウ','タナベ','1939-08-20','011-2222','東京都国分寺市','042-321-6200','Male')

--- Doctor
INSERT INTO ISJ.Doctor VALUES('DC001','幸太郎','大森','コウタロウ','オオモリ')

--- Encounter
INSERT INTO ISJ.Encounter VALUES('EN0001','DC001','P0003','1999-09-23','1999-10-03','urn:oid:1.2.392.200119.4.101.6','B0EF','持続腹痛')
INSERT INTO ISJ.Encounter VALUES('EN0002','DC001','P0003','2002-10-23','2003-01-03','urn:oid:1.2.392.200119.4.101.6','L0G6','伝染性単核症')
INSERT INTO ISJ.Encounter VALUES('EN0003','DC001','P0003','2022-01-01','2022-01-09','urn:oid:1.2.392.200119.4.101.6','B0EF','持続腹痛')
INSERT INTO ISJ.Encounter VALUES('EN0004','DC001','P0001','2022-05-07','2022-05-17','urn:oid:1.2.392.200119.4.101.6','KFKL','感染性筋炎')

--- MedicationRequest
INSERT INTO ISJ.MedicationRequest VALUES('ORD001','P0001','DC001',1,null,'錠',1,3,3,'1999-09-30',null,7,'103831601','カルボシステイン錠２５０ｍｇ',7,'1999-10-03',null,'経口')
INSERT INTO ISJ.MedicationRequest VALUES('ORD002','P0003','DC001',1,null,'錠',1,3,3,'2022-01-04',null,7,'103831601','カルボシステイン錠２５０ｍｇ',7,'2002-01-04',null,'経口')
INSERT INTO ISJ.MedicationRequest VALUES('ORD003','P0003','DC001',1,null,'錠',1,3,3,'2022-01-09',null,7,'103831601','カルボシステイン錠２５０ｍｇ',7,'2022-01-10',null,'経口')
INSERT INTO ISJ.MedicationRequest VALUES('ORD004','P0001','DC001',1,null,'錠',1,3,3,'2022-05-16',null,7,'103831601','カルボシステイン錠２５０ｍｇ',7,'2022-05-20',null,'経口')

--- Allergy
INSERT INTO ISJ.Allergy VALUES('A0001','P0002','DC001','active','confirmed','allergy','food','high',null,'そば')
INSERT INTO ISJ.Allergy VALUES('A0002','P0002','DC001','active','confirmed','allergy','food','high',null,'ピーナッツ')
INSERT INTO ISJ.Allergy VALUES('A0003','P0003','DC001','active','confirmed','allergy','food','high',null,'メロン')


--- Condition
INSERT INTO ISJ.Condition VALUES('C0001','EN0001','P0003','DC001','持続腹痛','B0EF','active','confirmed','1999-09-30')
INSERT INTO ISJ.Condition VALUES('C0002','EN0002','P0003','DC001','持続腹痛','B0EF','recurrence','confirmed','2002-11-02')
INSERT INTO ISJ.Condition VALUES('C0003','EN0003','P0003','DC001','高血圧症','B0EF','active','confirmed','2022-01-05')
INSERT INTO ISJ.Condition VALUES('C0004','EN0004','P0001','DC001','高血圧症',null,'active','confirmed','2022-05-10')

--- CarePlan
INSERT INTO ISJ.CarePlan VALUES('P0003','EN0001','DC001','Care001','1999-09-23','かかりつけ医で○○の検査を定期的に受けてください')
INSERT INTO ISJ.CarePlan VALUES('P0003','EN0002','DC001','Care002','2003-01-04','かかりつけ医の指示で入院が必要な検査値になったらすぐに連絡ください')
INSERT INTO ISJ.CarePlan VALUES('P0003','EN0003','DC001','Care003','2022-01-9','かかりつけ医の指示に従ってください')
INSERT INTO ISJ.CarePlan VALUES('P0001','EN0004','DC001','Care004','2022-05-16','○○クリニックで定期的に○△の検査を行い数値に異常があれば知らせてください')

--- Organization
INSERT INTO ISJ.Organization VALUES('Org001','インターシステムズホスピタル','13','151-1234','神奈川県','横浜市','関内1-1-1','045-111-2222',1,1234578,1234567890)

=============

--Patient特定
select * from ISJ.Patient where PatientNumber='P0003'

--Doctor特定
select * from ISJ.Doctor where DoctorNumber='DC001'

--Organization特定
select * from ISJ.Organization where OrgNumber='Org001'

--Allergy特定
select * from ISJ.Allergy where PatientNumber='P0003'

--MedicationRequest特定
select * from ISJ.MedicationRequest where OrderNumber='ORD003'

--CarePlan特定
select * from ISJ.CarePlan where EncounterNumber='EN0003'

-- Encounter特定
select * from ISJ.Encounter where EncounterNumber='EN0003'

--Condition特定
select * from ISJ.Condition where EncounterNumber='EN0003'
