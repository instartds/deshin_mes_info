package foren.unilite.modules.z_kocis;

import foren.framework.model.BaseVO;

public class S_Hum710ukrModel_KOCIS extends BaseVO {

    private static final long serialVersionUID = 1L;
    
	private String S_COMP_CODE;
    private String S_USER_ID;
    private String PERSON_NUMB;
    private Integer HEIGHT;
    private Integer	WEIGHT;
    private String SIGHT_LEFT;
    private String SIGHT_RIGHT;
    private String BLOOD_KIND;
    private String COLOR_YN;
    private String LIVE_KIND;
    private Integer	GROUND;
    private Integer	FLOOR_SPACE;
    private Integer	GARDEN;
    private Double	REAL_PROPERTY;
    private String LIVE_LEVEL;
    private String AGENCY_KIND;
    private String AGENCY_GRADE;
    private String HITCH_KIND;
    private Integer	HITCH_GRADE;
    private String HITCH_DATE;
    private String SPECIAL_ABILITY;
    private String RELIGION;
    
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
	public String getPERSON_NUMB() {
		return PERSON_NUMB;
	}
	public void setPERSON_NUMB(String pERSON_NUMB) {
		PERSON_NUMB = pERSON_NUMB;
	}
	public Integer getHEIGHT() {
		return HEIGHT;
	}
	public void setHEIGHT(Integer hEIGHT) {
		if(hEIGHT==null)	{
			HEIGHT = 0;
		}else {
			HEIGHT = hEIGHT;
		}
	}
	public Integer getWEIGHT() {
		return WEIGHT;
	}
	public void setWEIGHT(Integer wEIGHT) {
		if(wEIGHT==null)	{
			WEIGHT = 0;
		}else {
			WEIGHT = wEIGHT;
		}
	}
	public String getSIGHT_LEFT() {
		return SIGHT_LEFT;
	}
	public void setSIGHT_LEFT(String sIGHT_LEFT) {
		SIGHT_LEFT = sIGHT_LEFT;
	}
	public String getSIGHT_RIGHT() {
		return SIGHT_RIGHT;
	}
	public void setSIGHT_RIGHT(String sIGHT_RIGHT) {
		SIGHT_RIGHT = sIGHT_RIGHT;
	}
	public String getBLOOD_KIND() {
		return BLOOD_KIND;
	}
	public void setBLOOD_KIND(String bLOOD_KIND) {
		BLOOD_KIND = bLOOD_KIND;
	}
	public String getCOLOR_YN() {
		return COLOR_YN;
	}
	public void setCOLOR_YN(String cOLOR_YN) {
		COLOR_YN = cOLOR_YN;
	}
	public String getLIVE_KIND() {
		return LIVE_KIND;
	}
	public void setLIVE_KIND(String lIVE_KIND) {
		LIVE_KIND = lIVE_KIND;
	}
	public Integer getGROUND() {
		return GROUND;
	}
	public void setGROUND(Integer gROUND) {
		if(gROUND == null)	{
			GROUND = 0;
		}else {
			GROUND = gROUND;
		}
	}
	public Integer getFLOOR_SPACE() {
		return FLOOR_SPACE;
	}
	public void setFLOOR_SPACE(Integer fLOOR_SPACE) {
		if(fLOOR_SPACE == null)	{
			FLOOR_SPACE = 0;
		}else {
			FLOOR_SPACE = fLOOR_SPACE;
		}
	}
	public Integer getGARDEN() {
		return GARDEN;
	}
	public void setGARDEN(Integer gARDEN) {
		if(gARDEN == null)	{
			GARDEN = 0;
		} else {
			GARDEN = gARDEN;
		}
	}
	public Double getREAL_PROPERTY() {
		return REAL_PROPERTY;
	}
	public void setREAL_PROPERTY(Double rEAL_PROPERTY) {
		if(rEAL_PROPERTY == null)	{
			REAL_PROPERTY = 0.0;
		}else {
			REAL_PROPERTY = rEAL_PROPERTY;
		}
	}
	public String getLIVE_LEVEL() {
		return LIVE_LEVEL;
	}
	public void setLIVE_LEVEL(String lIVE_LEVEL) {
		LIVE_LEVEL = lIVE_LEVEL;
	}
	public String getAGENCY_KIND() {
		return AGENCY_KIND;
	}
	public void setAGENCY_KIND(String aGENCY_KIND) {
		AGENCY_KIND = aGENCY_KIND;
	}
	public String getAGENCY_GRADE() {
		return AGENCY_GRADE;
	}
	public void setAGENCY_GRADE(String aGENCY_GRADE) {
		AGENCY_GRADE = aGENCY_GRADE;
	}
	public String getHITCH_KIND() {
		return HITCH_KIND;
	}
	public void setHITCH_KIND(String hITCH_KIND) {
		HITCH_KIND = hITCH_KIND;
	}
	public Integer getHITCH_GRADE() {
		return HITCH_GRADE;
	}
	public void setHITCH_GRADE(Integer hITCH_GRADE) {
		if(hITCH_GRADE == null)	{
			HITCH_GRADE = 0;
		}else {
			HITCH_GRADE = hITCH_GRADE;
		}
	}
	public String getHITCH_DATE() {
		return HITCH_DATE;
	}
	public void setHITCH_DATE(String hITCH_DATE) {
		HITCH_DATE = hITCH_DATE;
	}
	public String getSPECIAL_ABILITY() {
		return SPECIAL_ABILITY;
	}
	public void setSPECIAL_ABILITY(String sPECIAL_ABILITY) {
		SPECIAL_ABILITY = sPECIAL_ABILITY;
	}
	public String getRELIGION() {
		return RELIGION;
	}
	public void setRELIGION(String rELIGION) {
		RELIGION = rELIGION;
	}

}
