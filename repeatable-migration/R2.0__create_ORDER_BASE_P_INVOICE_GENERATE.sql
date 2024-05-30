USE ORDER_PROCESS.ORDER_BASE;

CREATE
OR REPLACE PROCEDURE ORDER_PROCESS.ORDER_BASE.P_INVOICE_GENERATE() returns varchar LANGUAGE SQL AS '
BEGIN
    insert into order_process.order_base.T_INVOICE(ORDER_ID,
ORDER_DATE,
INVOICE_DATE,
TOTAL_AMOUNT,
DISCOUNT,
TAX_AMOUNT,
FINAL_INVOICE_AMT,
CUSTOMER_ID,
CREATE_DATE,
CREATE_USER)
select 
header.order_id, 
header.order_date,
current_date,
header.total_amount,

case 
when customer.category like ''%GOLD%'' and header.coupon_code like ''%DISCOUNT%''  then header.total_amount * 0.05
when customer.category like ''%SILVER%'' and header.coupon_code like ''%DISCOUNT%''  then header.total_amount * 0.03
when customer.category like ''%BRONZE%'' and header.coupon_code like ''%DISCOUNT%''  then header.total_amount * 0.01
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_X%''  
    then header.TOTAL_AMOUNT*0.03
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_Y%''  
    then header.TOTAL_AMOUNT*0.02
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_Z%''  
    then header.TOTAL_AMOUNT*0.01           
else 0
end as discoffer,

(header.TOTAL_AMOUNT - discoffer) * 0.09 as tax_amount,
(header.TOTAL_AMOUNT - discoffer) + tax_amount as final_invoice_amt,
    
customer.customer_id,
customer.create_date,
customer.create_user
from order_process.order_xfrm.V_ORDER_HEADER header inner join order_process.order_xfrm.v_customer customer on header.customer_id = customer.customer_id where customer.status = ''ACTIVE'' and header.order_date > current_date;
return ''1234'';
END;
';