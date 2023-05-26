package foren.unilite.modules.z_kd;

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


@Service("s_zcc610ukrv_kdService")
public class S_zcc610ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
        
        /**
         *  메인그리드 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectDetail(Map param) throws Exception {
            return super.commonDao.list("s_zcc610ukrv_kdService.selectDetail", param);
        }
        
        /**
         *  수금등록 그리드 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectSubDetail(Map param) throws Exception {
            return super.commonDao.list("s_zcc610ukrv_kdService.selectSubDetail", param);
        }
    
        /**
         * 저장
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_kd")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
        public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
  
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
            dataMaster.put("COMP_CODE", user.getCompCode());

            if(paramList != null)  {
               List<Map> insertList = null;
               List<Map> updateList = null;
               List<Map> deleteList = null;
               for(Map dataListMap: paramList) {
                   if(dataListMap.get("method").equals("updateDetail")) {
                       updateList = (List<Map>)dataListMap.get("data");    
                   }
               }
               if(updateList != null) this.updateDetail(updateList, user, dataMaster); 
  
           }
        
           paramList.add(0, paramMaster);
               
           return  paramList;
       }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")                                             // UPDATE
        public void updateDetail(List<Map> paramList, LoginVO user, Map<String, Object> dataMaster) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {  
                super.commonDao.update("s_zcc610ukrv_kdService.updateList", param);
            }
            
            return ;
        }
        
        /**
         * 저장
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_kd")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
        public List<Map> saveSubAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
  
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
            dataMaster.put("COMP_CODE", user.getCompCode());
          
            if(paramList != null)  {
               List<Map> insertList = null;
               List<Map> updateList = null;
               List<Map> deleteList = null;
               for(Map dataListMap: paramList) {
                   if(dataListMap.get("method").equals("deleteSubDetail")) {
                       deleteList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("updateSubDetail")) {
                       updateList = (List<Map>)dataListMap.get("data");    
                   } else if(dataListMap.get("method").equals("insertSubDetail")) {
                       insertList = (List<Map>)dataListMap.get("data");    
                   } 
               }           
               if(deleteList != null) this.deleteSubDetail(deleteList, user);
               if(updateList != null) this.updateSubDetail(updateList, user); 
               if(insertList != null) this.insertSubDetail(insertList, user);             
           }
        
           paramList.add(0, paramMaster);
               
           return  paramList;
       }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")
        public void insertSubDetail(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
                super.commonDao.update("s_zcc610ukrv_kdService.insertSubList", param);
            }
            return ;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")
        public void updateSubDetail(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
                super.commonDao.update("s_zcc610ukrv_kdService.updateSubList", param);
            }
            return ;
        } 
        
        @ExtDirectMethod(group = "z_kd", value = ExtDirectMethodType.STORE_MODIFY)
        public void deleteSubDetail(List<Map> paramList,  LoginVO user) throws Exception {
            for(Map param :paramList ) {
               super.commonDao.update("s_zcc610ukrv_kdService.deleteSubList", param);
            }
            return ;
        } 
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_kd")
    	public Map closeYnUpdate(Map param, LoginVO user) throws Exception {
        	
            super.commonDao.update("s_zcc610ukrv_kdService.closeYnUpdate", param);
            
    		return param;
    	}
        
}
