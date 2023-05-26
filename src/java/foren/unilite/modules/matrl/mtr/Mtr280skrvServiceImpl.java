package foren.unilite.modules.matrl.mtr;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mtr280skrvService")
public class Mtr280skrvServiceImpl  extends TlabAbstractServiceImpl {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수주현황- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		return  super.commonDao.list("mtr280skrvServiceImpl.selectList1", param);
	}

	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("mtr280skrvServiceImpl.mainReport", param);
	}

	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("mtr280skrvServiceImpl.subReport", param);
	}
}
