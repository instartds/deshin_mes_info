package foren.unilite.modules.base.bcm;

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
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("bcm120ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Bcm120ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)	/* 조회1 */
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		return super.commonDao.list("bcm120ukrvService.selectMasterList", param);
	}

	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMaster2(Map param) throws Exception {
		return super.commonDao.list("bcm120ukrvService.selectMasterList2", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			List<Map> insertList2 = null;
			List<Map> updateList2 = null;
			List<Map> deleteList2 = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteList2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail2")) {
					insertList2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail2")) {
					updateList2 = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(deleteList2 != null) this.deleteDetail2(deleteList2, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(insertList2 != null) this.insertDetail2(insertList2, user);
			if(updateList != null) this.updateDetail(updateList, user);
			if(updateList2 != null) this.updateDetail2(updateList2, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("bcm120ukrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{
				for(Map checkCompCode : chkList) {
					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("bcm120ukrvService.insertDetail", param);
				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("bcm120ukrvService.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
			for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("bcm120ukrvService.updateDetail", param);
			}
		}
		return 0;
	}


	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("bcm120ukrvService.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
			for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("bcm120ukrvService.deleteDetail", param);
			}
		}
		return 0;
	}



	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT2
	public Integer  insertDetail2(List<Map> paramList, LoginVO user) throws Exception {
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("bcm120ukrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{
				for(Map checkCompCode : chkList) {
					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("bcm120ukrvService.insertDetail2", param);
				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}

		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE2
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("bcm120ukrvService.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
			for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("bcm120ukrvService.updateDetail2", param);
			}
		}
		return 0;
	}


	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE2
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("bcm120ukrvService.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
			for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("bcm120ukrvService.deleteDetail2", param);
			}
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)	/*창고라벨 */
	public List<Map<String, Object>> selectWhLabel(Map param) throws Exception {
		return super.commonDao.list("bcm120ukrvService.selectWhLabel", param);
	}

	/**
	 * 창고CELL 라벨출력 - 20200507 추가: 이노베이션 용
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)	/*창고라벨 */
	public List<Map<String, Object>> selectWhCellLabel_inno(Map param) throws Exception {
		return super.commonDao.list("bcm120ukrvService.selectWhCellLabel_inno", param);
	}
}