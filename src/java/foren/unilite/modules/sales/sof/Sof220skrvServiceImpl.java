package foren.unilite.modules.sales.sof;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("sof220skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sof220skrvServiceImpl extends TlabAbstractServiceImpl {
	@InjectLogger
	public static Logger logger ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 초도수주현황
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("sof220skrvServiceImpl.selectList", param);
	}
}