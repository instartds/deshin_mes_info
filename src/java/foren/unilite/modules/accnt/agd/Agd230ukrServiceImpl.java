package foren.unilite.modules.accnt.agd;

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



@Service("agd230ukrService")
public class Agd230ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList (Map param) throws Exception {
		return super.commonDao.list("agd230ukrServiceImpl.selectList", param);
	}

	
	 /**버튼**/
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> saveAllAutoSign(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

        String keyValue = getLogKey();          

        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        
        List<Map> dataList = new ArrayList<Map>();
        List<List<Map>> resultList = new ArrayList<List<Map>>();
        if(paramList != null)   {
            for(Map param: paramList) {
                
                dataList = (List<Map>)param.get("data");
    
                if(param.get("method").equals("insertDetailAutoSign")) {
                    param.put("data", insertLogDetails(dataList, keyValue));  
                }
            }
        }
        
        Map<String, Object> sysDateMap =(Map<String, Object>) super.commonDao.select("agd230ukrServiceImpl.selectSysdate", paramMaster);
        String oprFlag  = (String) dataMaster.get("OPR_FLAG");
        if(oprFlag.equals("D")) {
        	
        	Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("S_USER_ID"  , user.getUserID());
            spParam.put("INPUT_DATE"    , sysDateMap.get("SYS_DATE"));
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("CALL_PATH", dataMaster.get("BUTTON_FLAG"));
            
            super.commonDao.queryForObject("spUspAccntAutoSlip21Cancel", spParam);
            
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

            if(!ObjUtils.isEmpty(errorDesc)){
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            } 
	
        } else {

            Map<String, Object> spParam = new HashMap<String, Object>();
            spParam.put("S_COMP_CODE", user.getCompCode());
            spParam.put("PROC_TYPE"     , dataMaster.get("PROC_TYPE"));
            spParam.put("DATE_OPTION"   , dataMaster.get("DATE_OPTION"));
            spParam.put("WORK_DATE"     , dataMaster.get("WORK_DATE"));
            spParam.put("S_USER_ID"  , user.getUserID());
            spParam.put("INPUT_DATE"    , sysDateMap.get("SYS_DATE"));
            spParam.put("KEY_VALUE", keyValue);
            spParam.put("S_LANG_CODE", user.getLanguage());
            spParam.put("CALL_PATH", dataMaster.get("BUTTON_FLAG"));
            
            super.commonDao.queryForObject("spUspAccntAutoSlip21", spParam);
            
            
            String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

            if(!ObjUtils.isEmpty(errorDesc)){
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            } 
        }
        
        paramList.add(0, paramMaster);
                
        return  paramList;
    }
    /**
     * 버튼 -> 선택된 디테일 정보 로그 저장
     */
    public List<Map> insertLogDetails(List<Map> params, String keyValue) throws Exception {
        
        for(Map param: params)      {
            param.put("KEY_VALUE", keyValue);
            if(param.get("P_PAY_YYYYMM") != null)	{
            	param.put("P_PAY_YYYYMM" , ObjUtils.getSafeString(param.get("P_PAY_YYYYMM")).replace(".", ""));
            }
            super.commonDao.insert("agd230ukrServiceImpl.insertLogDetail", param);
        }     
        return params;
    }
    
    @ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_MODIFY)
    public void insertDetailAutoSign(List<Map> params, LoginVO user) throws Exception {
        return;
    }
}
