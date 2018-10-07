## Create Database/Schema 
CREATE DATABASE IF NOT EXISTS ww2analysis; 

Use ww2analysis;

## Create DimAirCraft Table

CREATE TABLE IF NOT EXISTS ww2analysis.DimAirCraft (
gloss_id INTEGER NOT NULL,
aircraft VARCHAR (50),
name VARCHAR (100),
full_name VARCHAR (500),
aircraft_type VARCHAR (100),
hyperlink VARCHAR (500),
PRIMARY KEY (gloss_id)
);

## Create DimWeapon Table
CREATE TABLE IF NOT EXISTS ww2analysis.DimWeapon (
weapon_id INTEGER NOT NULL,
country VARCHAR (50) ,
weapon_name VARCHAR (100) ,
weapon_type VARCHAR (20) ,
weapon_class VARCHAR (5) ,
number_of_bomblets INTEGER NOT NULL DEFAULT 0,
alt_weapon_name VARCHAR (100) ,
weapon_description VARCHAR (500) ,
PRIMARY KEY (weapon_id)
);

## Create AirBombingOps Table

CREATE TABLE IF NOT EXISTS ww2analysis.AirBombingOps (
wwii_id INTEGER NOT NULL,
master_index_number INTEGER NOT NULL DEFAULT 0,
msndate DATE NULL,
theater VARCHAR (50) NULL,
naf VARCHAR (50) NULL,
country_flying_mission VARCHAR (50) NULL,
tgt_country_code INTEGER NOT NULL DEFAULT 0,
tgt_country VARCHAR (100) NULL,
tgt_location VARCHAR (500) NULL,
tgt_type VARCHAR (100) NULL,
tgt_id INTEGER NOT NULL DEFAULT 0,
tgt_industry_code INTEGER NOT NULL DEFAULT 0,
tgt_industry VARCHAR (500) NULL,
source_latitude VARCHAR (20) NULL,
source_longitude VARCHAR (20) NULL,
latitude NUMERIC NOT NULL DEFAULT 0.00,
longitude NUMERIC NOT NULL DEFAULT 0.00,
unit_id VARCHAR (100) NULL,
mds VARCHAR (20) NULL,
aircraft_name VARCHAR (100) NULL,
msn_type INTEGER NOT NULL DEFAULT 0,
tgt_priority VARCHAR (10) NULL,
tgt_priority_explanation VARCHAR (100) NULL,
ac_attacking INTEGER NOT NULL DEFAULT 0,
altitude NUMERIC NOT NULL DEFAULT 0.00,
altitude_feet INTEGER NOT NULL DEFAULT 0,
number_of_he NUMERIC NOT NULL DEFAULT 0.00,
type_of_he VARCHAR (200) NULL,
lbs_he NUMERIC NOT NULL DEFAULT 0.00,
tons_of_he NUMERIC NOT NULL DEFAULT 0.00,
number_of_ic NUMERIC NOT NULL DEFAULT 0.00,
type_of_ic VARCHAR (100) NULL,
lbs_ic NUMERIC NOT NULL DEFAULT 0.00,
tons_of_ic NUMERIC NOT NULL DEFAULT 0.00,
number_of_frag NUMERIC NOT NULL DEFAULT 0.00,
type_of_frag VARCHAR (100) NULL,
lbs_frag NUMERIC NOT NULL DEFAULT 0.00,
tons_of_frag NUMERIC NOT NULL DEFAULT 0.00,
total_lbs NUMERIC NOT NULL DEFAULT 0.00,
total_tons NUMERIC NOT NULL DEFAULT 0.00,
takeoff_base VARCHAR (100) NULL,
takeoff_country VARCHAR (100) NULL,
takeoff_latitude NUMERIC NOT NULL DEFAULT 0.00,
takeoff_longitude NUMERIC NOT NULL DEFAULT 0.00,
ac_lost INTEGER NOT NULL DEFAULT 0,
ac_damaged INTEGER NOT NULL DEFAULT 0,
ac_airborne INTEGER NOT NULL DEFAULT 0,
ac_dropping INTEGER NOT NULL DEFAULT 0,
time_over_target VARCHAR (10) NULL,
sighting_method_code VARCHAR (10) NULL,
sighting_explanation VARCHAR (50) NULL,
bda VARCHAR (500) NULL,
callsign VARCHAR (20) NULL,
rounds_ammo INTEGER NOT NULL DEFAULT 0,
spares_return_ac INTEGER NOT NULL DEFAULT 0,
wx_fail_ac INTEGER NOT NULL DEFAULT 0,
mech_fail_ac INTEGER NOT NULL DEFAULT 0,
misc_fail_ac INTEGER NOT NULL DEFAULT 0,
target_comment VARCHAR (500) NULL,
mission_comments VARCHAR (500) NULL,
source VARCHAR (50) NULL,
database_edit_comments VARCHAR (4000) NULL,

PRIMARY KEY (wwii_id)
);
