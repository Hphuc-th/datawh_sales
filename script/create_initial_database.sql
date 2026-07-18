/**
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
	This script automatically create from scratch DataWarehouse database with 3 schema: Bronze, Sliver, Gold.
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
**/
USE master;
GO 
IF EXISTS ( SELECT 1 FROM sys.databases WHERE name= 'DataWarehouse')
BEGIN 
	ALTER DATABASE Datawarehouse
	SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Datawarehouse;
END 
GO
CREATE DATABASE Datawarehouse;
PRINT (' Created database Datawarehouse successfully ' );
GO 
USE Datawarehouse;
GO

--Create schema 
CREATE SCHEMA bronze;
GO 
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;

