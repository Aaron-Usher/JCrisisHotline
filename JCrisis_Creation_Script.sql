DROP DATABASE IF EXISTS JCrisis_Hotline_DB;

CREATE DATABASE JCrisis_Hotline_DB;

USE JCrisis_Hotline_DB;

Create Table Call_Record (
    Call_Record_ID INT AUTO_INCREMENT NOT NULL COMMENT 'ID of the call record',
    Start_Time DATETIME NOT NULL COMMENT 'Start time of the comment',
    Counselor_ID INT NOT NULL COMMENT 'ID of the counselor overlooking the call',
    Call_Description TEXT COMMENT 'Description of the call record',
    Call_Type_ID VARCHAR(25) NOT NULL COMMENT 'Type of the call record',
    Caller_ID INT COMMENT 'ID of the caller',
    End_Time DATETIME NOT NULL COMMENT 'End time of the call record',
    PRIMARY KEY (Call_Record_ID)
) COMMENT 'Information about a specific call record';



Create Table Call_Record_Resource (
    Call_Record_ID INT NOT NULL COMMENT 'ID of the related Call Record',
    Resource_ID INT NOT NULL COMMENT 'ID of the resource reffered to in the Call Record',
    PRIMARY KEY (Call_Record_ID, Resource_ID)
) COMMENT 'Join table of call records and resources; each record indicates a resource that was reccomended during a call record';

Create Table Caller (
    Caller_ID INT NOT NULL COMMENT 'ID of the caller',
    First_Name VARCHAR(25) COMMENT 'First name of the caller',
    Last_Name VARCHAR(25) COMMENT 'Last name of the caller',
    Phone VARCHAR(20) COMMENT 'Phone number of the caller',
    Address VARCHAR(50) COMMENT 'Address of the caller',
    City VARCHAR(25) COMMENT 'City of the caller',
    Territory CHAR(2) COMMENT 'Two digit state code of the caller',
    ZIP VARCHAR(10) COMMENT 'Zip code of the caller',
    PRIMARY KEY(Caller_ID)
) COMMENT 'Information about any caller using our service';

Create Table Call_Type (
    Call_Type_ID VARCHAR(25) NOT NULL COMMENT 'Category of the call type',
    Description TEXT COMMENT 'A more specific descripton for the category',
    PRIMARY KEY(Call_Type_ID)
) COMMENT 'Types of calls and their descriptions';

Create Table Limitation(
    Limitation_ID INT NOT NULL,
    Limitation_Category_ID VARCHAR(25),
    Description TEXT,
    PRIMARY KEY (Limitation_ID)
);

Create Table Limitation_Category (
    Limitation_Category_ID VARCHAR(25),
    Description TEXT,
    PRIMARY KEY (Limitation_Category_ID)
);

Create Table Resource_Provider (
    Resource_ID INT AUTO_INCREMENT NOT NULL COMMENT 'ID of the Resource',
    Name VARCHAR(50) NOT NULL COMMENT 'Name of the Resource',
    Phone VARCHAR(15) NOT NULL COMMENT 'Phone Number of the Resource',
    Address_One VARCHAR(50) NOT NULL COMMENT 'Address of the Resource',
    Address_Two VARCHAR(50) COMMENT 'Optional Address of the Resource',
    City VARCHAR(50) NOT NULL COMMENT 'City of the Resource',
    Territory VARCHAR(50) NOT NULL COMMENT 'State of the Resource',
    Country VARCHAR(50) NOT NULL COMMENT 'Country of the Resource',
    Postal_Code VARCHAR(10) NOT NULL COMMENT 'Zip Code of the Resource',
    Description TEXT NOT NULL COMMENT 'Desceiption of the Resource',
    PRIMARY KEY(Resource_ID)
);

Create Table Resource_Limitation (
    Resource_ID INT NOT NULL COMMENT 'ID of the Resource',
    Limitation_ID INT NOT NULL COMMENT 'ID of the Limitation',
    PRIMARY KEY(Resource_ID, Limitation_ID)
);

Create Table Resource_Category (
    Resource_Category_ID VARCHAR(25) NOT NULL,
    Description TEXT NOT NULL,
    PRIMARY KEY (Resource_Category_ID)
);
/*
Create Table Resource_Category_Hierarchy (
    Super_Category VARCHAR(25) NOT NULL,
    Sub_Category VARCHAR(25) NOT NULL,
    PRIMARY KEY(Super_Category,Sub_Category)
);
*/
Create Table Resource_Category_Resource (
    Resource_Category_ID VARCHAR(25),
    Resource_ID INT NOT NULL,
    PRIMARY KEY(Resource_Category_ID, Resource_ID)
);

Create Table Role (
    Role_ID VARCHAR(20) NOT NULL,
    Description TEXT NOT NULL,
    PRIMARY KEY(Role_ID)
);

Create Table App_User (
    User_ID INT AUTO_INCREMENT NOT NULL,
    Password_Hash CHAR(64) NOT NULL,	-- Need to change once we know what the hash will be for the default user.
    Password_Salt CHAR(64) NOT NULL, -- Need to change when we have this implemented.
    First_Name VARCHAR(200) NOT NULL,
    Last_Name VARCHAR(200) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Address_One VARCHAR(100) NOT NULL,
    Address_Two VARCHAR(100),
    City VARCHAR(100) NOT NULL,
    Territory VARCHAR(50) NOT NULL,
    Zip VARCHAR(10) NOT NULL,
    PRIMARY KEY(User_ID)
);

ALTER TABLE App_User AUTO_INCREMENT = 10000;

ALTER TABLE Call_Record AUTO_INCREMENT = 10000;

ALTER TABLE Call_Record AUTO_INCREMENT = 10000;

Create Table User_Role (
    User_ID INT NOT NULL,
    Role_ID VARCHAR(20) NOT NULL,
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME,
    PRIMARY KEY (User_ID, Role_ID, Start_Date)
);

ALTER TABLE Call_Record
ADD FOREIGN KEY Call_Record_Counselor_ID(Counselor_ID)
REFERENCES App_User(User_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Call_Record
ADD FOREIGN KEY Call_Record_Call_Type_ID(Call_Type_ID)
REFERENCES Call_Type(Call_Type_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Call_Record
ADD FOREIGN KEY Call_Record_Caller_ID(Caller_ID)
REFERENCES Caller(Caller_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Call_Record_Resource
ADD FOREIGN KEY Call_Record_Resource_Call_Record_ID(Call_Record_ID)
REFERENCES Call_Record(Call_Record_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Call_Record_Resource
ADD FOREIGN KEY Call_Record_Resource_Resource_ID(Resource_ID)
REFERENCES Resource_Provider(Resource_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Limitation
ADD FOREIGN KEY Limitation_Limitation_Category_ID(Limitation_Category_ID)
REFERENCES Limitation_Category(Limitation_Category_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Resource_Limitation
ADD FOREIGN KEY Resource_Limitation_Resource_ID(Resource_ID)
REFERENCES Resource_Provider(Resource_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Resource_Limitation
ADD FOREIGN KEY Resource_Limitation_Limitation_ID(Limitation_ID)
REFERENCES Limitation(Limitation_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

/*
ALTER TABLE Resource_Category_Hierarchy
ADD FOREIGN KEY Resource_Category_Hierarchy_Super_Category(Super_Category)
REFERENCES Resource_Category(Resource_Category_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Resource_Category_Hierarchy
ADD FOREIGN KEY Resource_Category_Hierarchy_Sub_Category(Sub_Category)
REFERENCES Resource_Category(Resource_Category_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;
*/

ALTER TABLE Resource_Category_Resource
ADD FOREIGN KEY Resource_Category_Resource_Resource_Category_ID(Resource_Category_ID)
REFERENCES Resource_Category(Resource_Category_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Resource_Category_Resource
ADD FOREIGN KEY Resource_Category_Resource_Resource_ID(Resource_ID)
REFERENCES Resource_Provider(Resource_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE User_Role
ADD FOREIGN KEY User_Role_User_ID(User_ID)
REFERENCES App_User(User_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE User_Role
ADD FOREIGN KEY User_Role_Role_ID(Role_ID)
REFERENCES Role(Role_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;


-- Test data insertion point
INSERT INTO Resource_Category (Resource_Category_ID, Description)
VALUES ('naturalDisasters', 'Flooding tornadoes weather related incidents fires or any incident that is created by a weather disaster')
	,('suicide', 'When a person threatens suicide or plans to commit suicide')
	,('domesticAbuse', 'Violent or aggressive behavior within the home')
	,('economicChanges', 'Loss of a job or medical bills or theft of a purse or cash or utilities being shut off')
	,('communityResources', 'A lack of housing resources or food resources or inadequate crime protection')
;

INSERT INTO Caller (Caller_ID, First_Name, Last_Name, Phone, Address, City, Territory, ZIP)
VALUES (10000, 'John', 'Doe', '1234567890', '123 Somewhere', 'Someburg', 'IA', '52404')
	,  (10001, 'Jane', 'Doe', '1234567891', '123 Somewhere', 'Someburg', 'IA', '52404')
    ,  (10002, 'Ben', 'Dover', '5247841212', '123 Anywhere', 'Knowhere', 'IA', '52403')
;

INSERT INTO Call_Type (Call_Type_ID, Description)
VALUES ('Suicide', 'Calls dealing with people suffering from suicidal thoughts, assisting those who know others with suicidal thoughts, or helping survivors of suicide attempts')
	,  ('Abuse', 'Calls handling acts of physical, emotional, and/or verbal abuse')
    ,  ('Depression', 'Calls assisting those dealing with depression or with callers working with someone suffering from depression')
;
	
INSERT INTO Role (Role_ID, Description)
VALUES ('User','Any peson interacting with the application.')
	,  ('Counselor','Users who create call records, retrieve prior call records, and research crisis resources for use in assisting callers.')
	,  ('Manager',"Perform functions of a counselor, update/review call records, update counselors' status, and review reports.")
	,  ('Business Admin','User who uses reports to enhance PR.')
    ,  ('Data Entry','User who interacts with the Database_System either designing reports or modifying data.')
;

INSERT INTO App_User (Password_Hash, Password_Salt, First_Name, Last_Name, Phone, Address_One, Address_Two, City, Territory, Zip)
VALUES ('Set Password Hash','Set Password','Johnny','Smith', '319-555-5555', '333 Gray Fox Run', '', 'Cedar Rapids', 'IA', '52404')
	,  ('Set Password Hash','Set Password','Bob','Jones', '319-555-5556', 'Kirkwood Apartments', '444 Gray Fox Run', 'Cedar Rapids', 'IA', '52404')
	,  ('Set Password Hash','Set Password','Katie','Perry', '319-555-5557', '555 Gray Fox Run', '', 'Cedar Rapids', 'IA', '52404')
	,  ('Set Password Hash','Set Password','Sara','Walker', '319-555-5558', '666 Gray Fox Run', '', 'Cedar Rapids', 'IA', '52404')
;

INSERT INTO User_Role (User_ID, Role_ID, Start_Date)
VALUES (10000,'User','2017-02-24 10:00:00')
	,  (10000,'Counselor','2017-02-24 10:00:00')
	,  (10001,'User','2016-10-24 10:00:00')
	,  (10001,'Counselor','2016-10-24 10:00:00')
    ,  (10001,'Manager','2016-10-24 10:00:00')
    ,  (10002,'User','2016-11-25 10:00:00')
	,  (10002,'Business Admin','2016-11-25 10:00:00')
    ,  (10003,'User','2016-06-24 10:00:00')
    ,  (10003,'Data Entry','2016-06-24 10:00:00')
;
/*
INSERT INTO Call_Record (Start_Time, Counselor_ID, Call_Description, Call_Type_ID, Caller_ID, End_Time)
VALUES ('2012-12-31 11:30:45', 10000, "Cool call", 10000, 10000, '2012-12-31 11:30:46')
	,  ('2012-12-31 11:30:45', 10000, "Cool call", 10000, 10000, '2012-12-31 11:30:46')
	,  ('2012-12-31 11:30:45', 10000, "Cool call", 10000, 10000, '2012-12-31 11:30:46')
;

INSERT INTO Call_Record_Resource (Call_Record_ID, Resource_ID)
VALUES (10000, 10000)
	,  (10001, 10001)
	,  (10002, 10002)
;
*/
INSERT INTO resource_provider ( Resource_ID, Name, Phone, Address_One, Address_Two, City, Territory, Country, Postal_Code, Description)
			  VALUES ( 10000 , 'Peter Parker' , '319 999 9999', '20 Ingram Street' , NULL, 'Flushing', 'NY', 'US', '11375', 'Super Heroes' )
					, ( 10001 , 'Bruce Wayne' , '319 888 9999', '1007 Mountain Drive' , NULL, 'Gotham', 'NJ', 'US', '21375', 'Super Heroes')
					,( 10002 , 'Thor' , '319 888 8888', 'Some Where in Asgard' , NULL, 'Asgard', 'AG', 'AJ', '99999', 'Super Heroes')
	;		  
/*
INSERT INTO Resource_Limitation (Resource_ID, Limitation_ID)
							VALUES( 10000,10000)
								,( 10001,10001)
								,( 10002,10002)
                                ;
*/