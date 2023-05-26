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

@Service("sof100skrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sof100skrvServiceImpl  extends TlabAbstractServiceImpl {
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
		// 스프링 버전 확인하기

		String springVersion = org.springframework.core.SpringVersion.getVersion();

		System.out.println("스프링 프레임워크 버전 : " + springVersion);




		return  super.commonDao.list("sof100skrvServiceImpl.selectList1", param);
	}

	/**
	 * 수주현황- 고객별별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		return  super.commonDao.list("sof100skrvServiceImpl.selectList2", param);
	}

	/**
	 * 수주현황- 납기일별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {
		return  super.commonDao.list("sof100skrvServiceImpl.selectList3", param);
	}
}
