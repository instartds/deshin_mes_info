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


@Service("s_str903ukrv_kdService")
public class S_str903ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
    	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());
    
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
            return super.commonDao.list("s_str903ukrv_kdService.selectList", param);
        }
        
        /**
         * 저장
         * @param paramList
         * @param paramMaster
         * @param user
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
        @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
        public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
            
            if(paramList != null)  {
                   List<Map> updateList = null;
                   for(Map dataListMap: paramList) {
                       if(dataListMap.get("method").equals("updateDetail")) {
                           updateList = (List<Map>)dataListMap.get("data");    
                       } 
                   }           
                   if(updateList != null) this.updateDetail(updateList, user);             
               }
               paramList.add(0, paramMaster);
                   
               return  paramList;
       }
        
       @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
       public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
           Map compCodeMap = new HashMap();
           compCodeMap.put("S_COMP_CODE", user.getCompCode());
            for(Map param :paramList ) {   
                super.commonDao.update("s_str903ukrv_kdService.updateDetail", param);
            }
            return 0;
       }
}
