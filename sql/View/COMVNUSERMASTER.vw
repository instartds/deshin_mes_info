CREATE OR REPLACE FORCE VIEW TRA_CM.COMVNUSERMASTER
(ESNTL_ID, USER_ID, PASSWORD, USER_NM, USER_ZIP, 
 USER_ADRES, USER_EMAIL, GROUP_ID, USER_SE, ORGNZT_ID, 
 CUO_CD, ENTRPRS_MBER_ID, CMPNY_NM, CMPNY_TYPE, JOB, 
 DSP_ID)
AS 
SELECT GN.ESNTL_ID, GN.MBER_ID, GN.PASSWORD, GN.MBER_NM, GN.ZIP, GN.ADRES, GN.MBER_EMAIL_ADRES, ' ' AS GROUP_ID, 'GNR' AS USER_SE, ' ' AS ORGNZT_ID,
       EN.CUO_CD, EN.ENTRPRS_MBER_ID, EN.CMPNY_NM, EN.CMPNY_TYPE, GN.JOB, EN.DSP_ID
  FROM COMTNGNRLMBER GN, COMTNENTRPRSMBER EN
 WHERE GN.entrprs_mber_id = EN.entrprs_mber_id;
