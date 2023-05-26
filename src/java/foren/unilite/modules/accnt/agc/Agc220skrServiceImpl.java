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
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.accnt.agc.Agc130skrServiceImpl;
@Service("agc220skrService")
public class Agc220skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	@Resource(name="agc130skrService")
	private Agc130skrServiceImpl agc130skrService;
	
	


	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param, LoginVO user) throws Exception {			// 재무상태표
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIVI", "20");			   // tab 1 = 20
		param.put("DIV_CODE", finaldivCode);
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc220skrService.fnCheckExistABA131", param);
	    if(ObjUtils.isEmpty(fnCheckExistABA131)){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
		}else{
		    List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc220skrService.selectList1", param);
            String errorDesc ="";
            if(ObjUtils.isNotEmpty(returnData)){
                errorDesc = ObjUtils.getSafeString(returnData.get(0).get("ERROR_DESC"));
            }
            if(ObjUtils.isNotEmpty(errorDesc)){
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            }else{
                return returnData;
            }
		}
	}	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param, LoginVO user) throws Exception {
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIVI", "20");				// tab 2 = 20
		param.put("DIV_CODE", finaldivCode);
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc220skrService.fnCheckExistABA131", param);
	    if(ObjUtils.isEmpty(fnCheckExistABA131)){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
		}else{
		    List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc220skrService.selectList2", param);
            String errorDesc ="";
            if(ObjUtils.isNotEmpty(returnData)){
                errorDesc = ObjUtils.getSafeString(returnData.get(0).get("ERROR_DESC"));
            }
            if(ObjUtils.isNotEmpty(errorDesc)){
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            }else{
                return returnData;
            }
		    
		}
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList3(Map param, LoginVO user) throws Exception {
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIVI", "20");				// tab 3 = 20
		param.put("DIV_CODE", finaldivCode);
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc220skrService.fnCheckExistABA131", param);
	    if(ObjUtils.isEmpty(fnCheckExistABA131)){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
		}else{
		    List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc220skrService.selectList3", param);
            String errorDesc ="";
            if(ObjUtils.isNotEmpty(returnData)){
                errorDesc = ObjUtils.getSafeString(returnData.get(0).get("ERROR_DESC"));
            }
            if(ObjUtils.isNotEmpty(errorDesc)){
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            }else{
                return returnData;
            }
		    
		}
	}
}
