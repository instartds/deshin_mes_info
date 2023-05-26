CREATE OR REPLACE FUNCTION TRA_CM.F_TOHSNSTR (hsn in varchar2 )
RETURN varchar2 IS


BEGIN
   
   RETURN lpad(hsn,3,'0') ;
   
END F_TOHSNSTR;
/
