package foren.unilite.modules.human.hpa;

import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hpa600ukrService")
public class Hpa600ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
//	public Map procHpa600(Map param, LoginVO loginVO) throws Exception {
//		if(param.get("DIV_CODE").equals("")){			
//			param.put("DIV_CODE", "%");
//		} 
//		if(param.get("DEPT_CODE").equals("")){
//			param.put("DEPT_CODE", "0");
//		}
//		if(param.get("DEPT_CODE2").equals("")){			
//			param.put("DEPT_CODE2", "ZZZZZ");
//		}
//		if(param.get("PROV_PAY_FLAG").equals("")){			
//			param.put("PROV_PAY_FLAG", "%");
//		}
//		if(param.get("PERSON_NUMB").equals("")){			
//			param.put("PERSON_NUMB", "%");
//		}
//		if(param.get("PAY_CODE").equals("")){			
//			param.put("PAY_CODE", "%");
//		}
//		if(param.get("PAY_GUBUN").equals("")){			
//			param.put("PAY_GUBUN", "%");
//		}
//		if(param.get("RETIRE_GUBUN").equals("")){			
//			param.put("RETIRE_GUBUN", "%");
//		}
//		if(param.get("BASE_DATE").equals("")){			
//			param.put("BASE_DATE", "29991231");
//		}
//		
//		param.put("S_COMP_CODE", loginVO.getCompCode());
//		param.put("USER_ID", loginVO.getUserID());
//		
//		String arr[] = param.toString().split(",");		
//		for(int i=0;i<arr.length;i++){
//			System.out.println(arr[i]);
//		}
//		Map result = (Map)super.commonDao.queryForObject("hpa600ukrServiceImpl.proc", param);		
//		
//		System.out.println(result.toString());
//		
//		return result;
//		
//	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public Object  spStart(Map spParam, LoginVO user) throws Exception {
		String deptCd = (String) spParam.get("DEPTS").toString().replace("[", "");
		String depts = deptCd.replace("]", "");
		String arryDeptCd[] = depts.split(", ");
		String stDeptCd = arryDeptCd[0];
		String edDeptCd = arryDeptCd[arryDeptCd.length -1];
		
		spParam.put("DEPT_CODE_FR", stDeptCd);
		spParam.put("DEPT_CODE_TO", edDeptCd);
		Map errorMap = (Map) super.commonDao.select("hpa600ukrServiceImpl.USP_HUMAN_HPA600UKR", spParam);
		if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
			String errorDesc = (String) errorMap.get("errorDesc");
			//String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}else{
			return true;
		}	
	}
	
	
}
	
