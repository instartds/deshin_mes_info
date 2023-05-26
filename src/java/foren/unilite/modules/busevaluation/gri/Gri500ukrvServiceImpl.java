package foren.unilite.modules.busevaluation.gri;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bor.Bor100ukrvModel;


@Service("gri500ukrvService")
public class Gri500ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busevalution", value = ExtDirectMethodType.FORM_LOAD)
	public Object  selectMaster(Map param) throws Exception {	
		return  super.commonDao.select("gri500ukrvServiceImpl.selectMaster", param);
	}
	
	/**
	 *  재무상태표 수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "busevalution")
	public ExtDirectFormPostResult syncMaster(Gri500ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
		
		param.setS_USER_ID(user.getUserID());
		super.commonDao.update("gri500ukrvServiceImpl.deleteUpdate", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}
}
