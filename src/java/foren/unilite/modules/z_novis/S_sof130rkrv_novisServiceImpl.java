package foren.unilite.modules.z_novis;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_sof130rkrv_novisService")
public class S_sof130rkrv_novisServiceImpl  extends TlabAbstractServiceImpl {
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
		return  super.commonDao.list("s_sof130rkrv_novisServiceImpl.selectList1", param);
	}

	public List<Map<String, Object>>  clipselect1(Map param) throws Exception {
		return  super.commonDao.list("s_sof130rkrv_novisServiceImpl.clipselect1", param);
	}

	public List<Map<String, Object>>  clipselect2(Map param) throws Exception {
		return  super.commonDao.list("s_sof130rkrv_novisServiceImpl.clipselect2", param);
	}

	public List<Map<String, Object>>  clipselectsub(Map param) throws Exception {
		return  super.commonDao.list("s_sof130rkrv_novisServiceImpl.clipselectsub", param);
	}
	public List<Map<String, Object>>  clipselect3_mainReport(Map param) throws Exception {
		return  super.commonDao.list("s_sof130rkrv_novisServiceImpl.clipselect3_mainReport", param);
	}

	public List<Map<String, Object>>  clipselect3_subReport(Map param) throws Exception {
		return  super.commonDao.list("s_sof130rkrv_novisServiceImpl.clipselect3_subReport", param);
	}
}
