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

@Service("s_mba100ukrv_wmService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Mba100ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 불량유형 컬럼 조회 (Q011) - 20201022 추가: 동적컬럼 생성을 위한 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("s_mba100ukrv_wmServiceImpl.selectColumns" ,loginVO);
	}

	/**
	 * master data 조회
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("s_mba100ukrv_wmServiceImpl.selectList1", param);
	}

	/**
	 * detail data 조회
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("s_mba100ukrv_wmServiceImpl.selectList2", param);
	}



	/**
	 * master data 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> updateList1 = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList1")) {
					updateList1 = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList1 != null) this.updateList1(updateList1, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer updateList1(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList) {
			super.commonDao.update("s_mba100ukrv_wmServiceImpl.updateList1", param);
		}
		return 0;
	}



	/**
	 * detail data 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> updateList2 = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList2")) {
					updateList2 = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList2 != null) this.updateList2(updateList2, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public Integer updateList2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList) {
			super.commonDao.update("s_mba100ukrv_wmServiceImpl.updateList2", param);
		}
		return 0;
	}



	/**
	 * 단가구분에 따른 매입단가 가져오는 로직
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public Double getBasicP(Map param) throws Exception {
		return (Double) super.commonDao.select("s_mba100ukrv_wmServiceImpl.getBasicP", param);
	}




	/**
	 * 확정 / 미확정
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_wm")
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
				super.commonDao.update("s_mba100ukrv_wmServiceImpl.confirmY", param);
			} else {
				super.commonDao.update("s_mba100ukrv_wmServiceImpl.confirmN", param);
			}
		}
		return 0;
	}
}