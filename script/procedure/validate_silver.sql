select * from silver.erp_px_cat_g1v2;
--check for null or duplicate in Primary key
-- expected : No result

select id, count(*) 
from silver.erp_px_cat_g1v2 
group by id
having count(*)>1 or id is null 

-- check for unwanted space 
--expected : no result
select maintenance
from silver.erp_px_cat_g1v2
where trim(maintenance) <> maintenance

-- check for Consistence & Standazation 
select distinct subcate
from silver.erp_px_cat_g1v2

