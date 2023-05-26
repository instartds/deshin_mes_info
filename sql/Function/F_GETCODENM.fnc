CREATE OR REPLACE FUNCTION TRA_CM.F_GETCODENM(p_code in varchar2, p_codeGroup in varchar2)
RETURN varchar2 IS
   rtn          VARCHAR2(100);
   E_ERROR      EXCEPTION;
       
/**********************************************
-- dpType : 'D' = return DSP_ID
-- dpType : 'N' = return CMPNY_NM
-- dpType : 'A' = return DSP_ID & CMPNY_NM
-- dpType : 'L' = return [DSP_ID] & CMPNY_NM
**********************************************/
       
BEGIN

       SELECT '[' || p_code || '] ' || code_nm
       INTO rtn
       FROM COMTCCMMNDETAILCODE 
       WHERE code_id  = p_codeGroup
            and code = p_code;

       RETURN rtn;

EXCEPTION
  WHEN E_ERROR THEN
    RETURN '#'||p_code||'#';
  WHEN OTHERS THEN
    RETURN '#'||p_code||'#';
       
END F_GETCODENM;
/