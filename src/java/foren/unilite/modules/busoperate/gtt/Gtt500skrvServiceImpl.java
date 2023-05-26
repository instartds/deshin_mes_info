package foren.unilite.modules.busoperate.gtt;

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
import foren.unilite.com.validator.UniDirectValidateException;


@Service("gtt500skrvService")
public class Gtt500skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gtt500skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectMechanicList(Map param) throws Exception {	
		return  super.commonDao.list("gtt500skrvServiceImpl.selectMechanicList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectOfficerList(Map param) throws Exception {	
		return  super.commonDao.list("gtt500skrvServiceImpl.selectOfficerList", param);
	}

}
