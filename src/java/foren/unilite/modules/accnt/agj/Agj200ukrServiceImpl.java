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



@Service("agj200ukrService")
public class Agj200ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 회계전표등록 - 일반전표 목록 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return (List) super.commonDao.list("agj200ukrServiceImpl.selectList", param);
	}
	
	/**
	 * 회계전표등록 - 매입매출 목록 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectSalesList(Map param) throws Exception {
		
		return (List) super.commonDao.list("agj200ukrServiceImpl.selectSalesList", param);
	}
	
	/**
	 * 회계전표등록 - 전표옵션 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object selectOption(Map param) throws Exception {
		
		return super.commonDao.select("agj200ukrServiceImpl.selectOption", param);
	}
	
	/**
	 * 회계전표등록 - 전표번호 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getSlipNum(Map param) throws Exception {
		
		return super.commonDao.select("agj200ukrServiceImpl.getSlipNum", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "Accnt")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
	
		
		//로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();			
		
		//로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();

		Map sParam = new HashMap();
		
		Map autoMap = (Map) super.commonDao.select("agj200ukrServiceImpl.getMaxAutoNum", sParam);
		int i=  Integer.parseInt(autoMap.get("MAX_AUTO_NUM").toString());
		if(paramList != null)	{
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				for(Map paramData: dataList) {
					paramData.put("KEY_VALUE", keyValue);		
					paramData.put("AUTO_NUM", i);
					super.commonDao.update("agj200ukrServiceImpl.insertLog", paramData);	
					i++;
				}
				
			}
		}
		
		//매입매출 정보
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(ObjUtils.isNotEmpty(dataMaster) && ObjUtils.isNotEmpty(dataMaster.get("PUB_DATE"))	)	{
			//Log Table 저장
			dataMaster.put("KEY_VALUE", keyValue);		
			//dataMaster.put("OPR_FLAG", "N");	
			dataMaster.put("S_COMP_CODE", user.getCompCode());
			dataMaster.put("S_USER_ID", user.getUserID());
			logger.debug("test");
			

			super.commonDao.update("agj200ukrServiceImpl.insertLog300", dataMaster);	
			//SP parameter
			Map aParam = new HashMap();
			aParam.put("CompCode", user.getCompCode());
			aParam.put("KeyValue", keyValue);
			aParam.put("UserID", user.getUserID());
			aParam.put("UserLang", user.getLanguage());
			
			//SP 호출
			super.commonDao.queryForObject("agj200ukrServiceImpl.spAccntAcSlipY0", aParam);
			
			String errorDesc = ObjUtils.getSafeString(aParam.get("ErrorDesc"));
			if(ObjUtils.isNotEmpty(errorDesc))	{
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			}else {
				paramMaster.put("PUB_NUM",aParam.get("PUB_NUM"));
				if(paramList != null)	{
					List<Map> dataList2 = new ArrayList<Map>();
					for(Map param: paramList) {
						dataList2 = (List<Map>)param.get("data");
							for(Map paramData: dataList2) {
								Map rMap= (Map) super.commonDao.select("agj200ukrServiceImpl.selectLog", paramData);
								
								paramData.put("OPR_FLAG", "L");
								paramData.put("SLIP_NUM", rMap.get("SLIP_NUM"));
								
								paramData.put("OLD_SLIP_NUM", rMap.get("SLIP_NUM"));
								paramData.put("OLD_AC_DATE", paramData.get("AC_DATE"));
								paramData.put("OLD_SLIP_SEQ", paramData.get("SLIP_SEQ"));
								dataMaster.put("SLIP_NUM",rMap.get("SLIP_NUM"));
							}
					}
					Map rMap2= (Map) super.commonDao.select("agj200ukrServiceImpl.selectSalesLog", dataMaster);
					dataMaster.put("PUB_NUM",rMap2.get("PUB_NUM"));
					dataMaster.put("SLIP_NUM",rMap2.get("SLIP_NUM"));
					
					//super.commonDao.update("agj100ukrServiceImpl.deleteLog", sParam);
				}
			}
		} else  {
		//Stored Procedure 실행
			sParam.put("CompCode", user.getCompCode());
			sParam.put("KeyValue", keyValue);
			sParam.put("UserID", user.getUserID());
			sParam.put("UserLang", user.getLanguage());
			
			super.commonDao.queryForObject("agj200ukrServiceImpl.spAccntAcSlip", sParam);
			
			String errorDesc = ObjUtils.getSafeString(sParam.get("ErrorDesc"));
	
			if(ObjUtils.isNotEmpty(errorDesc))	{
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			} else {
				
				if(paramList != null)	{
					List<Map> dataList2 = new ArrayList<Map>();
					for(Map param: paramList) {
						dataList2 = (List<Map>)param.get("data");
							for(Map paramData: dataList2) {
								Map rMap= (Map) super.commonDao.select("agj200ukrServiceImpl.selectLog", paramData);
								
								paramData.put("OPR_FLAG", "L");
								paramData.put("SLIP_NUM", rMap.get("SLIP_NUM"));
								
								paramData.put("OLD_SLIP_NUM", rMap.get("SLIP_NUM"));
								paramData.put("OLD_AC_DATE", paramData.get("AC_DATE"));
								paramData.put("OLD_SLIP_SEQ", paramData.get("SLIP_SEQ"));
								dataMaster.put("SLIP_NUM",rMap.get("SLIP_NUM"));
							}
					}
					//super.commonDao.update("agj100ukrServiceImpl.deleteLog", sParam);
				}
			}
		}
		paramMaster.put("data", dataMaster);
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
	 * 회계전표등록 - 매입매출 계산서 번호 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getPubNum(Map param) throws Exception {
		
		return super.commonDao.select("agj200ukrServiceImpl.getPubNum", param);
	}
}
