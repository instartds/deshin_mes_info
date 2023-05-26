package foren.unilite.modules.sales.ssa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ssa550skrvService")
public class Ssa550skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 수탁수수료매출현황
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("ssa550skrvServiceImpl.selectList", param);
	}
	
	private int parseInt(String text) {
		// TODO Auto-generated method stub
		return 0;
	}


	
}
