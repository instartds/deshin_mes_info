package foren.unilite.modules.z_wm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("s_mba200ukrv_wmService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Mba200ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * master data 조회
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("s_mba200ukrv_wmServiceImpl.selectList1", param);
	}

	/**
	 * detail data 조회
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("s_mba200ukrv_wmServiceImpl.selectList2", param);
	}



	/** 20210315 추가: master data 저장
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_wm")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> updateDetail1 = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail1")) {
					updateDetail1 = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateDetail1 != null) this.updateDetail1(updateDetail1, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public Integer updateDetail1(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_mba200ukrv_wmServiceImpl.updateDetail1", param);
		}
		return 0;
	}



	/** 20210315 추가: detail data 저장
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_wm")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> updateDetail2 = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail2")) {
					updateDetail2 = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateDetail2 != null) this.updateDetail2(updateDetail2, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_wm")
	public Integer updateDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_mba200ukrv_wmServiceImpl.updateDetail2", param);
		}
		return 0;
	}



	/**
	 * 승인 / 미승인
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> confirmAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> confirmDetail = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("confirmDetail")) {
					confirmDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(confirmDetail != null) this.confirmDetail(confirmDetail, paramMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer confirmDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		for(Map param :paramList) {
			if("Y".equals(dataMaster.get("confirmFlag"))) {
				super.commonDao.update("s_mba200ukrv_wmServiceImpl.confirmY", param);
			} else {
				super.commonDao.update("s_mba200ukrv_wmServiceImpl.confirmN", param);
			}
		}
		return 0;
	}
}