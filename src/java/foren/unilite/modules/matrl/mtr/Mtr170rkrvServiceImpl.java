package foren.unilite.modules.matrl.mtr;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mtr170rkrvService")
public class Mtr170rkrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 수주현황- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>>  selectList(Map param,LoginVO user) throws Exception {
		param.put("S_COMP_CODE", user.getCompCode());
		param.put("VIEW_OPT", param.get("VIEW_OPT")==null?"1":param.get("VIEW_OPT"));
		param.put("ITEM_LEVEL1", param.get("ITEM_LEVEL1")==null?"":param.get("ITEM_LEVEL1"));
		param.put("ITEM_LEVEL2", param.get("ITEM_LEVEL2")==null?"":param.get("ITEM_LEVEL2"));
		param.put("ITEM_LEVEL3", param.get("ITEM_LEVEL3")==null?"":param.get("ITEM_LEVEL3"));
		return  super.commonDao.list("mtr170skrvServiceImpl.selectList", param);
	}
	
	private int parseInt(String text) {
		// TODO Auto-generated method stub
		return 0;
	}
	
}
