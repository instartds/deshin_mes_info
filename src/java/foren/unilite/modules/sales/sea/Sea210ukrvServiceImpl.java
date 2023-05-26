package foren.unilite.modules.sales.sea;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.ObjectError;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.MessageUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("sea210ukrvService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class Sea210ukrvServiceImpl extends TlabAbstractServiceImpl {
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
		return super.commonDao.list("sea210ukrvServiceImpl.searchPopupList", param);
	}

	/**
	 * 비중체크로직 - 20210907 추가
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public int checkSpecGravity(Map param, LoginVO user) throws Exception {
		return (int) super.commonDao.select("sea210ukrvServiceImpl.checkSpecGravity", param);
	}

	/**
	 * 견적공수등록(원재료/SEA210T) 데이터 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetail(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("sea210ukrvServiceImpl.selectDetail", param);
	}

	/**
	 * 견적공수등록(부재료/SEA220T) 데이터 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetail2(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("sea210ukrvServiceImpl.selectDetail2", param);
	}









	/**견적원가계산(원재료/SEA210T) 저장
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
		List<Map> updateDetail = new ArrayList<Map>();

		if(paramList != null) {
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")|| dataListMap.get("method").equals("updateDetail")) {
					updateDetail.addAll((List<Map>)dataListMap.get("data"));
				} 
			}
			if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public void insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public void deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		int rtnCnt = 0;
		try {
			for(Map param : paramList) {
				rtnCnt += super.commonDao.update("sea210ukrvServiceImpl.updateDetail", param);
			}
		} catch(Exception e) {
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return rtnCnt;
	} 



	/**견적원가계산(내용물/SEA220T) 저장
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1. master data 저장
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		//2. detail data 저장
		List<Map> insertDetail2 = null;
		List<Map> updateDetail2 = null;
		List<Map> deleteDetail2 = null;

		if(paramList != null) {
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail2")) {
					insertDetail2 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail2")) {
					updateDetail2 = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteDetail2 = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertDetail2 != null) this.insertDetail2(insertDetail2, user, dataMaster);
			if(updateDetail2 != null) this.updateDetail2(updateDetail2, user, dataMaster);
			if(deleteDetail2 != null) this.deleteDetail2(deleteDetail2, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		int rtnCnt = 0;
			for(Map param : paramList ) {
				Map chkMapData = (Map) super.commonDao.select("sea210ukrvServiceImpl.checkSubData", param);
				// 같은 품목코드가 없을 경우
				if(chkMapData == null || (Integer)chkMapData.get("CHECK_ROW") == 0){
					try {
						rtnCnt += super.commonDao.insert("sea210ukrvServiceImpl.insertDetail2", param);
					} catch(Exception e) {
						throw new UniDirectValidateException(this.getMessage("8114", user));
					}
				} else{
					throw new UniDirectValidateException(this.getMessage("54439", user) + "\n동일한 품목정보가 존재합니다.");
				}
			}
		return rtnCnt;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail2(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("sea210ukrvServiceImpl.updateDetail2", param);
		}
		return 0;
	} 

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		for(Map param : paramList) {
			try {
				super.commonDao.delete("sea210ukrvServiceImpl.deleteDetail2", param);
			}catch(Exception e) {
				throw new  UniDirectValidateException(this.getMessage("547",user));
			}
		}
		return 0;
	}
}