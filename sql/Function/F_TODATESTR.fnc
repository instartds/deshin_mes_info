CREATE OR REPLACE FUNCTION TRA_CM.F_TODATESTR(date in date) 
RETURN varchar2 IS 

BEGIN
       RETURN TO_CHAR(date, 'dd/MM/yyyy');  
END F_TODATESTR;
/
