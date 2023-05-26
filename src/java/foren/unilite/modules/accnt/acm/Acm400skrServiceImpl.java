package foren.unilite.modules.accnt.acm;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.modules.com.common.CMSIntfServiceImpl;

@Service("acm400skrService")
public class Acm400skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name="cMSIntfService")
	private CMSIntfServiceImpl cMSIntfService;
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {
		cMSIntfService.getCMSData(param, loginVO);
		return (List) super.commonDao.list("acm400skrServiceImpl.selectList", param);
	}
}
