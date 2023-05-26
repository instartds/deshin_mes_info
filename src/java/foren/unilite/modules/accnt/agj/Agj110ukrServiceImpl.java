package foren.unilite.modules.accnt.agj;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;



@Service("agj110ukrService")
public class Agj110ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	@Resource(name="agj100ukrService")
	private Agj100ukrServiceImpl agj100ukrService;
	/**
	 * 결의전표등록(전표번호별) 이전 전표 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getPrevSlipNum(Map param) throws Exception {
		return super.commonDao.select("agj110ukrServiceImpl.getPrevSlipNum", param);
	}

	/**
	 * 결의전표등록(전표번호별) 이후 전표 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt")
	public Object getNextSlipNum(Map param) throws Exception {
		return super.commonDao.select("agj110ukrServiceImpl.getNextSlipNum", param);
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
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectSearch(Map param) throws Exception {
		return super.commonDao.list("agj110ukrServiceImpl.selectSearch", param);
	}
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectList(Map param) throws Exception {
		return super.commonDao.list("agj110ukrServiceImpl.selectList", param);
	}

	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectList4(Map param) throws Exception {
		Map<String, Object> rTemp = (Map<String, Object>) super.commonDao.select("agj110ukrServiceImpl.selectFnDate", param);
		String fnDate = ObjUtils.getSafeString(rTemp.get("FN_DATE"));
		if(ObjUtils.isNotEmpty(fnDate))	{
			fnDate = GStringUtils.left(fnDate, 4) + GStringUtils.right(ObjUtils.getSafeString(param.get("AC_DATE_FR")), 4);
		} else {
			fnDate = ObjUtils.getSafeString(param.get("AC_DATE_FR"));
		}
		param.put("S_DATE", fnDate);
		return super.commonDao.list("agj110ukrServiceImpl.selectList4", param);
	}
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectPendRef(Map param) throws Exception {
		return super.commonDao.list("agj110ukrServiceImpl.selectPendRef", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "Accnt")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//로그테이블에서 사용할 Key 생성		
		String keyValue = getLogKey();
		Map<String, Object> paramMasterData = (Map<String, Object>) paramMaster.get("data");
		
		//로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataListAGB320	= new ArrayList<Map>();
		Map sParam			= new HashMap();
		Map autoMap			= (Map) super.commonDao.select("agj100ukrServiceImpl.getMaxAutoNum", sParam);
		int i				= Integer.parseInt(autoMap.get("MAX_AUTO_NUM").toString());

		if(paramList != null) {
			for(Map param: paramList) {
				List<Map> dataList = (List<Map>)param.get("data");
				for(Map paramData: dataList) {
					paramData.put("KEY_VALUE", keyValue);
					paramData.put("AUTO_NUM", i);
					super.commonDao.update("agj100ukrServiceImpl.insertLog", paramData);
					i++;
					//미결반제데이터 목록 생성
					if("Y".equals(ObjUtils.getSafeString(paramData.get("IS_PEND_INPUT"))))	{
						dataListAGB320.add(paramData);
					}
				}
			}
			
		}

		
		if(paramList != null && ObjUtils.isNotEmpty(dataListAGB320) )	{
			for(Map paramData: dataListAGB320) {
				super.commonDao.update("agj110ukrServiceImpl.insertLog110", paramData);	
				Map AutoNumMap = (Map) super.commonDao.select("agj110ukrServiceImpl.getAutoNum", paramData);	 
				if(AutoNumMap != null)	{
					paramData.put("AUTO_NUM2", AutoNumMap.get("AUTO_NUM"));	
				}
			}
			Map checkParam			= new HashMap();
			checkParam.put("S_COMP_CODE", user.getCompCode());
			checkParam.put("KEY_VALUE", keyValue);
			List<Map<String, Object>> checkAmtList = (List<Map<String, Object>>) super.commonDao.list("agj110ukrServiceImpl.selectLimitAmt", checkParam);
			if(checkAmtList != null && checkAmtList.size() > 0)	{
				String checkMessage = "반제금액이 초과 되었습니다.||";
				for(Map<String, Object> amtMap : checkAmtList)	{
					checkMessage = checkMessage +   "원 전표일 : "+ amtMap.get("ORG_AC_DATE") 
					                            + ", 원 전표번호 : "+amtMap.get("ORG_SLIP_NUM") 
					                            + ", 원 전표순번 : "+amtMap.get("ORG_SLIP_SEQ")+",\n"
					                            +  "반제가능금액 : "+amtMap.get("ORG_J_AMT_I")
					                            + ", 외화 반제가능금액 : "+amtMap.get("ORG_FOR_J_AMT_I")
					                            +"\n\n";
				}
				throw new  UniDirectValidateException(checkMessage);
			}
		}
		sParam.put("CompCode", user.getCompCode());
		sParam.put("KeyValue", keyValue);
		sParam.put("UserID", user.getUserID());
		sParam.put("UserLang", user.getLanguage());
		
		super.commonDao.queryForObject("agj110ukrServiceImpl.spAccntExSlipX1", sParam);
		String errorDesc = ObjUtils.getSafeString(sParam.get("ErrorDesc"));
		
		if(ObjUtils.isNotEmpty(errorDesc))	{
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		
		String exNum = ObjUtils.getSafeString(paramMasterData.get("EX_NUM"));

		for(Map param: paramList) {
			List<Map> dataList = (List<Map>)param.get("data");
			for(Map paramData: dataList) {
				Map rMap= (Map) super.commonDao.select("agj100ukrServiceImpl.selectLog", paramData);
				paramData.put("SLIP_NUM"		, rMap.get("EX_NUM"));
				paramData.put("SLIP_SEQ"		, rMap.get("Ex_SEQ"));
				paramData.put("OLD_SLIP_DATE"	, paramData.get("AC_DATE"));
				paramData.put("OLD_SLIP_NUM"	, rMap.get("EX_NUM"));
				paramData.put("OLD_SLIP_SEQ"	, rMap.get("Ex_SEQ"));
				paramData.put("OPR_FLAG"		, "L");
				logger.debug("IS_PEND_INPUT : "+ObjUtils.getSafeString(paramData.get("IS_PEND_INPUT")));
				if("Y".equals(ObjUtils.getSafeString(paramData.get("IS_PEND_INPUT"))))	{
					Map<String, Object> exNumMap = (Map<String, Object> )super.commonDao.select("agj110ukrServiceImpl.getExNum", paramData);
					paramData.put("OPR_FLAG", "L");
					paramData.put("J_EX_NUM", exNumMap.get("J_EX_NUM"));	
					paramData.put("J_EX_SEQ", exNumMap.get("J_EX_SEQ"));
					paramData.put("BLN_I", paramData.get("J_AMT_I"));	
					paramData.put("FOR_BLN_I", paramData.get("FOR_J_AMT_I"));
				}
				exNum = ObjUtils.getSafeString(rMap.get("EX_NUM"));
			}
		}
		
		if(1==1)	{
			//throw new  UniDirectValidateException("TEST");
		}
		paramMasterData.put("EX_NUM", exNum);
		
		paramList.add(0, paramMaster);	
		return paramList;
	}
	

}
