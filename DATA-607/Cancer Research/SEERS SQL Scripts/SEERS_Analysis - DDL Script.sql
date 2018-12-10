## Create Database/Schema 
CREATE DATABASE IF NOT EXISTS SEERS_Analysis; 

Use SEERS_Analysis;

## cancer patients master ##
CREATE TABLE IF NOT EXISTS SEERS_Analysis.Cancer_Patients_Master (
SEERDiagnosticUnit      varchar(50) NULL,
personID         integer   NOT NULL,
locality         varchar(100)   NULL,
maritalStatus         varchar(100)   NULL,
race         varchar(100)   NULL,
derivedHispanicOrigin         varchar(100)   NULL,
sex         varchar(1)   NULL,
ageDiagnosis         integer   NULL,
birthYear         integer   NULL,
sequenceNumber         integer   NULL,
monthDiagnosis         integer   NULL,
yearDiagnosis         integer   NULL,
primarySite         varchar(100)   NULL,
laterality         varchar(100)   NULL,
histology         varchar(100)   NULL,
behavior         varchar(100)   NULL,
histologicType         varchar(100)   NULL,
behaviorCode         varchar(100)   NULL,
grade         varchar(100)   NULL,
diagnosticConfirmation         varchar(100)   NULL,
reportingSourceType         varchar(100)   NULL,
survivalMonths         integer   NULL
);


## CI5 (Cancer Incidents in Five Continents) Tables ##

## Diagnostic Units Master ###
CREATE TABLE IF NOT EXISTS SEERS_Analysis.Diagnostic_Units_Master (
CancerCode      integer NOT NULL,
DiagCode         varchar(20)   NOT NULL,
DiagUnitLvl0Desc         varchar(200)   NULL,
DiagUnitLvl1Desc         varchar(200)   NULL,
DiagUnitLvl1CodeDesc          varchar(200)   NULL,
SEERDiagnosticUnit         varchar(20)   NULL,
SEERDiagnosticUnitDesc         varchar(100)   NULL,
primary key(CancerCode)
);

## Cancer Registry Master ###
CREATE TABLE IF NOT EXISTS SEERS_Analysis.Cancer_Registry_Master (
CancerRegistryID      integer NOT NULL,
CancerRegistryDesc         varchar(200)   NOT NULL,
Year1        varchar(4)   NULL,
Year2        varchar(4)   NULL,
Country      varchar(200)   NULL,
Continent    varchar(200)   NULL,
primary key(CancerRegistryID)
);

## Cancer Incidents Summary ###
CREATE TABLE IF NOT EXISTS SEERS_Analysis.Cancer_Cases_Summary (
CancerRegistryID  integer NOT NULL,
Year              integer   NULL,
Sex               varchar(1)   NULL,
CancerCode        integer   NULL,
TotalCases      integer   NULL,
Age_0_4           integer   NULL,
Age_5_9           integer   NULL,
Age_10_14         integer   NULL,
Age_15_19         integer   NULL,
Age_20_24         integer   NULL,
Age_25_29         integer   NULL,
Age_30_34         integer   NULL,
Age_35_39         integer   NULL,
Age_40_44         integer   NULL,
Age_45_49         integer   NULL,
Age_50_54         integer   NULL,
Age_55_59         integer   NULL,
Age_60_64         integer   NULL,
Age_65_69         integer   NULL,
Age_70_74         integer   NULL,
Age_75_79         integer   NULL,
Age_80_84         integer   NULL,
Age_85Plus        integer   NULL,
Age_Unk           integer   NULL
);

### Cancer Incidents Details ###

CREATE TABLE IF NOT EXISTS SEERS_Analysis.Cancer_Cases_Details (
CancerRegistryID  integer NOT NULL,
Year              integer   NULL,
Sex               varchar(1)   NULL,
CancerCode        integer   NULL,
AgeGroup          varchar(20) NULL,
TotalCases        integer   NULL
);

## Cancer Population Summary ###
CREATE TABLE IF NOT EXISTS SEERS_Analysis.Population_Summary (
CancerRegistryID  integer NOT NULL,
Year              integer   NULL,
Sex               varchar(1)   NULL,
TotalPopulation      integer   NULL,
Age_0_4           integer   NULL,
Age_5_9           integer   NULL,
Age_10_14         integer   NULL,
Age_15_19         integer   NULL,
Age_20_24         integer   NULL,
Age_25_29         integer   NULL,
Age_30_34         integer   NULL,
Age_35_39         integer   NULL,
Age_40_44         integer   NULL,
Age_45_49         integer   NULL,
Age_50_54         integer   NULL,
Age_55_59         integer   NULL,
Age_60_64         integer   NULL,
Age_65_69         integer   NULL,
Age_70_74         integer   NULL,
Age_75_79         integer   NULL,
Age_80_84         integer   NULL,
Age_85Plus        integer   NULL
);

### Population Details by Age Group 

CREATE TABLE IF NOT EXISTS SEERS_Analysis.Population_Details (
CancerRegistryID  integer NOT NULL,
Year              integer   NULL,
Sex               varchar(1)   NULL,
AgeGroup          varchar(20) NULL,
TotalPopulation        integer   NULL
);