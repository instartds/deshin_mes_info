package foren.unilite.modules.sales.srq;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.logging.InjectLogger;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("srq300rkrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Srq300rkrvServiceImpl  extends TlabAbstractServiceImpl {
    @InjectLogger
    public static   Logger  logger  ;// = LoggerFactory.getLogger(this.getClass());

	/**
	 * 수주현황- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sof")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return  super.commonDao.list("srq300rkrvServiceImpl.selectList1", param);
	}

	public List<Map<String, Object>> clipselect(Map param) throws Exception {
		return  super.commonDao.list("srq300rkrvServiceImpl.clipselect", param); 
	}

	public List<Map<String, Object>> clipselectsub(Map param) throws Exception {
		return  super.commonDao.list("srq300rkrvServiceImpl.clipselectsub", param); 
	}

	/**
	 * 극동 사이트 출력물 쿼리
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> clipselectsub_kd(Map param) throws Exception {
		return  super.commonDao.list("srq300rkrvServiceImpl.clipselectsub_kd", param); 
	}
}
