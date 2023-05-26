package foren.unilite.modules.z_hs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_emp120skrv_hsService")
public class S_Emp120skrv_hsServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 에이치 설퍼 출하내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_hs", value = ExtDirectMethodType.STORE_BUFFERED)
	public Map<String, Object> selectList(Map param) throws Exception {

		Map<String, Object> rMap = new HashMap();
		List<Map<String, Object>> rList = new ArrayList();

		rList = (List<Map<String, Object>>) super.commonDao.list("s_emp120skrv_hsServiceImpl.selectList", param);

		int total = 0;
		if (rList.size() > 0) {
			Map<String, Object> tmpMap = (Map<String, Object>)rList.get(0);
			total = ObjUtils.parseInt(tmpMap.get("TOTAL"));
		}
		rMap.put("data", rList);
		rMap.put("total", total);
		
		return rMap;
	}

	/**
	 * 에이치 설퍼 출하내역 환율 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_hs", value = ExtDirectMethodType.STORE_READ)
	public List<Map> selectExchg(Map param) throws Exception {
		return super.commonDao.list("s_emp120skrv_hsServiceImpl.selectExchg", param);
	}
}
