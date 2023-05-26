package foren.unilite.modules.human.had;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("had500ukrService")
public class Had500ukrServiceImpl  extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.FORM_LOAD)
	public Object select(Map param) throws Exception {
		return super.commonDao.select("had500ukrServiceImpl.selectList500", param);		
	}
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "human")
	public ExtDirectFormPostResult syncMaster(Had500ukrModel param,  LoginVO user, BindingResult result) throws Exception {
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		
		BigDecimal bZero = new BigDecimal("0");
		param.setP1_SAVE_TAX_DED_I(bZero);
		param.setP2_SAVE_TAX_DED_I(bZero);
		
		param.setP1_TAX_EXEMPTION1_I(bZero);
		param.setP1_TAX_EXEMPTION2_I(bZero);
		param.setP1_TAX_EXEMPTION3_I(bZero);
		param.setP1_TAX_EXEMPTION4_I(bZero);

		param.setP2_TAX_EXEMPTION1_I(bZero);
		param.setP2_TAX_EXEMPTION2_I(bZero);
		param.setP2_TAX_EXEMPTION3_I(bZero);
		param.setP2_TAX_EXEMPTION4_I(bZero);
				
		param.setP1_TAX_EXEMPTION_STUDY_I(bZero);
		param.setP2_TAX_EXEMPTION_STUDY_I(bZero);
				
		param.setP1_TAX_EXEMPTION5_I(bZero);
		param.setP2_TAX_EXEMPTION5_I(bZero);
		param.setP1_FORE_DED_I(bZero);
		param.setP2_FORE_DED_I(bZero);
			  
		super.commonDao.update("had500ukrServiceImpl.sync", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);		
		return extResult;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList510(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> rv = null;		
		rv = (List) super.commonDao.list("had500ukrServiceImpl.selectList510", param);
		return rv;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll510(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map<String, Object>> deleteList = null;
			List<Map<String, Object>> insertList = null;
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete510")) {		
					deleteList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insert510")) {		
					insertList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update510")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");	
				} 
			}	
			if(deleteList != null) this.delete510(deleteList );
			if(insertList != null) this.insert510(insertList );
			if(updateList != null) this.update510(updateList );				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	} 
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> delete510(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had500ukrServiceImpl.delete510", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> insert510(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.insert("had500ukrServiceImpl.insert510", param);
		}
		return paramList;		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> update510(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had500ukrServiceImpl.update510", param);
		}
		return paramList;		
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList520(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> rv = null;		
		rv = (List) super.commonDao.list("had500ukrServiceImpl.selectList520", param);
		return rv;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll520(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map<String, Object>> deleteList = null;
			List<Map<String, Object>> insertList = null;
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete520")) {		
					deleteList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insert520")) {		
					insertList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update520")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");	
				} 
			}	
			if(deleteList != null) this.delete520(deleteList );
			if(insertList != null) this.insert520(insertList );
			if(updateList != null) this.update520(updateList );				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	} 
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> delete520(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had500ukrServiceImpl.delete520", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> insert520(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.insert("had500ukrServiceImpl.insert520", param);
		}
		return paramList;		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> update520(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("had500ukrServiceImpl.update520", param);
		}
		return paramList;		
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList530_1(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> rv = null;		
		param.put("EMPLOY_GUBUN", "1");
		rv = (List) super.commonDao.list("had500ukrServiceImpl.selectList530", param);
		return rv;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll530_1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map<String, Object>> deleteList = null;
			List<Map<String, Object>> insertList = null;
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete530_1")) {		
					deleteList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insert530_1")) {		
					insertList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update530_1")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");	
				} 
			}	
			if(deleteList != null) this.delete530_1(deleteList );
			if(insertList != null) this.insert530_1(insertList );
			if(updateList != null) this.update530_1(updateList );				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	} 
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> delete530_1(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			param.put("EMPLOY_GUBUN", "1");
			super.commonDao.update("had500ukrServiceImpl.delete530", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> insert530_1(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			param.put("EMPLOY_GUBUN", "1");
			super.commonDao.insert("had500ukrServiceImpl.insert530", param);
		}
		return paramList;		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> update530_1(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {
			param.put("EMPLOY_GUBUN", "1");
			super.commonDao.update("had500ukrServiceImpl.update530", param);
		}
		return paramList;		
	}
	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList530_2(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> rv = null;	
		param.put("EMPLOY_GUBUN", "2");
		rv = (List) super.commonDao.list("had500ukrServiceImpl.selectList530", param);
		return rv;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll530_2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map<String, Object>> deleteList = null;
			List<Map<String, Object>> insertList = null;
			List<Map<String, Object>> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete530_2")) {		
					deleteList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("insert530_2")) {		
					insertList = (List<Map<String, Object>>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update530_2")) {
					updateList = (List<Map<String, Object>>)dataListMap.get("data");	
				} 
			}	
			if(deleteList != null) this.delete530_2(deleteList );
			if(insertList != null) this.insert530_2(insertList );
			if(updateList != null) this.update530_2(updateList );				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	} 
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> delete530_2(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {	
			param.put("EMPLOY_GUBUN", "2");
			super.commonDao.update("had500ukrServiceImpl.delete530", param);
		}
		return paramList;
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> insert530_2(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {	
			param.put("EMPLOY_GUBUN", "2");
			super.commonDao.insert("had500ukrServiceImpl.insert530", param);
		}
		return paramList;		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> update530_2(List<Map<String, Object>> paramList) throws Exception {
		for(Map param : paramList) {	
			param.put("EMPLOY_GUBUN", "2");
			super.commonDao.update("had500ukrServiceImpl.update530", param);
		}
		return paramList;		
	}
	
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public Map<String, Object>  deleteAll(Map<String, Object> param) throws Exception {
		super.commonDao.update("had500ukrServiceImpl.delete500", param);
		super.commonDao.update("had500ukrServiceImpl.delete510", param);
		super.commonDao.update("had500ukrServiceImpl.delete520", param);
		super.commonDao.update("had500ukrServiceImpl.delete530", param);
		return param;
	}
}
