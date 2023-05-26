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


@Service("s_pmr913ukrv_kdService")
public class S_pmr913ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
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
        @ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList(Map param) throws Exception {
            return super.commonDao.list("s_pmr913ukrv_kdService.selectList", param);
        }
        
        /**
         *  detail 저장
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
        public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
            logger.debug("[saveAll] paramDetail:" + paramList);
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            String inoutNum = (String) dataMaster.get("INOUT_NUM");
            
            Map<String, Object> spParam = new HashMap<String, Object>();
            List<Map> dataList = new ArrayList<Map>();
            for(Map paramData: paramList) {   
                dataList = (List<Map>) paramData.get("data");
                String oprFlag = "N";
                if(paramData.get("method").equals("insertDetail")) oprFlag="N";
                if(paramData.get("method").equals("updateDetail")) oprFlag="U";
                if(paramData.get("method").equals("deleteDetail")) oprFlag="D";
           
                for(Map param:  dataList) {
                    param.put("USER_ID", user.getUserID());    
                    super.commonDao.update("s_pmr913ukrv_kdService.spReceiving", param);
                }
            }
            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
            if(!ObjUtils.isEmpty(errorDesc)){
                String[] messsage = errorDesc.split(";");
                throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
            } else {
                
            }
            paramList.add(0, paramMaster);
            return  paramList;
       }
       
       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // INSERT
       public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
           
           return 0;
       } 
       
       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")          // UPDATE
       public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
           
           return 0;
       } 
       
       
       @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
       public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
           
           return 0;
       }
}
