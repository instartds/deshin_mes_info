package foren.unilite.modules.human.had;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("had830ukrService")
public class Had830ukrServiceImpl  extends TlabAbstractServiceImpl {

	@ExtDirectMethod(group = "human")
	public void doBatch(Map param, LoginVO user) throws Exception {
		//**************************************************
	    // 급여 월 마감 되어 있는지 확인
	    //**************************************************
		Map<String, Object> chkClosed = (Map<String, Object>) super.commonDao.select("had830ukrServiceImpl.closeSalary", param);
		if(chkClosed != null && "CLOSED".equals(ObjUtils.getSafeString(chkClosed.get("CHK"))))	{
			throw new UniDirectValidateException(this.getMessage("54240", user));	// 이미 마감된 자료입니다.
		}
		//'**************************************************
	    //' 계산 대상중 개인마감자가 포함 되어 있는지 여부 확인
	    //'**************************************************
		List<Map<String, Object>> closedEmpList =  super.commonDao.list("had830ukrServiceImpl.closedEmployee", param);
		if(closedEmpList != null && closedEmpList.size() > 0)	{
			throw new UniDirectValidateException(this.getMessage("54240", user));	// 이미 마감된 자료입니다.
		}
		
		//대상자 검색
		List<Map<String, Object>> empList =  super.commonDao.list("had830ukrServiceImpl.employee", param);
		if(empList == null || empList.size()  == 0)	{
			throw new UniDirectValidateException(this.getMessage("54265", user));	// 세액반영할 대상자가 없습니다.
		}
		
		super.commonDao.update("had830ukrServiceImpl.deleteOld", param);
		super.commonDao.update("had830ukrServiceImpl.batch", param);
		super.commonDao.update("had830ukrServiceImpl.dedUpdate", param);

	}
	
	@ExtDirectMethod(group = "human")
	public void cancelBatch(Map param, LoginVO user) throws Exception {
		//**************************************************
	    // 급여 월 마감 되어 있는지 확인
	    //**************************************************
		Map<String, Object> chkClosed = (Map<String, Object>) super.commonDao.select("had830ukrServiceImpl.closeSalary", param);
		if(chkClosed != null && "CLOSED".equals(ObjUtils.getSafeString(chkClosed.get("CHK"))))	{
			throw new UniDirectValidateException(this.getMessage("54240", user));	// 이미 마감된 자료입니다.
		}
		//'**************************************************
	    //' 계산 대상중 개인마감자가 포함 되어 있는지 여부 확인
	    //'**************************************************
		List<Map<String, Object>> closedEmpList =  super.commonDao.list("had830ukrServiceImpl.closedEmployee", param);
		if(closedEmpList != null && closedEmpList.size() > 0)	{
			throw new UniDirectValidateException(this.getMessage("54240", user));	// 이미 마감된 자료입니다.
		}
		
		//대상자 검색
		List<Map<String, Object>> empList =  super.commonDao.list("had830ukrServiceImpl.employee", param);
		if(empList == null || empList.size()  == 0)	{
			throw new UniDirectValidateException(this.getMessage("54265", user));	// 세액반영할 대상자가 없습니다.
		}
		
		super.commonDao.update("had830ukrServiceImpl.deleteOld", param);
		super.commonDao.update("had830ukrServiceImpl.cancelBatch", param);
		super.commonDao.update("had830ukrServiceImpl.dedUpdate", param);

	}
}
