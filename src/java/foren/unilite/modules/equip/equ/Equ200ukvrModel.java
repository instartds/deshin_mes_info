package foren.unilite.modules.equip.equ;

import java.lang.reflect.Array;

import foren.framework.model.BaseVO;

public class Equ200ukvrModel extends BaseVO {

    private static final long serialVersionUID = 1L;

    private String S_COMP_CODE	;
    private String S_USER_ID	;
    private String  COMP_CODE	;
    private	String	DIV_CODE	;
    private	String	EQU_CODE	;
    private String  FILE_NAME	;
    private String  FILE_TYPE	;
    private String  MANAGE_NO;


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
	public String getMANAGE_NO() {
    	return MANAGE_NO;
    }
    public void setMANAGE_NO(String s_MANAGE_NO) {
    	MANAGE_NO = s_MANAGE_NO;
    }


}
