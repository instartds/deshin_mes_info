package foren.unilite.modules.accnt.atx;

import foren.framework.model.BaseVO;

public class Atx200ukrModel extends BaseVO {
  
    private String  BILL_DIV_CODE;
    private String  PUB_DATE_FR;
    private String  PUB_DATE_TO;
    private String  WRITE_DATE;
    private String  FILE_GUBUN;
    
    
	public String getBILL_DIV_CODE() {
		return BILL_DIV_CODE;
	}
	public void setBILL_DIV_CODE(String bILL_DIV_CODE) {
		BILL_DIV_CODE = bILL_DIV_CODE;
	}
	public String getPUB_DATE_FR() {
		return PUB_DATE_FR;
	}
	public void setPUB_DATE_FR(String pUB_DATE_FR) {
		PUB_DATE_FR = pUB_DATE_FR;
	}
	public String getPUB_DATE_TO() {
		return PUB_DATE_TO;
	}
	public void setPUB_DATE_TO(String pUB_DATE_TO) {
		PUB_DATE_TO = pUB_DATE_TO;
	}
	public String getWRITE_DATE() {
		return WRITE_DATE;
	}
	public void setWRITE_DATE(String wRITE_DATE) {
		WRITE_DATE = wRITE_DATE;
	}
	public String getFILE_GUBUN() {
		return FILE_GUBUN;
	}
	public void setFILE_GUBUN(String fILE_GUBUN) {
		FILE_GUBUN = fILE_GUBUN;
	}
    
}
