USE SCHEMA BOM;
CREATE
	OR replace VIEW BMATHUB_XFRM.V_METADATA_RULES (
	ITEM_CLASS_NM
	,LOCATION_ID
	) AS

SELECT ITEM_CLASS_NM
	,LOCATION_ID
FROM BMATHUB_BASE.T_METADATA_RULES