package foren.unilite.modules.human.hbo;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hbo210ukrService")
public class Hbo210ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/* 상여계산 SP 호출  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbo")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public String spCalcPay(Map param, LoginVO user) throws Exception {
		String rtnV = "";
        param.put("LANG_TYPE", user.getLanguage());
        Map errorMap = (Map) super.commonDao.select("hbo210ukrServiceImpl.spCalcPay", param);
        
        String errorDesc ="";
        if(ObjUtils.isNotEmpty(errorMap)){
            errorDesc = ObjUtils.getSafeString(errorMap.get("ErrorDesc"));
        }
        
        if(ObjUtils.isNotEmpty(errorDesc)){
            throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} else {
			rtnV = "Y";
			return rtnV;
		}
	}
	
	
	
	//사용 안 함
	/**
	 * 프로시져 실행 
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbo")
	public Map procHbo210(Map param, LoginVO loginVO) throws Exception {		
		if(param.get("DIV_CODE").equals("")){			
			param.put("DIV_CODE", "'%'");
		} 
		if(param.get("DEPT_CODE").equals("")){
			param.put("DEPT_CODE", "0");
		}
		if(param.get("DEPT_CODE2").equals("")){			
			param.put("DEPT_CODE2", "ZZZZZ");
		}
		if(param.get("PAY_PROV_FLAG").equals("")){			
			param.put("PAY_PROV_FLAG", "%");
		}
		if(param.get("PERSON_NUMB").equals("")){			
			param.put("PERSON_NUMB", "%");
		}
		if(param.get("PAY_CODE").equals("")){			
			param.put("PAY_CODE", "%");
		}		
		if(param.get("BASE_DT_FR").equals("")){
			param.put("BASE_DT_FR", "000000");
		}
		if(param.get("BASE_DT_TO").equals("")){
			param.put("BASE_DT_TO", "000000");
		}
		if(param.get("BONUS_AVG_RATE").equals("")){
			param.put("BONUS_AVG_RATE", "0");
		}
		
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}

		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("USER_ID", loginVO.getUserID());
		
		Map result = (Map)super.commonDao.queryForObject("hbo210ukrServiceImpl.procHbo210", param);		
		
		return result;
		
	}

}
