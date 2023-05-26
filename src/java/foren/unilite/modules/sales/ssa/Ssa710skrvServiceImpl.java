package foren.unilite.modules.sales.ssa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssa710skrvService")
public class Ssa710skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 전자문서 로그 : 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		Map eTaxDbUserMap = (Map) super.commonDao.select("ssa710skrvServiceImpl.EtaxDbUser", param);
		param.put("CONNECT_SYS", ObjUtils.getSafeString(eTaxDbUserMap.get("connectSys")));
		param.put("CONNECT_DB", ObjUtils.getSafeString(eTaxDbUserMap.get("connectDB")));
		
		return  super.commonDao.list("ssa710skrvServiceImpl.selectList", param);
	}

	


	
}
