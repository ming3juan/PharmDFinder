--CREATE DATABASE PharmDFinderDB

GO
-- To DROP old tables
DROP TABLE [Pharmacy]
DROP TABLE [Pharmacist]
-- ALTER TABLE [Pharmacy] ADD Test VARCHAR(10) DEFAULT 'aa' NOT NULL

GO
CREATE TABLE [Pharmacy]
(
	[PharmacyId] SMALLINT CONSTRAINT pk_PharmacyId PRIMARY KEY IDENTITY,

	--@"^([A-Z]{1}[a-z]*)+([\s]{1}[A-Z]{1}[a-z]*)*$"
	[Name] VARCHAR(100) CONSTRAINT uq_Name UNIQUE NOT NULL,

	--@"^([A-Z]{1}[a-z]*)+([\s]{1}[A-Z]{1}[a-z]*)*$"
	[DBA] VARCHAR(100) DEFAULT ' ',

	[Address] VARCHAR(100) CONSTRAINT uq_Address NOT NULL,
	--@"^\d{5,5}$)|(^\d{5,5}-\d{4,4}$/ 
	-- 5 digits or 5 digits then - then 4 digits
	[ZipCode] CHAR(5) NOT NULL,

	--@"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" 
	--1 or more letters then @ then 1 or more letters then . then 2-4 letters
	[EmailId] VARCHAR(100) CONSTRAINT uq_Pharmacy_EmailId UNIQUE NOT NULL,

	-- @"^[\d]{10,10}$" --10 digits
	[TelephoneNum] CHAR(10) CONSTRAINT uq_Pharmacy_TelephoneNum UNIQUE NOT NULL,

	--@"^[\d]{10,10}$" --10 digits
	[Fax] CHAR(10) CONSTRAINT uq_Fax UNIQUE,

	--@"^[\d]{7,7}$" --7 digits
	[NCPDP] CHAR(7) CONSTRAINT uq_NCPDP UNIQUE NOT NULL,

	--@"^[\d]{10,10}$" --10 digits
	[NPI] CHAR(10) CONSTRAINT uq_NPI UNIQUE NOT NULL,

	--@"^[a-zA-Z]{2,2}\d{7,7}" --2 letters then 7 digits
	[DEA] CHAR(9) CONSTRAINT uq_DEA UNIQUE NOT NULL,

	--@"^\d{6,6}" --6 digits
	[LicenseNum] CHAR(6) CONSTRAINT uq_Pharmacy_LicenseNum UNIQUE NOT NULL,

	--@"^\d{9,9}" --9 digits
	[TaxId] CHAR(9) CONSTRAINT uq_TaxId UNIQUE NOT NULL
)

GO

CREATE TABLE [Pharmacist]
(
	[PharmacistId] SMALLINT CONSTRAINT pk_PharmacistId PRIMARY KEY IDENTITY,

	--@"^[A-Z]{1}[a-zA-Z]+*$"
	[FirstName] VARCHAR(50) NOT NULL,
	--@"^[A-Z]{1}[a-zA-Z]+*$"
	[LastName] VARCHAR(50) NOT NULL,

	--@"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" 
	-- 1 or more letter then @ then 1 or more letter then . then 2-4 letters
	[EmailId] VARCHAR(100) CONSTRAINT uq_Pharmacist_EmailId UNIQUE NOT NULL,

	--@"^[\d]{10,10}$" --10 digits
	[TelephoneNum] CHAR(10) CONSTRAINT uq_Pharmacist_TelephoneNum UNIQUE NOT NULL,

	--@"^\d{6,6}" --6 digits
	[LicenseNum] CHAR(6) CONSTRAINT uq_Pharamcist_LicenseNum UNIQUE NOT NULL,

	--@"^[A-Z]{2}$"
	[StateOfLicense] CHAR(2) NOT NULL,

	--GREATER THAN 1950 - less than equal CURRENT YEAR
	[YearOfLicensure] INT CONSTRAINT chk_YearOfLicensure CHECK(YearOfLicensure > 1980 AND YearOfLicensure <= YEAR(GETDATE()) ) NOT NULL,
)

GO

INSERT INTO Pharmacy VALUES ('Dude Pharmacy', DEFAULT, '14 Monroe St', '10002', 'dude@gmail.com', '1234567890', '0987654321', '1', '1', '1', '1', '1')
INSERT INTO Pharmacy VALUES ('', DEFAULT, '14 Monroe St', '10002', '', '', '', '', '', '2', '2', '2')
--INSERT INTO Pharmacist VALUES('Awesome', 'Juan', 'awesome@gmail.com', '1234567890'