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

@Service("sof115skrvService")
public class Sof115skrvServiceImpl  extends TlabAbstractServiceImpl {
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수주현황- 거래처별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("sof115skrvServiceImpl.selectList", param);
	}
	

	
}
