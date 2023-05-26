CREATE OR REPLACE FUNCTION TRA_CM.F_TODATE (dateStr in varchar2 )
RETURN date IS


BEGIN
   
   RETURN to_date(dateStr,'dd/MM/yyyy');
   
END F_TODATE;
/
