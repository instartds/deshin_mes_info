package foren.unilite.modules.accnt.aiga;

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



@Service("aiga240ukrvService")
public class Aiga240ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 감가상각비자동기표방법등록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("aiga240ukrvServiceImpl.selectList", param);
	}
	
	public List<ComboItemModel> selectSetDivi( Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("aiga240ukrvServiceImpl.selectSetDivi", param);
	}
	
	public List<ComboItemModel> selectAmtDivi(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("aiga240ukrvServiceImpl.selectAmtDivi", param);
	}

	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		if(paramList != null)	{
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
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		//try {
			for(Map param : paramList )	{
				if(!param.get("ALTER_DIVI").equals("40") && !param.get("ALTER_DIVI").equals("22")){
					String setDiviOrg = (String) param.get("SET_DIVI");
					param.put("SET_DIVI", setDiviOrg.substring(5));
				}
				String amtDiviOrg = (String) param.get("AMT_DIVI");
				param.put("AMT_DIVI", amtDiviOrg.substring(5));
				super.commonDao.update("aiga240ukrvServiceImpl.insertDetail", param);
			}	
		//}catch(Exception e){
		//	throw new  UniDirectValidateException(this.getMessage("2627", user));
		//}
		return;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			if(!param.get("ALTER_DIVI").equals("40") && !param.get("ALTER_DIVI").equals("22")){
				String setDiviOrg = (String) param.get("SET_DIVI");
				param.put("SET_DIVI", setDiviOrg.substring(5));
			}
			String amtDiviOrg = (String) param.get("AMT_DIVI");
			param.put("AMT_DIVI", amtDiviOrg.substring(5));
			super.commonDao.insert("aiga240ukrvServiceImpl.updateDetail", param);
		}
		 return;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
			 //try {
				 if(!param.get("ALTER_DIVI").equals("40") && !param.get("ALTER_DIVI").equals("22")){
					String setDiviOrg = (String) param.get("SET_DIVI");
					param.put("SET_DIVI", setDiviOrg.substring(5));
				}
				String amtDiviOrg = (String) param.get("AMT_DIVI");
				param.put("AMT_DIVI", amtDiviOrg.substring(5));
				 super.commonDao.delete("aiga240ukrvServiceImpl.deleteDetail", param);
			 //}catch(Exception e)	{
	    	//		throw new  UniDirectValidateException(this.getMessage("547",user));
	    	//}	
		 }
		 return;
	}
	
	
	
}
