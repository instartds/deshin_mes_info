package foren.unilite.modules.accnt.agj;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.util.JSONUtils;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.JsonUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.popup.PopupServiceImpl;
import foren.unilite.modules.com.potal.BadgeServiceImpl;

@Service("agj100ukrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Agj100ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="tlabBadgeService")
	private TlabBadgeService tlabBadgeService;
	
	@Resource(name="popupService")
	private PopupServiceImpl popupService;

	/**
	 * 결의전표등록 - 전표옵션 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object selectOption(Map param) throws Exception {
		return super.commonDao.select("agj100ukrServiceImpl.selectOption", param);
	}

	/**
	 * 결의전표등록 - 전표번호 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object getSlipNum(Map param) throws Exception {
		return super.commonDao.select("agj100ukrServiceImpl.getSlipNum", param);
	}

	/**
	 * 결의전표등록 - 일반전표 목록 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("agj100ukrServiceImpl.selectList", param);
	}

	/**
	 * 결의전표등록 - 현금계정 가져오기 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object getCashAccnt(Map param) throws Exception {
		return super.commonDao.select("agj100ukrServiceImpl.getCashAccnt", param);
	}

	/**
	 * 결의전표등록 - 매입매출 목록 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public List<Map<String, Object>> selectCustomList(Map param) throws Exception {
		return (List) super.commonDao.list("agj100ukrServiceImpl.selectCustomList", param);
	}

	/**
	 * 결의 미결 반제 등록
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_SYNCALL)
	public List<Map> insertLagj110(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		String keyValue = getLogKey();

		Map<String, Object> paramMasterData = (Map<String, Object>) paramMaster.get("data");
		if(paramMasterData != null && ObjUtils.isNotEmpty(paramMasterData.get("KeyValue"))) {
			keyValue = ObjUtils.getSafeString(paramMasterData.get("KeyValue"));
		}
		
		//로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList	= new ArrayList<Map>();
		Map sParam			= new HashMap();
		Map autoMap			= (Map) super.commonDao.select("agj100ukrServiceImpl.getMaxAutoNum", sParam);
		int i				= Integer.parseInt(autoMap.get("MAX_AUTO_NUM").toString());

		if(paramList != null) {
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				for(Map paramData: dataList) {
					paramData.put("KEY_VALUE", keyValue);
					paramData.put("AUTO_NUM", i);
					super.commonDao.update("agj100ukrServiceImpl.insertLog", paramData);
					i++;
				}
			}
			List<Map> dataList2 = new ArrayList<Map>();
			for(Map param: paramList) {
				dataList2 = (List<Map>)param.get("data");
				for(Map paramData: dataList2) {
					Map rMap= (Map) super.commonDao.select("agj100ukrServiceImpl.selectLog", paramData);
					paramMasterData.put("SLIP_NUM"	, rMap.get("EX_NUM"));
					paramData.put("SLIP_NUM"		, rMap.get("EX_NUM"));
					paramData.put("SLIP_SEQ"		, rMap.get("Ex_SEQ"));
					paramData.put("OLD_SLIP_DATE"	, paramData.get("AC_DATE"));
					paramData.put("OLD_SLIP_NUM"	, rMap.get("EX_NUM"));
					paramData.put("OLD_SLIP_SEQ"	, rMap.get("Ex_SEQ"));
					paramData.put("OPR_FLAG"		, "L");
				}
			}
		}

		Map<String, Object> paramData = (Map<String, Object>)paramMaster.get("data");
		paramData.put("KeyValue", keyValue);
		paramMaster.put("data", paramData);
		logger.debug(JsonUtils.toJsonStr(paramMaster).toString());

		paramList.add(0, paramMaster);	
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//로그테이블에서 사용할 Key 생성
		String keyValue = getLogKey();
		//로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList	= new ArrayList<Map>();
		Map sParam			= new HashMap();
		Map autoMap			= (Map) super.commonDao.select("agj100ukrServiceImpl.getMaxAutoNum", sParam);
		int i				= Integer.parseInt(autoMap.get("MAX_AUTO_NUM").toString());

		if(paramList != null) {
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				for(Map paramData: dataList) {
					paramData.put("KEY_VALUE", keyValue);
					paramData.put("AUTO_NUM", i);
					super.commonDao.update("agj100ukrServiceImpl.insertLog", paramData);
					i++;
				}
			}
		}

		//Stored Procedure 실행
		//매입매출 정보
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		if(ObjUtils.isNotEmpty(dataMaster) && ObjUtils.isNotEmpty(dataMaster.get("PUB_DATE"))) {
			//Log Table 저장
			dataMaster.put("KEY_VALUE", keyValue);
			//dataMaster.put("OPR_FLAG", "N");	
			dataMaster.put("S_COMP_CODE", user.getCompCode());
			dataMaster.put("S_USER_ID", user.getUserID());

			super.commonDao.update("agj100ukrServiceImpl.insertLog120", dataMaster);

			//SP parameter
			Map aParam = new HashMap();
			aParam.put("CompCode"	, user.getCompCode());
			aParam.put("KeyValue"	, keyValue);
			aParam.put("UserID"		, user.getUserID());
			aParam.put("UserLang"	, user.getLanguage());
			
			//SP 호출
			super.commonDao.queryForObject("agj100ukrServiceImpl.spAccntExslipY1", aParam);
			String errorDesc = ObjUtils.getSafeString(aParam.get("ErrorDesc"));

			if(ObjUtils.isNotEmpty(errorDesc)) {
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			} else {
				if(paramList != null) {
					List<Map> dataList2 = new ArrayList<Map>();
					for(Map param: paramList) {
						dataList2 = (List<Map>)param.get("data");
						for(Map paramData: dataList2) {
							Map rMap= (Map) super.commonDao.select("agj100ukrServiceImpl.selectLog", paramData);
							paramData.put("SLIP_NUM"		, rMap.get("EX_NUM"));
							dataMaster.put("SLIP_NUM"		, rMap.get("EX_NUM"));
							paramData.put("OLD_AC_DATE"		, paramData.get("AC_DATE"));
							paramData.put("OLD_SLIP_NUM"	, rMap.get("EX_NUM"));
							paramData.put("OLD_SLIP_SEQ"	, paramData.get("SLIP_SEQ"));
							paramData.put("OPR_FLAG"		, "L");
						}
					}
					Map rMap2= (Map) super.commonDao.select("agj100ukrServiceImpl.selectSalesLog", dataMaster);
					dataMaster.put("PUB_NUM",rMap2.get("PUB_NUM"));
					//super.commonDao.update("agj100ukrServiceImpl.deleteLog", sParam);
				}
			}
		}else {
			sParam.put("CompCode"	, user.getCompCode());
			sParam.put("KeyValue"	, keyValue);
			sParam.put("UserID"		, user.getUserID());
			sParam.put("UserLang"	, user.getLanguage());

			super.commonDao.queryForObject("agj100ukrServiceImpl.spAccntExslip", sParam);
			String errorDesc = ObjUtils.getSafeString(sParam.get("ErrorDesc"));

			if(ObjUtils.isNotEmpty(errorDesc)) {
				throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
			} else {
				if(paramList != null) {
					List<Map> dataList2 = new ArrayList<Map>();
					for(Map param: paramList) {
						dataList2 = (List<Map>)param.get("data");
						for(Map paramData: dataList2) {
							Map rMap= (Map) super.commonDao.select("agj100ukrServiceImpl.selectLog", paramData);
							paramData.put("SLIP_NUM"		, rMap.get("EX_NUM"));
							paramData.put("OPR_FLAG"		, "L");
							paramData.put("OLD_AC_DATE"		, paramData.get("AC_DATE"));
							paramData.put("OLD_SLIP_NUM"	, rMap.get("EX_NUM"));
							paramData.put("OLD_SLIP_SEQ"	, paramData.get("SLIP_SEQ"));
							dataMaster.put("SLIP_NUM"		, rMap.get("EX_NUM"));
						}
					}
					//super.commonDao.update("agj100ukrServiceImpl.deleteLog", sParam);
				}
			}
		}
		tlabBadgeService.reload();
		paramMaster.put("data", dataMaster);
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert(List<Map> params) throws Exception {
		return params;
	}
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update(List<Map> params) throws Exception {
		return params;
	}
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete(List<Map> params) throws Exception {
		return params;
	}

	/**
	 * 결의전표등록 - 매입매출 계산서 번호 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public Object getPubNum(Map param) throws Exception {
		return super.commonDao.select("agj100ukrServiceImpl.getPubNum", param);
	}

	/**
	 * 자동분개 불러오기 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public List<Map> selectAutoAccnt(Map param) throws Exception {
		List<Map> rList = super.commonDao.list("agj100ukrServiceImpl.selectAutoAccnt", param);
		for(Map rMap : rList) {
			Map param2 = new HashMap();
			param2.put("S_COMP_CODE", param.get("S_COMP_CODE"));
			param2.put("ACCNT_CODE", rMap.get("ACCNT"));
			List<Map<String, Object>> accntList = popupService.accntPopupWithAcCode(param2);
			if(accntList != null ) {
				rMap.putAll(accntList.get(0));
			}
		}
		return rList;
	}

	/**
	 * 중복 입력자롸 확인
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt")
	public List<Map> selectDuplicate(Map params, LoginVO user) throws Exception {
		List<Map> paramList = (List<Map>) params.get("data");
		List<Map> rList = new ArrayList<Map>();
		for(Map pMap : paramList) {
			if("1".equals(params.get("csSLIP_TYPE"))) {
				pMap.put("S_COMP_CODE", user.getCompCode());
				Map dup = (Map)super.commonDao.select("agj200ukrServiceImpl.selectDuplicate", pMap);
				if(dup != null && ObjUtils.parseInt(dup.get("CNT")) > 0) {
					rList.add(pMap);
				}
			} else {
				pMap.put("S_COMP_CODE", user.getCompCode());
				Map dup = (Map)super.commonDao.select("agj100ukrServiceImpl.selectDuplicate", pMap);
				if(dup != null && ObjUtils.parseInt(dup.get("CNT")) > 0) {
					rList.add(pMap);
				}
			}
		}
		return rList;
	}
}