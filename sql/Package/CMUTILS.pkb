CREATE OR REPLACE PACKAGE BODY TRA_CM.CMUTILS AS
/******************************************************************************
   NAME:       CMUTILS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/16/2012      goindole       1. Created this package.
******************************************************************************/

  FUNCTION IFPAD(Param1 IN varchar2, prefix IN varchar2) RETURN varchar2
  is
    rv   VARCHAR2 (2000);
  begin
    if(param1 is not null) then 
        rv := prefix || param1;    
    else
        rv := '';
    end if;
            
    return rv;
  end;

END CMUTILS;
/