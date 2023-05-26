package foren.unilite.modules.accnt.agc;

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



@Service("agc341ukrService")
public class Agc341ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public Object spUspAccntAutoSlip58 (Map spParam, LoginVO user) throws Exception {
        
	    spParam.put("S_COMP_CODE", user.getCompCode());
        spParam.put("S_LANG_CODE", user.getLanguage());
        spParam.put("S_USER_ID"  , user.getUserID());
        spParam.put("WORK_TYPE", "BATCH");   //호출경로
        
        super.commonDao.queryForObject("spUspAccntAutoSlip58", spParam);
//      super.commonDao.update("spUspAccntAfb700ukrDelA", spParam);     
        String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));                
        if(!ObjUtils.isEmpty(errorDesc)){
//          String[] messsage = errorDesc.split(";");
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        }else{
            return true;
        }
    }
	
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
    public Object spUspAccntAutoSlip58Cancel (Map spParam, LoginVO user) throws Exception {

        spParam.put("S_COMP_CODE", user.getCompCode());
        spParam.put("S_LANG_CODE", user.getLanguage());
        spParam.put("S_USER_ID"  , user.getUserID());    
        spParam.put("WORK_TYPE", "BATCH");   //호출경로
	        
        super.commonDao.queryForObject("spUspAccntAutoSlip58Cancel", spParam);
//	      super.commonDao.update("spUspAccntAfb700ukrDelA", spParam);     
        String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));                
        if(!ObjUtils.isEmpty(errorDesc)){
//	          String[] messsage = errorDesc.split(";");
             throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
        }else{
            return true;
        }
    }
}
