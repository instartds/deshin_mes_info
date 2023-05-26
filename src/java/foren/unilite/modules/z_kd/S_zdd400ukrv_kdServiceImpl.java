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
import foren.unilite.modules.com.fileman.FileMnagerService;


@Service("s_zdd400ukrv_kdService")
public class S_zdd400ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
    
        Map reqNum = new HashMap();
        @Resource(name = "fileMnagerService")
        private FileMnagerService fileMnagerService;
        
        /**
         *  의뢰번호 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectReqNum(Map param) throws Exception {
            return super.commonDao.list("s_zdd400ukrv_kdService.selectReqNum", param);
        }

        /**
         *  조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectList(Map param) throws Exception {
            return super.commonDao.list("s_zdd400ukrv_kdService.selectList", param);
        }
        
        /**
         * 
         * 사원의 해당부서 조회
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
        public List<Map<String, Object>> selectPersonDept(Map param) throws Exception {
            return super.commonDao.list("s_zdd400ukrv_kdService.selectPersonDept", param);
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
            reqNum = null;
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            String addFid = dataMaster.get("ADD_FID").toString();
            String delFid = dataMaster.get("DEL_FID").toString();
            if(paramList != null)   {
                List<Map> updateList = null;
                for(Map dataListMap: paramList) {
                    if(dataListMap.get("method").equals("updateList")) {
                        updateList = (List<Map>)dataListMap.get("data");    
                    } 
                }
                if(updateList != null) this.updateList(updateList, user, addFid, delFid);
            }
            
            paramList.add(0, paramMaster);
                    
            return  paramList;
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
                super.commonDao.update("s_zdd400ukrv_kdService.updateList", param);
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
            return super.commonDao.list("s_zdd400ukrv_kdService.getFileList", param);
        }
        
        private void insertBDC101(Map param) throws Exception {
             String[] fids =  ObjUtils.getSafeString(param.get("ADD_FIDS")).split(",");      
             for(String fid : fids) {
                 param.put("FID", fid);
                 super.commonDao.insert("s_zdd400ukrv_kdService.insertBDC101", param);
                 super.commonDao.update("s_zdd400ukrv_kdService.updateList", param);
             }
        }
        
        private void deleteBDC101(Map param) throws Exception {
            String[] fids =  ObjUtils.getSafeString(param.get("DEL_FIDS")).split(",");
             for(String fid : fids) {
                 param.put("FID", fid);
                 super.commonDao.update("s_zdd400ukrv_kdService.deleteBDC101", param);
                 super.commonDao.update("s_zdd400ukrv_kdService.updateList", param);
             }
        }
}
