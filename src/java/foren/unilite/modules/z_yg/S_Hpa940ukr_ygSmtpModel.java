package foren.unilite.modules.z_yg;

import foren.framework.model.BaseVO;

public class S_Hpa940ukr_ygSmtpModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
	private String SEND_METHOD;
	private String SERVER_NAME;
	private String SERVER_PROT;
	private String PICKUP_FOLDER_PATH;
	private String SEND_USER_NAME;
	private String SEND_PASSWORD;
	private String CONN_TIMEOUT;
	private String SSL_USE_YN;
	
	private String FROM_ADDR;
	
	public String getSEND_METHOD() {
		return SEND_METHOD;
	}
	public void setSEND_METHOD(String sEND_METHOD) {
		SEND_METHOD = sEND_METHOD;
	}
	public String getSERVER_NAME() {
		return SERVER_NAME;
	}
	public void setSERVER_NAME(String sERVER_NAME) {
		SERVER_NAME = sERVER_NAME;
	}
	public String getSERVER_PROT() {
		return SERVER_PROT;
	}
	public void setSERVER_PROT(String sERVER_PROT) {
		SERVER_PROT = sERVER_PROT;
	}
	public String getPICKUP_FOLDER_PATH() {
		return PICKUP_FOLDER_PATH;
	}
	public void setPICKUP_FOLDER_PATH(String pICKUP_FOLDER_PATH) {
		PICKUP_FOLDER_PATH = pICKUP_FOLDER_PATH;
	}
	public String getSEND_USER_NAME() {
		return SEND_USER_NAME;
	}
	public void setSEND_USER_NAME(String sEND_USER_NAME) {
		SEND_USER_NAME = sEND_USER_NAME;
	}
	public String getSEND_PASSWORD() {
		return SEND_PASSWORD;
	}
	public void setSEND_PASSWORD(String sEND_PASSWORD) {
		SEND_PASSWORD = sEND_PASSWORD;
	}
	public String getCONN_TIMEOUT() {
		return CONN_TIMEOUT;
	}
	public void setCONN_TIMEOUT(String cONN_TIMEOUT) {
		CONN_TIMEOUT = cONN_TIMEOUT;
	}
	public String getSSL_USE_YN() {
		return SSL_USE_YN;
	}
	public void setSSL_USE_YN(String sSL_USE_YN) {
		SSL_USE_YN = sSL_USE_YN;
	}
	
	@Override
	public String toString() {
		return "S_Hpa940ukr_ygSmtpModel [SEND_METHOD=" + SEND_METHOD
				+ ", SERVER_NAME=" + SERVER_NAME + ", SERVER_PROT="
				+ SERVER_PROT + ", PICKUP_FOLDER_PATH=" + PICKUP_FOLDER_PATH
				+ ", SEND_USER_NAME=" + SEND_USER_NAME + ", SEND_PASSWORD="
				+ SEND_PASSWORD + ", CONN_TIMEOUT=" + CONN_TIMEOUT
				+ ", SSL_USE_YN=" + SSL_USE_YN + ", FROM_ADDR=" + FROM_ADDR
				+ "]";
	}
	public String getFROM_ADDR() {
		return FROM_ADDR;
	}
	public void setFROM_ADDR(String fROM_ADDR) {
		FROM_ADDR = fROM_ADDR;
	}
	
	
	
	
	
}
