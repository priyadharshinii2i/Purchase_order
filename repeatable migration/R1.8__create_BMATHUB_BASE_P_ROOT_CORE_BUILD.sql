CREATE OR REPLACE PROCEDURE P_MASTER_ROOT_MAINTAIN()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
AS
'
BEGIN
        truncate table BMATHUB_BASE.T_COMPRESS_BOM_CORE
        Insert into BMATHUB_BASE.T_COMPRESS_BOM_CORE (
            ITEM,
            ITEM_CLASS_NM,
            ANCHOR_ITEM_ID,
            BOM_NUM,
            LOC,
            CREATE_DTM,
            CREATE_USER
        ) 
        SELECT  
            BOM1.ITEM_ID,
            BOM1.ITEM_CLASS_NM,
            BOM3.ITEM_ID,
            BOMNUM.NEXTVAL,
            ''VF_FG'',
            CURRENT_DATE,
            CURRENT_USER
        FROM BMATHUB_XFRM.V_ORIG_BOM_ROOT AS BOM1 
        JOIN BMATHUB_XFRM.V_ORIG_BOM_ROOT AS BOM2 ON BOM1.ITEM_ID = BOM2.OUTPUT_ITEM_ID JOIN                                        BMATHUB_XFRM.V_ORIG_BOM_ROOT AS BOM3 ON BOM2.ITEM_ID = BOM3.OUTPUT_ITEM_ID WHERE                                            BOM3.ITEM_CLASS_NM =''UPI_SORT'' AND BOM1.ITEM_CLASS_NM = ''IC''  AND BOM2.ITEM_CLASS_NM =''UPI_DIE_PREP'';
  RETURN ''completed'';
END;
';
