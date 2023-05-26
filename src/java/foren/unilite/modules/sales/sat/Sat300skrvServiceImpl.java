package foren.unilite.modules.sales.sat;

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
import foren.unilite.modules.sales.SalesCommonServiceImpl;
import foren.unilite.modules.z_mit.S_sas200ukrv_mitModel;

@Service("sat300skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sat300skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public  List<Map<String, Object>> selectMaster(Map param, LoginVO loginVO) throws Exception {		
		return  super.commonDao.list("sat300skrvServiceImpl.selectMaster", param);
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("sat300skrvServiceImpl.selectList", param);
	}
	
	
}
