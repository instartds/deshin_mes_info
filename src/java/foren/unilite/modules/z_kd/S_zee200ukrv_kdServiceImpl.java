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

@Service("s_zee200ukrv_kdService")
public class S_zee200ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
        @Resource(name = "tlabMenuService")
         TlabMenuService tlabMenuService;
        

        /**
         * 상단 그리드 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList(Map param) throws Exception {
            return super.commonDao.list("s_zee200ukrv_kdService.selectList", param);
        }

        /**
         *  하단 그리드 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 이미지 조회
        public List<Map<String, Object>> selectList2(Map param) throws Exception {
            return super.commonDao.list("s_zee200ukrv_kdService.selectList2", param);
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
            dataMaster.put("COMP_CODE", user.getCompCode());
            Map<String, Object> autoSpParam = new HashMap<String, Object>();
//            SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
//            Date dateGet = new Date ();
//            String dateGetString = dateFormat.format(dateGet);
//            String eqDocCode = (String) dataMaster.get("EQDOC_CODE");
//            if (ObjUtils.isEmpty(dataMaster.get("EQDOC_CODE") )) {
//                Map<String, Object> spParam = new HashMap<String, Object>();
//                spParam.put("COMP_CODE",    user.getCompCode());
//                spParam.put("DIV_CODE",     dataMaster.get("DIV_CODE"));
//                spParam.put("TABLE_ID",     "S_ZEE200T_KD");
//                spParam.put("PREFIX",       "");
//                spParam.put("BASIS_DATE",   dateGetString);
//                spParam.put("AUTO_TYPE",    "1");
//
//                super.commonDao.queryForObject("s_zee200ukrv_kdService.spAutoNum", spParam);
//                eqDocCode = ObjUtils.getSafeString(spParam.get("KEY_NUMBER")).substring(2, 10) + "-" + ObjUtils.getSafeString(spParam.get("KEY_NUMBER")).substring(10, 13);
//            } else {
//
//            }

            if(paramList != null) {
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
                   
               return paramList;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
        public List<Map> insertDetail(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
                String eqdocCode = (String) param.get("EQDOC_CODE");
                Map<String, Object> spParam = new HashMap<String, Object>();
                spParam.put("COMP_CODE", user.getCompCode());
                spParam.put("DIV_CODE", param.get("DIV_CODE"));
                spParam.put("TABLE_ID", "S_ZEE200T_KD");
                spParam.put("PREFIX", "");
                spParam.put("BASIS_DATE", param.get("BUY_DATE"));
                spParam.put("AUTO_TYPE", "1");

                String checkEqdocCode = (String)super.commonDao.select("s_zee200ukrv_kdService.checkEqdocCode", param);
                if(ObjUtils.isEmpty(checkEqdocCode)) {
                    super.commonDao.queryForObject("s_zee200ukrv_kdService.spAutoNum", spParam);
                    eqdocCode = ObjUtils.getSafeString(spParam.get("KEY_NUMBER")).substring(2, 10) + "-" + ObjUtils.getSafeString(spParam.get("KEY_NUMBER")).substring(10, 13);
//                    eqdocCode = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
                    param.put("EQDOC_CODE", eqdocCode);
                    
                    super.commonDao.update("s_zee200ukrv_kdService.insertDetail", param);
                } else {
                    throw new UniDirectValidateException("모니터등록번호가 중복되었습니다."+ "\n모니터등록번호 : " + param.get("M_REG_NUM"));
//                    throw new UniDirectValidateException("모니터등록번호가 중복되었습니다.");
                }
            }
            
            return paramList;
        
//            for(Map param : paramList ) {
//                param.put("EQDOC_CODE", eqDocCode);
//                
//                String checkEqdocCode = (String)super.commonDao.select("s_zee200ukrv_kdService.checkEqdocCode", param);
//                if(ObjUtils.isEmpty(checkEqdocCode)) {
//                    super.commonDao.update("s_zee200ukrv_kdService.insertDetail", param);
//                } else {
//                    throw new UniDirectValidateException("모니터등록번호가 중복되었습니다.");
//                }
//                
//            }
//            return 0;
        }

        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {

//                String checkEqdocCode = (String)super.commonDao.select("s_zee200ukrv_kdService.checkEqdocCode", param);
//                if(ObjUtils.isEmpty(checkEqdocCode)) {
                    super.commonDao.update("s_zee200ukrv_kdService.updateDetail", param);
//                } else {
//                    throw new UniDirectValidateException("모니터등록번호가 중복되었습니다."+ "\n모니터등록번호 : " + param.get("M_REG_NUM"));
//                }
            }
            return 0;
        }

        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
        public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_zee200ukrv_kdService.deleteDetail", param);
            }
            return 0;
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
        public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
            logger.debug("[saveAll] paramMaster:" + paramMaster);
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data"); 
            dataMaster.put("COMP_CODE", user.getCompCode());

            if(paramList != null) {
                   List<Map> insertList2 = null;
                   List<Map> updateList2 = null;
                   List<Map> deleteList2 = null;
                   for(Map dataListMap: paramList) {
                       if(dataListMap.get("method").equals("deleteDetail2")) {
                           deleteList2 = (List<Map>)dataListMap.get("data");
                       } else if(dataListMap.get("method").equals("updateDetail2")) {
                           updateList2 = (List<Map>)dataListMap.get("data");    
                       } else if(dataListMap.get("method").equals("insertDetail2")) {
                           insertList2 = (List<Map>)dataListMap.get("data");    
                       }
                   }
                   if(deleteList2 != null) this.deleteDetail2(deleteList2, user);
                   if(updateList2 != null) this.updateDetail2(updateList2, user); 
                   if(insertList2 != null) this.insertDetail2(insertList2, user);
               }
               paramList.add(0, paramMaster);
                   
               return  paramList;
       }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
        public Integer insertDetail2(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param : paramList ) {
                super.commonDao.update("s_zee200ukrv_kdService.insertDetail2", param);
            }      
            return 0;
        } 
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_zee200ukrv_kdService.updateDetail2", param);
            }
            return 0;
        }
        
        @ExtDirectMethod(group = "prodt", needsModificatinAuth = true)                        // DELETE
        public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_zee200ukrv_kdService.deleteDetail2", param);
            }
            return 0;
        }
}