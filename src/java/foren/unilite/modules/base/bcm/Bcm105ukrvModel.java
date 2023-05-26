package foren.unilite.modules.base.bcm;

import foren.framework.model.BaseVO;
import foren.framework.utils.ObjUtils;

public class Bcm105ukrvModel extends BaseVO {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    
    /* Primary Key */
     private String  CUSTOM_CODE;    		//거래처코드' 		,type:'string'	, isPk:true, pkGen:'user'},
	 private String  CUSTOM_TYPE;    		//구분' 			,type:'string'	,comboType:'AU',comboCode:'B015' ,allowBlank: false, defaultValue:'1'},
	 private String  CUSTOM_NAME;    		//거래처명' 		,type:'string'	,allowBlank:false},
	 private String  CUSTOM_NAME1;    		//거래처명1' 		,type:'string'	},
	 private String  CUSTOM_NAME2;    		//거래처명2' 		,type:'string'	},
	 private String  CUSTOM_FULL_NAME;    	//거래처명(전명)' 	,type:'string'	,allowBlank:false},
	 private String  NATION_CODE;    		//국가코드' 		,type:'string'	,comboType:'AU',comboCode:'B012'},
	 private String  COMPANY_NUM;    		//사업자번호' 		,type:'string'	},
	 private String  SERVANT_COMPANY_NUM;	//종사업자번호' 		,type:'string'	},
	 private String  TOP_NUM;    			//'주민번호' 		,type:'string'	},
	 private String  TOP_NAME;    			//'대표자' 			,type:'string'	},
	 private String  BUSINESS_TYPE;    		//법인/구분' 		,type:'string'	,comboType:'AU',comboCode:'B016'},
	 private String  USE_YN;    			//'사용유무' 		,type:'string'	,comboType:'AU',comboCode:'B010', defaultValue:'Y'},
	 private String  COMP_TYPE;    			//업태' 			,type:'string'	},
	 private String  COMP_CLASS;    		//업종' 			,type:'string'	},
	 private String  AGENT_TYPE;    		//거래처분류' 		,type:'string'	,comboType:'AU',comboCode:'B055' ,allowBlank: false, defaultValue:'1'},
	 private String  AGENT_TYPE2;    		//거래처분류2' 		,type:'string'	},
	 private String  AGENT_TYPE3;    		//거래처분류3' 		,type:'string'	},
	 private String  AREA_TYPE;    			//지역' 			,type:'string'	,comboType:'AU',comboCode:'B056'},
	 private String  ZIP_CODE;    			//'우편번호' 		,type:'string'	},
	 private String  ADDR1;    				//'주소1' 			,type:'string'	},
	 private String  ADDR2;    				//'주소2' 			,type:'string'	},					
	 private String  TELEPHON;    			//'연락처' 			,type:'string'	},
	 private String  FAX_NUM;    			//'FAX번호' 		,type:'string'	},
	 private String  HTTP_ADDR;    			//홈페이지' 		,type:'string'	},  
	 private String  MAIL_ID;    			//'E-mail' 			,type:'string'	},
	 private String  WON_CALC_BAS;    		//원미만계산' 		,type:'string'	,comboType:'AU',comboCode:'B017'},
	 private String  START_DATE;    		//거래시작일' 		,type:'uniDate'	,allowBlank: false, defaultValue:UniDate.today()},
	 private String  STOP_DATE;    			//거래중단일' 		,type:'uniDate'	},
	 private String  TO_ADDRESS;    		//송신주소' 		,type:'string'	},
	 private String  TAX_CALC_TYPE;    		//세액계산법' 		,type:'string'	,comboType:'AU',comboCode:'B051', defaultValue:'1'},
	 private String  RECEIPT_DAY;    		//결제기간' 		,type:'string'	,comboType:'AU',comboCode:'B034'},
	 private String  MONEY_UNIT;    		//기준화폐' 		,type:'string'	, comboType:'AU',comboCode:'B004'},
	 private String  TAX_TYPE;    			//'세액포함여부' 	,type:'string'	, comboType:'AU',comboCode:'B030', defaultValue:'1'},
	 private String  BILL_TYPE;    			//계산서유형' 		,type:'string'	, comboType:'AU',comboCode:'A022'},
	 private String  SET_METH;    			//'결제방법' 		,type:'string'	, comboType:'AU',comboCode:'B038'},
	 private float  VAT_RATE;    			//'세율' 			,type:'uniFC'	,defaultValue:0},
	 private String  TRANS_CLOSE_DAY;    	//마감종류' 		,type:'string'	, comboType:'AU',comboCode:'B033'},
	 private int    COLLECT_DAY;    		//수금일'  			,type:'integer' ,defaultValue:1, minValue:1},                  
	 private String  CREDIT_YN;    			//여신적용여부' 	,type:'string'	, comboType:'AU',comboCode:'B010'},
	 private double  TOT_CREDIT_AMT;    	//여신(담보)액' 	,type:'uniPrice'	},
	 private double  CREDIT_AMT;    		//신용여신액' 		,type:'uniPrice'	},
	 private String  CREDIT_YMD;    		//신용여신만료일' 	,type:'uniDate'	},
	 private String  COLLECT_CARE;    		//미수관리방법' 	,type:'string'	, comboType:'AU',comboCode:'B057', defaultValue:'1'},
	 private String  BUSI_PRSN;    			//주담당자' 		,type:'string'	, comboType:'AU',comboCode:'S010'},
	 private String  CAL_TYPE;    			//'카렌더타입' 		,type:'string'	, comboType:'AU',comboCode:'B062'},
	 private String  REMARK;    			//'비고' 			,type:'string'	},
	 private String  MANAGE_CUSTOM;    		//집계거래처' 		,type:'string'	},					
	 private String  MCUSTOM_NAME;    		//집계거래처명' 	,type:'string'	},
	 private String  COLLECTOR_CP;    		//수금거래처' 		,type:'string'	},					
	 private String  COLLECTOR_CP_NAME;    	//수금거래처명' 	,type:'string'	},					
	 private String  BANK_CODE;    			//금융기관' 		,type:'string'	},
	 private String  BANK_NAME;    			//금융기관명' 		,type:'string'	},
	 private String  BANKBOOK_NUM;    		//계좌번호' 		,type:'string'	},
	 private String  BANKBOOK_NAME;    		//예금주' 			,type:'string'	},
	 private String  CUST_CHK;    			//'거래처변경여부' 	,type:'string'	},
	 private String  SSN_CHK;    			//'주민번호변경여부',type:'string'	},
	 private String  UPDATE_DB_USER;    	//작성자' 			,type:'string'	},
	 private String  UPDATE_DB_TIME;    	//작성시간' 		,type:'uniDate'	},
	 private String  PURCHASE_BANK;    		//구매카드은행' 	,type:'string'	},
	 private String  PURBANKNAME;    		//구매카드은행명' 	,type:'string'	},
	 private String  BILL_PRSN;    			//전자문서담당자' 	,type:'string'	},
	 private String  HAND_PHON;    			//핸드폰번호' 		,type:'string'	},
	 private String  BILL_MAIL_ID;    		//전자문서E-mail'	,type:'string'	},
	 private String  BILL_PRSN2;    		//전자문서담당자2' 	,type:'string'	},
	 private String  HAND_PHON2;    		//핸드폰번호2' 		,type:'string'	},
	 private String  BILL_MAIL_ID2;    		//전자문서E-mail2'	,type:'string'	},
	 private String  BILL_MEM_TYPE;    		//전자세금계산서' 	,type:'string'	},
	 private String  ADDR_TYPE;    			//신/구주소 구분' 	,type:'string'	, comboType:'AU',comboCode:'B232'},
	 private String  COMP_CODE;    			//COMP_CODE' 		,type:'string'	, defaultValue: UserInfo.compCode},
	 private String  CHANNEL;    			//'CHANNEL' 		,type:'string'	},
	 private String  BILL_CUSTOM;    		//계산서거래처코드'	,type:'string'	},
	 private String  BILL_CUSTOM_NAME;    	//계산서거래처' 	,type:'string'	},
	 private String  CREDIT_OVER_YN;    	//CREDIT_OVER_YN' 	,type:'string'	},
	 private String  Flag;    				//Flag' 			,type:'string'	},    
	 private String  DEPT_CODE;    			//관련부서' 		,type:'string'	},    
	 private String  DEPT_NAME;    			//관련부서명' 		,type:'string'	},
	 private String  BILL_PUBLISH_TYPE;    	//전자세금계산서발행유형' 		,type:'string'	, defaultValue:'1'}, //임시 2016.11.07
	 // 추가(극동)   
     private String  R_PAYMENT_YN;			//정기결제여부'    	,type:'string', allowBlank: false , comboType:'AU',comboCode:'B010' },    
     private String  DELIVERY_METH;			//운송방법'        	,type:'string'  }
	
     public String getCUSTOM_CODE() {
		return CUSTOM_CODE;
	}
	public void setCUSTOM_CODE(String cUSTOM_CODE) {
		CUSTOM_CODE = cUSTOM_CODE;
	}
	public String getCUSTOM_TYPE() {
		return CUSTOM_TYPE;
	}
	public void setCUSTOM_TYPE(String cUSTOM_TYPE) {
		CUSTOM_TYPE = cUSTOM_TYPE;
	}
	public String getCUSTOM_NAME() {
		return CUSTOM_NAME;
	}
	public void setCUSTOM_NAME(String cUSTOM_NAME) {
		CUSTOM_NAME = cUSTOM_NAME;
	}
	public String getCUSTOM_NAME1() {
		return CUSTOM_NAME1;
	}
	public void setCUSTOM_NAME1(String cUSTOM_NAME1) {
		CUSTOM_NAME1 = cUSTOM_NAME1;
	}
	public String getCUSTOM_NAME2() {
		return CUSTOM_NAME2;
	}
	public void setCUSTOM_NAME2(String cUSTOM_NAME2) {
		CUSTOM_NAME2 = cUSTOM_NAME2;
	}
	public String getCUSTOM_FULL_NAME() {
		return CUSTOM_FULL_NAME;
	}
	public void setCUSTOM_FULL_NAME(String cUSTOM_FULL_NAME) {
		CUSTOM_FULL_NAME = cUSTOM_FULL_NAME;
	}
	public String getNATION_CODE() {
		return NATION_CODE;
	}
	public void setNATION_CODE(String nATION_CODE) {
		NATION_CODE = nATION_CODE;
	}
	public String getCOMPANY_NUM() {
		return COMPANY_NUM;
	}
	public void setCOMPANY_NUM(String cOMPANY_NUM) {
		COMPANY_NUM = cOMPANY_NUM;
	}
	public String getSERVANT_COMPANY_NUM() {
		return SERVANT_COMPANY_NUM;
	}
	public void setSERVANT_COMPANY_NUM(String sERVANT_COMPANY_NUM) {
		SERVANT_COMPANY_NUM = sERVANT_COMPANY_NUM;
	}
	public String getTOP_NUM() {
		return TOP_NUM;
	}
	public void setTOP_NUM(String tOP_NUM) {
		TOP_NUM = tOP_NUM;
	}
	public String getTOP_NAME() {
		return TOP_NAME;
	}
	public void setTOP_NAME(String tOP_NAME) {
		TOP_NAME = tOP_NAME;
	}
	public String getBUSINESS_TYPE() {
		return BUSINESS_TYPE;
	}
	public void setBUSINESS_TYPE(String bUSINESS_TYPE) {
		BUSINESS_TYPE = bUSINESS_TYPE;
	}
	public String getUSE_YN() {
		return USE_YN;
	}
	public void setUSE_YN(String uSE_YN) {
		USE_YN = uSE_YN;
	}
	public String getCOMP_TYPE() {
		return COMP_TYPE;
	}
	public void setCOMP_TYPE(String cOMP_TYPE) {
		COMP_TYPE = cOMP_TYPE;
	}
	public String getCOMP_CLASS() {
		return COMP_CLASS;
	}
	public void setCOMP_CLASS(String cOMP_CLASS) {
		COMP_CLASS = cOMP_CLASS;
	}
	public String getAGENT_TYPE() {
		return AGENT_TYPE;
	}
	public void setAGENT_TYPE(String aGENT_TYPE) {
		AGENT_TYPE = aGENT_TYPE;
	}
	public String getAGENT_TYPE2() {
		return AGENT_TYPE2;
	}
	public void setAGENT_TYPE2(String aGENT_TYPE2) {
		AGENT_TYPE2 = aGENT_TYPE2;
	}
	public String getAGENT_TYPE3() {
		return AGENT_TYPE3;
	}
	public void setAGENT_TYPE3(String aGENT_TYPE3) {
		AGENT_TYPE3 = aGENT_TYPE3;
	}
	public String getAREA_TYPE() {
		return AREA_TYPE;
	}
	public void setAREA_TYPE(String aREA_TYPE) {
		AREA_TYPE = aREA_TYPE;
	}
	public String getZIP_CODE() {
		return ZIP_CODE;
	}
	public void setZIP_CODE(String zIP_CODE) {
		ZIP_CODE = zIP_CODE;
	}
	public String getADDR1() {
		return ADDR1;
	}
	public void setADDR1(String aDDR1) {
		ADDR1 = aDDR1;
	}
	public String getADDR2() {
		return ADDR2;
	}
	public void setADDR2(String aDDR2) {
		ADDR2 = aDDR2;
	}
	public String getTELEPHON() {
		return TELEPHON;
	}
	public void setTELEPHON(String tELEPHON) {
		TELEPHON = tELEPHON;
	}
	public String getFAX_NUM() {
		return FAX_NUM;
	}
	public void setFAX_NUM(String fAX_NUM) {
		FAX_NUM = fAX_NUM;
	}
	public String getHTTP_ADDR() {
		return HTTP_ADDR;
	}
	public void setHTTP_ADDR(String hTTP_ADDR) {
		HTTP_ADDR = hTTP_ADDR;
	}
	public String getMAIL_ID() {
		return MAIL_ID;
	}
	public void setMAIL_ID(String mAIL_ID) {
		MAIL_ID = mAIL_ID;
	}
	public String getWON_CALC_BAS() {
		return WON_CALC_BAS;
	}
	public void setWON_CALC_BAS(String wON_CALC_BAS) {
		WON_CALC_BAS = wON_CALC_BAS;
	}
	public String getSTART_DATE() {
		return START_DATE;
	}
	public void setSTART_DATE(String sTART_DATE) {
		START_DATE = sTART_DATE;
	}
	public String getSTOP_DATE() {
		return STOP_DATE;
	}
	public void setSTOP_DATE(String sTOP_DATE) {
		STOP_DATE = sTOP_DATE;
	}
	public String getTO_ADDRESS() {
		return TO_ADDRESS;
	}
	public void setTO_ADDRESS(String tO_ADDRESS) {
		TO_ADDRESS = tO_ADDRESS;
	}
	public String getTAX_CALC_TYPE() {
		return TAX_CALC_TYPE;
	}
	public void setTAX_CALC_TYPE(String tAX_CALC_TYPE) {
		TAX_CALC_TYPE = tAX_CALC_TYPE;
	}
	public String getRECEIPT_DAY() {
		return RECEIPT_DAY;
	}
	public void setRECEIPT_DAY(String rECEIPT_DAY) {
		RECEIPT_DAY = rECEIPT_DAY;
	}
	public String getMONEY_UNIT() {
		return MONEY_UNIT;
	}
	public void setMONEY_UNIT(String mONEY_UNIT) {
		MONEY_UNIT = mONEY_UNIT;
	}
	public String getTAX_TYPE() {
		return TAX_TYPE;
	}
	public void setTAX_TYPE(String tAX_TYPE) {
		TAX_TYPE = tAX_TYPE;
	}
	public String getBILL_TYPE() {
		return BILL_TYPE;
	}
	public void setBILL_TYPE(String bILL_TYPE) {
		BILL_TYPE = bILL_TYPE;
	}
	public String getSET_METH() {
		return SET_METH;
	}
	public void setSET_METH(String sET_METH) {
		SET_METH = sET_METH;
	}
	public float getVAT_RATE() {
		return VAT_RATE;
	}
	public void setVAT_RATE(String vAT_RATE) {
		VAT_RATE = ObjUtils.parseFloat(vAT_RATE, 0.0f);
	}
	public String getTRANS_CLOSE_DAY() {
		return TRANS_CLOSE_DAY;
	}
	public void setTRANS_CLOSE_DAY(String tRANS_CLOSE_DAY) {
		TRANS_CLOSE_DAY = tRANS_CLOSE_DAY;
	}
	public int getCOLLECT_DAY() {
		return COLLECT_DAY;
	}
	public void setCOLLECT_DAY(String cOLLECT_DAY) {
		COLLECT_DAY = ObjUtils.parseInt(cOLLECT_DAY,1);
	}
	public String getCREDIT_YN() {
		return CREDIT_YN;
	}
	public void setCREDIT_YN(String cREDIT_YN) {
		CREDIT_YN = cREDIT_YN;
	}
	public double getTOT_CREDIT_AMT() {
		return TOT_CREDIT_AMT;
	}
	public void setTOT_CREDIT_AMT(String tOT_CREDIT_AMT) {
		TOT_CREDIT_AMT = ObjUtils.parseDouble(tOT_CREDIT_AMT, 0.0d);
	}
	public double getCREDIT_AMT() {
		return CREDIT_AMT;
	}
	public void setCREDIT_AMT(String cREDIT_AMT) {
		CREDIT_AMT = ObjUtils.parseDouble(cREDIT_AMT, 0.0d);
	}
	public String getCREDIT_YMD() {
		return CREDIT_YMD;
	}
	public void setCREDIT_YMD(String cREDIT_YMD) {
		CREDIT_YMD = cREDIT_YMD;
	}
	public String getCOLLECT_CARE() {
		return COLLECT_CARE;
	}
	public void setCOLLECT_CARE(String cOLLECT_CARE) {
		COLLECT_CARE = cOLLECT_CARE;
	}
	public String getBUSI_PRSN() {
		return BUSI_PRSN;
	}
	public void setBUSI_PRSN(String bUSI_PRSN) {
		BUSI_PRSN = bUSI_PRSN;
	}
	public String getCAL_TYPE() {
		return CAL_TYPE;
	}
	public void setCAL_TYPE(String cAL_TYPE) {
		CAL_TYPE = cAL_TYPE;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getMANAGE_CUSTOM() {
		return MANAGE_CUSTOM;
	}
	public void setMANAGE_CUSTOM(String mANAGE_CUSTOM) {
		MANAGE_CUSTOM = mANAGE_CUSTOM;
	}
	public String getMCUSTOM_NAME() {
		return MCUSTOM_NAME;
	}
	public void setMCUSTOM_NAME(String mCUSTOM_NAME) {
		MCUSTOM_NAME = mCUSTOM_NAME;
	}
	public String getCOLLECTOR_CP() {
		return COLLECTOR_CP;
	}
	public void setCOLLECTOR_CP(String cOLLECTOR_CP) {
		COLLECTOR_CP = cOLLECTOR_CP;
	}
	public String getCOLLECTOR_CP_NAME() {
		return COLLECTOR_CP_NAME;
	}
	public void setCOLLECTOR_CP_NAME(String cOLLECTOR_CP_NAME) {
		COLLECTOR_CP_NAME = cOLLECTOR_CP_NAME;
	}
	public String getBANK_CODE() {
		return BANK_CODE;
	}
	public void setBANK_CODE(String bANK_CODE) {
		BANK_CODE = bANK_CODE;
	}
	public String getBANK_NAME() {
		return BANK_NAME;
	}
	public void setBANK_NAME(String bANK_NAME) {
		BANK_NAME = bANK_NAME;
	}
	public String getBANKBOOK_NUM() {
		return BANKBOOK_NUM;
	}
	public void setBANKBOOK_NUM(String bANKBOOK_NUM) {
		BANKBOOK_NUM = bANKBOOK_NUM;
	}
	public String getBANKBOOK_NAME() {
		return BANKBOOK_NAME;
	}
	public void setBANKBOOK_NAME(String bANKBOOK_NAME) {
		BANKBOOK_NAME = bANKBOOK_NAME;
	}
	public String getCUST_CHK() {
		return CUST_CHK;
	}
	public void setCUST_CHK(String cUST_CHK) {
		CUST_CHK = cUST_CHK;
	}
	public String getSSN_CHK() {
		return SSN_CHK;
	}
	public void setSSN_CHK(String sSN_CHK) {
		SSN_CHK = sSN_CHK;
	}
	public String getUPDATE_DB_USER() {
		return UPDATE_DB_USER;
	}
	public void setUPDATE_DB_USER(String uPDATE_DB_USER) {
		UPDATE_DB_USER = uPDATE_DB_USER;
	}
	public String getUPDATE_DB_TIME() {
		return UPDATE_DB_TIME;
	}
	public void setUPDATE_DB_TIME(String uPDATE_DB_TIME) {
		UPDATE_DB_TIME = uPDATE_DB_TIME;
	}
	public String getPURCHASE_BANK() {
		return PURCHASE_BANK;
	}
	public void setPURCHASE_BANK(String pURCHASE_BANK) {
		PURCHASE_BANK = pURCHASE_BANK;
	}
	public String getPURBANKNAME() {
		return PURBANKNAME;
	}
	public void setPURBANKNAME(String pURBANKNAME) {
		PURBANKNAME = pURBANKNAME;
	}
	public String getBILL_PRSN() {
		return BILL_PRSN;
	}
	public void setBILL_PRSN(String bILL_PRSN) {
		BILL_PRSN = bILL_PRSN;
	}
	public String getHAND_PHON() {
		return HAND_PHON;
	}
	public void setHAND_PHON(String hAND_PHON) {
		HAND_PHON = hAND_PHON;
	}
	public String getBILL_MAIL_ID() {
		return BILL_MAIL_ID;
	}
	public void setBILL_MAIL_ID(String bILL_MAIL_ID) {
		BILL_MAIL_ID = bILL_MAIL_ID;
	}
	public String getBILL_PRSN2() {
		return BILL_PRSN2;
	}
	public void setBILL_PRSN2(String bILL_PRSN2) {
		BILL_PRSN2 = bILL_PRSN2;
	}
	public String getHAND_PHON2() {
		return HAND_PHON2;
	}
	public void setHAND_PHON2(String hAND_PHON2) {
		HAND_PHON2 = hAND_PHON2;
	}
	public String getBILL_MAIL_ID2() {
		return BILL_MAIL_ID2;
	}
	public void setBILL_MAIL_ID2(String bILL_MAIL_ID2) {
		BILL_MAIL_ID2 = bILL_MAIL_ID2;
	}
	public String getBILL_MEM_TYPE() {
		return BILL_MEM_TYPE;
	}
	public void setBILL_MEM_TYPE(String bILL_MEM_TYPE) {
		BILL_MEM_TYPE = bILL_MEM_TYPE;
	}
	public String getADDR_TYPE() {
		return ADDR_TYPE;
	}
	public void setADDR_TYPE(String aDDR_TYPE) {
		ADDR_TYPE = aDDR_TYPE;
	}
	public String getCOMP_CODE() {
		return COMP_CODE;
	}
	public void setCOMP_CODE(String cOMP_CODE) {
		COMP_CODE = cOMP_CODE;
	}
	public String getCHANNEL() {
		return CHANNEL;
	}
	public void setCHANNEL(String cHANNEL) {
		CHANNEL = cHANNEL;
	}
	public String getBILL_CUSTOM() {
		return BILL_CUSTOM;
	}
	public void setBILL_CUSTOM(String bILL_CUSTOM) {
		BILL_CUSTOM = bILL_CUSTOM;
	}
	public String getBILL_CUSTOM_NAME() {
		return BILL_CUSTOM_NAME;
	}
	public void setBILL_CUSTOM_NAME(String bILL_CUSTOM_NAME) {
		BILL_CUSTOM_NAME = bILL_CUSTOM_NAME;
	}
	public String getCREDIT_OVER_YN() {
		return CREDIT_OVER_YN;
	}
	public void setCREDIT_OVER_YN(String cREDIT_OVER_YN) {
		CREDIT_OVER_YN = cREDIT_OVER_YN;
	}
	public String getFlag() {
		return Flag;
	}
	public void setFlag(String flag) {
		Flag = flag;
	}
	public String getDEPT_CODE() {
		return DEPT_CODE;
	}
	public void setDEPT_CODE(String dEPT_CODE) {
		DEPT_CODE = dEPT_CODE;
	}
	public String getDEPT_NAME() {
		return DEPT_NAME;
	}
	public void setDEPT_NAME(String dEPT_NAME) {
		DEPT_NAME = dEPT_NAME;
	}
	public String getBILL_PUBLISH_TYPE() {
		return BILL_PUBLISH_TYPE;
	}
	public void setBILL_PUBLISH_TYPE(String bILL_PUBLISH_TYPE) {
		BILL_PUBLISH_TYPE = bILL_PUBLISH_TYPE;
	}
	public String getR_PAYMENT_YN() {
		return R_PAYMENT_YN;
	}
	public void setR_PAYMENT_YN(String r_PAYMENT_YN) {
		R_PAYMENT_YN = r_PAYMENT_YN;
	}
	public String getDELIVERY_METH() {
		return DELIVERY_METH;
	}
	public void setDELIVERY_METH(String dELIVERY_METH) {
		DELIVERY_METH = dELIVERY_METH;
	}
}
