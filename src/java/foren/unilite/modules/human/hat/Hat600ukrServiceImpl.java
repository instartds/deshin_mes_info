package foren.unilite.modules.human.hat;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.combo.ComboServiceImpl;


@Service("hat600ukrService")
public class Hat600ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	@Resource( name = "tlabCodeService" )
    private TlabCodeService        tlabCodeService;
	
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
		String deptCd = (String) spParam.get("DEPTS").toString().replace("[", "");
		String depts = deptCd.replace("]", "");
		String arryDeptCd[] = depts.split(", ");
		String stDeptCd = arryDeptCd[0];
		String edDeptCd = arryDeptCd[arryDeptCd.length -1];
		
		spParam.put("DEPT_CODE_FR", stDeptCd);
		spParam.put("DEPT_CODE_TO", edDeptCd);
		Map errorMap = null ;
		
		
		// 근태인정프로그램 사용여부 확인
		CodeInfo codeInfo = tlabCodeService.getCodeInfo(user.getCompCode());
        String flagPGM_YN = "N";
        CodeDetailVO flagPGMVO = codeInfo.getCodeInfo("H234", "1");
        if(flagPGM_YN != null) {
        		flagPGM_YN = ObjUtils.getSafeString(flagPGMVO.getRefCode1(), "N");
        }
        
		if("Y".equals(flagPGM_YN))	{
			errorMap =	(Map) super.commonDao.select("hat600ukrServiceImpl.USP_HUMAN_HAT600UKR_FLAG", spParam);	//근태인정프로그램을 사용하는 경우
		} else {
			errorMap =	(Map) super.commonDao.select("hat600ukrServiceImpl.USP_HUMAN_HAT600UKR", spParam); 
		}
		
//		String errorDesc = (String) errorMap.get("errorDesc");
		if(!ObjUtils.isEmpty(errorMap.get("errorDesc"))){
			String errorDesc = (String) errorMap.get("errorDesc");
			//String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}else{
			return true;
		}	
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hum")
	public Map<String, Object>  getPayProvDate(Map param) throws Exception {		
		return  (Map<String, Object>) super.commonDao.select("hat600ukrServiceImpl.getPayProvDate", param);
	}


}
