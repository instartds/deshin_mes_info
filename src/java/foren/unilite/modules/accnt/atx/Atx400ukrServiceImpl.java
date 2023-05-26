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



@Service("atx400ukrService")
public class Atx400ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	/* 조회 */
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		if(super.commonDao.list("atx400ukrServiceImpl.selectList", param).isEmpty()) {
			Map interestRateMap = (Map)	super.commonDao.select("atx400ukrServiceImpl.fnGetInterestRate", param);
			if(ObjUtils.isNotEmpty(interestRateMap)){
				param.put("INTEREST_RATE", interestRateMap.get("INTEREST_RATE"));
			}else{
				param.put("INTEREST_RATE", 0);
			}
			return super.commonDao.list("atx400ukrServiceImpl.selectList4", param);
		}else{
			return super.commonDao.list("atx400ukrServiceImpl.selectList", param);
		}
	}
	
	/**
	 * 재참조버튼 관련 1
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> dataCheck(Map param) throws Exception {
		return  super.commonDao.list("atx400ukrServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return  super.commonDao.list("atx400ukrServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectBor120List(Map param) throws Exception {
		return  super.commonDao.list("atx400ukrServiceImpl.selectBor120TList", param);
	}
	
	/**
	 * 재참조버튼 관련 2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> reReference(Map param) throws Exception {
		super.commonDao.list("atx400ukrServiceImpl.deleteDetail2", param);
		Map interestRateMap = (Map)	super.commonDao.select("atx400ukrServiceImpl.fnGetInterestRate", param);
		if(ObjUtils.isNotEmpty(interestRateMap)){
			param.put("INTEREST_RATE", interestRateMap.get("INTEREST_RATE"));
		}else{
			param.put("INTEREST_RATE", 0);
		}
		return  super.commonDao.list("atx400ukrServiceImpl.selectList4", param);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	/* 이자율 팝업 조회 */
	public List<Map<String, Object>> selectInterestRate(Map param) throws Exception {
		return super.commonDao.list("atx400ukrServiceImpl.selectInterestRate", param);
	}

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)	/* 이자율 팝업 조회 */
	public Object fnGetInterestRate(Map param) throws Exception {
		return super.commonDao.select("atx400ukrServiceImpl.fnGetInterestRate", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
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
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("atx400ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList ) {
//				for(Map checkCompCode : chkList) {
//					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("atx400ukrServiceImpl.insertDetail", param);
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
//		List<Map> chkList = (List<Map>) super.commonDao.list("atx400ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{	
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx400ukrServiceImpl.updateDetail", param);
//			}
		}
		return 0;
	}
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("atx400ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{	
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx400ukrServiceImpl.deleteDetail", param);
//			}
		}
		return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveInterestRate(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteInterestRate")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertInterestRate")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateInterestRate")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteInterestRate(deleteList, user);
			if(insertList != null) this.insertInterestRate(insertList, user);
			if(updateList != null) this.updateInterestRate(updateList, user);
		}
		paramList.add(0, paramMaster);
		
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertInterestRate(List<Map> paramList, LoginVO user) throws Exception {
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("atx400ukrServiceImpl.checkCompCode", compCodeMap);
			for(Map param : paramList ) {
//				for(Map checkCompCode : chkList) {
//					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("atx400ukrServiceImpl.insertInterestRate", param);
//				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateInterestRate(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("atx400ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList ) {
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx400ukrServiceImpl.updateInterestRate", param);
//			}
		}
		return 0;
	} 
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteInterestRate(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("atx400ukrServiceImpl.checkCompCode", compCodeMap);
		for(Map param :paramList )	{	
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("atx400ukrServiceImpl.deleteInterestRate", param);
//			}
		}
		return 0;
	}
}
