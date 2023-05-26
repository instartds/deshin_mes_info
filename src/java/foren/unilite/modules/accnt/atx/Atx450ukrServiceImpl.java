package foren.unilite.modules.accnt.atx;

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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("atx450ukrService")
public class Atx450ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	// 제일 먼저 조회
	public List<Map<String, Object>> selectFirst(Map param) throws Exception {
		return super.commonDao.list("atx450ukrServiceImpl.selectFirst", param);
	}

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	// 1번쨰 그리드
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		if(super.commonDao.list("atx450ukrServiceImpl.selectFirst", param).isEmpty()) {
			return super.commonDao.list("atx450ukrServiceImpl.selectList_1", param);
		} else {
			return super.commonDao.list("atx450ukrServiceImpl.selectList", param);
		}
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	// 2번쨰 그리드
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		if(super.commonDao.list("atx450ukrServiceImpl.selectFirst", param).isEmpty()) {
			return super.commonDao.list("atx450ukrServiceImpl.selectList2_2", param);
		} else {
			return super.commonDao.list("atx450ukrServiceImpl.selectList2", param);
		}
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	// 3번쨰 그리드
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		if(super.commonDao.list("atx450ukrServiceImpl.selectFirst", param).isEmpty()) {
			return super.commonDao.list("atx450ukrServiceImpl.selectList3_3", param);
		} else {
			return super.commonDao.list("atx450ukrServiceImpl.selectList3", param);
		}
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	// 4번쨰 그리드
	public List<Map<String, Object>> selectList4(Map param) throws Exception {
		if(super.commonDao.list("atx450ukrServiceImpl.selectFirst", param).isEmpty()) {
			return super.commonDao.list("atx450ukrServiceImpl.selectList4_4", param);
		} else {
			return super.commonDao.list("atx450ukrServiceImpl.selectList4", param);
		}
	}
	
	
	
	/* 재참조 관련1 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> dataCheck(Map param) throws Exception {
		return  super.commonDao.list("atx450ukrServiceImpl.selectList", param);
	}
	
	/* 재참조 관련2 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> reReference(Map param) throws Exception {
		super.commonDao.list("atx450ukrServiceImpl.deleteDataCheck", param);
		super.commonDao.list("atx450ukrServiceImpl.deleteDataCheck2", param);
		super.commonDao.list("atx450ukrServiceImpl.deleteDataCheck3", param);
		super.commonDao.list("atx450ukrServiceImpl.deleteDataCheck4", param);
		return super.commonDao.list("atx450ukrServiceImpl.selectList_1", param);
	}
	
	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("atx450ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{
//				for(Map checkCompCode : chkList) {
//					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("atx450ukrServiceImpl.insertDetail", param);
//				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("atx450ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx450ukrServiceImpl.updateDetail", param);
//			}
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail2")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail2")) {
					updateList = (List<Map>)dataListMap.get("data");
				} 
			}
			if(deleteList != null) this.deleteDetail2(deleteList, user);
			if(insertList != null) this.insertDetail2(insertList, user);
			if(updateList != null) this.updateDetail2(updateList, user);
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail2(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("atx450ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{
//				for(Map checkCompCode : chkList) {
//					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("atx450ukrServiceImpl.insertDetail2", param);
//				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("atx450ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx450ukrServiceImpl.updateDetail2", param);
//			}
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("atx450ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx450ukrServiceImpl.deleteDetail2", param);
//			}
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll3(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail3")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail3")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail3")) {
					updateList = (List<Map>)dataListMap.get("data");
				} 
			}
			if(deleteList != null) this.deleteDetail3(deleteList, user);
			if(insertList != null) this.insertDetail3(insertList, user);
			if(updateList != null) this.updateDetail3(updateList, user);
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail3(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("atx450ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList )	{
//				for(Map checkCompCode : chkList) {
//					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("atx450ukrServiceImpl.insertDetail3", param);
//				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail3(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("atx450ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx450ukrServiceImpl.updateDetail3", param);
//			}
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail3(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("atx450ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx450ukrServiceImpl.deleteDetail3", param);
//			}
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll4(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail4")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail4")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail4")) {
					updateList = (List<Map>)dataListMap.get("data");	
				}
			}
			if(deleteList != null) this.deleteDetail4(deleteList, user);
			if(insertList != null) this.insertDetail4(insertList, user);
			if(updateList != null) this.updateDetail4(updateList, user);
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail4(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("atx450ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList ) {
//				for(Map checkCompCode : chkList) {
//					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("atx450ukrServiceImpl.insertDetail4", param);
//				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("atx450ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList ) {
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx450ukrServiceImpl.updateDetail4", param);
//			}
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail4(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("atx450ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{	
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx450ukrServiceImpl.deleteDetail4", param);
//			}
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public void atx450ukrDelA (Map param, LoginVO user) throws Exception {
		super.commonDao.list("atx450ukrServiceImpl.deleteDataCheck", param);
		super.commonDao.list("atx450ukrServiceImpl.deleteDataCheck2", param);
		super.commonDao.list("atx450ukrServiceImpl.deleteDataCheck3", param);
		super.commonDao.list("atx450ukrServiceImpl.deleteDataCheck4", param);
		
		return;
	}
}
