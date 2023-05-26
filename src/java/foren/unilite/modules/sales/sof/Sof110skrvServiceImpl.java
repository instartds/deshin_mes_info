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

@Service("sof110skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sof110skrvServiceImpl  extends TlabAbstractServiceImpl {
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
		return  super.commonDao.list("sof110skrvServiceImpl.selectList", param);
	}

	/**
	 * 수주진행현황- 생산내역 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>> detailList (Map param) throws Exception {
		return  super.commonDao.list("sof110skrvServiceImpl.detailList", param);
	}

	/**
	 * 수주진행현황- 구매내역 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>> detailList2 (Map param) throws Exception {
		return  super.commonDao.list("sof110skrvServiceImpl.detailList2", param);
	}

	/**
	 * 수주진행현황(통합) - 20200120 추가
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>> detailListAll (Map param) throws Exception {
		return  super.commonDao.list("sof110skrvServiceImpl.detailListAll", param);
	}
}
