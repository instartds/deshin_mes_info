package foren.unilite.modules.z_kd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
@Service("s_tix900ukrv_kdService")
public class S_tix900ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "trade")
	public Object selectFormMaster(Map param) throws Exception {
		return  super.commonDao.select("s_tix900ukrv_kdServiceImpl.selectFormMaster", param);
	}
	
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList(Map param) throws Exception {
        return super.commonDao.list("s_tix900ukrv_kdServiceImpl.selectList", param);
    }
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
    public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
        
        if(paramList != null)  {
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
    
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")     // INSERT
   public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {      
       for(Map param : paramList ) {            
           super.commonDao.update("s_tix900ukrv_kdServiceImpl.insertDetail", param);
       }   
       return 0;
   }   
   
   @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
   public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList ) {   
            super.commonDao.update("s_tix900ukrv_kdServiceImpl.updateDetail", param);
        }
        return 0;
   } 
   
   
   @ExtDirectMethod(group = "base", needsModificatinAuth = true)       // DELETE
   public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
        for(Map param :paramList ) {   
            super.commonDao.update("s_tix900ukrv_kdServiceImpl.deleteDetail", param);
        }
        return 0;
   } 
	
}
