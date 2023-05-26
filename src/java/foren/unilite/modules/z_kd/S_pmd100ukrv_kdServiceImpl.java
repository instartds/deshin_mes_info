package foren.unilite.modules.z_kd;

import java.util.ArrayList;
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


@Service("s_pmd100ukrv_kdService")
public class S_pmd100ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger    logger  = LoggerFactory.getLogger(this.getClass());
        
        @Resource(name = "fileMnagerService")
        private FileMnagerService fileMnagerService;
    
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
            return super.commonDao.list("s_pmd100ukrv_kdService.selectList", param);
        }
        
        /**
         *  조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // spare 조회
        public List<Map<String, Object>> selectSpareList(Map param) throws Exception {
            return super.commonDao.list("s_pmd100ukrv_kdService.selectSpareList", param);
        }
        
        /**
         *  금형코드 입력시 품번,차종 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 금형코드 입력시 품번,차종 SELECT
        public List<Map<String, Object>> selectOemCodeCarType(Map param) throws Exception {
            return super.commonDao.list("s_pmd100ukrv_kdService.selectOemCodeCarType", param);
        }
        
        /**
         *  금형코드 입력시 품번,차종 조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 금형코드 입력시 금형명 SELECT
        public List<Map<String, Object>> selectMoldName(Map param) throws Exception {
            return super.commonDao.list("s_pmd100ukrv_kdService.selectMoldName", param);
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
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_pmd100ukrv_kdService.insertDetail", param);

                if (!ObjUtils.isEmpty(param.get("IMAGE_FID"))) {
                    fileMnagerService.confirmFile(user,
                            ObjUtils.getSafeString(param.get("IMAGE_FID")));
                    // }
                }
            }
            return 0;
        } 
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_pmd100ukrv_kdService.updateDetail", param);
                
                if (!ObjUtils.isEmpty(param.get("IMAGE_FID"))) {
                    fileMnagerService.confirmFile(user,
                            ObjUtils.getSafeString(param.get("IMAGE_FID")));
                    // }
                }
            }
            return 0;
        } 
        
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
        public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_pmd100ukrv_kdService.deleteDetail", param);

                if (!ObjUtils.isEmpty(param.get("IMAGE_FID"))) {
                    fileMnagerService.confirmFile(user,
                            ObjUtils.getSafeString(param.get("IMAGE_FID")));
                    // }
                }
            }
            return 0;
        } 
        
        /**
         *  SPARE 저장
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
        public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
            
            if(paramList != null)  {
                   List<Map> insertList = null;
                   List<Map> updateList = null;
                   List<Map> deleteList = null;
                   for(Map dataListMap: paramList) {
                       if(dataListMap.get("method").equals("deleteDetail2")) {
                           deleteList = (List<Map>)dataListMap.get("data");
                       } else if(dataListMap.get("method").equals("updateDetail2")) {
                           updateList = (List<Map>)dataListMap.get("data");    
                       } else if(dataListMap.get("method").equals("insertDetail2")) {
                           insertList = (List<Map>)dataListMap.get("data");    
                       } 
                   }           
                   if(deleteList != null) this.deleteDetail2(deleteList, user);
                   if(updateList != null) this.updateDetail2(updateList, user); 
                   if(insertList != null) this.insertDetail2(insertList, user);             
               }
               paramList.add(0, paramMaster);
                   
               return  paramList;
       }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
        public Integer insertDetail2(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_pmd100ukrv_kdService.insertDetail2", param);
            }
            return 0;
        } 
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_pmd100ukrv_kdService.updateDetail2", param);
            }
            return 0;
        } 
        
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
        public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_pmd100ukrv_kdService.deleteDetail2", param);
            }
            return 0;
        }
}
