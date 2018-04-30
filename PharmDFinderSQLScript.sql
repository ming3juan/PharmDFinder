--CREATE DATABASE PharmDFinderDB
GO

-- To DROP old tables
ALTER TABLE dbo.AssignedSchedules  
DROP CONSTRAINT FK_AssignedPharmacy_PharmacyId;
ALTER TABLE dbo.AssignedSchedules  
DROP CONSTRAINT FK_AssignedPharmacist_PharmacistId;

DROP TABLE AssignedSchedules
GO

ALTER TABLE dbo.OpenSchedules  
DROP CONSTRAINT FK_OpenPharmacy_PharmacyId;

DROP TABLE OpenSchedules
GO

DROP TABLE Pharmacy
GO

DROP TABLE Pharmacist
GO

-- ALTER TABLE [Pharmacy] ADD Test VARCHAR(10) DEFAULT 'aa' NOT NULL

GO
CREATE TABLE Pharmacy
(
	PharmacyId SMALLINT CONSTRAINT PK_PharmacyId PRIMARY KEY IDENTITY,
	PharmacyName VARCHAR(100) CONSTRAINT UQ_Name UNIQUE NOT NULL, --@"^([A-Z]{1}[a-z]*)+([\s]{1}[A-Z]{1}[a-z]*)*$"
	DBA VARCHAR(100) DEFAULT ' ', --@"^([A-Z]{1}[a-z]*)+([\s]{1}[A-Z]{1}[a-z]*)*$"
	[Address] VARCHAR(100) CONSTRAINT UQ_Address NOT NULL,
	ZipCode CHAR(5) NOT NULL,--@"^\d{5,5}$)|(^\d{5,5}-\d{4,4}$/ 
	EmailId VARCHAR(100) CONSTRAINT UQ_PharmacyEmailId UNIQUE NOT NULL,	--@"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" 
	TelephoneNum CHAR(10) CONSTRAINT UQ_PharmacyTelephoneNum UNIQUE NOT NULL,	-- @"^[\d]{10,10}$" --10 digits
	Fax CHAR(10) CONSTRAINT UQ_Fax UNIQUE,	--10 digits
	NCPDP CHAR(7) CONSTRAINT UQ_NCPDP UNIQUE NOT NULL,	--7 digits
	NPI CHAR(10) CONSTRAINT UQ_NPI UNIQUE NOT NULL, --10 digits
	DEA CHAR(9) CONSTRAINT UQ_DEA UNIQUE NOT NULL, --@"^[a-zA-Z]{2,2}\d{7,7}" --2 letters then 7 digits
	LicenseNum CHAR(6) CONSTRAINT UQ_PharmacyLicenseNum UNIQUE NOT NULL, --6 digits
	TaxId CHAR(9) CONSTRAINT UQ_TaxId UNIQUE NOT NULL --9 digits
)

GO

CREATE TABLE Pharmacist
(
	PharmacistId SMALLINT CONSTRAINT PK_PharmacistId PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50) NOT NULL,--@"^[A-Z]{1}[a-zA-Z]+*$",
	LastName VARCHAR(50) NOT NULL, --@"^[A-Z]{1}[a-zA-Z]+*$"
	EmailId VARCHAR(100) CONSTRAINT UQ_PharmacistEmailId UNIQUE NOT NULL, --@"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" 
	[Address] VARCHAR(100) NOT NULL,
	ZipCode CHAR(5) NOT NULL, --@"^\d{5,5}$)|(^\d{5,5}-\d{4,4}$/"
	TelephoneNum CHAR(10) CONSTRAINT UQ_PharmacistTelephoneNum UNIQUE NOT NULL, --@"^[\d]{10,10}$" --10 digits
	LicenseNum CHAR(6) CONSTRAINT UQ_PharamcistLicenseNum UNIQUE NOT NULL,--6 digits
	StateOfLicense CHAR(2) NOT NULL, --2 captial letters
	--GREATER THAN 1950 - less than equal CURRENT YEAR
	YearOfLicensure INT CONSTRAINT CHK_YearOfLicensure CHECK (YearOfLicensure <= YEAR(GETDATE()) AND YearOfLicensure > 1950)  NOT NULL,
	CONSTRAINT UQ_AddressFirstNameLastName UNIQUE ([Address], FirstName, LastName) --Can't have same full name and address
)

GO

CREATE TABLE AssignedSchedules
(
	AssignedScheduleId INT CONSTRAINT PK_AssignedScheduleId PRIMARY KEY IDENTITY,
	PharmacyId SMALLINT CONSTRAINT FK_AssignedPharmacy_PharmacyId REFERENCES Pharmacy(PharmacyId) NOT NULL,
	PharmacistId SMALLINT CONSTRAINT FK_AssignedPharmacist_PharmacistId REFERENCES Pharmacist(PharmacistId) NOT NULL,
	StartDateTime SMALLDATETIME CONSTRAINT CK_AssignedStartDateTime CHECK (StartDateTime > GETDATE()) NOT NULL,
	EndDateTime SMALLDATETIME CONSTRAINT CK_AssignedEndDateTime CHECK (EndDateTime > GETDATE()) NOT NULL,
	PayRate DECIMAL(5,2) CONSTRAINT CK_AssignedPayRate CHECK (PayRate > 0) NOT NULL,
)

GO

CREATE TABLE OpenSchedules
(
	OpenScheduleId INT CONSTRAINT PK_OpenScheduleId PRIMARY KEY IDENTITY,
	PharmacyId SMALLINT CONSTRAINT FK_OpenPharmacy_PharmacyId REFERENCES Pharmacy(PharmacyId) NOT NULL,
	StartDateTime SMALLDATETIME CONSTRAINT CK_OpenStartDateTime CHECK (StartDateTime > GETDATE()) NOT NULL,
	EndDateTime SMALLDATETIME CONSTRAINT CK_OpenEndDateTime CHECK (EndDateTime > GETDATE()) NOT NULL,
	PayRate DECIMAL(5,2) CONSTRAINT CK_OpenPayRate CHECK (PayRate > 0) NOT NULL,
	IsPayNegotiable CHAR(3) CONSTRAINT CK_IsPayNegotiable_YorN CHECK(IsPayNegotiable IN ('Y', 'N'))
)

GO

--INSERT INTO Pharmacy VALUES ('Dude Pharmacy', DEFAULT, '14 Monroe St', '10002', 'dude@gmail.com', '1234567890', '0987654321', '1', '1', '1', '1', '1')
--INSERT INTO Pharmacy VALUES ('', DEFAULT, '14 Monroe St', '10002', '', '', '', '', '', '2', '2', '2')
--INSERT INTO Pharmacist VALUES('Awesome', 'Juan', 'awesome@gmail.com', '1234567890'