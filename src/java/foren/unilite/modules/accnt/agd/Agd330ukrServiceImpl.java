package foren.unilite.modules.accnt.agd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("agd330ukrService")
public class Agd330ukrServiceImpl  extends TlabAbstractServiceImpl {
	

	
	/**
	 *  실행
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt")
	public Object  procAutoSlip(Map param, LoginVO user) throws Exception {

		super.commonDao.queryForObject("agd330ukrServiceImpl.spAutoSlip55", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}	
		return param;
	}
	
	/**
	 *  취소
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod( group = "accnt")
	public Object  cancelAutoSlip(Map param, LoginVO user) throws Exception {

		super.commonDao.queryForObject("agd330ukrServiceImpl.spCancelAutoSlip55", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}	
		return param;
	}
	
}
