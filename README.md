# Datawh_sales 
This is a project that buildes a datawarehouse for intergrating data from multiple sources into a single source of data.By centralizing data, the platform delivers a standardized and trustworthy foundation to support strategic Decision-Making and Business Intelligence.
## Layer : 
- Bronze Layer: Stores raw, unprocessed data as is from sources. 
- Sliver Layer : Stores cleaned , standalized data.
- Gold Layer :  Stores Business-Ready data.
Detail in : https://drive.google.com/file/d/14XHeJx1sd5xzwTIAg2UX8vlxnmlHdzPy/view?usp=drive_link
## Naming conventions:
- Language: Use english for all names.
- Naming convention : Use lowercase letters and sperate words by underscore (*_*)
  ### **Bronze Rules**
  - All names must start with the source system name, and table names must match their original names without renaming.
  - **`<sourcesystem>_<entity>`**  
    - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).  
    - `<entity>`: Exact table name from the source system.  
    - Example: `crm_customer_info` → Customer information from the CRM system.
  
  ### **Silver Rules**
  - All names must start with the source system name, and table names must match their original names without renaming.
  - **`<sourcesystem>_<entity>`**  
    - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).  
    - `<entity>`: Exact table name from the source system.  
    - Example: `crm_customer_info` → Customer information from the CRM system.
  
  ### **Gold Rules**
  - All names must use meaningful, business-aligned names for tables, starting with the category prefix.
  - **`<category>_<entity>`**  
    - `<category>`: Describes the role of the table, such as `dim` (dimension) or `fact` (fact table).  
    - `<entity>`: Descriptive name of the table, aligned with the business domain (e.g., `customers`, `products`, `sales`).  
    - Examples:
      - `dim_customers` → Dimension table for customer data.  
      - `fact_sales` → Fact table containing sales transactions.  



