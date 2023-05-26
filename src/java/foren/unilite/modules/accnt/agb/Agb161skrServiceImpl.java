package foren.unilite.modules.accnt.agb;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;



@Service("agb161skrService")
public class Agb161skrServiceImpl extends TlabAbstractServiceImpl {
		
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("agb161skrServiceImpl.selectMasterList", param);
	}
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)		// 조회2
	public List<Map<String, Object>> selectDetail(Map param) throws Exception {
		return super.commonDao.list("agb161skrServiceImpl.selectDetailList", param);
	}
}
