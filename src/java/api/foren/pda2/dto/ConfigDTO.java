package api.foren.pda2.dto;

import java.io.Serializable;

import foren.framework.model.LoginVO;

public class ConfigDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String compCode;
	
	private String divCode;
	
	private String dataCode;
	
	private String dataValue;
	
	private String dataName;
	
	private LoginVO userInfo;

	public String getCompCode() {
		return compCode;
	}

	public void setCompCode(String compCode) {
		this.compCode = compCode;
	}

	public String getDivCode() {
		return divCode;
	}

	public void setDivCode(String divCode) {
		this.divCode = divCode;
	}

	public String getDataCode() {
		return dataCode;
	}

	public void setDataCode(String dataCode) {
		this.dataCode = dataCode;
	}

	public String getDataValue() {
		return dataValue;
	}

	public void setDataValue(String dataValue) {
		this.dataValue = dataValue;
	}

	public String getDataName() {
		return dataName;
	}

	public void setDataName(String dataName) {
		this.dataName = dataName;
	}

	public LoginVO getUserInfo() {
		return userInfo;
	}

	public void setUserInfo(LoginVO userInfo) {
		this.userInfo = userInfo;
	}

	@Override
	public String toString() {
		return "ConfigDTO [compCode=" + compCode + ", divCode=" + divCode + ", dataCode=" + dataCode + ", dataValue="
				+ dataValue + ", dataName=" + dataName + ", userInfo=" + userInfo + "]";
	}
	
}
