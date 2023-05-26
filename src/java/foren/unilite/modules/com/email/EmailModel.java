package foren.unilite.modules.com.email;

import foren.framework.model.BaseVO;

public class EmailModel  extends BaseVO {
	
	private static final long serialVersionUID = 1L;
	
	private String TO ;
	private String FROM ;
	private String SUBJECT;
	private String TEXT;
	private String CC;
	private String BCC;
	private boolean hasHtmlText = false;
	private String FILE;
	private String COMP_CODE;
	
	public EmailModel() {
		
	}


	public String getTO() {
		return TO;
	}


	public void setTO(String tO) {
		TO = tO;
	}

	public String getFROM() {
		return FROM;
	}


	public void setFROM(String fROM) {
		FROM = fROM;
	}


	public String getSUBJECT() {
		return SUBJECT;
	}


	public void setSUBJECT(String sUBJECT) {
		SUBJECT = sUBJECT;
	}


	public String getTEXT() {
		return TEXT;
	}


	public void setTEXT(String tEXT) {
		TEXT = tEXT;
	}


	public String getCC() {
		return CC;
	}


	public void setCC(String cC) {
		CC = cC;
	}


	public String getBCC() {
		return BCC;
	}


	public void setBCC(String bCC) {
		BCC = bCC;
	}
	

	public boolean hasHtmlText() {
		return hasHtmlText;
	}


	public void setHasHtmlText(boolean hasHtmlText) {
		this.hasHtmlText = hasHtmlText;
	}


	public static long getSerialversionuid() {
		return serialVersionUID;
	}


	public String getFILE() {
		return FILE;
	}


	public void setFILE(String fILE) {
		FILE = fILE;
	}


	public String getCOMP_CODE() {
		return COMP_CODE;
	}


	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
	
	
	
}
