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



@Service("agc150skrService")
public class Agc150skrServiceImpl extends TlabAbstractServiceImpl {
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
	public int dropTempTableAGB100T() throws Exception {
		return super.commonDao.update("agc150rkrService.dropTempTableAGB100T", null);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public int createTableAGB100T(Map param) throws Exception {
		return super.commonDao.update("agc150rkrService.fnCreateTable", param);
	}
	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public int existTableAGB100T() throws Exception {
		return super.commonDao.update("agc150rkrService.existTableAGB100T", null);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param , LoginVO user) throws Exception {			// 재무상태표
		
		String finaldivCode2 = "";
		String finaldivCode3 = "";
		String finaldivCode4 = "";
		String finaldivCode5 = "";
		String finaldivCode6 = "";
		
		String divCode1 = (String) param.get("DIV_CODE1").toString().replace("[", "");
		String finaldivCode1 = divCode1.replace("]", "");
		
		if(param.get("DIV_CODE2") != null){
			String divCode2 = (String) param.get("DIV_CODE2").toString().replace("[", "");
			finaldivCode2 = divCode2.replace("]", "");
		}
		if(param.get("DIV_CODE3") != null){
			String divCode3 = (String) param.get("DIV_CODE3").toString().replace("[", "");
			finaldivCode3 = divCode3.replace("]", "");
		}
		if(param.get("DIV_CODE4") != null){
			String divCode4 = (String) param.get("DIV_CODE4").toString().replace("[", "");
			finaldivCode4 = divCode4.replace("]", "");
		}
		if(param.get("DIV_CODE5") != null){	
			String divCode5 = (String) param.get("DIV_CODE5").toString().replace("[", "");
			finaldivCode5 = divCode5.replace("]", "");
		}
		if(param.get("DIV_CODE6") != null){
			String divCode6 = (String) param.get("DIV_CODE6").toString().replace("[", "");
			finaldivCode6 = divCode6.replace("]", "");
		}
		param.put("DIVI", "10");
		param.put("DIV_CODE1", finaldivCode1);
		
		param.put("DIV_CODE2", finaldivCode2);
		param.put("DIV_CODE3", finaldivCode3);
		param.put("DIV_CODE4", finaldivCode4);
		param.put("DIV_CODE5", finaldivCode5);
		param.put("DIV_CODE6", finaldivCode6);
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc150skrService.fnCheckExistABA131", param);
	    if(ObjUtils.isEmpty(fnCheckExistABA131)){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
		}else{
	        
	        List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc150skrService.selectList1", param);
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
	public List<Map<String, Object>> selectList2(Map param , LoginVO user) throws Exception {			// 손익계산서
		
		String finaldivCode2 = "";
		String finaldivCode3 = "";
		String finaldivCode4 = "";
		String finaldivCode5 = "";
		String finaldivCode6 = "";
		
		String divCode1 = (String) param.get("DIV_CODE1").toString().replace("[", "");
		String finaldivCode1 = divCode1.replace("]", "");
		
		if(param.get("DIV_CODE2") != null){
			String divCode2 = (String) param.get("DIV_CODE2").toString().replace("[", "");
			finaldivCode2 = divCode2.replace("]", "");
		}
		if(param.get("DIV_CODE3") != null){
			String divCode3 = (String) param.get("DIV_CODE3").toString().replace("[", "");
			finaldivCode3 = divCode3.replace("]", "");
		}
		if(param.get("DIV_CODE4") != null){
			String divCode4 = (String) param.get("DIV_CODE4").toString().replace("[", "");
			finaldivCode4 = divCode4.replace("]", "");
		}
		if(param.get("DIV_CODE5") != null){	
			String divCode5 = (String) param.get("DIV_CODE5").toString().replace("[", "");
			finaldivCode5 = divCode5.replace("]", "");
		}
		if(param.get("DIV_CODE6") != null){
			String divCode6 = (String) param.get("DIV_CODE6").toString().replace("[", "");
			finaldivCode6 = divCode6.replace("]", "");
		}
		param.put("DIVI", "20");
		param.put("DIV_CODE1", finaldivCode1);
		
		param.put("DIV_CODE2", finaldivCode2);
		param.put("DIV_CODE3", finaldivCode3);
		param.put("DIV_CODE4", finaldivCode4);
		param.put("DIV_CODE5", finaldivCode5);
		param.put("DIV_CODE6", finaldivCode6);
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc150skrService.fnCheckExistABA131", param);
	    if(ObjUtils.isEmpty(fnCheckExistABA131)){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
		}else{
		    List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc150skrService.selectList2", param);
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
	public List<Map<String, Object>> selectList3(Map param , LoginVO user) throws Exception {			// 제조원가명세서
		
		String finaldivCode2 = "";
		String finaldivCode3 = "";
		String finaldivCode4 = "";
		String finaldivCode5 = "";
		String finaldivCode6 = "";
		
		String divCode1 = (String) param.get("DIV_CODE1").toString().replace("[", "");
		String finaldivCode1 = divCode1.replace("]", "");
		
		if(param.get("DIV_CODE2") != null){
			String divCode2 = (String) param.get("DIV_CODE2").toString().replace("[", "");
			finaldivCode2 = divCode2.replace("]", "");
		}
		if(param.get("DIV_CODE3") != null){
			String divCode3 = (String) param.get("DIV_CODE3").toString().replace("[", "");
			finaldivCode3 = divCode3.replace("]", "");
		}
		if(param.get("DIV_CODE4") != null){
			String divCode4 = (String) param.get("DIV_CODE4").toString().replace("[", "");
			finaldivCode4 = divCode4.replace("]", "");
		}
		if(param.get("DIV_CODE5") != null){	
			String divCode5 = (String) param.get("DIV_CODE5").toString().replace("[", "");
			finaldivCode5 = divCode5.replace("]", "");
		}
		if(param.get("DIV_CODE6") != null){
			String divCode6 = (String) param.get("DIV_CODE6").toString().replace("[", "");
			finaldivCode6 = divCode6.replace("]", "");
		}
		param.put("DIVI", "30");
		param.put("DIV_CODE1", finaldivCode1);
		
		param.put("DIV_CODE2", finaldivCode2);
		param.put("DIV_CODE3", finaldivCode3);
		param.put("DIV_CODE4", finaldivCode4);
		param.put("DIV_CODE5", finaldivCode5);
		param.put("DIV_CODE6", finaldivCode6);
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc150skrService.fnCheckExistABA131", param);
		if(fnCheckExistABA131.isEmpty()){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
		}else{
		    List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc150skrService.selectList3", param);
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
