package foren.unilite.modules.base.bpr;

import java.util.ArrayList;
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
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("bpr260ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Bpr260ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("bpr260ukrvServiceImpl.selectDetailList", param);
	}

	/**
	 * 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> checkDataInfo(Map param) throws Exception {
		return super.commonDao.list("bpr260ukrvServiceImpl.checkDataInfo", param);
	}

	/**
	 * 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)   {
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
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")	// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("bpr260ukrvServiceImpl.insertDetail", param);
			if(!ObjUtils.isEmpty(param.get("ITEM_WIDTH"))) {
				super.commonDao.update("bpr260ukrvServiceImpl.updateDetail2", param);
			}
			if(!ObjUtils.isEmpty(param.get("KEEP_TEMPER")) || !ObjUtils.isEmpty(param.get("PACK_QTY")) || !ObjUtils.isEmpty(param.get("PACK_TYPE"))) {
				super.commonDao.update("bpr260ukrvServiceImpl.updateDetail3", param);
			}
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")	// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("bpr260ukrvServiceImpl.updateDetail", param);
			if(!ObjUtils.isEmpty(param.get("ITEM_WIDTH"))) {
				super.commonDao.update("bpr260ukrvServiceImpl.updateDetail2", param);
			}
			if(!ObjUtils.isEmpty(param.get("KEEP_TEMPER")) || !ObjUtils.isEmpty(param.get("PACK_QTY")) || !ObjUtils.isEmpty(param.get("PACK_TYPE"))) {
				super.commonDao.update("bpr260ukrvServiceImpl.updateDetail3", param);
			}
		}
		return 0;
	} 

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)				// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {   
			super.commonDao.update("bpr260ukrvServiceImpl.deleteDetail", param);
		}
		return 0;
	}
}