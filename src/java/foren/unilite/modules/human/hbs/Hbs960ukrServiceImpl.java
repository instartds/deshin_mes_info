package foren.unilite.modules.human.hbs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

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


@Service("hbs960ukrService")
public class Hbs960ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("S_USER_ID", loginVO.getUserID());		
		return (List) super.commonDao.list("hbs960ukrServiceImpl.selectList", param);	
//		return null;
	}	

	
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{			
			super.commonDao.update("hbs960ukrServiceImpl.update", param);							
		}
		return paramList;
	}
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert(List<Map> paramList) throws Exception {
		for(Map param :paramList )	{				
			super.commonDao.update("hbs960ukrServiceImpl.update", param);							
		}
		return paramList;
	}
	// sync All
/*	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public Integer syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return 0;
	}*/
	
	// sync All
	
	@ExtDirectMethod( group = "human")
	public List<Map<String, Object>> checkInstallmentPay(Map param, LoginVO loginVO) throws Exception {		
		return (List<Map<String, Object>>) super.commonDao.list("hbs960ukrServiceImpl.checkInstallmentPay", param);	
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		if(paramList != null)   {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
//				if(dataListMap.get("method").equals("deleteDetail")) {
//					deleteList = (List<Map>)dataListMap.get("data");
//				}else 
				if(dataListMap.get("method").equals("insert")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else 
				if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.insert(insertList);
			if(updateList != null) this.update(updateList);
		}
		paramList.add(0, paramMaster);

		return paramList;
		
	}
		
}
	
