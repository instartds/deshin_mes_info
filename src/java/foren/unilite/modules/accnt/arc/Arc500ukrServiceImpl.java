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

@Service( "arc500ukrService" )
public class Arc500ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 수수료청구자동기표 조회  
     * @param param
     * @return
     * @throws Exception
     */     
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
    public List<Map<String, Object>> selectList(Map param, LoginVO user) throws Exception {     
        return super.commonDao.list("arc500ukrServiceImpl.selectList", param);
    }
    
    /**버튼**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAllAutoSign(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

        String keyValue = getLogKey();          

        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        
        String buttonFlag = (String) dataMaster.get("BUTTON_FLAG");
        String workDate   = (String) dataMaster.get("WORK_DATE");
        
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        if(paramList != null)   {
            for(Map param: paramList) {
                
                
                dataList = (List<Map>)param.get("data");
    
                if(param.get("method").equals("insertDetailAutoSign")) {
                    param.put("data", insertLogDetails(dataList, keyValue, buttonFlag,workDate));  
                }
            }
        }
        if(buttonFlag.equals("1") || buttonFlag.equals("2")){

            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_GUBUN", buttonFlag);
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("S_USER_ID"  , user.getUserID());
            super.commonDao.queryForObject("spUspAccntAutoSlip90", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
    
            if(!ObjUtils.isEmpty(errorDesc)){
    //            dataMaster.put("ELEC_SLIP_NO", "");
//                String[] messsage = errorDesc.split(";");
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {
    
    //            dataMaster.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("rtnElecSilpNo")));
           
    //            for(Map param: paramList) {
    //                dataList = (List<Map>)param.get("data");    
    //                if(param.get("method").equals("insertDetail")) {
    //                    List<Map> datas = (List<Map>)param.get("data");
    //                    for(Map data: datas){
    //                        data.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("ELEC_SLIP_NO")));
    //                    }
    //                }
    //            }   
            }
        }else if(buttonFlag.equals("3")){

            Map<String, Object> spParam = new HashMap<String, Object>();
            
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_GUBUN", buttonFlag);
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("S_USER_ID"  , user.getUserID());
            super.commonDao.queryForObject("spUspAccntAutoSlip90Cancel", spParam);
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
    
            if(!ObjUtils.isEmpty(errorDesc)){
    //            dataMaster.put("ELEC_SLIP_NO", "");
//                String[] messsage = errorDesc.split(";");
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {
    
    //            dataMaster.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("rtnElecSilpNo")));
           
    //            for(Map param: paramList) {
    //                dataList = (List<Map>)param.get("data");    
    //                if(param.get("method").equals("insertDetail")) {
    //                    List<Map> datas = (List<Map>)param.get("data");
    //                    for(Map data: datas){
    //                        data.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("ELEC_SLIP_NO")));
    //                    }
    //                }
    //            }   
            }
        }
        
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    /**
     * 버튼 -> 선택된 디테일 정보 로그 저장
     */
    public List<Map> insertLogDetails(List<Map> params, String keyValue, String buttonFlag, String workDate) throws Exception {
        
        
       /* if(buttonFlag.equals("afterAddApprove")){
        
            for(Map param: params)      {
                param.put("KEY_VALUE", keyValue);
    //            param.put("OPR_FLAG", oprFlag);
                
                super.commonDao.insert("aep820ukrServiceImpl.insertLogDetail", param);
            }       
        }*/
        for(Map param: params)      {
            param.put("KEY_VALUE", keyValue);
            param.put("OPR_FLAG", buttonFlag);
            param.put("WORK_DATE", workDate);
            
            if(!ObjUtils.isEmpty(param.get("RECE_COMP_NAME"))){
                param.put("RECE_COMP_NAME", "");  
            }
            if(!ObjUtils.isEmpty(param.get("CUSTOM_NAME"))){
                param.put("CUSTOM_NAME", "");  
            }  
            
            super.commonDao.insert("arc500ukrServiceImpl.insertLogDetail", param);
        }     
        return params;
    }
    
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
    public void insertDetailAutoSign(List<Map> params, LoginVO user) throws Exception {
        return;
    }
}
