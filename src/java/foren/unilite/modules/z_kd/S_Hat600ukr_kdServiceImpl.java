package foren.unilite.modules.z_kd;

import java.util.List;
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


@Service("s_hat600ukr_kdService")
public class S_Hat600ukr_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 일근태 집계작업
	 * 
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hum")
	public Object  insertMaster(Map spParam, LoginVO user) throws Exception {
//		String deptCd = (String) spParam.get("DEPTS").toString().replace("[", "");
//		String depts = deptCd.replace("]", "");
//		String arryDeptCd[] = depts.split(", ");
//		String stDeptCd = arryDeptCd[0];
//		String edDeptCd = arryDeptCd[arryDeptCd.length -1];
//		
//		spParam.put("DEPT_CODE_FR", stDeptCd);
//		spParam.put("DEPT_CODE_TO", edDeptCd);
		Map errorMap = (Map) super.commonDao.select("s_hat600ukr_kdServiceImpl.USP_HUMAN_HAT600UKR_KDG", spParam);
//		String errorDesc = (String) errorMap.get("ERROR_DESC");

		if(!ObjUtils.isEmpty(errorMap.get("ERROR_DESC"))){
			String errorDesc = (String) errorMap.get("errorDesc");
//			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));

		}else{
			return true;
		}	
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public Map<String, Object>  getPayProvDate(Map param) throws Exception {		
		return  (Map<String, Object>) super.commonDao.select("s_hat600ukr_kdServiceImpl.getPayProvDate", param);
	}


}
