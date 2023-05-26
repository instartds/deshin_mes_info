package foren.unilite.modules.human.hpa;

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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hpa996ukrService")
public class Hpa996ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("S_USER_ID", loginVO.getUserID());		
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		return (List) super.commonDao.list("hpa996ukrServiceImpl.selectList", param);
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> insertList(List<Map> paramList,  LoginVO user) throws Exception {
		int rsExistYN1 = super.commonDao.update("hpa996ukrServiceImpl.Hpa996QChk2_1", paramList.get(0));
		int rsExistYN2 = super.commonDao.update("hpa996ukrServiceImpl.Hpa996QChk2_2", paramList.get(0));
		List<Map> rsRetTaxI = new ArrayList();
		rsRetTaxI = (List)super.commonDao.select("hpa996ukrServiceImpl.Hpa996QChk1", paramList.get(0));
		
		for(Map param :paramList )	{			
			String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}
			
			if((rsExistYN1 != -1) && (rsExistYN2 != -1)){
				if(rsRetTaxI.get(0).get("RET_IN_TAX_I") == param.get("RET_IN_TAX_I")){
					super.commonDao.update("hpa996ukrServiceImpl.insertList", param);
				}
			}
		}
		return paramList;
	}

	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> updateList(List<Map> paramList,  LoginVO user) throws Exception {
		int rsExistYN1 = super.commonDao.update("hpa996ukrServiceImpl.Hpa996QChk2_1", paramList.get(0));
		int rsExistYN2 = super.commonDao.update("hpa996ukrServiceImpl.Hpa996QChk2_2", paramList.get(0));
		List<Map> rsRetTaxI = new ArrayList();
		rsRetTaxI = (List)super.commonDao.select("hpa996ukrServiceImpl.Hpa996QChk1", paramList.get(0));
					
		for(Map param :paramList )	{			
			String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}			
			
			if((rsExistYN1 != -1) && (rsExistYN2 != -1)){
				if(rsRetTaxI.get(0).get("RET_IN_TAX_I") == param.get("RET_IN_TAX_I")){
					super.commonDao.update("hpa996ukrServiceImpl.updateList", param);
				}
			}
		}
		return paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> deleteList(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList )	{			
			String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}			
			super.commonDao.update("hpa996ukrServiceImpl.deleteList", param);							
		}
		return paramList;
	}

	// sync All
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
		 if(paramList != null)	{
				List<Map> insertList = null;
				List<Map> updateList = null;
				List<Map> deleteList = null;
				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("deleteList")) {
						deleteList = (List<Map>)dataListMap.get("data");
					}else if(dataListMap.get("method").equals("insertList")) {		
						insertList = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateList")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				if(insertList != null) this.insertList(insertList, user);
				if(updateList != null) this.updateList(updateList, user);				
				if(deleteList != null) this.deleteList(deleteList, user);
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}
}
	
