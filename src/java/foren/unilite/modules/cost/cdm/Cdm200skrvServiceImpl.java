package foren.unilite.modules.cost.cdm;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;

@Service("cdm200skrvService")
public class Cdm200skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("cdm200skrvServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("cdm200skrvServiceImpl.selectList2", param);
	}
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		param.put("LANG_SUFFIX", UniliteUtil.getLangSuffix(ObjUtils.getSafeString(param.get("S_LANG_CODE")).toUpperCase()));
		return super.commonDao.list("cdm200skrvServiceImpl.selectList3", param);
	}
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList4(Map param) throws Exception {
		param.put("LANG_SUFFIX", UniliteUtil.getLangSuffix(ObjUtils.getSafeString(param.get("S_LANG_CODE")).toUpperCase()));
		return super.commonDao.list("cdm200skrvServiceImpl.selectList4", param);
	}
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList5(Map param) throws Exception {
		param.put("LANG_SUFFIX", UniliteUtil.getLangSuffix(ObjUtils.getSafeString(param.get("S_LANG_CODE")).toUpperCase()));
		return super.commonDao.list("cdm200skrvServiceImpl.selectList5", param);
	}
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList6(Map param) throws Exception {
		return super.commonDao.list("cdm200skrvServiceImpl.selectList6", param);
	}
	@ExtDirectMethod(group = "cost", value = ExtDirectMethodType.STORE_READ)
	public Object selectMaxSeq(Map param) throws Exception {
		return super.commonDao.select("cdm200skrvServiceImpl.selectMaxSeq", param);
	}
}