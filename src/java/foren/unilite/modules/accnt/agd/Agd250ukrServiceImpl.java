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



@Service("agd250ukrService")
public class Agd250ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("agd250ukrServiceImpl.selectList", param);
	}

	/*
	 * @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	 * // 실행 public Object procButton(List<Map> param, LoginVO user) throws
	 * Exception { String keyValue = getLogKey();
	 * 
	 * //2.로그테이블에 KEY_VALUE 업데이트 for(Map param: paramList) { param.put("KEY_VALUE",
	 * keyValue);
	 * 
	 * super.commonDao.insert("agd151ukrServiceImpl.insertLogTable", param); }
	 * Object r = super.commonDao.queryForObject("agd250ukrServiceImpl.agd250ukrDo",
	 * param); Map<String, Object> rMap = (Map<String, Object>) r;
	 * if(!"".equals(rMap.get("ERROR_CODE"))) { String[] sErr =
	 * rMap.get("ERROR_CODE").toString().split(";"); throw new
	 * UniDirectValidateException(this.getMessage(sErr[0], user)); } return r; }
	 * 
	 * @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	 * // 실행 public Object cancButton(Map param, LoginVO user) throws Exception {
	 * Object r =
	 * super.commonDao.queryForObject("agd250ukrServiceImpl.agd250ukrCancel",
	 * param); Map<String, Object> rMap = (Map<String, Object>) r;
	 * if(!"".equals(rMap.get("ERROR_CODE"))) { String[] sErr =
	 * rMap.get("ERROR_CODE").toString().split(";"); throw new
	 * UniDirectValidateException(this.getMessage(sErr[0], user)); } return r; }
	 */
	/**
	 * SP호출을 위한 로그테이블 생성 / SP 호출 로직
	 * @param paramList
	 * @param paramMaster
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> callProcedure(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
    	
    	String keyValue = getLogKey(); 
    	
        if(paramList != null)   {
            List<Map> insertList = null;
          
            
            
            for(Map dataListMap: paramList) {
            	if(dataListMap.get("method").equals("runProcedure")) {
            		insertList = (List<Map>)dataListMap.get("data");
                }
            }           
            if(insertList != null) this.runProcedure(insertList, paramMaster,  keyValue, user);
        }
        
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        dataMaster.put("KEY_VALUE", keyValue);
        paramList.add(0, paramMaster);
        

        return  paramList;
    }
    
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    private List<Map> runProcedure( List<Map> paramList, Map paramMaster, String keyValue, LoginVO user ) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");
        
        for(Map param: paramList)      {
        	param.put("KEY_VALUE", keyValue);
        	super.commonDao.insert("agd250ukrServiceImpl.insertLogTable", param);
        }       
    
        return paramList;
    }
}
