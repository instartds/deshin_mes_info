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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.prodt.pmp.Pmp160ukrvModel;


@Service("s_pbs071ukrv_kdService")
public class S_pbs071ukrv_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
    public List<Map<String, Object>>  selectList(Map param) throws Exception {
    
        return  super.commonDao.list("s_pbs071ukrv_kdService.selectList", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
    public List<Map<String, Object>>  selectList2(Map param) throws Exception {
    
        return  super.commonDao.list("s_pbs071ukrv_kdService.selectList2", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
    public List<Map<String, Object>>  selectList3(Map param) throws Exception {
    
        return  super.commonDao.list("s_pbs071ukrv_kdService.selectList3", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
    public List<Map<String, Object>>  selectCopyProgWorkShopCode(Map param) throws Exception {
    
        return  super.commonDao.list("s_pbs071ukrv_kdService.selectCopyProgWorkShopCode", param);
    }
    
    
    
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        logger.debug("[saveAll] paramDetail:" + paramList);
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        Map<String, Object> spParam = new HashMap<String, Object>();
        SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
        Date dateGet = new Date ();
        String dateGetString = dateFormat.format(dateGet);
        
        List<Map> dataList = new ArrayList<Map>();
        for(Map paramData: paramList) {   
            dataList = (List<Map>) paramData.get("data");
            String oprFlag = "N";
            if(paramData.get("method").equals("insertDetail")) oprFlag="N";
            if(paramData.get("method").equals("updateDetail")) oprFlag="U";
            if(paramData.get("method").equals("deleteDetail")) oprFlag="D";
       
            for(Map param:  dataList) {
                param.put("NUD_FLAG", oprFlag);
                param.put("USER_ID", user.getUserID()); 
                param.put("COMP_CODE", user.getCompCode()); 
                super.commonDao.update("s_pbs071ukrv_kdService.spReceiving", param);
            }
        }
        String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
        if(!ObjUtils.isEmpty(errorDesc)) {
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
        } 
        
        paramList.add(0, paramMaster);
        return  paramList;
   }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")     // INSERT
    public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {
        return 0;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")      // UPDATE
    public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
        return 0;
    } 
    
    
    @ExtDirectMethod(group = "prodt", needsModificatinAuth = true)                   // DELETE
    public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
        return 0;
    }
    
    
    
    
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {  
        if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteDetail3")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("insertDetail3")) {
                    insertList = (List<Map>)dataListMap.get("data");    
                } else if(dataListMap.get("method").equals("updateDetail3")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                } 
            }           
            if(deleteList != null) this.deleteDetail3(deleteList, user);
            if(insertList != null) this.insertDetail3(insertList, user);
            if(updateList != null) this.updateDetail3(updateList, user);              
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")     // INSERT
    public Integer  insertDetail3(List<Map> paramList, LoginVO user) throws Exception {      
        for(Map param : paramList ) {            
            super.commonDao.update("s_pbs071ukrv_kdService.insertDetail3", param);
       }
        return 0;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")      // UPDATE
    public Integer updateDetail3(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList ) {  
            super.commonDao.update("s_pbs071ukrv_kdService.updateDetail3", param);
        }
        return 0;
    } 
    
    
    @ExtDirectMethod(group = "prodt", needsModificatinAuth = true)                   // DELETE
    public Integer deleteDetail3(List<Map> paramList,  LoginVO user) throws Exception {
        for(Map param :paramList ) {   
            super.commonDao.update("s_pbs071ukrv_kdService.deleteDetail3", param);
        }
        return 0;
    }
    


    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)       // 공정&설비 등록
    public List<Map<String, Object>> selectList4(Map param) throws Exception {
        return super.commonDao.list("s_pbs071ukrv_kdService.selectList4", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {    
        if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteDetail4")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }else if(dataListMap.get("method").equals("insertDetail4")) {        
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateDetail4")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                } 
            }           
            if(deleteList != null) this.deleteDetail4(deleteList, user);
            if(insertList != null) this.insertDetail4(insertList, user);
            if(updateList != null) this.updateDetail4(updateList, user);                
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // INSERT
    public Integer  insertDetail4(List<Map> paramList, LoginVO user) throws Exception {     
        for(Map param : paramList ) {            
            super.commonDao.update("s_pbs071ukrv_kdService.insertDetail4", param);
        }  
        return 0;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
    public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList ) {   
            super.commonDao.update("s_pbs071ukrv_kdService.updateDetail4", param);
        }
        return 0;
    } 
    
    
    @ExtDirectMethod(group = "base", needsModificatinAuth = true)                   // DELETE
    public Integer deleteDetail4(List<Map> paramList,  LoginVO user) throws Exception {
        for(Map param :paramList ) {   
            super.commonDao.update("s_pbs071ukrv_kdService.deleteDetail4", param);
        }
        return 0;
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
    
    @ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)       // 공정&금형 등록
    public List<Map<String, Object>> selectList5(Map param) throws Exception {
        return super.commonDao.list("s_pbs071ukrv_kdService.selectList5", param);
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAll5(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {    
        if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteDetail5")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }else if(dataListMap.get("method").equals("insertDetail5")) {        
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateDetail5")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                } 
            }           
            if(deleteList != null) this.deleteDetail5(deleteList, user);
            if(insertList != null) this.insertDetail5(insertList, user);
            if(updateList != null) this.updateDetail5(updateList, user);                
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // INSERT
    public Integer  insertDetail5(List<Map> paramList, LoginVO user) throws Exception {     
        for(Map param : paramList ) {            
            super.commonDao.update("s_pbs071ukrv_kdService.insertDetail5", param);
        }
        return 0;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")      // UPDATE
    public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {
        for(Map param :paramList ) {   
            super.commonDao.update("s_pbs071ukrv_kdService.updateDetail5", param);
        }
        return 0;
    } 
    
    
    @ExtDirectMethod(group = "base", needsModificatinAuth = true)                   // DELETE
    public Integer deleteDetail5(List<Map> paramList,  LoginVO user) throws Exception {
        for(Map param :paramList ) {   
            super.commonDao.update("s_pbs071ukrv_kdService.deleteDetail5", param);
        }
        return 0;
    }
}
