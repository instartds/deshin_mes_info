package foren.unilite.modules.trade.tio;

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
import ch.ralscha.extdirectspring.util.ParametersResolver;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.crm.cmd.Cmd100ukrvModel;
import foren.unilite.modules.sales.SalesCommonServiceImpl;

@Service("tio110skrvService")
public class Tio110skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name="salesCommonService")
	private SalesCommonServiceImpl SalesUtil;
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "trade")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("tio110skrvServiceImpl.selectList", param);
	}
}
