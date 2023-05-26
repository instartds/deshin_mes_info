CREATE OR REPLACE FUNCTION TRA_CM.F_GETCOMPINFO(entrprsMberId in varchar2, dpType in varchar2)
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
       IF(dpType = 'D') THEN
           SELECT DSP_ID
           INTO rtn
           FROM COMTNENTRPRSMBER WHERE ENTRPRS_MBER_ID = entrprsMberId;
       ELSIF (dpType = 'N') THEN
           SELECT CMPNY_NM 
           INTO rtn
           FROM COMTNENTRPRSMBER WHERE ENTRPRS_MBER_ID = entrprsMberId;
       ELSIF (dpType = 'A') THEN
           SELECT DSP_ID || ',' || CMPNY_NM
           INTO rtn
           FROM COMTNENTRPRSMBER WHERE ENTRPRS_MBER_ID = entrprsMberId;
       ELSIF (dpType = 'L') THEN
           SELECT '[' || DSP_ID || '] ' || CMPNY_NM
           INTO rtn
           FROM COMTNENTRPRSMBER WHERE ENTRPRS_MBER_ID = entrprsMberId;
       ELSE 
          rtn := '#'||entrprsMberId||'#';
       END IF;
       RETURN rtn;

EXCEPTION
  WHEN E_ERROR THEN
    RETURN '#'||entrprsMberId||'#';
  WHEN OTHERS THEN
    RETURN '#'||entrprsMberId||'#';
       
END F_GETCOMPINFO;
/
