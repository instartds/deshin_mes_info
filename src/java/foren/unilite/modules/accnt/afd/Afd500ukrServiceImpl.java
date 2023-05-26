package foren.unilite.modules.accnt.afd;

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
import foren.unilite.modules.accnt.afn.Afn100ukrModel;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("afd500ukrService")
public class Afd500ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectAmt(Map param) throws Exception {		
		return super.commonDao.select("afd500ukrService.selectAmtPoint", param);
	}
	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		Map<String, Object> amtPoint = (Map<String, Object>)this.selectAmt(param);
		param.put("AMT_POINT", amtPoint.get("AMT_POINT"));
		return super.commonDao.list("afd500ukrService.selectList", param);
	}	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> saveCodeCheck(Map param) throws Exception {
		return super.commonDao.list("afd500ukrService.saveCodeCheck", param);
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
					} else if(dataListMap.get("method").equals("updateDetail")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} else if(dataListMap.get("method").equals("insertDetail")) {
						insertList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				if(deleteList != null) this.deleteDetail(deleteList, user);
				if(updateList != null) this.updateDetail(updateList, user);	
				if(insertList != null) this.insertDetail(insertList, user);				
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer insertDetail(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("afd500ukrService.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("afd500ukrService.insertDetail", param);
//			}
		}
		return 0;
	}

	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("afd500ukrService.checkCompCode", compCodeMap);
		for(Map param :paramList )	{
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("afd500ukrService.updateDetail", param);
//			}
		}
		return 0;
	}
	
	
	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("afd500ukrService.checkCompCode", compCodeMap);
		for(Map param :paramList )	{	
//			for(Map checkCompCode : chkList) {
//				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("afd500ukrService.deleteDetail", param);
//			}
		}
		return 0;
	} 
}