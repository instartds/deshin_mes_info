package foren.unilite.modules.base.gve;

import java.util.ArrayList;
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


@Service("gve100skrvService")
public class Gve100skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gve100skrvServiceImpl.selectList", param);
	}
	
	

}
