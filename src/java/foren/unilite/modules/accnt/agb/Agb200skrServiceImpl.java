package foren.unilite.modules.accnt.agb;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;



@Service("agb200skrService")
public class Agb200skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		return (List) super.commonDao.list("agb200skrServiceImpl.selectDetailList", param);
	}
	
	
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> fnAgb200Init(Map param, LoginVO loginVO) throws Exception {
		
		return (List) super.commonDao.list("agb200skrServiceImpl.fnAgb200Init", param);
	}
}
