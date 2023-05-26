package foren.unilite.modules.z_mit;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_str330ukrv_mitService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_str330ukrv_mitServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 미확인 반품결과 조회 쿼리
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		param.put("CONFIRM_FLAG", "N");
		return  super.commonDao.list("s_str330ukrv_mitServiceImpl.selectList", param);
	}

	/**
	 * 확인 반품결과 조회 쿼리
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		param.put("CONFIRM_FLAG", "Y");
		return  super.commonDao.list("s_str330ukrv_mitServiceImpl.selectList", param);
	}





	/**
	 * 미확인 반품결과 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList(deleteList, user, dataMaster);
			if(insertList != null) this.updateList(insertList, user, dataMaster);
			if(updateList != null) this.updateList(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/**추가**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return 0;
	}

	/**수정**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList) {
			param.put("INSPEC_DATE", paramMaster.get("INSPEC_DATE"));
			if(ObjUtils.parseBoolean(param.get("CONFIRM_YN"), true)) {
				param.put(param.get("CONFIRM_YN"), "Y");
			} else {
				param.put(param.get("CONFIRM_YN"), "N");
			}
			super.commonDao.update("s_str330ukrv_mitServiceImpl.updateList", param);
		}
		return 0;
	}

	/**삭제**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			try {
				super.commonDao.delete("s_str330ukrv_mitServiceImpl.deleteList", param);
			} catch(Exception e) {
				throw new UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}



	/**
	 * 미확인 반품결과 저장
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null) {
			List<Map> insertList2 = null;
			List<Map> updateList2 = null;
			List<Map> deleteList2 = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList2")) {
					insertList2 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList2")) {
					updateList2 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteList2")) {
					deleteList2 = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList2 != null) this.deleteList2(deleteList2, user, dataMaster);
			if(insertList2 != null) this.updateList2(insertList2, user, dataMaster);
			if(updateList2 != null) this.updateList2(updateList2, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	/**추가**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertList2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return 0;
	}

	/**수정**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateList2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList) {
			param.put("INSPEC_DATE", paramMaster.get("INSPEC_DATE"));
			super.commonDao.update("s_str330ukrv_mitServiceImpl.updateList", param);
		}
		return 0;
	}

	/**삭제**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteList2(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			try {
				super.commonDao.delete("s_str330ukrv_mitServiceImpl.deleteList", param);
			} catch(Exception e) {
				throw new UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}








	/**
	 * 폐기, 재입고 처리
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
	public List<Map> setBtr100t(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)   {
			List<Map> insertList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("outRein")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.outRein(insertList, paramMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer outRein( List<Map> paramList, Map paramMaster,  LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue	= getLogKey();

		for(Map param: paramList) {
			param.put("KEY_VALUE"	, keyValue);
			if("OUT".equals(dataMaster.get("SAVE_FLAG"))) {
				param.put("DEPT_CODE"	, dataMaster.get("DEPT_CODE"));
				param.put("OUT_DATE"	, dataMaster.get("OUT_DATE"));
				param.put("WH_CODE"		, dataMaster.get("WH_CODE"));
				param.put("WH_CELL_CODE", dataMaster.get("WH_CELL_CODE"));
				param.put("INOUT_PRSN"	, dataMaster.get("INOUT_PRSN"));
				param.put("data", super.commonDao.insert("s_str330ukrv_mitServiceImpl.insertLog1", param));
			} else {
				param.put("DEPT_CODE"		, dataMaster.get("DEPT_CODE"));
				param.put("RE_IN_DATE"		, dataMaster.get("RE_IN_DATE"));
				param.put("WH_CODE"			, dataMaster.get("WH_CODE"));
				param.put("WH_CELL_CODE"	, dataMaster.get("WH_CELL_CODE"));
				param.put("IN_WH_CODE"		, dataMaster.get("IN_WH_CODE"));
				param.put("IN_WH_CELL_CODE"	, dataMaster.get("IN_WH_CELL_CODE"));
				param.put("INOUT_PRSN"		, dataMaster.get("INOUT_PRSN"));
				param.put("data", super.commonDao.insert("s_str330ukrv_mitServiceImpl.insertLog2", param));
			}
		}
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KEY_VALUE", keyValue);
		if("OUT".equals(dataMaster.get("SAVE_FLAG"))) {
			super.commonDao.queryForObject("s_str330ukrv_mitServiceImpl.spReseving1", spParam);
		} else {
			super.commonDao.queryForObject("s_str330ukrv_mitServiceImpl.spReseving2", spParam);
		}
		String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		if(!ObjUtils.isEmpty(errorDesc)){
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		return 0;
	}
}