package foren.unilite.modules.z_sh;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_sof100skrv_shService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_sof100skrv_shServiceImpl  extends TlabAbstractServiceImpl {
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
		return  super.commonDao.list("s_sof100skrv_shServiceImpl.selectList1", param);
	}

	/**
	 * 수주현황- 고객별별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
		return  super.commonDao.list("s_sof100skrv_shServiceImpl.selectList2", param);
	}
	
	/**
	 * 수주현황- 납기일별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {
		return  super.commonDao.list("s_sof100skrv_shServiceImpl.selectList3", param);
	}
}
