package foren.unilite.modules.accnt.arc;

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



@Service("arc210ukrService")
public class Arc210ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 감가상각비자동기표방법등록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("arc210ukrServiceImpl.selectList", param);
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
		
		for(Map param : paramList )	{
		    List<Map> saveCheck = (List<Map>) super.commonDao.list("arc210ukrServiceImpl.beforeCheckSave", param);
            
	        if(saveCheck != null && saveCheck.size() > 0){
	            if(saveCheck.get(0).get("CLOSE_FG").equals("Y")){
	                throw new  UniDirectValidateException(this.getMessage("54100", user));    //[54100] 이미 마감된 자료 입니다.
	            }
	        }
			try {
			    super.commonDao.update("arc210ukrServiceImpl.insertDetail", param);
    		}catch(Exception e){
    			throw new  UniDirectValidateException(this.getMessage("2627", user));
    		}
		}
		return;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{
		    List<Map> saveCheck = (List<Map>) super.commonDao.list("arc210ukrServiceImpl.beforeCheckSave", param);
            
            if(saveCheck != null && saveCheck.size() > 0){
                if(saveCheck.get(0).get("CLOSE_FG").equals("Y")){
                    throw new  UniDirectValidateException(this.getMessage("54100", user));    //[54100] 이미 마감된 자료 입니다.
                }
            }
			super.commonDao.insert("arc210ukrServiceImpl.updateDetail", param);
		}
		 return;
	} 
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{
		     List<Map> saveCheck = (List<Map>) super.commonDao.list("arc210ukrServiceImpl.beforeCheckSave", param);
             
             if(saveCheck != null && saveCheck.size() > 0){
                 if(saveCheck.get(0).get("CLOSE_FG").equals("Y")){
                     throw new  UniDirectValidateException(this.getMessage("54100", user));    //[54100] 이미 마감된 자료 입니다.
                 }
             }
			 try {
				 super.commonDao.delete("arc210ukrServiceImpl.deleteDetail", param);
			 }catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
	    	}	
		 }
		 return;
	}
	
	
	
}
