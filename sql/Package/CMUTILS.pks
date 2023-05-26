CREATE OR REPLACE PACKAGE TRA_CM.CMUTILS AS
/******************************************************************************
   NAME:       CMUTILS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/16/2012      goindole       1. Created this package.
******************************************************************************/

  FUNCTION IFPAD(Param1 IN varchar2, prefix IN varchar2) RETURN varchar2;

END CMUTILS;
/