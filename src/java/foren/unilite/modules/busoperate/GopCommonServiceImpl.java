package foren.unilite.modules.busoperate;

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


@Service("gopCommonService")
public class GopCommonServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  routeCombo(Map param) throws Exception {	
		return  super.commonDao.list("gopCommonServiceImpl.routeList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  vehicleCombo(Map param) throws Exception {	
		return  super.commonDao.list("gopCommonServiceImpl.vehicleList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectRouteList(Map param) throws Exception {	
		return  super.commonDao.list("gopCommonServiceImpl.selectRouteList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  driverList(Map param) throws Exception {	
		return  super.commonDao.list("gopCommonServiceImpl.driverList", param);
	}
	
	@ExtDirectMethod(group = "busincome", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  routeGroupForIncome(Map param) throws Exception {	
		return  super.commonDao.list("gopCommonServiceImpl.routeGroupForIncome", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  routeComboForIncome(Map param) throws Exception {	
		return  super.commonDao.list("gopCommonServiceImpl.routeListForIncome", param);
	}
	
}
