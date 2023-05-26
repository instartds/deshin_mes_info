package foren.unilite.modules.accnt.agb;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;



@Service("agb250skrService")
public class Agb250skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@ExtDirectMethod(group = "Accnt")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		Map selectRefCodeMap = (Map)super.commonDao.select("agb250skrServiceImpl.selectRefCode", param);
		if(selectRefCodeMap.get("REF_CODE1").equals("Y"))	{	
			return (List) super.commonDao.list("agb250skrServiceImpl.selectList2", param);
		} else {
			return (List) super.commonDao.list("agb250skrServiceImpl.selectList1", param);
		}
	}
}
