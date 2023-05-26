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

@Service( "arc400ukrService" )
public class Arc400ukrServiceImpl extends TlabAbstractServiceImpl {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    /**
     * 수수료청구등록 조회
     * 
     * @param param 검색항목
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "accnt", value = ExtDirectMethodType.STORE_READ )
    public List<Map<String, Object>> selectList( Map param ) throws Exception {
        return super.commonDao.list("arc400ukrServiceImpl.selectList", param);
    }
    
    /**버튼**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAllButton(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

        String keyValue = getLogKey();          

        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        
        String buttonFlag       = (String) dataMaster.get("BUTTON_FLAG");
        String chargeDate       = (String) dataMaster.get("CHARGE_DATE");
        String confChargeDate   = (String) dataMaster.get("CONF_CHARGE_DATE");
        
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        if(paramList != null)   {
            for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");
    
                if(param.get("method").equals("insertDetailButton")) {
                    param.put("data", insertLogDetails(dataList, keyValue, buttonFlag, chargeDate, confChargeDate));  
                }
            }
        }
        
        if(buttonFlag.equals("b3")){

            Map<String, Object> spParam = new HashMap<String, Object>();
            
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("CONF_CHARGE_DATE", confChargeDate);
            spParam.put("LANG_CODE", user.getLanguage());
            spParam.put("USER_ID"  , user.getUserID());
            super.commonDao.queryForObject("spUspAccntArc400ukrFnChargeDecide", spParam);
            
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
    
            if(!ObjUtils.isEmpty(errorDesc)){
    //            dataMaster.put("ELEC_SLIP_NO", "");
                String[] messsage = errorDesc.split(";");
                throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
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
        }else if(buttonFlag.equals("b4")){
            Map<String, Object> spParam = new HashMap<String, Object>();
            
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("CONF_CHARGE_DATE", confChargeDate);
            spParam.put("LANG_CODE", user.getLanguage());
            spParam.put("USER_ID"  , user.getUserID());
            super.commonDao.queryForObject("spUspAccntArc400ukrFnChargeCancel", spParam);
          
          
            String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
  
            if(!ObjUtils.isEmpty(errorDesc)){
  //            dataMaster.put("ELEC_SLIP_NO", "");
                String[] messsage = errorDesc.split(";");
                throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
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
    public List<Map> insertLogDetails(List<Map> params, String keyValue, String buttonFlag, String chargeDate, String confChargeDate) throws Exception {
        
        for(Map param: params)      {
            param.put("KEY_VALUE", keyValue);
            param.put("OPR_FLAG", buttonFlag);
            param.put("CHARGE_DATE", chargeDate);
            param.put("CONF_CHARGE_DATE", confChargeDate);
            
            if(buttonFlag.equals("b1")){    //청구버튼
                if(param.get("CHARGE_YN").equals("N")){
                    param.put("CHARGE_YN_UPDATE", "Y");
                    super.commonDao.insert("arc400ukrServiceImpl.insertArc400t", param);
                    super.commonDao.update("arc400ukrServiceImpl.updateArc210t", param);
                }
            }else if(buttonFlag.equals("b2")){  //미청구버튼
                if(param.get("CONF_YN").equals("N")){
                    if(param.get("CHARGE_YN").equals("Y")){
                        param.put("CHARGE_YN_UPDATE", "N");
                        super.commonDao.delete("arc400ukrServiceImpl.deleteArc400t", param);
                        super.commonDao.update("arc400ukrServiceImpl.updateArc210t", param);
                    }
                }
            }else if(buttonFlag.equals("b3") || buttonFlag.equals("b4")){   //청구확정버튼,청구확정취소버튼
                if(param.get("CHARGE_YN").equals("Y")){
                    super.commonDao.insert("arc400ukrServiceImpl.insertLogDetail", param);
                }
            }
        }     
        return params;
    }
    
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
    public void insertDetailButton(List<Map> params, LoginVO user) throws Exception {
        return;
    }
}
