package foren.unilite.modules.human.hpa;

import foren.framework.model.BaseVO;

public class Hpa630ukrModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    

    //년차
    private String YEAR_SAVE;
    private String YEAR_BONUS_I;
    private String YEAR_USE;
    private String YEAR_PROV;
    private String REMAINY;
    
    //월차
    private String MONTH_NUM;
    private String MONTH_USE;
    private String MONTH_PROV;
    private String REMAINM;
    
    private String DUTY_YYYY;
    private String PERSON_NUMB;
    
    private String COMP_CODE;
    
    
	public String getYEAR_SAVE() {
		return YEAR_SAVE;
	}
	public void setYEAR_SAVE(String yEAR_SAVE) {
		YEAR_SAVE = yEAR_SAVE;
	}
	public String getYEAR_BONUS_I() {
		return YEAR_BONUS_I;
	}
	public void setYEAR_BONUS_I(String yEAR_BONUS_I) {
		YEAR_BONUS_I = yEAR_BONUS_I;
	}
	public String getYEAR_USE() {
		return YEAR_USE;
	}
	public void setYEAR_USE(String yEAR_USE) {
		YEAR_USE = yEAR_USE;
	}
	public String getYEAR_PROV() {
		return YEAR_PROV;
	}
	public void setYEAR_PROV(String yEAR_PROV) {
		YEAR_PROV = yEAR_PROV;
	}
	public String getREMAINY() {
		return REMAINY;
	}
	public void setREMAINY(String rEMAINY) {
		REMAINY = rEMAINY;
	}
	public String getMONTH_NUM() {
		return MONTH_NUM;
	}
	public void setMONTH_NUM(String mONTH_NUM) {
		MONTH_NUM = mONTH_NUM;
	}
	public String getMONTH_USE() {
		return MONTH_USE;
	}
	public void setMONTH_USE(String mONTH_USE) {
		MONTH_USE = mONTH_USE;
	}
	public String getMONTH_PROV() {
		return MONTH_PROV;
	}
	public void setMONTH_PROV(String mONTH_PROV) {
		MONTH_PROV = mONTH_PROV;
	}
	public String getREMAINM() {
		return REMAINM;
	}
	public void setREMAINM(String rEMAINM) {
		REMAINM = rEMAINM;
	}
	public String getDUTY_YYYY() {
		return DUTY_YYYY;
	}
	public void setDUTY_YYYY(String dUTY_YYYY) {
		DUTY_YYYY = dUTY_YYYY;
	}
	public String getPERSON_NUMB() {
		return PERSON_NUMB;
	}
	public void setPERSON_NUMB(String pERSON_NUMB) {
		PERSON_NUMB = pERSON_NUMB;
	}
	@Override
	public String toString() {
		return "Hpa630ukrModel [YEAR_SAVE=" + YEAR_SAVE + ", YEAR_BONUS_I=" + YEAR_BONUS_I + ", YEAR_USE=" + YEAR_USE + ", YEAR_PROV=" + YEAR_PROV + ", REMAINY=" + REMAINY + ", MONTH_NUM=" + MONTH_NUM + ", MONTH_USE=" + MONTH_USE
				+ ", MONTH_PROV=" + MONTH_PROV + ", REMAINM=" + REMAINM + ", DUTY_YYYY=" + DUTY_YYYY + ", PERSON_NUMB=" + PERSON_NUMB + "]";
	}
	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
    
    
    
    
	
}
