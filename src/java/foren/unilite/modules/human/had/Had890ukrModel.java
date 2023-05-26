package foren.unilite.modules.human.had;

import foren.framework.model.BaseVO;

/**
 * 연말정산내역 이메일 전송 Model
 * @page had890ukr
 */
public class Had890ukrModel extends BaseVO{

	private static final long serialVersionUID = -2986774563116593921L;
	
	private String DIV_CODE;
	private String YEAR_YYYY;
	private String HALFWAY_TYPE_NM;
	private String HALFWAY_TYPE;
	private String PERSON_NUMB;
	private String DEPT_NAME;
	private String DEPT_CODE;
	private String EMAIL_ADDR;
	
	private String NAME;
	
	private String FRRETIREDATE;
	private String TORETIREDATE;
	
	private String TITLE;
	private String COMMENTS;
	

	public String getDIV_CODE() {
		return DIV_CODE;
	}
	public void setDIV_CODE(String dIV_CODE) {
		DIV_CODE = dIV_CODE;
	}
	public String getYEAR_YYYY() {
		return YEAR_YYYY;
	}
	public void setYEAR_YYYY(String yEAR_YYYY) {
		YEAR_YYYY = yEAR_YYYY;
	}
	public String getHALFWAY_TYPE_NM() {
		return HALFWAY_TYPE_NM;
	}
	public void setHALFWAY_TYPE_NM(String hALFWAY_TYPE_NM) {
		HALFWAY_TYPE_NM = hALFWAY_TYPE_NM;
	}
	public String getHALFWAY_TYPE() {
		return HALFWAY_TYPE;
	}
	public void setHALFWAY_TYPE(String hALFWAY_TYPE) {
		HALFWAY_TYPE = hALFWAY_TYPE;
	}
	public String getPERSON_NUMB() {
		return PERSON_NUMB;
	}
	public void setPERSON_NUMB(String pERSON_NUMB) {
		PERSON_NUMB = pERSON_NUMB;
	}
	public String getDEPT_NAME() {
		return DEPT_NAME;
	}
	public void setDEPT_NAME(String dEPT_NAME) {
		DEPT_NAME = dEPT_NAME;
	}
	public String getDEPT_CODE() {
		return DEPT_CODE;
	}
	public void setDEPT_CODE(String dEPT_CODE) {
		DEPT_CODE = dEPT_CODE;
	}
	public String getEMAIL_ADDR() {
		return EMAIL_ADDR;
	}
	public void setEMAIL_ADDR(String eMAIL_ADDR) {
		EMAIL_ADDR = eMAIL_ADDR;
	}
	public String getNAME() {
		return NAME;
	}
	public void setNAME(String nAME) {
		NAME = nAME;
	}
	public String getFRRETIREDATE() {
		return FRRETIREDATE;
	}
	public void setFRRETIREDATE(String fRRETIREDATE) {
		FRRETIREDATE = fRRETIREDATE;
	}
	public String getTORETIREDATE() {
		return TORETIREDATE;
	}
	public void setTORETIREDATE(String tORETIREDATE) {
		TORETIREDATE = tORETIREDATE;
	}
	public String getTITLE() {
		return TITLE;
	}
	public void setTITLE(String tITLE) {
		TITLE = tITLE;
	}
	public String getCOMMENTS() {
		return COMMENTS;
	}
	public void setCOMMENTS(String cOMMENTS) {
		COMMENTS = cOMMENTS;
	}
}
