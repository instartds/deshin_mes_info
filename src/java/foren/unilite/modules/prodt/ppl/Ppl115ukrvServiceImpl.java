package foren.unilite.modules.prodt.ppl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("ppl115ukrvService")
public class Ppl115ukrvServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
    
    	/**
         * 메인 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectMaster(Map param) throws Exception {
            return super.commonDao.list("ppl115ukrvService.selectMaster", param);
        }
    	/**
         * sub1 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectSub1(Map param) throws Exception {
            return super.commonDao.list("ppl115ukrvService.selectSub1", param);
        }	
        /**
         * sub2 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 소요자재 조회
        public List<Map<String, Object>> selectSubList(Map param) throws Exception {
            return super.commonDao.list("ppl115ukrvService.selectSubList", param);
        }
    	
        /**
         * 메인 저장
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
        public List<Map> saveAllMaster(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
  
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
            dataMaster.put("COMP_CODE", user.getCompCode());
          
            if(paramList != null)  {
//               List<Map> insertList = null;
               List<Map> updateList = null;
//               List<Map> deleteList = null;
               for(Map dataListMap: paramList) {
            	   
            	   if(dataListMap.get("method").equals("updateMaster")) {
	                   updateList = (List<Map>)dataListMap.get("data");    
	               }
            	   
                /*   if(dataListMap.get("method").equals("deleteMaster")) {
                       deleteList = (List<Map>)dataListMap.get("data");
                   } else if(dataListMap.get("method").equals("updateMaster")) {
                       updateList = (List<Map>)dataListMap.get("data");    
                   } else if(dataListMap.get("method").equals("insertMaster")) {
                       insertList = (List<Map>)dataListMap.get("data");    
                   } */
               }           
//               if(deleteList != null) this.deleteMaster(deleteList, user);
               if(updateList != null) this.updateMaster(updateList, user); 
//               if(insertList != null) this.insertMaster(insertList, user);             
           }
        
           paramList.add(0, paramMaster);
               
           return  paramList;
       }
        
/*        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
        public void insertMaster(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
            	param.put("EQU_CODE", ObjUtils.getSafeString(param.get("EQU_CODE_1")).toUpperCase()+ "-" + ObjUtils.getSafeString(param.get("EQU_CODE_2")));
            	param.put("EQU_SIZE_W", ObjUtils.nvl(param.get("EQU_SIZE_W"),'0'));
            	param.put("EQU_SIZE_L", ObjUtils.nvl(param.get("EQU_SIZE_L"),'0'));
            	param.put("EQU_SIZE_H", ObjUtils.nvl(param.get("EQU_SIZE_H"),'0'));
            	param.put("PRODT_O", ObjUtils.nvl(param.get("PRODT_O"),'0'));
            	param.put("WORK_Q", ObjUtils.nvl(param.get("WORK_Q"),'0'));

            	
                super.commonDao.update("ppl115ukrvService.insertMaster", param);
            }
            return ;
        }*/
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
        public void updateMaster(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
            
                super.commonDao.update("ppl115ukrvService.updateMaster", param);
            }
            return ;
        }
/*        
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
        public void deleteMaster(List<Map> paramList,  LoginVO user) throws Exception {
            for(Map param :paramList ) {
               super.commonDao.update("ppl115ukrvService.deleteMaster", param);
            }
            return ;
        }*/
    	
    	
}
