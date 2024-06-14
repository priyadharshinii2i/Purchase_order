USE SCHEMA BOM;
CREATE OR REPLACE PROCEDURE P_ROOT_CORE_BUILD()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
AS
$$
BEGIN 
    INSERT INTO BMATHUB_BASE.T_COMPRESS_BOM_CORE(
        ITEM,    
        ITEM_CLASS_NM,    
        ANCHOR_ITEM_ID,    
        BOM_NUM,    
        LOC,
        CREATE_DTM,    
        CREATE_USER    
    )  
    SELECT 
        INPUT_ITEM_ID,
        ITEM_CLASS_NM,
        INPUT_ITEM_ID AS ANCHOR_ITEM_ID,
        BOM_NUM,
        LOC,
        CURRENT_DATE,
        CURRENT_USER
    FROM BMATHUB_BASE.T_COMPRESS_BOM
    WHERE OUTPUT_ITEM_ID IN (
        SELECT INPUT_ITEM_ID
        FROM BMATHUB_BASE.T_COMPRESS_BOM
        WHERE OUTPUT_ITEM_ID IN (
            SELECT INPUT_ITEM_ID
            FROM BMATHUB_BASE.T_COMPRESS_BOM
            WHERE ITEM_CLASS_NM = 'IC'
        )
    );

    RETURN 'COMPLETED';
END;
$$;