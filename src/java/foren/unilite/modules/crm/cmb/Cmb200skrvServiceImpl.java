package foren.unilite.modules.crm.cmb;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.constants.Unilite;
import foren.unilite.com.menu.ProgramAuthModel;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("cmb200skrvService")
public class Cmb200skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
//	@ExtDirectMethod(group = "crm")
//	public List<Map<String, Object>> selectDataList(Map param, ProgramAuthModel auth) throws Exception {
//		return (List) super.commonDao.list("cmb200skrvServiceImpl.getDataList", param);
//	}
	
	
	@ExtDirectMethod(group = "crm")
	public Map<String, Object> selectCustomList(Map param) throws Exception {
		logger.debug("param >>> " + param.toString());
		Map<String, Object> rv = new HashMap<String, Object>();
		List list = super.commonDao.list("cmb200skrvServiceImpl.getCustomList", param);
		if(list != null) {
			if(list.size() > 0) {
				Map rec = (Map) list.get(0);
				rv.put("totalCount",rec.get("TOTAL_CNT"));
			} else {
				rv.put("totalCount",0);
				
			}
		}
		rv.put("success", Boolean.TRUE);
		rv.put("data", list);
		return rv;
	}
	
	
	
	@SuppressWarnings("unchecked")
	@ExtDirectMethod(group = "crm")
	public List<Map<String, Object>> selectDataListR(Map param, ProgramAuthModel auth) throws Exception {
		/*
		 * param.put("srchCompCode", Unilite.BASIC_COMP_CODE);
		 
		param.put("AUTHORITY_LEVEL", "10");
		param.put("EMP_ID", "kevein");
		*/
		logger.debug("param >>> {} " , auth.toString());
		return  super.commonDao.list("cmb200skrvServiceImpl.getDataList", param);
	}
}
