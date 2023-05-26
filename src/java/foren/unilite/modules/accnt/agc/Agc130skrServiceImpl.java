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
import foren.unilite.modules.accnt.agc.Agc130skrModel;
import foren.unilite.modules.com.fileman.FileMnagerService; 

@Service("agc130skrService")
public class Agc130skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	/**
	 * 
	 * 집계항목이 적용된 데이터가 있는지 검사
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnCheckExistABA131(Map param) throws Exception {
		return super.commonDao.list("agc130skrService.fnCheckExistABA131", param);
	}	

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param , LoginVO user) throws Exception {			// 재무상태표
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIVI", "10");
		param.put("DIV_CODE", finaldivCode);
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc130skrService.fnCheckExistABA131", param);
		if(ObjUtils.isEmpty(fnCheckExistABA131)){
            throw new  UniDirectValidateException(this.getMessage("55321", user));
        }else{
            List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc130skrService.selectList1", param);
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
		
		param.put("DIVI", "20");
		param.put("DIV_CODE", finaldivCode);

		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc130skrService.fnCheckExistABA131", param);
		if(ObjUtils.isEmpty(fnCheckExistABA131)){
            throw new  UniDirectValidateException(this.getMessage("55321", user));
        }else{
            List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc130skrService.selectList2", param);
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
		
		param.put("DIVI", "30");
		param.put("DIV_CODE", finaldivCode);
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc130skrService.fnCheckExistABA131", param);
		if(ObjUtils.isEmpty(fnCheckExistABA131)){
            throw new  UniDirectValidateException(this.getMessage("55321", user));
        }else{
            List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc130skrService.selectList3", param);
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
	public List<Map<String, Object>> selectList4(Map param, LoginVO user) throws Exception {
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIVI", "31");
		param.put("DIV_CODE", finaldivCode);
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc130skrService.fnCheckExistABA131", param);
		if(ObjUtils.isEmpty(fnCheckExistABA131)){
            throw new  UniDirectValidateException(this.getMessage("55321", user));
        }else{
            List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc130skrService.selectList4", param);
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
	public List<Map<String, Object>> selectList5(Map param, LoginVO user) throws Exception {
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIVI", "32");
		param.put("DIV_CODE", finaldivCode);
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc130skrService.fnCheckExistABA131", param);
		if(ObjUtils.isEmpty(fnCheckExistABA131)){
            throw new  UniDirectValidateException(this.getMessage("55321", user));
        }else{
            List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc130skrService.selectList5", param);
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
	public List<Map<String, Object>> selectList6(Map param, LoginVO user) throws Exception {
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIVI", "40");
		param.put("DIV_CODE", finaldivCode);
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc130skrService.fnCheckExistABA131", param);
		if(ObjUtils.isEmpty(fnCheckExistABA131)){
            throw new  UniDirectValidateException(this.getMessage("55321", user));
        }else{
            List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc130skrService.selectList6", param);
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
	public List<Map<String, Object>> selectList7(Map param, LoginVO user) throws Exception {
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIVI", "35");
		param.put("DIV_CODE", finaldivCode);
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc130skrService.fnCheckExistABA131", param);
		if(ObjUtils.isEmpty(fnCheckExistABA131)){
            throw new  UniDirectValidateException(this.getMessage("55321", user));
        }else{
            List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc130skrService.selectList7", param);
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
	public List<Map<String, Object>> selectList8(Map param, LoginVO user) throws Exception {
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIVI", "45");
		param.put("DIV_CODE", finaldivCode);
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc130skrService.fnCheckExistABA131", param);
		if(ObjUtils.isEmpty(fnCheckExistABA131)){
            throw new  UniDirectValidateException(this.getMessage("55321", user));
        }else{
            List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc130skrService.selectList8", param);
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
	
	/* 주석 조회 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm(Map param) throws Exception {
		
		return super.commonDao.select("agc130skrService.selectForm", param);
	}
	
	
	/* 주석 -저장(update) */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncForm(Agc130skrModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
	
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		super.commonDao.update("agc130skrService.updateForm", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		return extResult;
		
	}
}
