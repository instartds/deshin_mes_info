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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bor.Bor100ukrvModel;


@Service("s_zee300ukrv_kdService")
public class S_zee300ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
        private final Logger logger = LoggerFactory.getLogger(this.getClass());
        Map oeqCode = new HashMap();
        @Resource(name = "tlabMenuService")
         TlabMenuService tlabMenuService;
        
        
    	/**
    	 * 비품구분2
    	 * @param param(S_COMP_CODE)
    	 * @return
    	 * @throws Exception
    	 */
    	public List<ComboItemModel> getQeqGubun2(Map param) throws Exception {
    		return (List<ComboItemModel>) super.commonDao.list("s_zee300ukrv_kdService.getQeqGubun2", param);

    	}
    	/**
    	 * 비품구분3
    	 * @param param(S_COMP_CODE)
    	 * @return
    	 * @throws Exception
    	 */
    	public List<ComboItemModel> getQeqGubun3(Map param) throws Exception {
    		return (List<ComboItemModel>) super.commonDao.list("s_zee300ukrv_kdService.getQeqGubun3", param);

    	}
        /**
         *  조회
         * 
         * @param param
         * @return
         * @throws Exception
         */
        @ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)      // 조회
        public List<Map<String, Object>> selectList(Map param) throws Exception {
            return super.commonDao.list("s_zee300ukrv_kdService.selectList", param);
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
            oeqCode = null;
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
                if(!ObjUtils.isEmpty(oeqCode)){
                    dataMaster.put("OEQ_CODE", oeqCode.get("OEQ_CODE"));           
                }
               paramList.add(0, paramMaster);

               return  paramList;
       }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // INSERT
        public List<Map> insertDetail(List<Map> paramList, LoginVO user) throws Exception {
            for(Map param :paramList ) {
                oeqCode = (Map)super.commonDao.select("s_zee300ukrv_kdService.insertDetail", param);
                param.put("OEQ_CODE", oeqCode.get("OEQ_CODE"));
            }
            
            return paramList;
        
//            return 0;
        }
        
        @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")          // UPDATE
        public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {
                super.commonDao.update("s_zee300ukrv_kdService.updateDetail", param);
            }
            return 0;
        } 
        
        
        @ExtDirectMethod(group = "base", needsModificatinAuth = true)                        // DELETE
        public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
            Map compCodeMap = new HashMap();
            for(Map param :paramList ) {   
                super.commonDao.update("s_zee300ukrv_kdService.deleteDetail", param);
            }
            return 0;
        }
}
