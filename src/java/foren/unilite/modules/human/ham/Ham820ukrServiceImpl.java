package foren.unilite.modules.human.ham;

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
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("ham820ukrService")
public class Ham820ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList (Map param) throws Exception {
		return super.commonDao.list("ham820ukrServiceImpl.selectList", param);
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
                    param.put("data", insertLogDetails(dataList, keyValue, buttonFlag, workDate));  
                }
            }
        }
        
        if(buttonFlag.equals("BATCH") || buttonFlag.equals("LIST")){

            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("S_USER_ID"  , user.getUserID());
            spParam.put("SUPP_DATE_FR", dataMaster.get("SUPP_DATE_FR"));
            spParam.put("SUPP_DATE_TO", dataMaster.get("SUPP_DATE_TO"));
//            spParam.put("DED_TYPE", dataMaster.get("DED_TYPE"));
            spParam.put("WORK_DATE", dataMaster.get("WORK_DATE"));
            spParam.put("WORK_GUBUN", dataMaster.get("WORK_GUBUN"));
            
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("CALL_PATH", dataMaster.get("BUTTON_FLAG"));
            
            
            super.commonDao.queryForObject("spUspAccntAutoSlip23_HAM820UKR", spParam);
            
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

            if(!ObjUtils.isEmpty(errorDesc)){
//                dataMaster.put("ELEC_SLIP_NO", "");
//                String[] messsage = errorDesc.split(";");
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {

//                dataMaster.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("rtnElecSilpNo")));
           
//                for(Map param: paramList) {
//                    dataList = (List<Map>)param.get("data");    
//                    if(param.get("method").equals("insertDetail")) {
//                        List<Map> datas = (List<Map>)param.get("data");
//                        for(Map data: datas){
//                            data.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("ELEC_SLIP_NO")));
//                        }
//                    }
//                }   
            }
            
            
        }else if(buttonFlag.equals("CANCEL")){

            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("S_USER_ID"  , user.getUserID());
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("CALL_PATH", dataMaster.get("BUTTON_FLAG"));
            
            
            super.commonDao.queryForObject("spUspAccntAutoSlip23Cancel", spParam);
            
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

            if(!ObjUtils.isEmpty(errorDesc)){
//                dataMaster.put("ELEC_SLIP_NO", "");
//                String[] messsage = errorDesc.split(";");
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {

//                dataMaster.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("rtnElecSilpNo")));
           
//                for(Map param: paramList) {
//                    dataList = (List<Map>)param.get("data");    
//                    if(param.get("method").equals("insertDetail")) {
//                        List<Map> datas = (List<Map>)param.get("data");
//                        for(Map data: datas){
//                            data.put("ELEC_SLIP_NO", ObjUtils.getSafeString(spParam.get("ELEC_SLIP_NO")));
//                        }
//                    }
//                }   
            }
            
        }
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    /**
     * 버튼 -> 선택된 디테일 정보 로그 저장
     */
    public List<Map> insertLogDetails(List<Map> params, String keyValue, String buttonFlag, String workDate) throws Exception {
        
        for(Map param: params)      {
            param.put("KEY_VALUE", keyValue);
            param.put("OPR_FLAG", buttonFlag.substring(0, 2));
            if(workDate.equals("")){
                param.put("WORK_DATE", "");
            }else{
                param.put("WORK_DATE", workDate);
            }
            
            super.commonDao.insert("ham820ukrServiceImpl.insertLogDetail", param);
        }     
        return params;
    }
    
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
    public void insertDetailAutoSign(List<Map> params, LoginVO user) throws Exception {
        return;
    }
}
