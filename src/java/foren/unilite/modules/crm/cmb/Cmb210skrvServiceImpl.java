package foren.unilite.modules.crm.cmb;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("cmb210skrvService")
public class Cmb210skrvServiceImpl  extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 영업기회 검색
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "crm")
	public Map<String, Object> selectProjectList(Map param) throws Exception {
		logger.debug("param >>> " + param.toString());
		Map<String, Object> rv = new HashMap<String, Object>();
		List list = super.commonDao.list("cmb210skrvServiceImpl.getProjectList", param);
		if (list != null) {
			if (list.size() > 0) {
				Map rec = (Map) list.get(0);
				rv.put("totalCount", rec.get("TOTAL_CNT"));
			} else {
				rv.put("totalCount", 0);
			}
		}
		rv.put("success", Boolean.TRUE);
		rv.put("data", list);
		return rv;
	}
	
	/**
	 * 영업기회 건별 세부현황 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "crm")
	public List<Map<String, Object>>  selectActivityList(Map param) throws Exception {
		return super.commonDao.list("cmb210skrvServiceImpl.getActivityList", param);
	}
	
}
