/*==============================================================================
Script Name    : Create Silver Layer Tables
Script Purpose : Initializes the table structures for the 'silver' schema .
                 
CAUTION     :    RUNNING THIS SCRIPT WILL ENTIRELY DROP AND WIPE ALL 
                 EXISTING DATA IN THE TARGET TABLES. 
Impacted Tables:
  1. silver.erp_cust_az12      - ERP Customer master data
  2. silver.erp_px_cat_g1v2    - ERP Product category 
  3. silver.erp_loc_a101       - ERP Customer location data
  4. silver.crm_cust_info      - CRM Customer birthday
  5. silver.crm_sales_details   - CRM Sales transaction details
  6. silver.crm_prd_info       - CRM Product master data
==============================================================================*/
USE Datawarehouse;
GO

-- Create schema if not exists
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
END
GO

/*==============================================================
  Table: silver.erp_cust_az12
==============================================================*/
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12
(
    cid             NVARCHAR(50),
    bdate           DATE,
    gen             NVARCHAR(20),
    dwh_create_dt   DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

/*==============================================================
  Table: silver.erp_px_cat_g1v2
==============================================================*/
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2
(
    id              NVARCHAR(50),
    cat             NVARCHAR(100),
    subcate         NVARCHAR(100),
    maintenance     NVARCHAR(100),
    dwh_create_dt   DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

/*==============================================================
  Table: silver.erp_loc_a101
==============================================================*/
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101
(
    cid             NVARCHAR(50),
    cntry           NVARCHAR(100),
    dwh_create_dt   DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

/*==============================================================
  Table: silver.crm_cust_info
==============================================================*/
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info
(
    cst_id                INT,
    cst_key               NVARCHAR(50),
    cst_firstname         NVARCHAR(100),
    cst_lastname          NVARCHAR(100),
    cst_marital_status    NVARCHAR(20),
    cst_gndr              NVARCHAR(20),
    cst_create_date       DATE,
    dwh_create_dt         DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

/*==============================================================
  Table: silver.crm_sales_details
==============================================================*/
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details
(
    sls_ord_num       NVARCHAR(50),
    sls_prd_key       NVARCHAR(50),
    sls_cust_id       INT,
    sls_order_dt      DATE,
    sls_ship_dt       DATE,
    sls_due_dt        DATE,
    sls_sales         DECIMAL(18,2),
    sls_quantity      INT,
    sls_price         DECIMAL(18,2),
    dwh_create_dt     DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

/*==============================================================
  Table: silver.crm_prd_info
==============================================================*/
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info
(
    prd_id            INT,
    cat_id            NVARCHAR(10),
    prd_key           NVARCHAR(50),
    prd_nm            NVARCHAR(255),
    prd_cost          DECIMAL(18,2),
    prd_line          NVARCHAR(50),
    prd_start_dt      DATE,
    prd_end_dt        DATE,
    dwh_create_dt     DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

