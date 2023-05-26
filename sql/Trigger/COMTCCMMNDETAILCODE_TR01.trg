CREATE OR REPLACE TRIGGER TRA_CM.COMTCCMMNDETAILCODE_TR01
BEFORE INSERT OR UPDATE
ON TRA_CM.COMTCCMMNDETAILCODE
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  :New.LAST_UPDT_PNTTM := sysdate;
END;
/
