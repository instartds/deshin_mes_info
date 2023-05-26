package foren.unilite.modules.sales.sea;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("sea200ukrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Sea200ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 조회팝업 쿼리
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> searchPopupList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("sea200ukrvServiceImpl.searchPopupList", param);
	}

	/**
	 * 견적공수등록 데이터 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetail(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("sea200ukrvServiceImpl.selectDetail", param);
	}

	/**
	 * 견적공수등록 데이터 조회(금액상세, detailGrid2)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetail2(Map param, LoginVO user) throws Exception {
		String refCode = "";
		if("01".equals(param.get("OUT_DIV_CODE"))) {
			refCode = "REF_CODE1";
		} else {
			refCode = "REF_CODE2";
		}
		param.put("REF_CODE", refCode);
		return super.commonDao.list("sea200ukrvServiceImpl.selectDetail2", param);
	}









	/**견적공수등록 저장
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1. master data 저장
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//2. detail data 저장
		List<Map> insertDetail = null;
		List<Map> updateDetail = null;
		List<Map> deleteDetail = null;

		if(paramList != null) {
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertDetail = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertDetail != null) this.insertDetail(insertDetail, user, dataMaster);
			if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
			if(deleteDetail != null) this.deleteDetail(deleteDetail, user, dataMaster);
			
			// SEA100T 임가공비 저장
			if(dataMaster != null) this.insertCost(user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		try {
			for(Map param : paramList ) {
				super.commonDao.insert("sea200ukrvServiceImpl.insertDetail", param);
			}
		} catch(Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("sea200ukrvServiceImpl.updateDetail", param);
		}
		return 0;
	} 

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		for(Map param : paramList) {
			try {
					super.commonDao.delete("sea200ukrvServiceImpl.deleteDetail", param);
			}catch(Exception e) {
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}
	
	/**
	 * sea100t에 임가공비 저장
	 * */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertCost(LoginVO user, Map paramMaster) throws Exception {

		int rstlCnt = super.commonDao.delete("sea200ukrvServiceImpl.insertCost", paramMaster);

		return rstlCnt;
	}
}