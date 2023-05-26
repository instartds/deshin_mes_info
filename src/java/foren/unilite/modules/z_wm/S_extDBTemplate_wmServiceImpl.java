package foren.unilite.modules.z_wm;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_extDBTemplate_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})
public class S_extDBTemplate_wmServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "externalDAO_WM")
	protected ExternalDAO_WM extDao;
	

	@ExtDirectMethod(group = "z_wm")
	public List<Map<String, Object>> selectMaster(Map param) throws Exception {
		param.put("DIV_CODE", "01");
		return extDao.list("s_extDBTemplateServiceImpl.selectMaster", param);
	}
	
	
	@ExtDirectMethod(group = "z_wm")
	public Map<String, Object> selectList(Map param) throws Exception {
		param.put("DIV_CODE", "01");
		return extDao.select("s_extDBTemplateServiceImpl.selectList", param);
	}

	@ExtDirectMethod(group = "z_wm")
	public List<Map<String, Object>> update(Map param) throws Exception {
		param.put("DIV_CODE", "01");
		List<Map<String, Object>> paramList = new ArrayList();
		paramList.add(param);
		extDao.update("s_extDBTemplateServiceImpl.update", paramList);
		return null;
	}
}