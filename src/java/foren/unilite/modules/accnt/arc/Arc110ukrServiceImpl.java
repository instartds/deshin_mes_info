package foren.unilite.modules.accnt.arc;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service( "arc110ukrService" )
public class Arc110ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 채권접수 조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("arc110ukrServiceImpl.selectList", param);
    }
    
    /** 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertDetail")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteDetail(deleteList, user);
            if (insertList != null) this.insertDetail(insertList, user);
            if (updateList != null) this.updateDetail(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void insertDetail( List<Map> paramList, LoginVO user ) throws Exception {
        
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void updateDetail( List<Map> paramList, LoginVO user ) throws Exception {
        for (Map param : paramList) {
            if(param.get("ACCEPT_STATUS").equals("1")) {
                
                param.put("ACCEPT_STATUS", '2');
                super.commonDao.update("arc110ukrServiceImpl.updateDetail", param);
            }else if(param.get("ACCEPT_STATUS").equals("2")){
                
                param.put("ACCEPT_STATUS", '1');
                super.commonDao.update("arc110ukrServiceImpl.updateDetail", param);
            }
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void deleteDetail( List<Map> paramList, LoginVO user ) throws Exception {
        
        return;
    }
    
    
    /** 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveDeadlineAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteDeadlineDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertDeadlineDetail")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateDeadlineDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteDeadlineDetail(deleteList, user);
            if (insertList != null) this.insertDeadlineDetail(insertList, user, paramMaster);
            if (updateList != null) this.updateDeadlineDetail(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void insertDeadlineDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        try {
            Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
            
            for (Map param : paramList) {
                
                if (param.get("ACCEPT_STATUS").equals("1")) {
                    param.put("CANCEL_REASON", dataMaster.get("CANCEL_REASON"));
                    super.commonDao.update("arc110ukrServiceImpl.updateDeadline", param);
                }
                
            }
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void updateDeadlineDetail( List<Map> paramList, LoginVO user ) throws Exception {
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void deleteDeadlineDetail( List<Map> paramList, LoginVO user ) throws Exception {
        return;
    }
    
    /** 저장 **/
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt" )
    @Transactional( propagation = Propagation.REQUIRED, rollbackFor = { Exception.class } )
    public List<Map> saveRequestAll( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
        
        if (paramList != null) {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for (Map dataListMap : paramList) {
                if (dataListMap.get("method").equals("deleteRequestDetail")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("insertRequestDetail")) {
                    insertList = (List<Map>)dataListMap.get("data");
                } else if (dataListMap.get("method").equals("updateRequestDetail")) {
                    updateList = (List<Map>)dataListMap.get("data");
                }
            }
            if (deleteList != null) this.deleteRequestDetail(deleteList, user);
            if (insertList != null) this.insertRequestDetail(insertList, user, paramMaster);
            if (updateList != null) this.updateRequestDetail(updateList, user);
        }
        paramList.add(0, paramMaster);
        
        return paramList;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void insertRequestDetail( List<Map> paramList, LoginVO user, Map paramMaster ) throws Exception {
        try {
            Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
            Map<String, Object> spParam = new HashMap<String, Object>();
            
            Map<String, Object> saveParam = new HashMap<String, Object>();
            
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
            Date dateGet = new Date();
            String dateGetString = dateFormat.format(dateGet);
            
            spParam.put("COMP_CODE", user.getCompCode());
            
            spParam.put("DIV_CODE", user.getDivCode());
            spParam.put("TABLE_ID", "T_GWIF");
            spParam.put("PREFIX", "A");
            spParam.put("BASIS_DATE", dateGetString);
            spParam.put("AUTO_TYPE", "1");
            
            super.commonDao.queryForObject("arc110ukrServiceImpl.spAutoNum", spParam);
            
            dataMaster.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
            
            for (Map param : paramList) {
                
                List<Map> fnCheckQ = (List<Map>)super.commonDao.list("arc110ukrServiceImpl.fnCheckQ", param);
                if (fnCheckQ.size() > 0) {
                    if (!fnCheckQ.get(0).get("GW_STATUS").equals("0")) {
                        throw new Exception("이미상신된 데이터가 있으므로 결재요청을 할 수 없습니다.");
                    } else {
                        super.commonDao.delete("arc110ukrServiceImpl.deleteT_GWIF", param);
                        
                        param.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
                        super.commonDao.update("arc110ukrServiceImpl.updateAutoNum", param);
                    }
                    
                } else {
                    param.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
                    super.commonDao.update("arc110ukrServiceImpl.updateAutoNum", param);
                    
                }
            }
            
            saveParam.put("S_COMP_CODE", user.getCompCode());
            saveParam.put("S_USER_ID", user.getUserID());
            saveParam.put("KEY_NUMBER", ObjUtils.getSafeString(spParam.get("KEY_NUMBER")));
            super.commonDao.update("arc110ukrServiceImpl.insertT_GWIF", saveParam);
            
        } catch (Exception e) {
            throw new UniDirectValidateException(this.getMessage("2627", user));
        }
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void updateRequestDetail( List<Map> paramList, LoginVO user ) throws Exception {
        return;
    }
    
    @ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "accnt" )
    public void deleteRequestDetail( List<Map> paramList, LoginVO user ) throws Exception {
        return;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**
     * 접수,미접수,접수마감, 버튼 관련
     * **/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAllButton(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        
        if(paramList != null)   {
            List<Map> insertList = null;
            List<Map> updateList = null;
            List<Map> deleteList = null;
            for(Map dataListMap: paramList) {
                if(dataListMap.get("method").equals("deleteDetailButton")) {
                    deleteList = (List<Map>)dataListMap.get("data");
                }else if(dataListMap.get("method").equals("insertDetailButton")) {      
                    insertList = (List<Map>)dataListMap.get("data");
                } else if(dataListMap.get("method").equals("updateDetailButton")) {
                    updateList = (List<Map>)dataListMap.get("data");    
                } 
            }           
            if(deleteList != null) this.deleteDetailButton(deleteList, user);
            if(insertList != null) this.insertDetailButton(insertList, user, paramMaster);
            if(updateList != null) this.updateDetailButton(updateList, user);               
        }
        paramList.add(0, paramMaster);
                
        return paramList;
    }
    
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public void insertDetailButton(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {       
        try {
            
            Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
            
            String buttonFlag = (String) dataMaster.get("BUTTON_FLAG");
            for(Map param : paramList ) {
                if(buttonFlag.equals("R")){//접수
                    if(param.get("ACCEPT_STATUS").equals("1")){
                        param.put("ACCEPT_STATUS", '2');
                        super.commonDao.update("arc110ukrServiceImpl.updateReceipt", param);
                    }
                }else if(buttonFlag.equals("RC")){//미접수
                    if(param.get("ACCEPT_STATUS").equals("2") && (param.get("DOC_STATUS_DETAIL").equals("10"))){
                        param.put("ACCEPT_STATUS", '1');
                        super.commonDao.update("arc110ukrServiceImpl.updateReceipt", param);
                    }
                }else if(buttonFlag.equals("RD")){//접수마감
                    if(param.get("ACCEPT_STATUS").equals("1") && (param.get("DOC_STATUS_DETAIL").equals("10"))){
                        param.put("CANCEL_REASON", dataMaster.get("CANCEL_REASON"));
                        super.commonDao.update("arc110ukrServiceImpl.updateDeadline", param);
                    }
                }
            }   
        }catch(Exception e){
            throw new  UniDirectValidateException(this.getMessage("2627", user));
        }
        return;
    }   
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public void updateDetailButton(List<Map> paramList, LoginVO user) throws Exception {
        return;
    } 
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    public void deleteDetailButton(List<Map> paramList,  LoginVO user) throws Exception {
        return;
    }
    
    
    /**결재요청 버튼**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAllRequest(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

        String keyValue = getLogKey();          

        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        if(paramList != null)   {
            for(Map param: paramList) {
                
//                param.put("APRV_COMMENT", dataMaster.get("APRV_COMMENT"));
                dataList = (List<Map>)param.get("data");
    
                if(param.get("method").equals("insertDetailRequest")) {
                    param.put("data", insertRequestLogDetails(dataList, keyValue, "N") );  
                }
            }
        }

        Map<String, Object> spParam = new HashMap<String, Object>();

        spParam.put("COMP_CODE", user.getCompCode());
        spParam.put("KEY_VALUE", keyValue);
        spParam.put("APRV_TYPE", "AR");
        spParam.put("SLIP_TYPE", "");
        spParam.put("USER_ID"  , user.getUserID());
        super.commonDao.queryForObject("uspJoinsAccntAprvCheckArc110ukr", spParam);
        
        
        String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

        if(!ObjUtils.isEmpty(errorDesc)){
//            dataMaster.put("ELEC_SLIP_NO", "");
            String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        } else {
           
            Map<String, Object> spParam2 = new HashMap<String, Object>();

            spParam2.put("COMP_CODE", user.getCompCode());
            spParam2.put("KEY_VALUE", keyValue);
            spParam2.put("APRV_TYPE", "AR");
            spParam2.put("USER_ID"  , user.getUserID());
            super.commonDao.queryForObject("uspJoinsAccntAprvBufArc110ukr", spParam2);
            
            
            String errorDesc2 = ObjUtils.getSafeString(spParam2.get("ErrorDesc"));

            if(!ObjUtils.isEmpty(errorDesc2)){
//                dataMaster.put("ELEC_SLIP_NO", "");
                String[] messsage = errorDesc2.split(";");
                throw new  UniDirectValidateException(this.getMessage(errorDesc2, user));
            }else{

                Map<String, Object> spParam3 = new HashMap<String, Object>();

                spParam3.put("COMP_CODE", user.getCompCode());
                spParam3.put("KEY_VALUE", keyValue);
                spParam3.put("APRV_TYPE", "AR");
                spParam3.put("USER_ID"  , user.getUserID());
                super.commonDao.queryForObject("uspJoinsAccntAprvMainArc110ukr", spParam3);
                
                
                String errorDesc3 = ObjUtils.getSafeString(spParam3.get("ErrorDesc"));

                if(!ObjUtils.isEmpty(errorDesc3)){
//                    dataMaster.put("ELEC_SLIP_NO", "");
                    String[] messsage = errorDesc3.split(";");
                    throw new  UniDirectValidateException(this.getMessage(errorDesc3, user));
                }else{

                    
                }
                
            }
        }
        
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    /**
     * 버튼 -> 선택된 디테일 정보 로그 저장
     */
    public List<Map> insertRequestLogDetails(List<Map> params, String keyValue, String oprFlag) throws Exception {
        
        for(Map param: params)      {
            param.put("KEY_VALUE", keyValue);
            param.put("OPR_FLAG", oprFlag);
            
            super.commonDao.insert("arc110ukrServiceImpl.insertRequestLogDetail", param);
        }     
        return params;
    }
    
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
    public void insertDetailRequest(List<Map> params, LoginVO user) throws Exception {
        return;
    }
    
    
    
    
    
    
    
    
    
    
    
}
