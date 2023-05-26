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


@Service("s_zbb400ukrv_kdService")
public class S_zbb400ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
    
        Map docNum = new HashMap();
        @Resource(name = "fileMnagerService")
        private FileMnagerService fileMnagerService;
        /**
         *  조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList(Map param) throws Exception {
            return super.commonDao.list("s_zbb400ukrv_kdService.selectList", param);
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
            docNum = null;
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            String addFid = dataMaster.get("ADD_FID").toString();
            String delFid = dataMaster.get("DEL_FID").toString();
            if(paramList != null)   {
                List<Map> deleteList = null;
                List<Map> insertList = null;
                List<Map> updateList = null;
                for(Map dataListMap: paramList) {
                    if(dataListMap.get("method").equals("deleteList")) {
                        deleteList = (List<Map>)dataListMap.get("data");
                    }else if(dataListMap.get("method").equals("insertList")) {      
                        insertList = (List<Map>)dataListMap.get("data");
                    } else if(dataListMap.get("method").equals("updateList")) {
                        updateList = (List<Map>)dataListMap.get("data");    
                    } 
                }
                if(deleteList != null) this.deleteList(deleteList, user);
                if(insertList != null) this.insertList(insertList, user, addFid, delFid);
                if(updateList != null) this.updateList(updateList, user, addFid, delFid);   
            }
            if(!ObjUtils.isEmpty(docNum)){
                dataMaster.put("DOC_NUM", docNum.get("DOC_NUM"));           
            }
            
            paramList.add(0, paramMaster);
                    
            return  paramList;
        }
        
        
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
        public List<Map> insertList(List<Map> paramList, LoginVO user, String addFid, String delFid) throws Exception {     
                
            for(Map param :paramList ) {
                docNum = (Map)super.commonDao.select("s_zbb400ukrv_kdService.insertList", param);
                param.put("DOC_NUM", docNum.get("DOC_NUM"));
                param.put("ADD_FIDS", addFid);
//                  fileMnagerService.confirmFile(user, ObjUtils.getSafeString(param.get("ADD_FID")));
                this.insertBDC101(param);
            }
            return paramList;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateList(List<Map> paramList, LoginVO user, String addFid, String delFid) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {  
                param.put("ADD_FIDS", addFid);
                param.put("DEL_FIDS", delFid);
                this.deleteBDC101(param);
                fileMnagerService.deleteFile(user, ObjUtils.getSafeString(param.get("DEL_FIDS")));
                this.insertBDC101(param);
                super.commonDao.update("s_zbb400ukrv_kdService.updateList", param);
            }
            return 0;
        } 
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
        public Integer deleteList(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                List<Map> delFileList = (List<Map>) super.commonDao.list("s_zbb400ukrv_kdService.getDelFileId", param);
                for(Map fId : delFileList) {
                    param.put("DEL_FIDS", fId.get("FID"));
                    this.deleteBDC101(param);
                    fileMnagerService.deleteFile(user, ObjUtils.getSafeString(fId.get("FID")));
                }
                super.commonDao.update("s_zbb400ukrv_kdService.deleteList", param);
            }
            return 0;
        } 
        
        
        
        
        
        /**
         * 파일업로드 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @SuppressWarnings("unchecked")
        @ExtDirectMethod(group = "jim")
        public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception {
            param.put("S_COMP_CODE", login.getCompCode());
            return super.commonDao.list("s_zbb400ukrv_kdService.getFileList", param);
        }
        
        private void insertBDC101(Map param) throws Exception {
             String[] fids =  ObjUtils.getSafeString(param.get("ADD_FIDS")).split(",");      
             for(String fid : fids) {
                 param.put("FID", fid);
                 super.commonDao.insert("s_zbb400ukrv_kdService.insertBDC101", param);
             }
        }
        
        private void deleteBDC101(Map param) throws Exception {
            String[] fids =  ObjUtils.getSafeString(param.get("DEL_FIDS")).split(",");
             for(String fid : fids) {
                 param.put("FID", fid);
                 super.commonDao.update("s_zbb400ukrv_kdService.deleteBDC101", param);
             }
        }
        
//        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
//        public Integer insertList(List<Map> paramList, LoginVO user) throws Exception {
//            Map compCodeMap = new HashMap();
//            for(Map param :paramList ) {
//                String docNum = (String) param.get("DOC_NUM");
//                
////                param.put("COMP_CODE", user.getCompCode());            
////                param.put("DIV_CODE", param.get("DIV_CODE"));
////                param.put("DOC_NUM", param.get("DOC_NUM"));
////                param.put("DOC_KIND", param.get("DOC_KIND"));
////                param.put("WORK_DATE", param.get("WORK_DATE"));
////                param.put("REV_NUM", param.get("REV_NUM"));
//
//                super.commonDao.queryForObject("s_zbb400ukrv_kdService.spAutoNum", param);
//                docNum = ObjUtils.getSafeString(param.get("KEY_NUMBER"));    
//                
//                param.put("DOC_NUM", docNum);   
//                super.commonDao.update("s_zbb400ukrv_kdService.insertList", param);
//            }
//            return 0;
////        } 
//        
//        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
//        public Integer updateList(List<Map> paramList, LoginVO user) throws Exception {
//            Map compCodeMap = new HashMap();
//            for(Map param :paramList ) {   
//                super.commonDao.update("s_zbb400ukrv_kdService.updateList", param);
//            }
//            return 0;
//        } 
//        
//        
//        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
//        public Integer deleteList(List<Map> paramList,  LoginVO user) throws Exception {
//            Map compCodeMap = new HashMap();
//            for(Map param :paramList ) {   
//                super.commonDao.update("s_zbb400ukrv_kdService.deleteList", param);
//            }
//            return 0;
//        } 
}
