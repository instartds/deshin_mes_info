package foren.unilite.modules.z_mit;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_sof130skrv_mitService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_sof130skrv_mitServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 주문의뢰서 출력(MIT) - 주문 데이터 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("s_sof130skrv_mitServiceImpl.selectList", param);
	}

	/**
	 * 주문의뢰서 출력(MIT) - 출력 조회 쿼리(master)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  printList(Map param) throws Exception {
		return  super.commonDao.list("s_sof130skrv_mitServiceImpl.printList", param);
	}
	
	/**
	 * 수주현황- 납기일별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {
		return  super.commonDao.list("s_sof130skrv_mitServiceImpl.selectList3", param);
	}
}
