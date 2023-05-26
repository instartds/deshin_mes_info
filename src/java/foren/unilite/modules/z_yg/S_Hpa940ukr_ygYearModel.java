package foren.unilite.modules.z_yg;

import foren.framework.model.BaseVO;

public class S_Hpa940ukr_ygYearModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    
   
	/* Primary Key */
    private String YEAR_SAVE;
    private String YEAR_BONUS_I;
    private String MONTH_NUM;
    private String YEAR_USE;
    private String YEAR_PROV;
    private String MONTH_PROV;
    
	
	
	@Override
	public String toString() {
		return "S_Hpa940ukr_ygYearModel [YEAR_SAVE=" + YEAR_SAVE + ", YEAR_BONUS_I="
				+ YEAR_BONUS_I + ", MONTH_NUM=" + MONTH_NUM + ", YEAR_USE="
				+ YEAR_USE + ", YEAR_PROV=" + YEAR_PROV + "]";
	}
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
	public String getMONTH_NUM() {
		return MONTH_NUM;
	}
	public void setMONTH_NUM(String mONTH_NUM) {
		MONTH_NUM = mONTH_NUM;
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
	public String getMONTH_PROV() {
		return MONTH_PROV;
	}
	public void setMONTH_PROV(String mONTH_PROV) {
		MONTH_PROV = mONTH_PROV;
	}
 
    	

	
}
