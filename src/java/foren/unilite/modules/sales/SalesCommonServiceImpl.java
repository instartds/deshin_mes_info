package foren.unilite.modules.sales;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("salesCommonService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class SalesCommonServiceImpl extends TlabAbstractServiceImpl {

	private final Logger	logger		= LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 현재고량 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly=true) //, isolation=TransactionDefinition.ISOLATION_READ_UNCOMMITTED) 
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object  fnStockQ(Map param) throws Exception {
		return  super.commonDao.select("salesCommonServiceImpl.fnStockQ", param);
	}

	/**
	 * 단가관련정보 검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object  fnGetPriceInfo(Map param) throws Exception {	
		return  super.commonDao.select("salesCommonServiceImpl.fnGetPriceInfo", param);
	}

	/**
	 * 단가 및 재고량 검색
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object  getItemInfo(Map param) throws Exception {	
		Map<String, Object> priceInfo = (Map<String, Object>)super.commonDao.select("salesCommonServiceImpl.fnGetPriceInfo2", param);
		Map<String, Object> stockQInfo = (Map<String, Object>)super.commonDao.select("salesCommonServiceImpl.fnStockQ", param);
		Map<String, Object> r = new HashMap();
		r.putAll(priceInfo);
		r.putAll(stockQInfo);
		return  r;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object  fnGetPriceInfo2(Map param) throws Exception {
		//param.put("BASIS_DATE", param.get("BASIS_DATE"))
		return  super.commonDao.select("salesCommonServiceImpl.fnGetPriceInfo2", param);
	}

	public double fnWonCalc(String sWonCalBas ,double dAmount, int numDigit) {
		double absAmt = 0;
		boolean wasMinus = false;
		if (ObjUtils.isEmpty(numDigit)) numDigit =0;

		if( dAmount >= 0 ) {
			absAmt = dAmount;
		} else {
			absAmt = Math.abs(dAmount);
			wasMinus = true;
		}

		double mn = Math.pow(10,numDigit);
		switch (sWonCalBas) {
			case  "1" :	//up : 0에서 멀어짐.
				absAmt = Math.ceil(absAmt * mn) / mn;
				break;
			case  "2" :	//cut : 0에서 가까와짐, 아래 자리수 버림.
				absAmt = Math.floor(absAmt * mn) / mn;
				break;
			default:						//round
				absAmt = Math.round(absAmt * mn) / mn; 
		}
		return absAmt;
	}

	/**
	 * 영업 공통 콤보코드
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<CodeDetailVO> fnRecordCombo(Map param, LoginVO user) throws Exception  {
		String sLangSet = user.getLanguage();
		String sBwrLangFld = "";
		
		switch (sLangSet.toUpperCase()) {
			case "KOREAN":
				sBwrLangFld = "";
				break;
			case "ENGLISH":
				sBwrLangFld = "_EN";
				break;
			case "CHINESE":
				sBwrLangFld = "_CN";
				break;
			case "JAPANESE":
				sBwrLangFld = "_JP";
				break;
			default:
				sBwrLangFld = "";
				break;
		}
		param.put("sBwrLangFld", sBwrLangFld);
		return super.commonDao.list("salesCommonServiceImpl.fnRecordComBo", param);
	}

	/**
	 * 금액재계산
	 * @param param
	 * @param dParam_Unit_P
	 * @return
	 * @throws Exception
	 */
	public Map fnReCompute(Map param, double dParam_Unit_P) throws Exception	{
		Map rMap = new HashMap();

		String sTaxType = ObjUtils.getSafeString(param.get("TAX_TYPE"));		 //세구분
		String sTaxInout = ObjUtils.getSafeString(param.get("M_TAX_TYPE"));				//세액포함여부
		String sWonCalBas = ObjUtils.getSafeString(param.get("WON_CALC_BAS"));			   //원계산방법
		double dVatRate = ObjUtils.parseDouble(param.get("VAT_RATE"));					 //부가세율
		int dTransQ =  ObjUtils.parseInt(param.get("TRANS_RATE"));						 //입수
		int dUnitQty =  ObjUtils.parseInt(param.get("SALE_Q"));						//판매단위 수량
		double dParam_Unit_I = dUnitQty * dParam_Unit_P;	//판매단위 금액

		rMap.put("dParam_Unit_I", dParam_Unit_I);

		if( dTransQ == 0 ) {
			dTransQ = 1;
		}
		double dParamP = dParam_Unit_P / dTransQ ;  //재고단위 단가
		double dParamI = dUnitQty * dParamP;		//재고단위 금액

		rMap.put("dParamP", dParamP);
		rMap.put("dParamI", dParamI);

		double dTaxI = 0.0;
		if("1".equals(sTaxType)) {	  //* 세구분(1:과세/2:면세)
			switch(sTaxInout)  { 		//* 해당 거래처의 세액포함여부(1:별도/2:포함)
			case "1" :		   //* 별도
				//* 세액별도일 때, 세액 = 금액 * (부가세율 / 100)
				dTaxI = (dParam_Unit_I * (dVatRate / 100));

				rMap.put("dParam_Unit_I", this.fnWonCalc( sWonCalBas, dParam_Unit_I, 0) );
				rMap.put("dTaxI", this.fnWonCalc( sWonCalBas, dTaxI, 0) );
				break;			
			case "2"  :		  //* 포함
				/**
				 *  dParam_Unit_I = 금액
				'* dTemp = dParam_Unit_I / (세율 + 100) * 100 ==> dTemp = 절사처리(dTemp)
				'* dTaxI = dTemp * 세율 / 100		 ==> dTaxI = 절사처리(dTaxI)
				'* dParam_Unit_I = dParam_Unit_I - dTaxI
				*/
				double dTemp = (dParam_Unit_I / (dVatRate + 100)) * 100;
				rMap.put("dTemp", this.fnWonCalc( "2", dTemp, 0) );			//세액은 절사처리함.

				dTaxI = dTemp * dVatRate / 100;
				rMap.put("dTaxI", this.fnWonCalc( "2", dTaxI, 0) );			 //세액은 절사처리함.

				dParam_Unit_I = dParam_Unit_I - dTaxI;
				rMap.put("dParam_Unit_I", this.fnWonCalc( sWonCalBas, dParam_Unit_I, 0) );
				break;
			}
		}else {
			dTaxI = 0;
		}
		double dParam_Unit_T = dTaxI;
		rMap.put("dParam_Unit_T", this.fnWonCalc( sWonCalBas, dParam_Unit_T, 0) );
		
		return rMap;
	}

	/**
	 * 여신한도액 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object fnGetCRedit(Map param, LoginVO user) throws Exception  {	
		return super.commonDao.select("salesCommonServiceImpl.fnGetCRedit", param);
	}

	/**
	 * 환율 구하기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object fnExchangeRate(Map param) throws Exception  {	
		return super.commonDao.select("salesCommonServiceImpl.fnExchangeRate", param);
	}

	/**
	 * 작업장에 대한 제조처 반환
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object fnOrgCd(Map param) throws Exception  {	
		return super.commonDao.select("salesCommonServiceImpl.fnOrgCd", param);
	}

	/**
	 * 사업장정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object fnGetOrgInfo(Map param) throws Exception  {	
		return super.commonDao.select("salesCommonServiceImpl.fnGetOrgInfo", param);
	}

	/**
	 * 마감정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public void fnCloseCheck(Map param, LoginVO user) throws Exception  {
		Map resultMap = (Map) super.commonDao.select("salesCommonServiceImpl.fnCloseCheck", param);
		int rDate = ObjUtils.parseInt(resultMap.get("LAST_YYYYMM"));
		String sDate = ObjUtils.getSafeString(param.get("S_DATE"));
		if(sDate.length() >=6) {
			if(rDate > ObjUtils.parseInt(sDate.substring(0, 5))) {
				throw new  UniDirectValidateException(this.getMessage("54100", user));	 
			}
		}
		
	}

	/**
	 * 마감정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object fnGetPrevNextNo(Map param) throws Exception  {
		String type = ObjUtils.getSafeString(param.get("TYPE"));
		/* 견적정보 */
		if("ES".equals(type)) {
			return super.commonDao.select("salesCommonServiceImpl.fnGetPrevNextNoForEstimate", param);
		} /* 수주정보 */
		else if("SO".equals(type)) {
			return super.commonDao.select("salesCommonServiceImpl.fnGetPrevNextNoForOrder", param);
		}  /* 출하지시정보 */ 
		else if("SR".equals(type)) {
			return super.commonDao.select("salesCommonServiceImpl.fnGetPrevNextNoForIssue", param);
		}	 /* 수불(출고)정보 */  
		else if("IS".equals(type)) {
			return super.commonDao.select("salesCommonServiceImpl.fnGetPrevNextNoForInOut", param);
		}  /* 수불(입고)정보 */
		else if("PR".equals(type)) {
			return super.commonDao.select("salesCommonServiceImpl.fnGetPrevNextNoForIn", param);
		}  /* 수불(반품)정보 */  
		else if("IR".equals(type)) {
			return super.commonDao.select("salesCommonServiceImpl.fnGetPrevNextNoForReturn", param);
		}  /* 매출정보 */
		else if("SS".equals(type)) {
			return super.commonDao.select("salesCommonServiceImpl.fnGetPrevNextNoForSales", param);
		} /* 계산서정보 */ 
		else if("BI".equals(type)) {
			return super.commonDao.select("salesCommonServiceImpl.fnGetPrevNextNoForInvoce", param);
		}  /* 수금정보 */
		else if("CM".equals(type)) {
			return super.commonDao.select("salesCommonServiceImpl.fnGetPrevNextNoForCollect", param);
		} else {
			return null;
		}
	}

	/**
	 * 월마감 정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getMonClosing(Map param, LoginVO user) throws Exception  {	
		return super.commonDao.select("salesCommonServiceImpl.getMonClosing", param);
	}

	/**
	 * 일마감 정보 조회1
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getDayClosing(Map param, LoginVO user) throws Exception  {	
		return super.commonDao.select("salesCommonServiceImpl.getDayClosing", param);
	}

	/**
	 * 일마감 정보 조회2
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getDayClosing2(Map param, LoginVO user) throws Exception  {	
		return super.commonDao.select("salesCommonServiceImpl.getDayClosing2", param);
	}

	/**
	 * 잔액미수금 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getRemainderInfo1(Map param, LoginVO user) throws Exception  {	
		return super.commonDao.select("salesCommonServiceImpl.getRemainderInfo1", param);
	}

	/**
	 *선수금 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getRemainderInfo2(Map param, LoginVO user) throws Exception  {	
		return super.commonDao.select("salesCommonServiceImpl.getRemainderInfo2", param);
	}

	/**
	 * 화폐에따른 환율 구하기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object fnExchgRateO(Map param) throws Exception  { 
		return super.commonDao.select("salesCommonServiceImpl.fnExchgRateO", param);
	}

	/**
	 * 품목따른 최근단가 구하기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object fnGetLastPriceInfo(Map param) throws Exception  { 
		return super.commonDao.select("salesCommonServiceImpl.fnGetLastPriceInfo", param);
	}

	/**
	 * 품목따른 단가구분 구하기
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object fnGetPriceTypeInfo(Map param) throws Exception  { 
		return super.commonDao.select("salesCommonServiceImpl.fnGetPriceTypeInfo", param);
	}
}