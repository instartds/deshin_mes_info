package foren.unilite.modules.matrl.mad;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("mad120skrvService")
public class Mad120skrvServiceImpl  extends TlabAbstractServiceImpl {


	/**
	 * 매입처별 매입재고현황 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mad")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("mad120skrvServiceImpl.selectList", param);

	}
	/**
	 * 
	 * userID에 따른 납품창고 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		
		return  super.commonDao.select("mad120skrvServiceImpl.userWhcode", param);
	}
}
