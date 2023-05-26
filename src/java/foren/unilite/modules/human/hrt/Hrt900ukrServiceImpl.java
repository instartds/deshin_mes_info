package foren.unilite.modules.human.hrt;

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

@Service("hrt900ukrService")
public class Hrt900ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	/**
	 * 퇴직연금관리 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hrt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList1(Map param) throws Exception {
        return super.commonDao.list("hrt900ukrServiceImpl.selectList1", param);
    }
	
	@ExtDirectMethod(group = "hrt", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectList2(Map param) throws Exception {
        return super.commonDao.list("hrt900ukrServiceImpl.selectList2", param);
    }
	


	/**저장**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hrt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        
        if(paramList != null)   {
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
    
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
    public void insertDetail(List<Map> paramList, LoginVO user) throws Exception {       	
    	
        for(Map param : paramList ) {
        	           	
            super.commonDao.insert("hrt900ukrServiceImpl.insertDetail", param);
        }   
        return;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
    public void updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList )  {
            
            super.commonDao.update("hrt900ukrServiceImpl.updateDetail", param);
        }
         return;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
    public void deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
         for(Map param :paramList ) {

             super.commonDao.delete("hrt900ukrServiceImpl.deleteDetail", param);
         }
         return;
    }
    
}
