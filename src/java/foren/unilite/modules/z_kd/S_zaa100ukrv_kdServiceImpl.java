package foren.unilite.modules.z_kd;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bor.Bor100ukrvModel;
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("s_zaa100ukrv_kdService")
public class S_zaa100ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
    
        Map docNum = new HashMap();
        @Resource(name = "fileMnagerService")
        private FileMnagerService fileMnagerService;
        
        /**
         *  조회(검색팝업창)
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectOrderNoMaster(Map param) throws Exception {
            return super.commonDao.list("s_zaa100ukrv_kdService.selectOrderNoMaster", param);
        }
        
        /**
         *  조회1
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList(Map param) throws Exception {
            return super.commonDao.list("s_zaa100ukrv_kdService.selectList", param);
        }
        
        /**
         *  조회2
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList2(Map param) throws Exception {
            return super.commonDao.list("s_zaa100ukrv_kdService.selectList2", param);
        }
        
        
        
        /**
         *  저장
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
        public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
            logger.debug("[saveAll] paramMaster:" + paramMaster);
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
            dataMaster.put("COMP_CODE", user.getCompCode());
            
            if(paramList != null)  {
                List<Map> insertList = null;
                List<Map> updateList = null;
                List<Map> deleteList = null;
                for(Map dataListMap: paramList) {
                    if(dataListMap.get("method").equals("deleteList")) {
                        deleteList = (List<Map>)dataListMap.get("data");
                    } else if(dataListMap.get("method").equals("updateList")) {
                        updateList = (List<Map>)dataListMap.get("data");    
                    } else if(dataListMap.get("method").equals("insertList")) {
                        insertList = (List<Map>)dataListMap.get("data");    
                    } 
                }           
                if(deleteList != null) this.deleteList(deleteList, user);
                if(updateList != null) this.updateList(updateList, user); 
                if(insertList != null) this.insertList(insertList, user);             
            } else {
                
            }
            
            paramList.add(0, paramMaster);
                
            return  paramList;
       }
        
        
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
        public List<Map> insertList(List<Map> paramList, LoginVO user) throws Exception {     
            for(Map param :paramList ) {
                String planNum = (String) param.get("PLAN_NUM");
                Map<String, Object> spParam = new HashMap<String, Object>();
                spParam.put("COMP_CODE", user.getCompCode());            
                spParam.put("DIV_CODE", param.get("DIV_CODE"));
                spParam.put("TABLE_ID","s_zaa100ukrv_kd");
                spParam.put("PREFIX", "A");
                spParam.put("BASIS_DATE", param.get("PLAN_DATE"));
                spParam.put("AUTO_TYPE", "1");

                super.commonDao.queryForObject("s_scl901ukrv_kdService.spAutoNum", spParam);  
                planNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));   
                param.put("PLAN_NUM", planNum);
                super.commonDao.update("s_zaa100ukrv_kdService.insertList", param);
            }
            return paramList;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateList(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {  
                super.commonDao.update("s_zaa100ukrv_kdService.updateList", param);
            }
            return 0;
        } 
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
        public Integer deleteList(List<Map> paramList,  LoginVO user) throws Exception {
            for(Map param :paramList ) {   
                super.commonDao.update("s_zaa100ukrv_kdService.deleteList", param);
            }
            return 0;
        } 
        
        
        
        /**
         *  저장2
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
        public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            if(paramList != null)   {
                List<Map> deleteList2 = null;
                List<Map> insertList2 = null;
                List<Map> updateList2 = null;
                for(Map dataListMap: paramList) {
                    if(dataListMap.get("method").equals("deleteList2")) {
                        deleteList2 = (List<Map>)dataListMap.get("data");
                    }else if(dataListMap.get("method").equals("insertList2")) {      
                        insertList2 = (List<Map>)dataListMap.get("data");
                    } else if(dataListMap.get("method").equals("updateList2")) {
                        updateList2 = (List<Map>)dataListMap.get("data");    
                    } 
                }
                if(deleteList2 != null) this.deleteList2(deleteList2, user);
                if(insertList2 != null) this.insertList2(insertList2, user);
                if(updateList2 != null) this.updateList2(updateList2, user);   
            }
            paramList.add(0, paramMaster);
                    
            return  paramList;
        }
        
        
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT2
        public List<Map> insertList2(List<Map> paramList, LoginVO user) throws Exception {     
            for(Map param :paramList ) {
                super.commonDao.update("s_zaa100ukrv_kdService.insertList2", param);     
            }
            return paramList;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE2
        public Integer updateList2(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {  
                super.commonDao.update("s_zaa100ukrv_kdService.updateList2", param);
            }
            return 0;
        } 
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE2
        public Integer deleteList2(List<Map> paramList,  LoginVO user) throws Exception {
            for(Map param :paramList ) {   
                super.commonDao.update("s_zaa100ukrv_kdService.deleteList2", param);
            }
            return 0;
        } 
}
