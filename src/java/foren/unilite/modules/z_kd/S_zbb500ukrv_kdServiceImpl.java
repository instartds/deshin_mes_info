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


@Service("s_zbb500ukrv_kdService")
public class S_zbb500ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
    
        Map specNum = new HashMap();
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
            return super.commonDao.list("s_zbb500ukrv_kdService.selectList", param);
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
            specNum = null;
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
            if(!ObjUtils.isEmpty(specNum)){
                dataMaster.put("SPEC_NUM", specNum.get("SPEC_NUM"));           
            }
            
            paramList.add(0, paramMaster);
                    
            return  paramList;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
        public List<Map> insertList(List<Map> paramList, LoginVO user, String addFid, String delFid) throws Exception {     
                
            for(Map param :paramList ) {
                specNum = (Map)super.commonDao.select("s_zbb500ukrv_kdService.insertList", param);
                param.put("SPEC_NUM", specNum.get("SPEC_NUM"));
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
                super.commonDao.update("s_zbb500ukrv_kdService.updateList", param);
            }
            return 0;
        } 
        
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
        public Integer deleteList(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                List<Map> delFileList = (List<Map>) super.commonDao.list("s_zbb500ukrv_kdService.getDelFileId", param);
                for(Map fId : delFileList) {
                    param.put("DEL_FIDS", fId.get("FID"));
                    this.deleteBDC101(param);
                    fileMnagerService.deleteFile(user, ObjUtils.getSafeString(fId.get("FID")));
                }
                super.commonDao.update("s_zbb500ukrv_kdService.deleteList", param);
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
            return super.commonDao.list("s_zbb500ukrv_kdService.getFileList", param);
        }
        
        private void insertBDC101(Map param) throws Exception {
             String[] fids =  ObjUtils.getSafeString(param.get("ADD_FIDS")).split(",");      
             for(String fid : fids) {
                 param.put("FID", fid);
                 super.commonDao.insert("s_zbb500ukrv_kdService.insertBDC101", param);
             }
        }
        
        private void deleteBDC101(Map param) throws Exception {
            String[] fids =  ObjUtils.getSafeString(param.get("DEL_FIDS")).split(",");
             for(String fid : fids) {
                 param.put("FID", fid);
                 super.commonDao.update("s_zbb500ukrv_kdService.deleteBDC101", param);
             }
        }
}
