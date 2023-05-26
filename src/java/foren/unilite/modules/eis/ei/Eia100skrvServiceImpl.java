package foren.unilite.modules.eis.ei;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("eia100skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Eia100skrvServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static Logger  logger;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수주진행현황- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>> selectList (Map param) throws Exception {
		return  super.commonDao.list("eia100skrvServiceImpl.selectList", param);
	}

	/**
	 * 수주진행현황- 생산내역 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>> detailList (Map param) throws Exception {
		return  super.commonDao.list("eia100skrvServiceImpl.detailList", param);
	}



}
