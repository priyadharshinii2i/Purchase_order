USE SCHEMA BOM;

create or replace table MASTER_DATA.ITEM (
    ITEM_ID VARCHAR(21), 
    ITEM_CLASS_NM VARCHAR(30), 
    ITEM_DSC VARCHAR(30), 
    DELETE_IND VARCHAR(10));