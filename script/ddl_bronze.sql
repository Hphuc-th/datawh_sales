/**
Script purpose : 
	 This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
**/

IF OBJECT_ID( 'bronze.erp_cust_az12','U') IS NOT NULL 
BEGIN
DROP TABLE bronze.erp_cust_az12;
END 
GO
CREATE TABLE bronze.erp_cust_az12
(
	cid VARCHAR(50),
	bdate DATETIME2, 
	gen VARCHAR(50),
);
GO 
IF OBJECT_ID( 'bronze.erp_loc_a101','U') IS NOT NULL 
BEGIN
DROP TABLE bronze.erp_loc_a101;
END 
GO 
CREATE TABLE bronze.erp_loc_a101
(
	cid VARCHAR(50),
	cntry VARCHAR(50), 
);
GO 
IF OBJECT_ID( 'bronze.erp_px_cat_g1v2','U') IS NOT NULL 
BEGIN
DROP TABLE bronze.erp_px_cat_g1v2;
END 
GO 
CREATE TABLE bronze.erp_px_cat_g1v2
(
	id VARCHAR(50),
	cat VARCHAR(50), 
	subcate VARCHAR(50), 
	maintenance VARCHAR(50),
);
GO 
IF OBJECT_ID( 'bronze.crm_cust_info','U') IS NOT NULL 
BEGIN
DROP TABLE bronze.crm_cust_info;
END 
GO
CREATE TABLE bronze.crm_cust_info
(
	cst_id INT,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATETIME2,
);
GO 
IF OBJECT_ID( 'bronze.crm_prd_info','U') IS NOT NULL 
BEGIN
DROP TABLE bronze.crm_prd_info;
END 
GO 
CREATE TABLE bronze.crm_prd_info
(
	prd_id INT,
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost VARCHAR(50),
	prd_line VARCHAR(50),
	prd_start_dt DATETIME2,
	prd_end_dt DATETIME2,
);
GO 
IF OBJECT_ID( 'bronze.crm_sales_details','U') IS NOT NULL 
BEGIN
DROP TABLE bronze.crm_sales_details;
END 
GO 
CREATE TABLE bronze.crm_sales_details
(
	sls_ord_num VARCHAR(50),
	sls_prd_key VARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
);
GO 



