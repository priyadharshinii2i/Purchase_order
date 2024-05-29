USE ORDER_PROCESS.ORDER_BASE;

CREATE OR REPLACE PROCEDURE ORDER_PROCESS.ORDER_BASE.P_INVOICE_GENERATE()
returns varchar
LANGUAGE SQL
AS
'
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
when customer.category like ''%GOLD%'' and header.coupon_code like ''%LOYALITY%'' and header.total_amount >1000 then header.TOTAL_AMOUNT*1
when customer.category like ''%SILVER%'' and header.coupon_code like ''%LOYALITY%'' and header.total_amount >1000then header.TOTAL_AMOUNT*1
when customer.category like ''%BRONZE%'' and header.coupon_code like ''%LOYALITY%'' and header.total_amount >1000 then header.TOTAL_AMOUNT*1
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_X%''  
    then header.TOTAL_AMOUNT*0.03
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_Y%''  
    then header.TOTAL_AMOUNT*0.02
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_Z%''  
    then header.TOTAL_AMOUNT*0.01           
else 0
end as discount,

case 
when customer.category like ''%GOLD%'' and header.coupon_code like ''%DISCOUNT%''  then (header.total_amount -(header.total_amount * 0.05)) * 0.09
when customer.category like ''%SILVER%'' and header.coupon_code like ''%DISCOUNT%''  then (header.TOTAL_AMOUNT -(header.total_amount * 0.03)) * 0.09
when customer.category like ''%BRONZE%'' and header.coupon_code like ''%DISCOUNT%''  then (header.TOTAL_AMOUNT -(header.total_amount * 0.01))* 0.09
when customer.category like ''%GOLD%'' and header.coupon_code like ''%LOYALITY%'' and header.total_amount >1000 then (header.TOTAL_AMOUNT * 1)*0.09
when customer.category like ''%SILVER%'' and header.coupon_code like ''%LOYALITY%'' and header.total_amount >1000then (header.TOTAL_AMOUNT * 1 )*0.09
when customer.category like ''%BRONZE%'' and header.coupon_code like ''%LOYALITY%'' and header.total_amount >1000 then (header.TOTAL_AMOUNT * 1)*0.09
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_X%''  
  then (header.TOTAL_AMOUNT - (header.TOTAL_AMOUNT*0.03))*0.09
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_Y%''  
  then (header.TOTAL_AMOUNT - (header.TOTAL_AMOUNT*0.02))*0.09
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_Z%''  
  then (header.TOTAL_AMOUNT - (header.TOTAL_AMOUNT*0.01))*0.09       
else 0
end as tax_amount,


case 
when customer.category like ''%GOLD%'' and header.coupon_code like ''%DISCOUNT%''  then (header.total_amount -(header.total_amount * 0.05)) + tax_amount
when customer.category like ''%SILVER%'' and header.coupon_code like ''%DISCOUNT%''  then (header.TOTAL_AMOUNT -(header.total_amount * 0.03))  + tax_amount
when customer.category like ''%BRONZE%'' and header.coupon_code like ''%DISCOUNT%''  then (header.TOTAL_AMOUNT -(header.total_amount * 0.01)) + tax_amount
when customer.category like ''%GOLD%'' and header.coupon_code like ''%LOYALITY%'' and header.total_amount >1000 then (header.TOTAL_AMOUNT * 1) + tax_amount
when customer.category like ''%SILVER%'' and header.coupon_code like ''%LOYALITY%'' and header.total_amount >1000then (header.TOTAL_AMOUNT * 1 ) + tax_amount
when customer.category like ''%BRONZE%'' and header.coupon_code like ''%LOYALITY%'' and header.total_amount >1000 then (header.TOTAL_AMOUNT * 1) + tax_amount
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_X%''  
  then (header.TOTAL_AMOUNT - (header.TOTAL_AMOUNT*0.03)) + tax_amount
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_Y%''  
  then (header.TOTAL_AMOUNT - (header.TOTAL_AMOUNT*0.02)) + tax_amount
when customer.category like ''%REGULAR%'' and header.coupon_code like ''%COUPON_Z%''  
  then (header.TOTAL_AMOUNT - (header.TOTAL_AMOUNT*0.01)) + tax_amount 
else 0
end as final_invoice_amt,
    
customer.customer_id,
customer.create_date,
customer.create_user
from order_process.order_xfrm.V_ORDER_HEADER header inner join order_process.order_xfrm.v_customer customer on header.customer_id = customer.customer_id where customer.status = ''ACTIVE'' and header.order_date > current_date;
return ''1234'';
END;
';
