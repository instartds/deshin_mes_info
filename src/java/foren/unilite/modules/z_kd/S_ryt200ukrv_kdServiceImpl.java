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


@Service("s_ryt200ukrv_kdService")
public class S_ryt200ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
    
        @Resource(name = "tlabMenuService")
         TlabMenuService tlabMenuService;
        /**
         *  조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList(Map param) throws Exception {
            return super.commonDao.list("s_ryt200ukrv_kdService.selectList", param);
        }
        
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 검색팝업창 조회
        public List<Map<String, Object>> selectList2(Map param) throws Exception {
            return super.commonDao.list("s_ryt200ukrv_kdService.selectList2", param);
        }
        
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 내역생성(데이터 있으면 지움)
        public List<Map<String, Object>> beforeSaveDelete(Map param) throws Exception {
            return super.commonDao.list("s_ryt200ukrv_kdService.beforeSaveDelete", param);
        }
        
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 내역생성 조회
        public List<Map<String, Object>> selectList3(Map param) throws Exception {
            return super.commonDao.list("s_ryt200ukrv_kdService.selectList3", param);
        }
        
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 마스터정보 조회
        public List<Map<String, Object>> selectMasterData(Map param) throws Exception {
            return super.commonDao.list("s_ryt200ukrv_kdService.selectMasterData", param);
        }
        
        
        
        
        
        
        /* 마스터 저장 */
        @ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "base")
        public ExtDirectFormPostResult syncMaster(S_ryt200ukrv_kdModel param, LoginVO user,  BindingResult result) throws Exception {
            param.setS_COMP_CODE(user.getCompCode());
            param.setS_USER_ID(user.getUserID());
            String saveMasterCheck = (String)super.commonDao.select("s_ryt200ukrv_kdService.saveMasterCheck", param);
            if(ObjUtils.isEmpty(saveMasterCheck)) {
                super.commonDao.update("s_ryt200ukrv_kdService.insertMaster", param);
                ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
                return extResult;
            } else {
                super.commonDao.update("s_ryt200ukrv_kdService.updateMaster", param);
                ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
                return extResult;
            }   
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
        public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
            logger.debug("[saveAll] paramMaster:" + paramMaster);
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
            if(paramList != null)  {
                   List<Map> insertList = null;
                   List<Map> updateList = null;
                   List<Map> deleteList = null;
                   for(Map dataListMap: paramList) {
                       if(dataListMap.get("method").equals("deleteDetail")) {
                           deleteList = (List<Map>)dataListMap.get("data");
                       } else if(dataListMap.get("method").equals("updateDetail")) {
                           updateList = (List<Map>)dataListMap.get("data");    
                       } else if(dataListMap.get("method").equals("insertDetail")) {
                           insertList = (List<Map>)dataListMap.get("data");    
                       } 
                   }           
                   if(deleteList != null) this.deleteDetail(deleteList, user);
                   if(updateList != null) this.updateDetail(updateList, user); 
                   if(insertList != null) this.insertDetail(insertList, user);             
               }
               paramList.add(0, paramMaster);
                   
               return  paramList;
       }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
        public Integer insertDetail(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param : paramList ) {
                super.commonDao.update("s_ryt200ukrv_kdService.insertDetail", param);
            }      
            return 0;
        } 
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_ryt200ukrv_kdService.updateDetail", param);
            }
            return 0;
        }
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
        public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_ryt200ukrv_kdService.deleteDetail", param);
                String pCustomCode = (String)super.commonDao.select("s_ryt200ukrv_kdService.beforeDeleteCheck", param);
                if(ObjUtils.isEmpty(pCustomCode)) {
                    super.commonDao.delete("s_ryt200ukrv_kdService.deleteMaster", param);
                } else {
                    
                }
            }
            return 0;
        } 
}
