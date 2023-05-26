package foren.unilite.modules.base.bor;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("bor100ukrvService")
public class Bor100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	/**
	 *  회사정보 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "base")
	public Object selectMaster(Map param) throws Exception {		
		
		return super.commonDao.select("bor100ukrvServiceImpl.selectMaster", param);
	}
	
	
	/**
	 *  회사정보 수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "base")
	public ExtDirectFormPostResult syncMaster(Bor100ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
		if(!"".equals(ObjUtils.getSafeString(param.getZIP_CODE())))	{
			param.setZIP_CODE(param.getZIP_CODE().replace("-", ""));
		}
		if(!"".equals(ObjUtils.getSafeString(param.getCOMPANY_NUM())))	{
			param.setCOMPANY_NUM(param.getCOMPANY_NUM().replaceAll("\\-", ""));
		}
		if(!"".equals(ObjUtils.getSafeString(param.getREPRE_NO())))	{
			param.setREPRE_NO(param.getREPRE_NO().replaceAll("\\-", ""));
		}
		if(!"".equals(ObjUtils.getSafeString(param.getCOMP_OWN_NO())))	{
			param.setCOMP_OWN_NO(param.getCOMP_OWN_NO().replaceAll("\\-", ""));
		}
		param.setS_USER_ID(user.getUserID());
		super.commonDao.update("bor100ukrvServiceImpl.update", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}
	

}
