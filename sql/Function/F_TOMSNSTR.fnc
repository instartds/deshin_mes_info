CREATE OR REPLACE FUNCTION TRA_CM.F_TOMSNSTR (msn in varchar2 )
RETURN varchar2 IS


BEGIN
   
   RETURN lpad(msn,4,'0') ;
   
END F_TOMSNSTR;
/
