package foren.unilite.modules.sales.sof;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("sof104ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sof104ukrvServiceImpl extends TlabAbstractServiceImpl {
	@InjectLogger
	public static Logger logger;	// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 등록자 콤보 생성
	 * @param param(S_COMP_CODE)
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> getUserInfo(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("sof104ukrvServiceImpl.getUserInfo", param);
	}

	/**
	 * 수주데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("sof104ukrvServiceImpl.selectList", param);
	}



	/**
	 * 수주납기변경 저장로직
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> insertDetail = null;
			List<Map> updateDetail = null;
			List<Map> deleteDetail = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertDetail = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertDetail != null) this.insertDetail(insertDetail, user, dataMaster);
			if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
			if(deleteDetail != null) this.deleteDetail(deleteDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		try {
			for(Map param : paramList ) {
				super.commonDao.update("sof104ukrvServiceImpl.insertDetail"	, param);
				super.commonDao.update("sof104ukrvServiceImpl.updateSOF110T", param);
				param.put("SAVE_FLAG", "N");
				super.commonDao.update("sof104ukrvServiceImpl.insertHistory", param);
			}
		} catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("sof104ukrvServiceImpl.updateDetail"	, param);
			super.commonDao.update("sof104ukrvServiceImpl.updateSOF110T", param);
			param.put("SAVE_FLAG", "U");
			super.commonDao.update("sof104ukrvServiceImpl.insertHistory", param);
		}
		return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 for(Map param : paramList) {
			try {
				super.commonDao.update("sof104ukrvServiceImpl.deleteDetail"	, param);
				super.commonDao.update("sof104ukrvServiceImpl.updateSOF110T", param);
				param.put("SAVE_FLAG", "D");
				super.commonDao.update("sof104ukrvServiceImpl.insertHistory", param);
			} catch(Exception e) {
				throw new UniDirectValidateException(this.getMessage("547", user));
			}
		}
		return 0;
	}
}