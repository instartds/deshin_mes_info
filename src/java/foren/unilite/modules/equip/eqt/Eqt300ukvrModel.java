package foren.unilite.modules.equip.eqt;

import foren.framework.model.BaseVO;

public class Eqt300ukvrModel extends BaseVO {

    private static final long serialVersionUID = 1L;
    
    private String S_COMP_CODE	;
    private String S_USER_ID	;
    private String  COMP_CODE	;
    private	String	DIV_CODE	;
    private	String	EQU_CODE	;
    private String  FILE_NAME	;
    private String  FILE_TYPE	;
    private String  CTRL_TYPE	;
    
    


	private int  SER_NO	;
    private String  IMAGE_FID	;
    
	
	public String getS_COMP_CODE() {
		return S_COMP_CODE;
	}
	public void setS_COMP_CODE(String s_COMP_CODE) {
		S_COMP_CODE = s_COMP_CODE;
	}
	public String getS_USER_ID() {
		return S_USER_ID;
	}
	public void setS_USER_ID(String s_USER_ID) {
		S_USER_ID = s_USER_ID;
	}
	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	public String getEQU_CODE() {
		return EQU_CODE;
	}
	public void setEQU_CODE(String eQU_CODE) {
		EQU_CODE = eQU_CODE;
	}
	
	public String getFILE_NAME() {
		return FILE_NAME;
	}
	public void setFILE_NAME(String fILE_NAME) {
		FILE_NAME = fILE_NAME;
	}
	public String getFILE_TYPE() {
		return FILE_TYPE;
	}
	public void setFILE_TYPE(String fILE_TYPE) {
		FILE_TYPE = fILE_TYPE;
	}
	public String getCTRL_TYPE() {
		return CTRL_TYPE;
	}
	public void setCTRL_TYPE(String cTRL_TYPE) {
		CTRL_TYPE = cTRL_TYPE;
	}
    public int getSER_NO() {
		return SER_NO;
	}
	public void setSER_NO(int sER_NO) {
		SER_NO = sER_NO;
	}
	public String getIMAGE_FID() {
		return IMAGE_FID;
	}
	public void setIMAGE_FID(String iMAGE_FID) {
		IMAGE_FID = iMAGE_FID;
	}
}
