CREATE OR REPLACE FUNCTION TRA_CM.F_TOCRNSTR(crn in varchar2)
RETURN varchar2 IS
BEGIN
       IF(length(crn) = 15) THEN
           RETURN substr(crn,0,11) || '-' || substr(crn,12);
       ELSE
           RETURN substr(crn,0,11) || '-' || substr(crn,12,4) || '-' || substr(crn,16);
       END IF;
END F_TOCRNSTR;
/
