package foren.unilite.modules.stock.qms;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("qms400ukrvService")
@SuppressWarnings({"rawtypes", "unchecked"})

public class Qms400ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	


	/**
	 * 불량유형 컬럼 조회 (P003) - 동적컬럼 생성을 위한 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("qms400ukrvServiceImpl.selectColumns" ,loginVO);
	}

	/**
	 * 조회 팝업의 조회쿼리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> searchWindowSelectList(Map param) throws Exception {
		return super.commonDao.list("qms400ukrvServiceImpl.searchWindowSelectList", param);
	}

	/**
	 * 작업지시참조 조회쿼리 (팝업창)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectWorkNum(Map param) throws Exception {
			return super.commonDao.list("qms400ukrvServiceImpl.selectWorkNum", param);
	}



	/**
	 * MASTER DATE 가져오는 쿼리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("qms400ukrvServiceImpl.selectList", param);
	}

	/**
	 * DETAIL DATA(불량 정보) 가져오는 쿼리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		if("ref".equals(param.get("REF_FLAG"))) {
			return super.commonDao.list("qms400ukrvServiceImpl.selectRefDetailData", param);
		} else {
			return super.commonDao.list("qms400ukrvServiceImpl.selectList2", param);
		}
	}





	/** Master Data 저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "stock")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, dataMaster, user);
			if(updateList != null) this.updateDetail(updateList, dataMaster, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")
	public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		try {
			Map inspecNumMap = new HashMap();
			if(ObjUtils.isEmpty(paramMaster.get("INSPEC_NUM"))) {
				inspecNumMap = (Map<String, Object>) super.commonDao.select("qms400ukrvServiceImpl.getInspecNum", paramMaster);
				paramMaster.put("INSPEC_NUM", inspecNumMap.get("INSPEC_NUM"));
			}
			for(Map param : paramList) {
				param.put("INSPEC_NUM", inspecNumMap.get("INSPEC_NUM"));
				super.commonDao.update("qms400ukrvServiceImpl.insertDetail", param);
			}
		}catch(Exception e) {
			throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")
	public Integer updateDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		try {
			for(Map param :paramList ) {
				super.commonDao.update("qms400ukrvServiceImpl.updateDetail", param);
			}
		} catch(Exception e){
				throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}

	@ExtDirectMethod(group = "stock", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			try {
				super.commonDao.delete("qms400ukrvServiceImpl.deleteDetail", param);
			}catch(Exception e) {
				throw new UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}



	/** detail Data 저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "stock")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> updateList2 = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail2")) {
					updateList2 = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList2 != null) this.updateDetail2(updateList2, dataMaster, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "stock")
	public Integer updateDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		try {
			List<Map> badQtys	= (List<Map>) paramMaster.get("badQtyArray");
			List<Map> badCodes	= (List<Map>) paramMaster.get("badQtyArray2");
			for(Map param : paramList) {
				for(int k=0; k<badCodes.size(); k++) {
					param.put("INSPEC_NUM"		, paramMaster.get("INSPEC_NUM"));
					param.put("BAD_INSPEC_CODE"	, badCodes.get(k));
					param.put("BAD_INSPEC_Q"	, param.get(badQtys.get(k)));
					if(param.get(badQtys.get(k)).equals(0)) {
						super.commonDao.delete("qms400ukrvServiceImpl.deleteDetail2", param);
					} else {
						super.commonDao.update("qms400ukrvServiceImpl.updateDetail2", param);
					}
				}
			}
		} catch(Exception e){
				throw new UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}
}