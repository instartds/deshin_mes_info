package foren.unilite.modules.accnt.atx;

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

@Service( "atx101ukrService" )
public class Atx101ukrServiceImpl extends TlabAbstractServiceImpl {
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
        return super.commonDao.list("atx101ukrServiceImpl.selectList", param);
    }
    
    /**버튼**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAllButton(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

        String keyValue = getLogKey();          

        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        
        String buttonFlag       = (String) dataMaster.get("BUTTON_FLAG");
        
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        if(paramList != null)   {
            for(Map param: paramList) {
                dataList = (List<Map>)param.get("data");
    
                if(param.get("method").equals("insertDetailButton")) {
                    param.put("data", insertLogDetails(dataList, keyValue, buttonFlag));  
                }
            }
        }
        
        if(buttonFlag.equals("FNCQ")){

            Map<String, Object> spParam = new HashMap<String, Object>();
            
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("LANG_CODE", user.getLanguage());
            spParam.put("USER_ID"  , user.getUserID());
            super.commonDao.queryForObject("spUspAccntAtx100ukrFnCompanyQuery", spParam);
            
            
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
        }else if(buttonFlag.equals("FNBN")){
            Map<String, Object> spParam = new HashMap<String, Object>();
            
            spParam.put("COMP_CODE", user.getCompCode());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_WORK_GB", "4");
            spParam.put("LANG_CODE", user.getLanguage());
            spParam.put("USER_ID"  , user.getUserID());
            super.commonDao.queryForObject("spUspAccntAbh200ukrFnBankNameresult_atx101", spParam);
          
          
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
    public List<Map> insertLogDetails(List<Map> params, String keyValue, String buttonFlag) throws Exception {
        
        for(Map param: params)      {
            param.put("KEY_VALUE", keyValue);
            param.put("OPR_FLAG", buttonFlag);
            super.commonDao.insert("atx101ukrServiceImpl.insertLogDetail", param);
                
            
        }     
        return params;
    }
    
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
    public void insertDetailButton(List<Map> params, LoginVO user) throws Exception {
        return;
    }
}
