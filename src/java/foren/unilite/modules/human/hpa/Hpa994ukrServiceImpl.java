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
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hpa994ukrService")
public class Hpa994ukrServiceImpl extends TlabAbstractServiceImpl {
	
	public List<ComboItemModel> getBussOfficeCode(Map param) throws Exception {
		return (List<ComboItemModel>)super.commonDao.list("hpa994ukrServiceImpl.getBussOfficeCode" ,param);
	}

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {		
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("S_USER_ID", loginVO.getUserID());		
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		return (List) super.commonDao.list("hpa994ukrServiceImpl.selectList", param);
	}	
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")		// UPDATE
	public Integer updateList(List<Map> paramList, LoginVO user) throws Exception {
//		폼에서 필요한 조건 가져올 경우 참조
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		 for(Map param :paramList )	{
//			 param.put("PAY_YYYYMM", dataMaster.get("PAY_YYYYMM"));
			 super.commonDao.insert("hpa994ukrServiceImpl.updateList", param);
		 }
		 return 0;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertList(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			for(Map param : paramList )	{			 
					 super.commonDao.update("hpa994ukrServiceImpl.insertList", param);
				
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteList(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
				 super.commonDao.update("hpa994ukrServiceImpl.deleteList", param);
		 }
		 return 0;
	} 
	
	
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
	

    
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return (List)super.commonDao.list("hpa994ukrServiceImpl.selectList1" ,param);
	}
	
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return (List)super.commonDao.list("hpa994ukrServiceImpl.selectList2" ,param);
	}
}
	
