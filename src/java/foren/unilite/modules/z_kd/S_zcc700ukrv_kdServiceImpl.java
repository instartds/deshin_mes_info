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


@Service("s_zcc700ukrv_kdService")
public class S_zcc700ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
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
            return super.commonDao.list("s_zcc700ukrv_kdService.selectList", param);
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
        public List<Map> insertDetail(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
                String entryNum = (String) param.get("ENTRY_NUM");
                Map<String, Object> spParam = new HashMap<String, Object>();
                spParam.put("COMP_CODE", user.getCompCode());
                spParam.put("DIV_CODE", param.get("DIV_CODE"));
                spParam.put("TABLE_ID", "S_ZCC700T_KD");
                spParam.put("PREFIX", "A");
                spParam.put("BASIS_DATE", param.get("ENTRY_DATE"));
                spParam.put("AUTO_TYPE", "1");

                super.commonDao.queryForObject("s_zcc700ukrv_kdService.spAutoNum", spParam);
                entryNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
                param.put("ENTRY_NUM", entryNum);
                super.commonDao.update("s_zcc700ukrv_kdService.insertDetail", param);
            }
            return paramList;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
            String exists700t = "";
            String exists710t = "";
            String msgAlert   = "";
            String msgAlertYN = "";
            
            Map compCodeMap = new HashMap();
            
            try {
                for(Map param :paramList ) {
                    exists700t = (String) super.commonDao.select("s_zcc700ukrv_kdService.exists700t", param);
                    exists710t = (String) super.commonDao.select("s_zcc700ukrv_kdService.exists710t", param);
                    
                    if(exists700t.equals("Y")){
                        msgAlertYN = "Y";
                        msgAlert = "샘플비미수금정리내역이 존재하여 수정할 수 없습니다."+ "\n관리코드 : " + param.get("ENTRY_NUM");
                        throw new  UniDirectValidateException(msgAlert);
                    }
                    
                    if(exists710t.equals("Y")){
                        msgAlertYN = "Y";
                        msgAlert = "수금내역이 존재하여 수정할 수 없습니다."+ "\n관리코드 : " + param.get("ENTRY_NUM");
                        throw new  UniDirectValidateException(msgAlert);
                    }
    
                    super.commonDao.update("s_zcc700ukrv_kdService.updateDetail", param);
                }
            }
            catch(Exception e){
                if(msgAlertYN == "Y"){
                    throw new  UniDirectValidateException(msgAlert);
                }
                else{
                    throw new  UniDirectValidateException(this.getMessage("0", user));
                }
            }
            return 0;
        }
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
        public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
            String exists700t = "";
            String exists710t = "";
            String msgAlert   = "";
            String msgAlertYN = "";
            
            Map compCodeMap = new HashMap();
            
            try {
                for(Map param :paramList ) {
                    exists700t = (String) super.commonDao.select("s_zcc700ukrv_kdService.exists700t", param);
                    exists710t = (String) super.commonDao.select("s_zcc700ukrv_kdService.exists710t", param);
                    
                    if(exists700t.equals("Y")){
                        msgAlertYN = "Y";
                        msgAlert = "샘플비미수금정리내역이 존재하여 삭제할 수 없습니다."+ "\n관리코드 : " + param.get("ENTRY_NUM");
                        throw new  UniDirectValidateException(msgAlert);
                    }
                    
                    if(exists710t.equals("Y")){
                        msgAlertYN = "Y";
                        msgAlert = "수금내역이 존재하여 삭제할 수 없습니다."+ "\n관리코드 : " + param.get("ENTRY_NUM");
                        throw new  UniDirectValidateException(msgAlert);
                    }
    
                    super.commonDao.update("s_zcc700ukrv_kdService.deleteDetail", param);
                }
            }
            catch(Exception e){
                if(msgAlertYN == "Y"){
                    throw new  UniDirectValidateException(msgAlert);
                }
                else{
                    throw new  UniDirectValidateException(this.getMessage("0", user));
                }
            }
            return 0;
        } 
}
