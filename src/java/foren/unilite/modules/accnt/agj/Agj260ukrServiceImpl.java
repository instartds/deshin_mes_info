package foren.unilite.modules.accnt.agj;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("agj260ukrService")
public class Agj260ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	

	
	/**
	 * 공통코드에서 원하는 컬럼의 값을 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object fnGetCommon(Map param) throws Exception {
		return super.commonDao.select("agj260ukrServiceImpl.fnGetCommon", param);
	}
	
	
	/**
	 * 용역원가대체입력  exceptionJump 가 N 일때
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public void Setagd058(Map param) throws Exception {
		String reValue = "";
		reValue = param.get("DIV_CODE").toString().replaceAll(",", "-");
		reValue = reValue.replaceAll("\\p{Z}", "");
		reValue = reValue.replaceAll("\\[", "");
		reValue = reValue.replaceAll("\\]", "");
		param.put("DIV_CODE", reValue);
		
		param.put("Profit1", "C6");
		param.put("Profit2", "C7");
		
		/*String accnt_Profit1 = "";
		String accnt_Profit2 = "";
		
		List<Map> checkOption1 = (List<Map>) super.commonDao.list("agj260ukrServiceImpl.Cagd058UKR_Query1", param);
		accnt_Profit1 = (String) checkOption1.get(0).get("ACCNT");
		
		List<Map> checkOption2 = (List<Map>) super.commonDao.list("agj260ukrServiceImpl.Cagd058UKR_Query2", param);
		accnt_Profit2 = (String) checkOption1.get(0).get("ACCNT");
		
		
		if(checkOption1.size() > 0 && checkOption2.size() > 0){

			
		}
		
		super.commonDao.list("agj260ukrServiceImpl.Cagd058UKR1", param);
		
		super.commonDao.list("agj260ukrServiceImpl.Cagd058UKR2", param);*/
		
		return;
	}
	
	/**
	 * 결의전표등록 - 전표옵션 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object selectOption(Map param) throws Exception {
		
		return super.commonDao.select("agj260ukrServiceImpl.selectOption", param);
	}
	
	/**
	 * 결의전표등록 - 일반전표 목록 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return (List) super.commonDao.list("agj260ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 결의전표등록 - 현금계정 가져오기 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getCashAccnt(Map param) throws Exception {
		
		return super.commonDao.select("agj260ukrServiceImpl.getCashAccnt", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "Accnt")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
	
		
		
		//로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();

		Map sParam = new HashMap();
		String keyValue = "";
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				for(Map paramData: dataList) {
					if(ObjUtils.isEmpty(keyValue)) keyValue = ObjUtils.getSafeString(paramData.get("KEY_VALUE"));
					super.commonDao.update("agj260ukrServiceImpl.update", paramData);	
				}
				
			}
		}
		if(!"".equals(keyValue))	{
			sParam.put("CompCode", user.getCompCode());
			sParam.put("KeyValue", keyValue);
			sParam.put("UserID", user.getUserID());
			sParam.put("UserLang", user.getLanguage());
			
			super.commonDao.queryForObject("agj260ukrServiceImpl.spAccntExslip", sParam);
			
			String errorDesc = ObjUtils.getSafeString(sParam.get("ErrorDesc"));
			
			if(ObjUtils.isNotEmpty(errorDesc))	{
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}
		
		paramList.add(0, paramMaster);		
		return  paramList;
	}
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert(List<Map> params) throws Exception {
		return params;
	}
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update(List<Map> params) throws Exception {
		return params;
	}
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete(List<Map> params) throws Exception {
		return params;
	}
	
	/**
	 * 결의전표등록 - 매입매출 계산서 번호 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getPubNum(Map param) throws Exception {
		
		return super.commonDao.select("agj260ukrServiceImpl.getPubNum", param);
	}
	
	/**
	 * 매입 자동 기표 temporally 저장 (개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> savedTempDataList(Map<String, Object> param, LoginVO user) throws Exception {
		
		
		param.put("FR_PUB_DATE", param.get("BILL_DATE"));
		param.put("TO_PUB_DATE", param.get("BILL_DATE"));
		
		param.put("FR_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		param.put("TO_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		
		param.put("ACCOUNT_TYPE", param.get("ACCOUNT_TYPE"));
		param.put("ISSUE_EXPECTED_DATE", param.get("ISSUE_EXPECTED_DATE"));
		
		param.put("DATE_OPTION", "2");
		//param.put("PROC_DATE", "");
		
		param.put("CHANGE_BASIS_NUM", param.get("CHANGE_BASIS_NUM"));
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "Each");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAccntAutoSlip40", param);
		
		String ebynMessage = ObjUtils.getSafeString(param.get("EBYN_MESSAGE"));
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("EBYN_MESSAGE", ebynMessage);
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		
		return  rMap;
	}
	
	/**
	 * 매입 자동 기표 취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> cancelExList(Map<String, Object> param, LoginVO user) throws Exception {
		
		
		param.put("FR_PUB_DATE", param.get("BILL_DATE"));
		param.put("TO_PUB_DATE", param.get("BILL_DATE"));
		
		param.put("FR_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		param.put("TO_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		
		param.put("ACCOUNT_TYPE", param.get("ACCOUNT_TYPE"));
		param.put("ISSUE_EXPECTED_DATE", param.get("ISSUE_EXPECTED_DATE"));
		
		param.put("DATE_OPTION", "2");
		//param.put("PROC_DATE", "");
		
		param.put("CHANGE_BASIS_NUM", param.get("CHANGE_BASIS_NUM"));
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "Each");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip40Cancel", param);
		
		String ebynMessage = ObjUtils.getSafeString(param.get("EBYN_MESSAGE"));
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if("TRUE".equals(ebynMessage) 	// TRUE:메세지띄움, FALSE:메세지안띄움
				&& ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("EBYN_MESSAGE", ebynMessage);
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	/**
	 * 매출 자동 기표 temporally 저장 (개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> savedTempAutoSlip30(Map<String, Object> param, LoginVO user) throws Exception {
	
		
		param.put("FR_PUB_DATE", param.get("BILL_DATE"));
		param.put("TO_PUB_DATE", param.get("BILL_DATE"));
		
		param.put("FR_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		param.put("TO_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		
		param.put("BILL_TYPE", param.get("BILL_TYPE"));
		
		param.put("DATE_OPTION", "1");
		param.put("PROC_DATE", "");
		
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAccntAutoSlip30", param);
		
		String ebynMessage = ObjUtils.getSafeString(param.get("EBYN_MESSAGE"));
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("EBYN_MESSAGE", ebynMessage);
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		return  rMap;
	}
	
	/**
	 * 매출 자동 기표 취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> cancelAutoSlip30(Map<String, Object> param, LoginVO user) throws Exception {
		//20200302수정: 현재 sp안에는 메세지 표시여부에 대한 로직이 없음 - 화면에서 넘긴 값으로 결정하도록 변경
		String ebynMessage = ObjUtils.getSafeString(param.get("EBYN_MESSAGE"));
		param.put("FR_PUB_DATE", param.get("BILL_DATE"));
		param.put("TO_PUB_DATE", param.get("BILL_DATE"));
		
		param.put("FR_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		param.put("TO_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		
		param.put("BILL_TYPE", param.get("BILL_TYPE"));
		
		param.put("DATE_OPTION", "1");
		param.put("PROC_DATE", "");
		
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "Each");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip30Cancel", param);
		//20200302수정: 현재 sp안에는 메세지 표시여부에 대한 로직이 없음 - 화면에서 넘긴 값으로 결정하도록 변경
//		String ebynMessage = ObjUtils.getSafeString(param.get("EBYN_MESSAGE"));
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if("TRUE".equals(ebynMessage) 	// TRUE:메세지띄움, FALSE:메세지안띄움
				&& ObjUtils.isNotEmpty(errorDesc))	{
			rMap.put("EBYN_MESSAGE", ebynMessage);
			rMap.put("ERROR_DESC", errorDesc);
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("EBYN_MESSAGE", ebynMessage);
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	
	/**
	 * 수금 자동 기표 temporally 저장 (개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> savedTempAutoSlip31(Map<String, Object> param, LoginVO user) throws Exception {
	
		
		param.put("FR_DATE", param.get("COLL_DATE"));
		param.put("TO_DATE", param.get("COLL_DATE"));
		
		param.put("FR_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		param.put("TO_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		
		param.put("DATE_OPTION", "1");
		param.put("PROC_DATE", "");
		
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAccntAutoSlip31", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		
		return  rMap;
	}
	
	/**
	 * 수금 자동 기표 취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> cancelAutoSlip31(Map<String, Object> param, LoginVO user) throws Exception {
		
		
		
		param.put("FR_DATE", param.get("COLL_DATE"));
		param.put("TO_DATE", param.get("COLL_DATE"));
		
		param.put("FR_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		param.put("TO_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		
		param.put("DATE_OPTION", "1");
		param.put("PROC_DATE", "");
		
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip31Cancel", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if( ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	
	/**
	 * 세금계산서 등록 기표   (개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> autoSlip34(Map<String, Object> param, LoginVO user) throws Exception {	
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAccntAutoSlip34", param);
		
		String ebynMessage = ObjUtils.getSafeString(param.get("EBYN_MESSAGE"));
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("EBYN_MESSAGE", ebynMessage);
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		return  rMap;
	}
	
	/**
	 * 세금계산서 등록 기표  취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> cancelAutoSlip34(Map<String, Object> param, LoginVO user) throws Exception {
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip34Cancel", param);
		
		String ebynMessage = ObjUtils.getSafeString(param.get("EBYN_MESSAGE"));
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if("TRUE".equals(ebynMessage) 	// TRUE:메세지띄움, FALSE:메세지안띄움
				&& ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("EBYN_MESSAGE", ebynMessage);
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip52(Map<String, Object> param, LoginVO user) throws Exception {
		
		param.put("FR_AC_DATE", param.get("FR_AC_DATE"));
		param.put("TO_AC_DATE", param.get("TO_AC_DATE"));
		param.put("AC_YYYYMM", param.get("AC_YYYYMM"));
		
		param.put("PJT_CODE", param.get("PJT_CODE"));
		
		param.put("COST_DATE", param.get("COST_DATE"));
		param.put("DIV_CODE", param.get("DIV_CODE"));
		param.put("INPUT_USER_ID", param.get("INPUT_USER_ID"));
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		param.put("CALL_PATH", "Each");

		List<String> divCodeQArr = (List<String>) param.get("DIV_CODEQ");
		String divCodeQ = "";
		if(divCodeQ != null)	{
			int  i =0;
			for(String divCode : divCodeQArr)	{
				divCodeQ = divCodeQ+divCode;
				i++;
				if(i < divCodeQArr.size())	{
					divCodeQ = divCodeQ+"-";
				}
			}
		}
		param.put("DIV_CODEQ", divCodeQ);
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip52", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		return  rMap;
	}
	
	/**
	 * 매출 자동 기표 취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> cancelAutoSlip52(Map<String, Object> param, LoginVO user) throws Exception {
		
		param.put("FR_AC_DATE", param.get("FR_AC_DATE"));
		param.put("TO_AC_DATE", param.get("TO_AC_DATE"));
		param.put("AC_YYYYMM", param.get("AC_YYYYMM"));
		param.put("PJT_CODE", param.get("PJT_CODE"));
		param.put("CALL_PATH", "Each");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		List<String> divCodeQArr = (List<String>) param.get("DIV_CODEQ");
		String divCodeQ = "";
		if(divCodeQ != null)	{
			int  i =0;
			for(String divCode : divCodeQArr)	{
				divCodeQ = divCodeQ+divCode;
				i++;
				if(i < divCodeQArr.size())	{
					divCodeQ = divCodeQ+"-";
				}
			}
		}
		param.put("DIV_CODEQ", divCodeQ);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip52Cancel", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	/**
	 * 기간비용 자동기표
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip54(Map<String, Object> param, LoginVO user) throws Exception {
		
			
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		param.put("CALL_PATH", "EACH");

		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip54", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		return  rMap;
	}
	
	/**
	 * 기간비용 자동 기표 취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> cancelAutoSlip54(Map<String, Object> param, LoginVO user) throws Exception {
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip54Cancel", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	
	/**
	 * 수출자동기표-자동기표
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip60(Map<String, Object> param, LoginVO user) throws Exception {
	
		
		param.put("FR_PUB_DATE", param.get("DATE_SHIPPING"));
		param.put("TO_PUB_DATE", param.get("DATE_SHIPPING"));
		
		param.put("FR_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		param.put("TO_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		
		param.put("BILL_TYPE", "10");
		
		param.put("DATE_OPTION", "1");
		param.put("WORK_DATE", "");
		
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip60", param);
		
		String ebynMessage = ObjUtils.getSafeString(param.get("EBYN_MESSAGE"));
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("EBYN_MESSAGE", ebynMessage);
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		return  rMap;
	}
	
	/**
	 *  수출자동기표-기표취소 취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip60cancel(Map<String, Object> param, LoginVO user) throws Exception {
		
		
		
		param.put("FR_PUB_DATE", param.get("DATE_SHIPPING"));
		param.put("TO_PUB_DATE", param.get("DATE_SHIPPING"));
		
		param.put("FR_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		param.put("TO_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		
		param.put("BILL_TYPE", "10");
		
		param.put("DATE_OPTION", "1");
		param.put("PROC_DATE", "");
		
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip60Cancel", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	/**
	 * 무역경비자동기표
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip63(Map<String, Object> param, LoginVO user) throws Exception {
	
		
		param.put("DATE_OPTION", "1");
		param.put("WORK_DATE", "");
		
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip63", param);
		
		String ebynMessage = ObjUtils.getSafeString(param.get("EBYN_MESSAGE"));
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("EBYN_MESSAGE", ebynMessage);
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		return  rMap;
	}
	
	/**
	 *  무역자동기표-기표취소 취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip63cancel(Map<String, Object> param, LoginVO user) throws Exception {
		
		
		param.put("DATE_OPTION", "1");
		
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip63Cancel", param);
	
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	
	/**
	 * 미착자동기표-개별자동기표
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip64(Map<String, Object> param, LoginVO user) throws Exception {
	
		
		param.put("FR_PUB_DATE", param.get("DATE_SHIPPING"));
		param.put("TO_PUB_DATE", param.get("DATE_SHIPPING"));
		
		param.put("FR_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		param.put("TO_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		
		param.put("BILL_TYPE", "10");
		
		param.put("DATE_OPTION", "1");
		param.put("WORK_DATE", "");
		
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip64", param);
		
		String ebynMessage = ObjUtils.getSafeString(param.get("EBYN_MESSAGE"));
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("EBYN_MESSAGE", ebynMessage);
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		return  rMap;
	}
	
	/**
	 *  수출자동기표-기표취소 취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip64cancel(Map<String, Object> param, LoginVO user) throws Exception {
		
		
		
		param.put("FR_PUB_DATE", param.get("DATE_SHIPPING"));
		param.put("TO_PUB_DATE", param.get("DATE_SHIPPING"));
		
		param.put("FR_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		param.put("TO_CUSTOM_CODE", param.get("CUSTOM_CODE"));
		
		param.put("BILL_TYPE", "10");
		
		param.put("DATE_OPTION", "1");
		param.put("PROC_DATE", "");
		
		param.put("KEY_VALUE", "");
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip64Cancel", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	
	/**
	 * 미착대체 자동기표
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip66(Map<String, Object> param, LoginVO user) throws Exception {
	
		
		param.put("KEY_VALUE", param.get("KEY_VALUE"));
		
		param.put("DATE_OPTION", "1");
		param.put("PROC_DATE", param.get("SLIP_DATE"));
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip66", param);
		
		String ebynMessage = ObjUtils.getSafeString(param.get("EBYN_MESSAGE"));
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("EBYN_MESSAGE", ebynMessage);
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		return  rMap;
	}
	
	/**
	 *  미착대체 자동기표
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip66cancel(Map<String, Object> param, LoginVO user) throws Exception {
		
		param.put("PROC_DATE", param.get("SLIP_DATE"));
		param.put("KEY_VALUE", param.get("KEY_VALUE"));
		
		param.put("DATE_OPTION", "1");
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip66Cancel", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	/**
	 * 원가차감 자동기표(원가대체입력(agc310ukr))
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt")
	public Map<String, Object> spAutoSlip67(Map<String, Object> param, LoginVO user) throws Exception {
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		Map<String, Object> rMap = (Map<String, Object>) super.commonDao.select("agj260ukrServiceImpl.spAutoSlip67", param);
		
		if(rMap != null)	{
			String errorDesc = ObjUtils.getSafeString(rMap.get("ERROR_DESC"));
			if(ObjUtils.isNotEmpty(errorDesc))	{
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}
		return  rMap;
	}
	
	/**
	 *  원가대체 차감 기표 취소(원가대체입력(agc310ukr))
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt")
	public Map<String, Object> spAutoSlip67cancel(Map<String, Object> param, LoginVO user) throws Exception {
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		Map<String, Object> rMap = (Map<String, Object>) super.commonDao.select("agj260ukrServiceImpl.spAutoSlip67Cancel", param);
		
		if(rMap != null)	{
			String errorDesc = ObjUtils.getSafeString(rMap.get("ERROR_DESC"));
			if(ObjUtils.isNotEmpty(errorDesc))	{
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}
		
		return  rMap;
	}
	
	/**
	 * 법인카드사용내역 자동기표
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip68(Map<String, Object> param, LoginVO user) throws Exception {
		
			
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		param.put("CALL_PATH", "EACH");
		param.put("DATE_OPTION", "1");
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip68", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		return  rMap;
	}
	
	/**
	 * 법인카드사용내역 자동기표 취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> cancelAutoSlip68(Map<String, Object> param, LoginVO user) throws Exception {
		
		param.put("CALL_PATH", "EACH");

		param.put("DATE_OPTION", "1");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip68Cancel", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	/**
	 * 도급원가대체기표
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
			
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip76(Map<String, Object> param, LoginVO user) throws Exception {
		
		param.put("FR_AC_DATE", param.get("FR_AC_DATE"));
		param.put("TO_AC_DATE", param.get("TO_AC_DATE"));
		param.put("AC_YYYYMM", param.get("AC_YYYYMM"));
		
		param.put("PJT_CODE", param.get("PJT_CODE"));
		
		param.put("COST_DATE", param.get("COST_DATE"));
		param.put("DIV_CODE", param.get("DIV_CODE"));
		param.put("INPUT_USER_ID", param.get("INPUT_USER_ID"));
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		param.put("CALL_PATH", "Each");

		List<String> divCodeQArr = (List<String>) param.get("DIV_CODEQ");
		String divCodeQ = "";
		if(divCodeQ != null)	{
			int  i =0;
			for(String divCode : divCodeQArr)	{
				divCodeQ = divCodeQ+divCode;
				i++;
				if(i < divCodeQArr.size())	{
					divCodeQ = divCodeQ+"-";
				}
			}
		}
		param.put("DIV_CODEQ", divCodeQ);
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip76", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		return  rMap;
	}
	
	/**
	 * 도급원가대체기표 취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> cancelAutoSlip76(Map<String, Object> param, LoginVO user) throws Exception {
		
		param.put("FR_AC_DATE", param.get("FR_AC_DATE"));
		param.put("TO_AC_DATE", param.get("TO_AC_DATE"));
		param.put("AC_YYYYMM", param.get("AC_YYYYMM"));
		param.put("PJT_CODE", param.get("PJT_CODE"));
		param.put("CALL_PATH", "Each");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		List<String> divCodeQArr = (List<String>) param.get("DIV_CODEQ");
		String divCodeQ = "";
		if(divCodeQ != null)	{
			int  i =0;
			for(String divCode : divCodeQArr)	{
				divCodeQ = divCodeQ+divCode;
				i++;
				if(i < divCodeQArr.size())	{
					divCodeQ = divCodeQ+"-";
				}
			}
		}
		param.put("DIV_CODEQ", divCodeQ);
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip76Cancel", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	/**
	 * 도급원가차감 자동기표(원가대체입력(agc360ukr))
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt")
	public Map<String, Object> spAutoSlip77(Map<String, Object> param, LoginVO user) throws Exception {
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		Map<String, Object> rMap = (Map<String, Object>) super.commonDao.select("agj260ukrServiceImpl.spAutoSlip77", param);
		
		if(rMap != null)	{
			String errorDesc = ObjUtils.getSafeString(rMap.get("ERROR_DESC"));
			if(ObjUtils.isNotEmpty(errorDesc))	{
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}
		return  rMap;
	}
	
	/**
	 *  도급원가대체 차감 기표 취소(원가대체입력(agc360ukr))
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt")
	public Map<String, Object> spAutoSlip77cancel(Map<String, Object> param, LoginVO user) throws Exception {
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		Map<String, Object> rMap = (Map<String, Object>) super.commonDao.select("agj260ukrServiceImpl.spAutoSlip77Cancel", param);
		
		if(rMap != null)	{
			String errorDesc = ObjUtils.getSafeString(rMap.get("ERROR_DESC"));
			if(ObjUtils.isNotEmpty(errorDesc))	{
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}
		
		return  rMap;
	}
	
	/**
	 * 외환환평가 자동기표
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> spAutoSlip92(Map<String, Object> param, LoginVO user) throws Exception {
		
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		param.put("CALL_PATH", "EACH");

		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip92", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
			rMap.put("SLIP_KEY_VALUE", ObjUtils.getSafeString(param.get("SLIP_KEY_VALUE")));
		}
		return  rMap;
	}
	
	/**
	 * 외환환평가 자동 기표 취소(개별)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "Accnt")
	public Map<String, Object> cancelAutoSlip92(Map<String, Object> param, LoginVO user) throws Exception {
		
		param.put("CALL_PATH", "EACH");
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		
		super.commonDao.queryForObject("agj260ukrServiceImpl.spAutoSlip92Cancel", param);
		
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		
		Map<String, Object> rMap = new HashMap();
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rMap.put("ERROR_DESC", errorDesc);
		}
		
		return  rMap;
	}
	/**
	 * 외환환평가차감 자동기표(원가대체입력(agc310ukr))
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt")
	public Map<String, Object> spAutoSlip93(Map<String, Object> param, LoginVO user) throws Exception {
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		param.put("CALL_PATH", "EACH");
		
		Map<String, Object> rMap = (Map<String, Object>) super.commonDao.select("agj260ukrServiceImpl.spAutoSlip93", param);
		
		if(rMap != null)	{
			String errorDesc = ObjUtils.getSafeString(rMap.get("ERROR_DESC"));
			if(ObjUtils.isNotEmpty(errorDesc))	{
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}
		return  rMap;
	}
	
	/**
	 *  외환환평가 차감 기표 취소(원가대체입력(agc310ukr))
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt")
	public Map<String, Object> spAutoSlip93cancel(Map<String, Object> param, LoginVO user) throws Exception {
		
		String sysDate = (String) super.commonDao.select("agj260ukrServiceImpl.getSystemDate", null);
		param.put("INPUT_DATE", sysDate);
		
		Map<String, Object> rMap = (Map<String, Object>) super.commonDao.select("agj260ukrServiceImpl.spAutoSlip93Cancel", param);
		
		if(rMap != null)	{
			String errorDesc = ObjUtils.getSafeString(rMap.get("ERROR_DESC"));
			if(ObjUtils.isNotEmpty(errorDesc))	{
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}
		}
		
		return  rMap;
	}
}
