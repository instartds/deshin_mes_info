package foren.unilite.modules.z_yp;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_sof100skrv_ypService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_sof100skrv_ypServiceImpl  extends TlabAbstractServiceImpl {
	@InjectLogger
	public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 매출현황(오토마트)- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_yp")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		return  super.commonDao.list("S_sof100skrv_ypServiceImpl.selectList1", param);
	}

	/**
	 * 매출현황(오토마트)- 고객별별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_yp")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		return  super.commonDao.list("S_sof100skrv_ypServiceImpl.selectList2", param);
	}

	/**
	 * 매출현황(오토마트)- 납기일별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_yp")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {
		return  super.commonDao.list("s_sof100skrv_ypServiceImpl.selectList3", param);
	}


	/**
	 * 매출현황(오토마트)- 거래명세서
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_yp")
	public List<Map<String, Object>>  selectPrintList(Map param) throws Exception {
		return  super.commonDao.list("S_sof100skrv_ypServiceImpl.selectPrintList", param);
	}

	/**
	 * 매출현황(오토마트)- 납품서
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_yp")
	public List<Map<String, Object>>  selectPrintList2(Map param) throws Exception {
		return  super.commonDao.list("S_sof100skrv_ypServiceImpl.selectPrintList2", param);
	}

	/**
	 * 매출현황(오토마트)- 납품확인서
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_yp")
	public List<Map<String, Object>>  selectPrintList3(Map param) throws Exception {
		return  super.commonDao.list("S_sof100skrv_ypServiceImpl.selectPrintList3", param);
	}
}
