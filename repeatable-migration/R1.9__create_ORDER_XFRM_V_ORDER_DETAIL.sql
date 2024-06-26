USE ORDER_PROCESS.ORDER_XFRM;

CREATE
OR REPLACE VIEW ORDER_PROCESS.ORDER_XFRM.V_ORDER_DETAIL(
    ORDER_ID,
    ORDER_DATE,
    CUSTOMER_ID,
    ITEM_ID,
    QTY,
    TOTAL_AMOUNT,
    CREATE_DATE,
    CREATE_USER,
    PRICE
) AS
SELECT
    ORDER_ID,
    ORDER_DATE,
    CUSTOMER_ID,
    ITEM_ID,
    QTY,
    TOTAL_AMOUNT,
    CREATE_DATE,
    CREATE_USER,
    PRICE
FROM
    ORDER_PROCESS.ORDER_BASE.T_ORDER_DETAIL;